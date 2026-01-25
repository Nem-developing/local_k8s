resource "proxmox_virtual_environment_vm" "debian_vm" {
  count     = var.vm_count
  name      = "${var.vm_name_prefix}-${count.index + 1}"
  node_name = var.target_node
  vm_id     = var.vm_id_start == 0 ? null : var.vm_id_start + count.index

  clone {
    vm_id = [for vm in data.proxmox_virtual_environment_vms.template.vms : vm.vm_id if vm.name == var.template_name][0]
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = var.vm_cores
    sockets = var.vm_sockets
    type    = var.vm_cpu_type
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = var.vm_storage
    interface    = "scsi0"
    size         = var.vm_disk_size
    file_format  = "raw"
  }

  initialization {
    ip_config {
      ipv4 {
        address = length(var.vm_ips) > count.index ? var.vm_ips[count.index] : "dhcp"
        gateway = var.vm_gateway != "" ? var.vm_gateway : null
      }
    }

    user_account {
      keys = [trimspace(var.ssh_public_key)]
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
