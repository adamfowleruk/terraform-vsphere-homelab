

# # This is used in VM tags for "vm_group_name"
# # and has "avi-" prepended
# # and has "-controller" or "-se" appended
# variable "deployment_name" {
#   type = string
#   default = "lab02"
# }


# # vSphere settings

# variable "vsphere_datacenter" {
#   type    = string
# }

# variable "vsphere_cluster" {
#   type    = string
# }

# variable "homelab_esxi_host" {
#   type = string
#   default = "192.168.99.16"
# }

# variable "esxi_hosts" {
#   default = [
#     "vesxi01.lab02.my.cloud",
#     "vesxi02.lab02.my.cloud",
#     "vesxi03.lab02.my.cloud",
#   ]
# }

variable "vsphere_username" {
  type = string
  default = "administrator@vsphere.homelab"
}

variable "vsphere_password" {
  type = string
  sensitive = true
}
variable "vsphere_insecure" {
  type = bool
  default = true
}

variable "vsphere_hostname" {
  type = string
  default = "vcenter.homelab"
}

variable "vsphere_api_timeout" {
  type = number
  default = 60
}

