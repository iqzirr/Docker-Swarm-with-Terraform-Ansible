# Proxmox API Credentials
variable "user_token_id" {
  type = string
  default = "terraform-prov@pve!JAbAMSfkcCkWyqjmDt3VfegyNee9eeEDFtms66YQpBgZKaSS9B"
}

variable "user_token_secret" {
  type = string
  default = "2f5fe4b2-991c-4932-8926-ecc7f0e2d7d2"
}

variable "proxmox_api_url" {
  type = string
  default = "https://172.16.20.206:8006/api2/json"
}


# Proxmox Host Config
variable "template_name" {
  type = string
  default = "debian11-cloudinit-template"
}

variable "proxmox_host" {
  type = string  
  default = "mitsvr06"
}


# Proxmox VM Template Credential and Configurations, use privileged user for installing Docker
variable "proxmox_vm_user"{
  type = string
  default = "root"
}

variable "proxmox_vm_password"{
  type = string
  default = "mit"
}

variable "proxmox_vm_ssh_port"{
  type = string
  default = "22"
}