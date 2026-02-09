output "aks_ingress_public_ip" {
  description = "Endereço IP público para uso do Frontend Configuration do Application Gateway do AKS"
  value = azurerm_public_ip.aks-ingress-ip
}