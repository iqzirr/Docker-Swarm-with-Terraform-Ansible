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
  count       = 3
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
  master01    ansible_host=${proxmox_vm_qemu.docker_vm[0].ssh_host}    ansible_user=root ansible_port=22
  [Docker-Slave]
  slave01     ansible_host=${proxmox_vm_qemu.docker_vm[1].ssh_host}    ansible_user=root ansible_port=22
  slave02     ansible_host=${proxmox_vm_qemu.docker_vm[2].ssh_host}    ansible_user=root ansible_port=22
  EOF
}

resource "local_file" "generate_ssh-copy-id_executable"{
  filename = "./send-ssh-id.sh"
  content  = <<EOF
  sshpass -p "mit" ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new root@${proxmox_vm_qemu.docker_vm[0].ssh_host}
  sshpass -p "mit" ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new root@${proxmox_vm_qemu.docker_vm[1].ssh_host}
  sshpass -p "mit" ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new root@${proxmox_vm_qemu.docker_vm[2].ssh_host}
  EOF
  provisioner "local-exec" {
    command = <<-EOT
          chmod +x ./send-ssh-id.sh
          sh send-ssh-id.sh
          rm send-ssh-id.sh
          cd ../Ansible && ansible-playbook -i Hosts installDocker.yaml
          cd ../Ansible && ansible-playbook -i Hosts initSwarm.yaml
    EOT
  }
}