# Combine Terraform and Ansible for VM and Docker Swarm Cluster Creation

![image](/uploads/7607e9b725455cc54a5614dcca9c95b4/image.png)
![image](/uploads/da628a07e0f2177941bbae7edd778ac3/image.png)
![image](/uploads/26431086a106f64eb415feac3a74b61e/image.png)

Docker Engine Version: latest (Engine: 20.10.14, Client: 20.10.14)
Containerd Version: 1.5.11

System requirements:
- Localhost:
  - Ansible 2.10.1+
  - Terraform v1.1.+

- Remote hosts:
  - All Docker hosts must have passwordless SSH access
  - Supported Distros = automatically adjust host's Distro (look at https://docs.docker.com/engine/install/ for more information about compatible distros)
  - All Docker hosts must have sudo access for Docker installation

# Run Terraform
- change your directory to Terraform
```
terraform init
terraform plan
terraform apply
```
Limitations:
 - if we want to add more workers, we have to manually add sshpass and slave lines in main.tf, and change count to n vms

Result:
![Untitled](/uploads/01e3b1697b0647a4388afce93f7b0047/Untitled.png)