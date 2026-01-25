output "vm_names" {
    value = proxmox_vm_qemu.debian_vm[*].name
}

output "vm_ips" {
    value = proxmox_vm_qemu.debian_vm[*].default_ipv4_address
}
