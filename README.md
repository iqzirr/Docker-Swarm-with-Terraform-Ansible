# Combine Terraform and Ansible for Proxmox VM and Docker Swarm Cluster Creation


Docker Engine Version: latest (Engine: 20.10.14, Client: 20.10.14)
Containerd Version: 1.5.11

System requirements:
- Localhost:
  - Ansible 2.10.1+
  - Terraform v1.1.+
  - Telmate/terraform-provider-proxmox Plugin for Terraform (automatically installed when we initiate terraform)

- Proxmox Server (v7.1-x)
  - cloud-init template for VM creation
  - API Token for accessing Proxmox

- Remote hosts(Proxmox VMs):
  - All Docker hosts must have SSH installed
  - All Docker hosts must have passwordless SSH access (will be configured with ssh-copy-id, initiate our host with ssh-keygen first if we dont have public ssh key)
  - Supported Distros = automatically adjust VM's Distro (look at https://docs.docker.com/engine/install/ for more information about compatible distros)
  - All Docker hosts must have sudo/root access for Docker installation

# How to run the stack
- change your directory to Terraform
- configure all the needed variables in variables.tf
```
terraform init
terraform plan
terraform apply
```
- to delete the hosts
```
terraform destroy
```

Limitations:
 - if we want to add more workers, we have to manually add sshpass and slave lines in main.tf, and change count to n vms
