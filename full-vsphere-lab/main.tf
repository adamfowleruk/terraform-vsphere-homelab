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

module "esxi-cluster" {
  source = "../esxi-cluster"

  # Map input variables
}




output "results" {
  value = module.esxi-cluster
}