resource "proxmox_virtual_environment_vm" "debian_vm" {

  timeout_clone  = 21600 # 6 hours
  timeout_create = 21600 # 6 hours

  for_each = var.virtual_machines

  name      = each.value.name
  node_name = each.value.target_node
  vm_id     = each.value.vm_id == 0 ? null : each.value.vm_id

  clone {
    vm_id = [for vm in data.proxmox_virtual_environment_vms.template.vms : vm.vm_id if vm.name == each.value.template_name][0]
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = each.value.cores
    sockets = each.value.sockets
    type    = var.vm_cpu_type # Keeping global variable for type as it wasn't in the map, unless I add it? Map has: cores, sockets, memory, disk_size. CPU type is usually consistent.
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.vm_storage
    interface    = "scsi0"
    file_format  = "raw"
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = each.value.gateway != null ? each.value.gateway : (var.vm_gateway != "" ? var.vm_gateway : null)
      }
    }

    dns {
      servers = var.vm_dns != "" ? [var.vm_dns] : []
      domain  = var.vm_dns_search != "" ? var.vm_dns_search : null
    }

    user_account {
      username = var.vm_user
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  network_device {
    bridge = var.vm_network_bridge
    model  = "virtio"
  }

  operating_system {
    type = "l26" # Linux 2.6+
  }
  
  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }
}

data "proxmox_virtual_environment_vms" "template" {}
