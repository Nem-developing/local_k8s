# local_k8s

Infrastructure as Code to deploy a Kubernetes cluster on Proxmox using Terraform and Ansible.

## Prerequisites

- [Terraform](https://www.terraform.io/)
- [Proxmox VE](https://www.proxmox.com/) access with API token
- [Ansible](https://www.ansible.com/) (for configuration management, if applicable)

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
