# Combine Terraform and Ansible for Proxmox VM and Docker Swarm Cluster Creation


Docker Engine Version: latest (Engine: 20.10.14, Client: 20.10.14)
Containerd Version: 1.5.11

System requirements:
- Localhost:
  - Ansible 2.10.1+
  - Terraform v1.1.+

- Remote hosts:
  - All Docker hosts must have passwordless SSH access
  - Supported Distros = automatically adjust host's Distro (look at https://docs.docker.com/engine/install/ for more information about compatible distros)
  - All Docker hosts must have sudo/root access for Docker installation

# Run Terraform
- change your directory to Terraform
```
terraform init
terraform plan
terraform apply
```
Limitations:
 - if we want to add more workers, we have to manually add sshpass and slave lines in main.tf, and change count to n vms
