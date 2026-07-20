#############################################
# Connexion Proxmox
#############################################

proxmox_endpoint = "https://192.168.0.11:8006/api2/json"

proxmox_api_token = "terraform@pve!terraform-token=ebba76fb-ad92-46fb-a864-12c5358ae95c"

#############################################
# Infrastructure
#############################################

proxmox_node = "upg"

storage_pool = "local-lvm"

network_bridge = "vmbr0"
#############################################
# Template Cloud-Init
#############################################

template_vm_id = 900
