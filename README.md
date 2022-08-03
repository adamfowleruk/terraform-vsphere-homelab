# vSphere Homelab Terraform Module

Terraform module for creating a vsphere homelab.

This mechanism uses the vSphere provider to layout a Nested ESXi
demo environment for Homelab development. It is NOT suitable
for production workloads. It does apply UK / government grade
approaches to network separation, and creates an 'airgapped'
install environment.

## Prerequisites

You must have a single host with the following characteristics:-

- An Ethernet interface for access to the rest of the network and the Internet
- A 'management' vSphere Standard Switch (vSS) using the first network port, and ONLY used by the physical ESXi host and its vCenter
- A PCI network card with 4x Ethernet ports, NOT connected to a routable network (i.e. a switch only connected to this host, and attached storage)
- An 'Internal' vSphere Distributed Switch (vDS) for Management (i.e. Lab ESXi hosts and its vCenter et al), another for Storage, and another for Workload (I.e. Lab VMs)
- A PFSense VM connected to the above vDS networks (as LAN interfaces), and the outgoing vSS network (as a WAN) to manage routing and DNS
- A datastore for the physical VMs to reside on (default name: homelab)
- A datastore for the lab environment's nested VMs (default name: lab02)

## Quick start

You can run the script from the full-vsphere-lab folder with the following commands:-

```sh
cd full-vsphere-lab
terraform init
terraform apply --var-file YOUR-SETTINGS.yaml --var vsphere_password="YOURESCAPED\!PASSWORD"
```

## What this script creates

NOTE: This repo is currently a work in progress, and not all functionality is implemented.

The script will give the following default layout, assuming the environment is called 'Lab02' and has domain 'lab02.my.cloud':-

- DONE Add a Portgroup (network) for Lab02 Management to the management vDS (VLAN 0)
- DONE Add a Portgroup (network) for Lab02 Workload to the workload vDS (VLAN 200+lab number)
- WIP Creates 3 nested ESXi hosts with names vesxi0x.lab02.my.cloud (where x is 1-3)
- Creates a nested vCenter on the first host, configured to manage them all (vcenter01.lab02.my.cloud)
- Sets up vCenter HA with a second and third vCenter instance (vcenter02 and 03.lab02.my.cloud)
- Sets up vCenter and ESXi auto boot configuration
- Applies license keys as specified
- Creates Nested networks and switches as follows:-
  - Nested management vDS switch and network for ESXi hosts, vCenter, and any other management VMs you need, uplink to the homelab management vSwitch
  - Nested Workload vDS switch and 'VM Network' for workloads in the cluster, uplink to the homelab workload switch, with VLAN trunking
  - Nested Storage vDS Switch and Storage network for access to the homelab (for ISOs) and lab02 (for lab specific content) data stores, uplink to the homelab storage vSwitch
- (Optionally) adds nested vDS and vCenter configuration for IPFIX network monitoring to a specified vRNI cluster
- (Optionally) adds pfsense VLAN network configuration to a specified pfsense VM for the nested networks and routes
- (Optionally) creates a Linux Manjaro jumphost on the nested management network
- (Optionally) configures Wireguard extension on the pfsense VM to create a route directly to the management subnet with the Manjaro jumphost on

## Default settings for homelabs

The following best practice settings are applied:-

- All security settings for portgroups e.g. promiscuous et al, as likely required
- Disables VM logging (performance boost)
- Always uses thin provisioning for all VMs

## What to do after this script runs

You should be able to set up any VMware nested environment from this point.

Why not try the
[vSphere with Tanzu (aka Namespace Management)](https://github.com/vmware-tanzu-labs/terraform-provider-namespace-management)
modules to spin up a working Kubernetes environment?

## License and Copyright

Copyright VMware, Inc. 2022. Licenses under the Apache-2.0 license.

## Support statement

This repository contains purely sample code which is not supported in any way by VMware, Inc.