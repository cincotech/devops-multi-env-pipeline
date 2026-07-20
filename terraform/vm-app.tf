#############################################
# VM APP
# Application Docker + Nginx
#############################################

resource "proxmox_virtual_environment_vm" "vm_app" {
  name      = "vm-app"
  node_name = var.proxmox_node
  vm_id = 101
  tags = [
    "terraform",
    "application",
    "docker"
  ]
  started = true
  ####################################################
  # Clone du template Ubuntu Cloud-Init
  ####################################################
  clone {
    vm_id = var.template_vm_id
  }
  ####################################################
  # CPU
  ####################################################
  cpu {
    cores = var.default_cpu_cores
    type = "x86-64-v2-AES"
  }
  ####################################################
  # Mémoire
  ####################################################
  memory {
    dedicated = var.default_memory
  }
  ####################################################
  # Disque système
  ####################################################
  disk {
    datastore_id = var.storage_pool
    interface = "scsi0"
    size = var.default_disk_size
    discard = "on"
  }
  ####################################################
  # Carte réseau
  ####################################################
  network_device {
    bridge = var.network_bridge
    model = "virtio"
  }
  ####################################################
  # Configuration Cloud-Init
  ####################################################
  initialization {
    datastore_id = var.storage_pool
    ip_config {
      ipv4 {
        address = "192.168.0.21/24"
        gateway = "192.168.0.1"
      }
    }
    #Inutile de configurer un nouvel utilisateur car le template comprend déjà l’utilisateur devops avec les privileges sudo
    #user_account {
    # username = "cinco"
    #  password = "ChangeMe123!"
    #}
    dns {
      servers = [
        "8.8.8.8",
        "1.1.1.1"
      ]
    }
  }
}
