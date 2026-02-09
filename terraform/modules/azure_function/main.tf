resource "azurerm_storage_account" "azfunc-sa" {
  name                     = "${var.dns_prefix}azfuncsa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_account_replication_type
}

resource "azurerm_storage_container" "azfunc-sa-container" {
  name                  = "${var.dns_prefix}-azfunc-sa-container"
  storage_account_id    = azurerm_storage_account.azfunc-sa.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "azfunc-service-plan" {
  name                            = "${var.dns_prefix}-azfunc-service-plan"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku_name                        = var.az_func_sku_name
  os_type                         = var.az_func_os_type
  premium_plan_auto_scale_enabled = var.az_premium_plan_auto_scale_enabled
  maximum_elastic_worker_count    = var.az_maximum_elastic_worker_count
  zone_balancing_enabled          = var.az_zone_balancing_enabled
}

resource "azurerm_linux_function_app" "azfunc" {
  name                          = "${var.dns_prefix}-azfunc"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.azfunc-service-plan.id
  storage_account_name          = azurerm_storage_account.azfunc-sa.name
  storage_account_access_key    = azurerm_storage_account.azfunc-sa.primary_access_key
  https_only                    = true
  
  # Configurado no bloco site_config abaixo
  public_network_access_enabled = true
  
  site_config {
    application_insights_connection_string  = var.app_insights_connection_string
    application_insights_key                = var.app_insights_instrumentation_key
    always_on                               = var.azfunc_enable_always_on
    app_scale_limit                         = var.az_maximum_elastic_worker_count
    elastic_instance_minimum                = var.az_minimum_elastic_worker_count

    # Libera o acesso público para o SCM (Kudu) da Function App, necessário para deploy via GitHub Actions
    # https://www.youtube.com/watch?v=syd_155iRxc
    scm_ip_restriction {
      name                       = "AllowInbound"
      action                     = "Allow"
      priority                   = 300
      # Poderíamos estudar depois liberar apenas para os IPs do GitHub Actions, embora tenham mais de 2000...
      # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses
      ip_address = "0.0.0.0/0"
    }

    ip_restriction_default_action = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack {
      dotnet_version = "9.0"
      use_dotnet_isolated_runtime = true
    }

  }

  app_settings = {
    AWS_CREDENTIALS                 = var.aws_credentials
    AWS_REGION                      = var.aws_location
    COGNITO_USER_POOL_ID            = var.cognito_user_pool_id
    COGNITO_APP_CLIENT_ID           = var.cognito_client_id

    # https://learn.microsoft.com/en-us/azure/azure-functions/dotnet-isolated-process-guide?tabs=ihostapplicationbuilder%2Clinux#deployment-requirements
    linuxFxVersion                  = "DOTNET-ISOLATED|9.0"
    WEBSITE_RUN_FROM_PACKAGE        = 1
  }

}

# Serve para fornecer inbound privado para a Function App
resource "azurerm_private_endpoint" "azfunc_pe" {
  name                = "${var.dns_prefix}-azfunc-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.azfunc_private_endpoint_subnet_id

  private_service_connection {
    name                           = "azfunc-priv-connection"
    private_connection_resource_id = azurerm_linux_function_app.azfunc.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "azfunc-dns-zone-group"
    private_dns_zone_ids = [var.azfunc_private_dns_zone_id]
  }

  # https://github.com/hashicorp/terraform-provider-azurerm/issues/21781
  ip_configuration {
    name               = "azfunc-ip-config"
    private_ip_address = var.azfunc_private_ip
    subresource_name   = "sites"
    member_name        = "sites"
  }
}