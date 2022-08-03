terraform {
  required_providers {
    vsphere = {
      version = ">= 2.1.1"
      source = "hashicorp/vsphere"
    }
  }
}

# Lookup Homelab main physical ESXi host, and existing physical ESXi details

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}
data "vsphere_datastore" "homelab" {
  name          = var.homelab_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# data "vsphere_compute_cluster" "cluster" {
#   name          = var.vsphere_cluster_name
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }

# data "vsphere_network" "management_network" {
#   name          = var.management_network_name
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }

data "vsphere_host" "host" {
  name          = var.homelab_esxi_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_distributed_virtual_switch" "management_switch" {
  name          = var.management_switch_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_distributed_virtual_switch" "workload_switch" {
  name          = var.workload_switch_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_network" "lab_storage_network" {
  name          = var.storage_network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_resource_pool" "pool" {
  name          = "${var.homelab_esxi_host}/Resources"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}





# Create Networks (vDS Port groups) required by the new nested ESXi lab instance
resource "vsphere_distributed_port_group" "lab_management_network" {
  name          = "${var.lab_name} Management Network"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.management_switch.id
  
  vlan_id = 0
  allow_mac_changes = true
  allow_forged_transmits = true
  allow_promiscuous = true
}

resource "vsphere_distributed_port_group" "lab_workload_network" {
  name          = "${var.lab_name} Workload Network"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.workload_switch.id
  
  # vlan_id = 0
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }

  allow_mac_changes = true
  allow_forged_transmits = true
  allow_promiscuous = true
}


# Create nested ESXi VM(s)
# TODO determine if this is a better approach (of if we can duplicate/improve the recipe for our specific needs): https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/host
resource "vsphere_virtual_machine" "esxi" {
  count = 1 # TODO make this dynamic
  name             = "vesxi0${count}.${var.lab_domain}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.homelab.id
  num_cpus         = 28
  memory           = 65536
  # guest_id         = data.vsphere_virtual_machine.template.guest_id
  # scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id   = vsphere_distributed_port_group.lab_management_network.id
    adapter_type = "vmxnet3"
    # ipv4_address = "10.2.0.19"
    # ipv4_netmask = 24
  }
  network_interface {
    network_id   = vsphere_distributed_port_group.lab_workload_network.id
    adapter_type = "vmxnet3"
    # ipv4_address = "172.16.0.19"
    # ipv4_netmask = 24
  }
  network_interface {
    network_id   = vsphere_distributed_port_group.lab_workload_network.id
    adapter_type = "vmxnet3"
    # ipv4_address = "172.16.0.19"
    # ipv4_netmask = 24
  }
  network_interface {
    network_id   = data.vsphere_network.lab_storage_network.id
    adapter_type = "vmxnet3"
    # ipv4_address = "172.16.2.19"
    # ipv4_netmask = 24
  }
  # TODO ISO image linking
  # TODO Install settings for ESXi
  disk {
    # datastore_id = data.vsphere_datastore.homelab.id
    label            = "disk0"
    size             = 120
    thin_provisioned = true
  }
}

# Create Nested vCenter VM on first ESXi host
# TODO HA cluster eventually

# Attach NestedESXi instance(s) to vCenter

# Create standard networking layout in vCenter for segregated management and workload networks


# resource "vsphere_distributed_virtual_switch" "switch" {
#   name            = var.vds_switch_name
#   datacenter_id   = data.vsphere_datacenter.datacenter.id
  
#   max_mtu         = var.vds_switch_max_mtu
#   allow_mac_changes = var.vds_switch_security_mac_changes

#   uplinks         = [
#     var.vds_switch_active_uplinks,
#     var.vds_switch_standby_uplinks
#   ]
#   active_uplinks  = [var.vds_switch_active_uplinks]
#   standby_uplinks = [var.vds_switch_standby_uplinks]

#   # for all hosts

#   dynamic "host" {
#     for_each = data.vsphere_host.host

#     content {
#       host_system_id = host.id
#       devices = ["${var.vds_network_interfaces}"]
#     }
#   }

#   # host {
#   #   host_system_id = data.vsphere_host.host.0.id
#   #   devices        = ["${var.management_network_interfaces}"]
#   # }

#   # host {
#   #   host_system_id = data.vsphere_host.host.1.id
#   #   devices        = ["${var.management_network_interfaces}"]
#   # }

#   # host {
#   #   host_system_id = data.vsphere_host.host.2.id
#   #   devices        = ["${var.management_network_interfaces}"]
#   # }
# }

# resource "vsphere_distributed_port_group" "portgroup" {
#   name                            = var.vds_portgroup_name
#   distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.switch.id

#   vlan_id = var.vds_portgroup_vlan
# }


# # Returns output variables
# output "switch" {
#   value = vsphere_distributed_virtual_switch.switch.id
# }

# output "management_network" {
#   value = data.vsphere_network.management_network.id
# }

output "datacenter_id" {
  value = data.vsphere_datacenter.datacenter.id
}

# output "cluster_id" {
#   value = data.vsphere_compute_cluster.cluster.id
# }

output "host_id" {
  value = data.vsphere_host.host.id
}

output "lab_management_network_id" {
  value = vsphere_distributed_port_group.lab_management_network.id
}
output "lab_management_network_name" {
  value = vsphere_distributed_port_group.lab_management_network.name
}

output "lab_workload_network_id" {
  value = vsphere_distributed_port_group.lab_workload_network.id
}
output "lab_workload_network_name" {
  value = vsphere_distributed_port_group.lab_workload_network.name
}