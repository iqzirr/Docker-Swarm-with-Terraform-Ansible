variable "user_token_id" {
  type = string
  default = "terraform-prov@pve!JAbAMSfkcCkWyqjmDt3VfegyNee9eeEDFtms66YQpBgZKaSS9B"
}

variable "user_token_secret" {
  type = string
  default = "2f5fe4b2-991c-4932-8926-ecc7f0e2d7d2"
}

variable "template_name" {
    default = "debian11-cloudinit-template"
}

variable "proxmox_host" {
    default = "mitsvr06"
}