terraform {
  required_providers {
    vsphere = {
      version = ">= 2.1.1"
      source = "hashicorp/vsphere"
    }
  }
}


provider "vsphere" {
  vsphere_server = var.vsphere_hostname
  user           = var.vsphere_username
  password       = var.vsphere_password
  api_timeout    = var.vsphere_api_timeout
  # debug_client   = true

  # If you have a self-signed cert
  allow_unverified_ssl = var.vsphere_insecure
}

# TODO prereq DNS entries in pfsense, and VLAN routing rules

# Create a set of Nested ESXi nodes, and a vCenter VM on the first node
module "esxi-cluster" {
  source = "../esxi-cluster"

  # TODO Map input variables rather than accept the defaults
}

# TODO Now configure the nested vCenter VM as a HA cluster, and network layout




output "results" {
  value = module.esxi-cluster
}