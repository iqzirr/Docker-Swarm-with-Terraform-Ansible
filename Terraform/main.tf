terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.user_token_id
  pm_api_token_secret = var.user_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "docker_vm" {
  count       = var.proxmox_vm_count  #the number of hosts we want to create (3 = 1 master + 2 slave)
  name        = "docker-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = var.template_name
  os_type     = "cloud_init"
 
  
  ## VM Specs
  agent       = 1
  cores	      = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    type            = "scsi"
    storage         = "local-lvm"
    size            = "50G"
    ssd             = 1
    slot            = 0
  }

  network {
    bridge    = "vmbr0"
    model     = "virtio"
  }
}

resource "local_file" "generate_ssh-copy-id_executable"{
  count = "${length(proxmox_vm_qemu.docker_vm)}"
  filename = "./ssh-${count.index+1}"
  content= "sshpass -p ${var.proxmox_vm_password} ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new ${var.proxmox_vm_user}@${proxmox_vm_qemu.docker_vm[count.index].ssh_host}"
}

resource "local_file" "generate_ansible_hosts" {
  count = "${length(proxmox_vm_qemu.docker_vm)}"
  filename = "./vm_info-${count.index+1}"
  content= "node-${count.index+1}  ansible_host=${proxmox_vm_qemu.docker_vm[count.index].ssh_host}      ansible_user=${var.proxmox_vm_user}     ansible_port=${var.proxmox_vm_ssh_port}"
}

resource "null_resource" "execute_files"{
  depends_on= [
    local_file.generate_ansible_hosts,
    local_file.generate_ssh-copy-id_executable,
  ]
  provisioner "local-exec" {
    command = <<-EOT
          bash createSshCopyID.sh
          bash createAnsibleHostfile.sh
          bash ssh_copy_id.sh
          ansible-playbook ../Ansible/main.yaml
    EOT
  }
}

resource "local_file" "generate_docker_ssh" {
  filename = "../Docker/dockerssh"
  content= <<-EOT
    #!/bin/bash
    docker -H "ssh://${var.proxmox_vm_user}@${proxmox_vm_qemu.docker_vm[0].ssh_host}" $@
    EOT
}