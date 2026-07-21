#############################################
# VM DEVELOPMENT
# Application Docker + Nginx
#############################################

resource "proxmox_virtual_environment_vm" "vm_dev" {
  name      = "vm-dev"
  description = "VM Developpement"
  node_name = var.proxmox_node
  vm_id = 104
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
        address = "192.168.0.24/24"
        gateway = "192.168.0.1"
      }
    }
    #
    user_account {
       username = "devops"
       keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_dev.id

    dns {
      servers = [
        "8.8.8.8",
        "1.1.1.1"
      ]
    }

  }
}

# Ressource pour générer le fichier de configuration Cloud-Init pour DEV
resource "proxmox_virtual_environment_file" "cloud_init_dev" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data = <<EOF
#cloud-config
runcmd:
  - sed -i 's/#Port 22/Port 2224/' /etc/ssh/sshd_config
  - echo "Port 2224" > /etc/ssh/sshd_config.d/custom-port.conf
  - ufw allow 2224/tcp
  - ufw reload
  - systemctl restart ssh
EOF
    file_name = "cloud-init-dev.yaml"
  }
}
