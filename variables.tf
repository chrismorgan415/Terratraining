variable "vm_name"{
    type = string
    description = "This is the name for the virtual machine"
}
  
variable "admin_username"{
    type = string
    description = "This is the admin username for the virtual machine"
}
    
variable "vm_size" {
  type = string
  description = "This is the size of the virtual machine"
  default = "standard_B2s"
}
  
variable "admin_password" {
    type = string
    description = "This is the admin password for the virtual machine"
    sensitive = true
}

  variable "disk_name" {
    type = string
    description = "This is the name of the disk for the virtual machine"
}