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

variable "target_node" {
  description = "The Proxmox node to deploy the VM on"
  type        = string
}


# VM Configuration
# variable "vm_count" {
#   description = "Number of VMs to create"
#   type        = number
#   default     = 6
# }

# variable "template_name" {
#   description = "The name of the Cloud-Init template to clone"
#   type        = string
#   default     = "VM 100"
# }

# variable "vm_name_prefix" {
#   description = "The prefix for VM names (will be suffixed with -1, -2, etc.)"
#   type        = string
#   default     = "debian-vm"
# }

# Variable "vm_name" removed in favor of prefix

# variable "vm_id_start" {
#   description = "The starting ID for VMs (0 for auto-ID)"
#   type        = number
#   default     = 0
# }

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
    disk_size     = number
    ip            = string
    gateway       = optional(string)
  }))
}

variable "vm_cores" {
  description = "Number of CPU cores (default fallback)"
  type        = number
  default     = 4
}

variable "vm_sockets" {
    description = "Number of CPU sockets"
    type = number
    default = 1
}

variable "vm_cpu_type" {
  description = "CPU Type (e.g. host, kvm64, qemu64)"
  type        = string
  default     = "host"
}

variable "vm_memory" {
  description = "Memory size in MB"
  type        = number
  default     = 20480
}

variable "vm_balloon" {
  description = "Minimum memory (ballooning) in MB. Set to 0 to disable."
  type        = number
  default     = 0
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "vm_swap_size" {
    description = "Swap disk size (e.g. 4G). Leave empty to disable."
    type = string
    default = ""
}

variable "vm_storage" {
  description = "Storage ID where disk will be created"
  type        = string
  default     = "local-lvm"
}

variable "vm_onboot" {
    description = "Start VM on boot"
    type = bool
    default = true
}

variable "vm_tablet" {
    description = "Enable tablet for pointer"
    type = bool
    default = true
}

variable "vm_network_bridge" {
    description = "Network Bridge"
    type = string
    default = "vmbr0"
}

# Network
# variable "vm_ips" {
#   description = "List of IPs (CIDR) for the VMs. If empty, DHCP is used. Must match vm_count if set."
#   type        = list(string)
#   default     = []
# }

variable "vm_gateway" {
  description = "Gateway IP (leave empty if using DHCP or if want default from network)"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "Public SSH key to inject into the VM"
  type        = string
}
