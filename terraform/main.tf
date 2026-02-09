module "resource_group" {
  source              = "./modules/resource_group"
  
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "public_ip" {
  source                        = "./modules/public_ip"

  dns_prefix                    = var.dns_prefix
  resource_group_name           = module.resource_group.name
  location                      = var.location
  aks_ingress_allocation_method = var.aks_ingress_allocation_method
  aks_ingress_sku               = var.aks_ingress_sku
  aks_ingress_public_ip_zones   = var.aks_ingress_public_ip_zones

  depends_on                    = [ module.resource_group ]
}

module "vnet" {
  source                          = "./modules/vnet"

  dns_prefix                      = var.dns_prefix
  resource_group_name             = module.resource_group.name
  location                        = var.location
  vnet_prefix                     = var.vnet_prefix
  vnet_aks_node_subnet_prefix     = var.vnet_aks_node_subnet_prefix
  vnet_apim_subnet_prefix         = var.vnet_apim_subnet_prefix
  vnet_azfunc_pe_subnet_prefix    = var.vnet_azfunc_pe_subnet_prefix
  vnet_sb_subnet_prefix           = var.vnet_sb_subnet_prefix
  vnet_appgw_subnet_prefix        = var.vnet_appgw_subnet_prefix
  aks_ingress_public_ip           = module.public_ip.aks_ingress_public_ip.ip_address

  depends_on = [ module.resource_group, module.public_ip ]
}

module "appgw" {
  source                    = "./modules/appgw"

  dns_prefix                = var.dns_prefix
  resource_group_name       = module.resource_group.name
  location                  = var.location
  aks_app_gateway_zones     = var.aks_ingress_public_ip_zones
  aks_app_gateway_tier      = var.aks_app_gateway_tier
  aks_appgw_min_capacity    = var.aks_appgw_min_capacity
  aks_appgw_max_capacity    = var.aks_appgw_max_capacity 
  appgw_subnet_id           = module.vnet.appgw_subnet.id
  aks_appgw_private_ip      = module.vnet.aks_ingress_private_ip
  aks_appgw_public_ip_id    = module.public_ip.aks_ingress_public_ip.id

  depends_on = [ module.resource_group, module.vnet, module.public_ip ]
}

module "akv" {
  source = "./modules/azure_key_vault"

  dns_prefix                      = var.dns_prefix
  resource_group_name             = module.resource_group.name
  location                        = var.location
  akv_soft_delete_retention_days  = var.akv_soft_delete_retention_days
  akv_sku_name                    = var.akv_sku_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  aws_credentials                 = var.aws_credentials
  aws_location                    = var.aws_location

  server_mail_username            = var.server_mail_username
  server_mail_password            = var.server_mail_password
  server_mail_host                = var.server_mail_host
  server_mail_port                = var.server_mail_port
  server_mail_from                = var.server_mail_from

  depends_on = [ module.resource_group ]
}

module "app_insights" {
  source              = "./modules/app-insights"

  dns_prefix          = var.dns_prefix
  resource_group_name = module.resource_group.name
  location            = var.location
  
  depends_on = [ module.resource_group ]
}

module "cognito" {
  source                    = "./modules/cognito"
  
  aws_location              = var.aws_location
  dns_prefix                = var.dns_prefix
  callback_urls             = var.callback_urls
  akv_id                    = module.akv.akv_id
  
}

module "azfunc" {
  source                              = "./modules/azure_function"

  dns_prefix                          = var.dns_prefix
  location                            = var.location
  az_premium_plan_auto_scale_enabled  = var.az_premium_plan_auto_scale_enabled
  az_maximum_elastic_worker_count     = var.az_maximum_elastic_worker_count
  az_minimum_elastic_worker_count     = var.az_minimum_elastic_worker_count
  az_worker_count                     = var.az_worker_count
  az_zone_balancing_enabled           = var.az_zone_balancing_enabled
  app_insights_instrumentation_key    = module.app_insights.app_insights_instrumentation_key
  app_insights_connection_string      = module.app_insights.app_insights_connection_string
  aws_location                        = var.aws_location
  aws_credentials                     = var.aws_credentials
  resource_group_name                 = module.resource_group.name
  azfunc_enable_always_on             = var.azfunc_enable_always_on
  azfunc_private_endpoint_subnet_id   = module.vnet.azfunc_private_endpoint_subnet_id
  azfunc_private_dns_zone_id          = module.vnet.azfunc_private_dns_zone_id
  azfunc_private_ip                   = module.vnet.azfunc_private_ip
  az_func_os_type                     = var.az_func_os_type
  az_func_sku_name                    = var.az_func_sku_name
  sa_account_replication_type         = var.azfunc_sa_account_replication_type
  sa_account_tier                     = var.azfunc_sa_account_tier
  instance_memory_in_mb               = var.azfunc_instance_memory_in_mb
  cognito_user_pool_id                = module.cognito.cognito_user_pool_id
  cognito_client_id                   = module.cognito.cognito_user_pool_client_id

  depends_on = [ module.resource_group, module.vnet, module.cognito, module.app_insights ]
}

module "blob" {
  source                    = "./modules/blob"
  
  dns_prefix                = var.dns_prefix
  resource_group_name       = module.resource_group.name
  location                  = var.location
  video_container_name      = var.video_container_name
  image_container_name      = var.image_container_name
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  akv_id                    = module.akv.akv_id

  depends_on = [ module.resource_group ]
}

module "acr" {
  source                      = "./modules/acr"

  dns_prefix                  = var.dns_prefix
  resource_group_name         = module.resource_group.name
  location                    = var.location
  acr_sku                     = var.acr_sku
  acr_admin_enabled           = var.acr_admin_enabled
  acr_zone_redundancy_enabled = var.acr_zone_redundancy_enabled

  depends_on = [ module.resource_group ]
}

module "aks" {
  source                      = "./modules/aks"

  dns_prefix                  = var.dns_prefix
  resource_group_name         = module.resource_group.name
  aks_network_plugin          = var.aks_network_plugin
  aks_network_plugin_mode     = var.aks_network_plugin_mode
  aks_outbound_type           = var.aks_outbound_type
  aks_app_gw_id               = module.appgw.aks_appgw_id
  aks_service_subnet_prefix   = var.vnet_aks_service_subnet_prefix[0]
  aks_availability_zones      = var.aks_availability_zones
  aks_auto_scaling_enabled    = var.aks_auto_scaling_enabled
  aks_max_count               = var.aks_max_count
  aks_min_count               = var.aks_min_count
  aks_namespaces              = var.aks_namespaces
  node_pool_name              = var.node_pool_name
  node_pool_temp_name         = var.node_pool_temp_name
  location                    = var.location
  aks_node_subnet_id          = module.vnet.aks_node_subnet.id
  vm_size                     = var.vm_size
  identity_type               = var.identity_type
  kubernetes_version          = var.kubernetes_version
  acr_id                      = module.acr.acr_id
  resource_group_id           = module.resource_group.id
  vnet_id                     = module.vnet.vnet_id
  appgw_id                    = module.appgw.aks_appgw_id
  akv_id                      = module.akv.akv_id
  aks_enable_keda             = var.aks_enable_keda

  depends_on = [ module.resource_group, module.vnet, module.acr, module.appgw ]
}

module "helm" {
  source = "./modules/helm"
  
  dns_prefix                            = var.dns_prefix
  newrelic_otel_collector_chart_name    = var.newrelic_otel_collector_chart_name
  newrelic_otel_collector_repository    = var.newrelic_otel_collector_repository
  newrelic_otel_collector_namespace     = var.aks_namespaces[3]
  newrelic_otel_collector_chart_version = var.newrelic_otel_collector_chart_version
  newrelic_cluster_name                 = var.newrelic_cluster_name
  newrelic_license_key                  = var.newrelic_license_key
  newrelic_low_data_mode                = var.newrelic_low_data_mode
  newrelic_important_metrics_only       = var.newrelic_important_metrics_only

  depends_on = [ module.aks ]
  
}

module "service_bus" {
  source                  = "./modules/azure_service_bus"

  dns_prefix              = var.dns_prefix
  resource_group_name     = module.resource_group.name
  location                = var.location
  sb_partitions           = var.sb_partitions
  sb_subnet_id            = module.vnet.sb_pe_subnet_id
  sb_private_dns_zone_id  = module.vnet.sb_private_dns_zone_id
  sb_sku                  = var.sb_sku
  sb_capacity             = var.sb_capacity
  sb_max_capacity         = var.sb_max_capacity
  sb_queues               = var.sb_queues
  sb_topics               = var.sb_topics
  sb_subscriptions        = var.sb_subscriptions
  akv_id                  = module.akv.akv_id

  depends_on = [ module.resource_group, module.vnet ]
}

module "event_grid" {
  source = "./modules/event_grid"

  dns_prefix                = var.dns_prefix
  resource_group_name       = module.resource_group.name
  location                  = var.location
  sb_process_queue_id       = module.service_bus.sb_process_queue_id
  storage_account_id        = module.blob.storage_account_id
  video_container_name      = module.blob.storage_video_container_name
  event_delivery_schema     = var.event_delivery_schema
  event_max_retry_attempts  = var.event_max_retry_attempts
  event_ttl                 = var.event_ttl

  depends_on = [ module.resource_group, module.service_bus, module.blob ]

}

module "apim" {
  source                           = "./modules/apim"

  dns_prefix                       = var.dns_prefix
  resource_group_name              = module.resource_group.name
  location                         = var.location
  apim_zones                       = var.apim_zones
  app_insights_instrumentation_key = module.app_insights.app_insights_instrumentation_key
  app_insights_connection_string   = module.app_insights.app_insights_connection_string
  apim_subnet_id                   = module.vnet.apim_subnet.id
  apim_publisher_name              = var.apim_publisher_name
  apim_publisher_email             = var.apim_publisher_email
  apim_sku_name                    = var.apim_sku_name
  apim_capacity                    = var.apim_apacity
  apim_max_capacity                = var.apim_max_capacity
  apim_product_id                  = var.apim_product_id
  apim_product_display_name        = var.apim_product_display_name
  apim_product_description         = var.apim_product_description
  apim_subscription_display_name   = var.apim_subscription_display_name
  apim_subscription_state          = var.apim_subscription_state

  depends_on = [ module.resource_group, module.vnet, module.app_insights ]
}