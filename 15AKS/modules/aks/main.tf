# Datasource to get Latest Azure AKS latest Version
# Check if there is a var with the version name , if not , use the 
# latest version, if there is a var, use that version
# make sure the version specified in var is valid

data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = "vaidics-aks-cluster"
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_b2s_v2"
    zones   = []
    auto_scaling_enabled = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 40
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
   } 
  }

  service_principal  {
    client_id = var.client_id
    client_secret = var.client_secret
  }

# to do: generate the ssh keys using tls_private_key
# upload the key to key vault

  linux_profile {
    admin_username = "vaidict"
    ssh_key {
        key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    # connection {
    #    type = "ssh"
    #     user = "vaidict"
    #     private_key = tls_private_key.ssh_key.private_key_pem
    #     host = self.public_ip
    # }
    # provisioner "remote-exec" {
    #   inline = [ 
    #     "git clone https://github.com/piyushsachdeva/bank-of-anthos",


    #    ]
    # }
}

