resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.dns_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  workload_autoscaler_profile {
    keda_enabled = var.aks_enable_keda
  }
  
  default_node_pool {
    name                        = var.node_pool_name
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.aks_node_subnet_id
    auto_scaling_enabled        = var.aks_auto_scaling_enabled
    max_count                   = var.aks_max_count
    min_count                   = var.aks_min_count
    # Caso comece a falhar, avaliar se a subscription do azure possui Quota disponível para o SKU escolhido através do comando: az vm list-usage --location region -o table,
    # ou se o SKU está disponível nas zonas de disponibilidade escolhidas.
    zones                       = var.aks_availability_zones
    node_public_ip_enabled      = false
    temporary_name_for_rotation = var.node_pool_temp_name

    # https://github.com/hashicorp/terraform-provider-azurerm/issues/24020
    upgrade_settings { 
      max_surge = "10%" 
    }
  }

  identity {
    type = var.identity_type
  }

  network_profile {
    network_plugin      = var.aks_network_plugin
    network_plugin_mode = var.aks_network_plugin_mode
    outbound_type       = var.aks_outbound_type
    service_cidr        = var.aks_service_subnet_prefix
    dns_service_ip      = local.aks_dns_service_ip
  }

  ingress_application_gateway {
     gateway_id = var.aks_app_gw_id
  }

  role_based_access_control_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.aks]
}

resource "azurerm_role_assignment" "aks_subnet_contributor" {
  scope                = var.aks_node_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  depends_on = [azurerm_kubernetes_cluster.aks]
}

# https://docs.azure.cn/en-us/aks/create-k8s-cluster-with-aks-application-gateway-ingress#implement-the-terraform-code
 resource "azurerm_role_assignment" "agic_reader_rg" {
   scope                = var.resource_group_id
   role_definition_name = "Reader"
   principal_id         = local.agic_identity_object_id

   depends_on = [azurerm_kubernetes_cluster.aks]
 }
 resource "azurerm_role_assignment" "agic_network_contributor_vnet" {
   scope                = var.vnet_id
   role_definition_name = "Network Contributor"
   principal_id         = local.agic_identity_object_id

   depends_on = [azurerm_kubernetes_cluster.aks]
 }
 resource "azurerm_role_assignment" "agic_contributor_appgw" {
   scope                = var.appgw_id
   role_definition_name = "Contributor"
   principal_id         = local.agic_identity_object_id

   depends_on = [azurerm_kubernetes_cluster.aks]
 }

 resource "azurerm_role_assignment" "secrets_store_csi_user_kv" {
  scope                = var.akv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = local.secrets_store_csi_identity_object_id
}

resource "kubernetes_namespace_v1" "aks_namespaces" {
  count = length(var.aks_namespaces)

  metadata {
    name = var.aks_namespaces[count.index]

    labels = {
      managed-by  = "terraform"
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}