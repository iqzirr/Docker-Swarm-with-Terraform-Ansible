# Proxmox API Credentials
variable "user_token_id" {
  type = string
  default = "your user_token_id"
}

variable "user_token_secret" {
  type = string
  default = "your user_token_secret"
}

variable "proxmox_api_url" {
  type = string
  default = " your proxmox_api_url, ex= https://123.123.123.123:8006/api2/json"
}


# Proxmox Host Config
variable "template_name" {
  type = string
  default = "your vm template_name in Proxmox, ex= debian11-cloudinit-template"
}

variable "proxmox_host" {
  type = string  
  default = "your proxmox_host, ex= svr007"
}


# Proxmox VM Template Credential and Configurations, use privileged user for installing Docker
variable "proxmox_vm_user"{
  type = string
  default = "your proxmox_vm_user"
}

variable "proxmox_vm_password"{
  type = string
  default = "your proxmox_vm_password"
}

variable "proxmox_vm_ssh_port"{
  type = string
  default = "your proxmox_vm_ssh_port"
}