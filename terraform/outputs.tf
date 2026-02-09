output "vm_names" {
  value = {
    for k, v in proxmox_virtual_environment_vm.debian_vm : k => v.name
  }
}

output "vm_ips" {
  value = {
    for k, v in proxmox_virtual_environment_vm.debian_vm : k => v.ipv4_addresses
  }
}


