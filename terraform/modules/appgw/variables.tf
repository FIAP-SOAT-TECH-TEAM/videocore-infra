# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS. Deve ser único globalmente."
    
    validation {
      condition     = length(var.dns_prefix) >= 1 && length(var.dns_prefix) <= 54
      error_message = "O 'dns_prefix' deve ter entre 1 e 54 caracteres."
    }
  }
  variable "resource_group_name" {
    type = string
    description = "Nome do resource group"
    
    validation {
      condition = can(regex("^[a-zA-Z0-9]+$", var.resource_group_name))
      error_message = "O nome do resource group deve conter apenas letras e números."
    }
  }
  variable "location" {
    description = "Localização do recurso"
    type = string
  }


variable "aks_app_gateway_tier" {
  type        = string
  description = "O nível do Application Gateway para AKS. Pode ser 'Standard_v2' ou 'WAF_V2'."
  
  validation {
    condition     = var.aks_app_gateway_tier == "Standard_v2" || var.aks_app_gateway_tier == "WAF_V2"
    error_message = "O 'aks_app_gateway_tier' deve ser 'Standard_v2' ou 'WAF_V2'."
  }
}

variable "aks_app_gateway_zones" {
  type        = list(string)
  description = "As zonas de disponibilidade para o Application Gateway para AKS. Deve conter 1, 2 ou 3 zonas."
  
  validation {
    condition     = length(var.aks_app_gateway_zones) >= 1 && length(var.aks_app_gateway_zones) <= 3
    error_message = "A 'aks_app_gateway_zones' deve conter entre 1 e 3 zonas."
  }
}

variable "appgw_subnet_id" {
  type        = string
  description = "O ID da subnet onde Application Gateways são implantados."
}

variable "aks_appgw_private_ip" {
  type        = string
  description = "O endereço IP privado atribuído ao Frontend do Application Gateway para AKS."
}

variable "aks_appgw_min_capacity" {
  type        = number
  description = "A capacidade mínima para o dimensionamento automático do Application Gateway para AKS."
  
  validation {
    condition     = var.aks_appgw_min_capacity >= 1 && var.aks_appgw_min_capacity <= 10
    error_message = "A 'aks_appgw_min_capacity' deve estar entre 1 e 10."
  }
}

variable "aks_appgw_max_capacity" {
  type        = number
  description = "A capacidade máxima para o dimensionamento automático do Application Gateway para AKS."
  
  validation {
    condition     = var.aks_appgw_max_capacity >= var.aks_appgw_min_capacity && var.aks_appgw_max_capacity <= 20
    error_message = "A 'aks_appgw_max_capacity' deve ser maior ou igual a 'aks_appgw_min_capacity' e estar entre 1 e 20."
  }
}