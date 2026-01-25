# local_k8s

Infrastructure as Code to deploy a Kubernetes cluster on Proxmox using Terraform and Ansible.

## Prerequisites

- [Terraform](https://www.terraform.io/)
- [Proxmox VE](https://www.proxmox.com/) access with API token
- [Ansible](https://www.ansible.com/) (for configuration management, if applicable)

## Setup Proxmox User (Configuration Proxmox)

To create the necessary user and token, run the following commands on your Proxmox node (via SSH or Console):

```bash
# Créer l'utilisateur Terraform
pveum user add terraform-user@pve --comment "Utilisateur pour Terraform"

# Définir le mot de passe pour l'utilisateur
pveum passwd terraform-user@pve

# Créer le token API (sans séparation de privilèges pour simplifier les permissions)
pveum user token add terraform-user@pve terraform-token --privsep 0

# Assigner le rôle Administrateur à l'utilisateur sur la racine
pveum acl modify / --user terraform-user@pve --role Administrator

# Assigner le rôle Administrateur au token
pveum acl modify / --tokens 'terraform-user@pve!terraform-token' --role Administrator

# Assigner le rôle PVEAdmin au token (si nécessaire)
pveum acl modify / --tokens 'terraform-user@pve!terraform-token' --role PVEAdmin

# Créer un rôle personnalisé 'TerraformFull' avec les privilèges minimaux requis
pveum role add TerraformFull -privs 'VM.Allocate VM.Audit VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.PowerMgmt VM.Console Datastore.AllocateSpace Datastore.Audit Sys.Audit Sys.Modify'
```

## Getting Started

### 1. Configure Terraform

Navigate to the `terraform` directory:

```bash
cd terraform
```

Create/Update your `terraform.tfvars` file with your credentials:

```hcl
pm_api_url          = "https://proxmox-host:8006/api2/json"
pm_api_token_id     = "user@pam!tokenid"
pm_api_token_secret = "your-secret-uuid"
ssh_public_key      = "ssh-rsa AAAA..."
```

### 2. Initialize and Apply

Initialize the Terraform backend and provider:

```bash
terraform init
```

Review the deployment plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

## Structure

- `terraform/`: Contains all Terraform configuration files.
  - `main.tf`: Provider configuration.
  - `vm.tf`: VM resource definitions.
  - `variables.tf`: Variable declarations.
- `ansible/`: (Future) Ansible playbooks for k8s configuration.
