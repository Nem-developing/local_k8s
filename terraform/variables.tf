# Proxmox Authentication
variable "pm_api_url" {
  description = "The URL of the Proxmox API (e.g. https://192.168.1.10:8006/api2/json)"
  type        = string
}

variable "pm_api_token_id" {
  description = "The API Token ID (e.g. root@pam!terraform)"
  type        = string
}

variable "pm_api_token_secret" {
  description = "The API Token Secret"
  type        = string
  sensitive   = true
}

# VM Configuration

variable "virtual_machines" {
  description = "Map of VMs to create, individually configured"
  type = map(object({
    name          = string
    target_node   = string
    vm_id         = number
    template_name = string
    cores         = number
    sockets       = number
    memory        = number
    ip            = string
    gateway       = optional(string)
  }))
}

variable "vm_cpu_type" {
  description = "CPU Type (e.g. host, kvm64, qemu64)"
  type        = string
  default     = "host"
}

variable "vm_storage" {
  description = "Storage ID where disk will be created"
  type        = string
  default     = "local-lvm"
}

variable "vm_network_bridge" {
    description = "Network Bridge"
    type = string
    default = "vmbr0"
}

# Network

variable "vm_gateway" {
  description = "Gateway IP (leave empty if using DHCP or if want default from network)"
  type        = string
  default     = ""
}

variable "vm_dns" {
  description = "DNS Server IP (e.g. 1.1.1.1)"
  type        = string
  default     = "1.1.1.1"
}

variable "vm_dns_search" {
  description = "DNS Search Domain"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "Public SSH key to inject into the VM"
  type        = string
}

variable "vm_user" {
  description = "User to create/configure on the VM"
  type        = string
  default     = "nehemie"
}
