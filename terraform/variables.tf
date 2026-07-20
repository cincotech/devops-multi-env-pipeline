#############################################
# Connexion Proxmox
#############################################
variable "proxmox_endpoint" {
  description = "Adresse de l'API Proxmox"
  type        = string
}

variable "proxmox_api_token" {
  description = "Jeton API Proxmox"
  type        = string
  sensitive   = true
}

#############################################
# Infrastructure Proxmox
#############################################

variable "proxmox_node" {
  description = "Nom du nœud Proxmox"
  type        = string
}

variable "storage_pool" {
  description = "Nom du stockage Proxmox"
  type        = string
}

variable "network_bridge" {
  description = "Bridge réseau"
  type        = string
}


#############################################
# Ressources
#############################################

variable "default_cpu_cores" {
  description = "Nombre de cœurs CPU"
  type        = number
  default     = 2
}

variable "default_memory" {
  description = "Mémoire RAM (Mo)"
  type        = number
  default     = 2048
}

variable "default_disk_size" {
  description = "Taille du disque (Go)"
  type        = number
  default     = 50
}

#############################################
# Template Cloud-Init
#############################################

variable "template_vm_id" {
  description = "ID de la VM Template Ubuntu Cloud-Init"
  type        = number
}
