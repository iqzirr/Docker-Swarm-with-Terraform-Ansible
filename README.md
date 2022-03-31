# Terraform and Ansible for Docker Swarm Cluster Installer in Proxmox

features:
 - Automatically detect host's OS Distribution
 - Multi-Master Docker Swarm

System version:
 - Docker Engine Version: latest (Engine: 20.10.14, Client: 20.10.14)
 - Containerd Version: 1.5.11

System requirements:
- Localhost (Linux, Windows with WSL, or MacOS) with:
  - Ansible 2.10.1+
  - Terraform v1.1.+
  - Telmate/terraform-provider-proxmox Plugin for Terraform (automatically installed when we initiate terraform)
  - Sshpass 

- Proxmox Server (v7.1-x)
  - Cloud-Init template for VM creation
  - API Token for accessing Proxmox

- Remote hosts(Proxmox VMs):
  - All Docker hosts must have SSH installed
  - All Docker hosts must have passwordless SSH access (will be configured with ssh-copy-id, initiate our host with ssh-keygen first if we dont have public ssh key)
  - Supported Distros = all distros that are supported in this Docs (https://docs.docker.com/engine/install/)
  - All Docker hosts must have sudo/root access for Docker installation 

# How to run the stack
- First, change your directory to Terraform
- Configure all the needed variables and the amount of the vms in variables.tf
- To modify the spec of the vms, configure it in main.tf

```
terraform init
terraform plan
terraform apply
```
- To delete the hosts
```
terraform destroy
```

