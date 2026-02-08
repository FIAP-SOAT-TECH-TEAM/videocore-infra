# Vnet and Subnets

  resource "azurerm_virtual_network" "vnet" {
    name                = "${var.dns_prefix}-vnet"
    address_space       = var.vnet_prefix
    location            = var.location
    resource_group_name = var.resource_group_name
  }

  resource "azurerm_subnet" "aks_node_subnet" {
    name                 = "${var.dns_prefix}-aks-node-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = var.vnet_aks_node_subnet_prefix
  }

  resource "azurerm_subnet" "apim_subnet" {
    name                 = "${var.dns_prefix}-apim-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = var.vnet_apim_subnet_prefix
  }

  resource "azurerm_subnet" "azfunc_pe_subnet" {
    name                 = "${var.dns_prefix}-azfunc-pe-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = var.vnet_azfunc_pe_subnet_prefix
  }

  resource "azurerm_subnet" "sb_pe_subnet" {
    name                 = "${var.dns_prefix}-sb-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = var.vnet_sb_subnet_prefix
  }

  resource "azurerm_subnet" "appgw_subnet" {
    name                 = "${var.dns_prefix}-appgw-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = var.vnet_appgw_subnet_prefix
  }

# Private DNS Zones

  resource "azurerm_private_dns_zone" "private_dns" {
    name                = "${var.dns_prefix}.local"
    resource_group_name = var.resource_group_name
  }

  resource "azurerm_private_dns_zone" "az_websites_private_dns" {
    name                = "azurewebsites.net"
    resource_group_name = var.resource_group_name
  }

  resource "azurerm_private_dns_zone" "sb_private_dns" {
    name                = "privatelink.servicebus.windows.net"
    resource_group_name = var.resource_group_name
  }

# Private DNS Zone Links

  resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
    name                  = "${var.dns_prefix}-dns-link"
    resource_group_name   = var.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
    virtual_network_id    = azurerm_virtual_network.vnet.id
    registration_enabled  = true
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "az_websites_vnet_link" {
    name                  = "${var.dns_prefix}-azfunc-dns-link"
    resource_group_name   = var.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.az_websites_private_dns.name
    virtual_network_id    = azurerm_virtual_network.vnet.id
    registration_enabled  = false
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "sb_private_dns" {
    name                  = "${var.dns_prefix}-sb-dns-link"
    resource_group_name   = var.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.sb_private_dns.name
    virtual_network_id    = azurerm_virtual_network.vnet.id
    registration_enabled  = false
    
  }

# Private DNS A Records

  resource "azurerm_private_dns_a_record" "api_order_dns_a" {
    name                = "order"
    zone_name           = azurerm_private_dns_zone.private_dns.name
    resource_group_name = var.resource_group_name
    ttl                 = 300
    records             = [local.aks_ingress_private_ip]
  }

  resource "azurerm_private_dns_a_record" "api_payment_dns_a" {
    name                = "payment"
    zone_name           = azurerm_private_dns_zone.private_dns.name
    resource_group_name = var.resource_group_name
    ttl                 = 300
    records             = [local.aks_ingress_private_ip]
  }

  resource "azurerm_private_dns_a_record" "api_catalog_dns_a" {
    name                = "catalog"
    zone_name           = azurerm_private_dns_zone.private_dns.name
    resource_group_name = var.resource_group_name
    ttl                 = 300
    records             = [local.aks_ingress_private_ip]
  }

  resource "azurerm_private_dns_a_record" "azfunc_dns_a" {
    name                = "${var.dns_prefix}-azfunc"
    zone_name           = azurerm_private_dns_zone.az_websites_private_dns.name
    resource_group_name = var.resource_group_name
    ttl                 = 300
    records             = [local.azfunc_private_ip]
  }

# Network Security Groups

  resource "azurerm_network_security_group" "apim_nsg" {
    name                = "${var.dns_prefix}-apim-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
      name                       = "AllowHttpsInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }

    security_rule {
      name                       = "AllowHttpInbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }

    security_rule {
      name                       = "AllowApimMgmtInbound"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3443"
      source_address_prefix      = "AzureCloud"
      destination_address_prefix = "*"
    }
  }

  resource "azurerm_network_security_group" "azfunc_pe_nsg" {
    name                = "${var.dns_prefix}-azfunc-pe-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
      name                       = "AllowApimInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = azurerm_subnet.apim_subnet.address_prefixes[0]
      destination_address_prefix = "*"
    }
  }

  resource "azurerm_network_security_group" "sb_nsg" {
    name                = "${var.dns_prefix}-sb-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
      name                       = "AllowAksInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5671-5672"
      source_address_prefix      = azurerm_subnet.aks_node_subnet.address_prefixes[0]
      destination_address_prefix = "*"
    }
  }

  resource "azurerm_network_security_group" "appgw_nsg" {
    name                = "${var.dns_prefix}-appgw-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    # https://learn.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#required-security-rules
    security_rule {
      name                       = "AllowApimInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = azurerm_subnet.apim_subnet.address_prefixes[0]
      destination_address_prefix = local.aks_ingress_private_ip
    }

    security_rule {
      name                       = "AllowGatewayManagementInbound"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "65200-65535"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
    
  }

# NSG Associations
  resource "azurerm_subnet_network_security_group_association" "apim_assoc" {
    subnet_id                 = azurerm_subnet.apim_subnet.id
    network_security_group_id = azurerm_network_security_group.apim_nsg.id
  }

  resource "azurerm_subnet_network_security_group_association" "azfunc_pe_assoc" {
    subnet_id                 = azurerm_subnet.azfunc_pe_subnet.id
    network_security_group_id = azurerm_network_security_group.azfunc_pe_nsg.id
  }

  resource "azurerm_subnet_network_security_group_association" "sb_assoc" {
    subnet_id                 = azurerm_subnet.sb_pe_subnet.id
    network_security_group_id = azurerm_network_security_group.sb_nsg.id
  }

  resource "azurerm_subnet_network_security_group_association" "appgw_assoc" {
    subnet_id                 = azurerm_subnet.appgw_subnet.id
    network_security_group_id = azurerm_network_security_group.appgw_nsg.id
  }