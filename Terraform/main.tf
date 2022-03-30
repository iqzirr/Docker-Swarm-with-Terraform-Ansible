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
  count       = 3  #the number of hosts we want to create (3 = 1 master + 2 slave)
  name        = "docker-vm-${count.index + 1}"
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

output "nodeip" {
  value = "${proxmox_vm_qemu.docker_vm.*.ssh_host}"
}

resource "local_file" "host_ips"{
  filename = "../Ansible/Hosts"
  content  = <<EOF
  [Docker-Master]
  master01    ansible_host=${proxmox_vm_qemu.docker_vm[0].ssh_host}    ansible_user=${var.proxmox_vm_user} ansible_port=${var.proxmox_vm_ssh_port}
  [Docker-Slave]
  slave01     ansible_host=${proxmox_vm_qemu.docker_vm[1].ssh_host}    ansible_user=${var.proxmox_vm_user} ansible_port=${var.proxmox_vm_ssh_port}
  slave02     ansible_host=${proxmox_vm_qemu.docker_vm[2].ssh_host}    ansible_user=${var.proxmox_vm_user} ansible_port=${var.proxmox_vm_ssh_port}
  #add slaves as much as the host number -1
  EOF
}

#send ssh public key to vms for Docker installation with Ansible
resource "local_file" "generate_ssh-copy-id_executable"{
  filename = "./send-ssh-id.sh"
  content  = <<EOF
  sshpass -p ${var.proxmox_vm_password} ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new ${var.proxmox_vm_user}@${proxmox_vm_qemu.docker_vm[0].ssh_host}
  sshpass -p ${var.proxmox_vm_password} ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new ${var.proxmox_vm_user}@${proxmox_vm_qemu.docker_vm[1].ssh_host}
  sshpass -p ${var.proxmox_vm_password} ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new ${var.proxmox_vm_user}@${proxmox_vm_qemu.docker_vm[2].ssh_host}
  #add this line, as much as the host count
  EOF
  provisioner "local-exec" {
    command = <<-EOT
          chmod +x ./send-ssh-id.sh
          sh send-ssh-id.sh
          rm send-ssh-id.sh
          cd ../Ansible && ansible-playbook -i Hosts installDocker.yaml
          cd ../Ansible && ansible-playbook -i Hosts initSwarm.yaml
          rm ../Ansible/Hosts
    EOT
  }
}