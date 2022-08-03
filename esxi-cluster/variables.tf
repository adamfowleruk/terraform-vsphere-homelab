# vSphere Cluster variables:-

variable "vsphere_datacenter" {
  type    = string
  default = "homelab"
}

variable "homelab_datastore" {
  type    = string
  default = "homelab"
}

variable "storage_network_name" {
  type    = string
  default = "Internal Storage Network"
}

variable "vsphere_cluster_name" {
  type    = string
  default = "homelab"
}

variable "management_switch_name" {
  type    = string
  default = "Internal Management Switch"
}

variable "workload_switch_name" {
  type    = string
  default = "Internal Workload Switch"
}

variable "homelab_esxi_host" {
  type = string
  # This is a name not necessary an IP address. 
  # Mine was installed with just an IP though...
  default = "192.168.99.16"
}

variable "lab_name" {
  type = string
  default = "Lab02"
}

variable "lab_domain" {
  type = string
  default = "lab02.my.cloud"
}