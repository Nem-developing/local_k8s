resource "proxmox_vm_qemu" "debian_vm" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.target_node
  vmid        = var.vm_id_start == 0 ? null : var.vm_id_start + count.index
  clone       = var.template_name
  
  # Basic Config
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.vm_cores
  sockets     = var.vm_sockets
  cpu         = var.vm_cpu_type
  memory      = var.vm_memory
  balloon     = var.vm_balloon
  onboot      = var.vm_onboot
  tablet      = var.vm_tablet
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    size    = var.vm_disk_size
    type    = "scsi"
    storage = var.vm_storage
    iothread = 1
  }

  # Swap Disk (Optional)
  dynamic "disk" {
    for_each = var.vm_swap_size != "" ? [1] : []
    content {
      slot    = 1
      size    = var.vm_swap_size
      type    = "scsi"
      storage = var.vm_storage
      iothread = 1
    }
  }

  network {
    model  = "virtio"
    bridge = var.vm_network_bridge
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init
  # Use list of IPs if provided, otherwise DHCP
  ipconfig0 = length(var.vm_ips) > count.index ? "ip=${var.vm_ips[count.index]}${var.vm_gateway != "" ? ",gw=${var.vm_gateway}" : ""}" : "ip=dhcp"
  
  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF
}
