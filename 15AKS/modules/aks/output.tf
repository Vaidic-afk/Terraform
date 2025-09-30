output "config" {
    value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  
}

output "kube_version" {
  value = azurerm_kubernetes_cluster.aks-cluster.kubernetes_version
}

output "private_key" {
  value = tls_private_key.ssh_key.private_key_openssh
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_pem
}

