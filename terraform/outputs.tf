output "vm_names" {
    value = proxmox_virtual_environment_vm.debian_vm[*].name
}

output "vm_ips" {
    value = proxmox_virtual_environment_vm.debian_vm[*].ipv4_addresses
}


