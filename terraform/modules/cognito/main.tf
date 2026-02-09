resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = "${var.dns_prefix}_user_pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

# Habilita Hosted UI do cognito
# https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-managed-login.html#set-up-managed-login
resource "aws_cognito_user_pool_domain" "cognito_user_pool_domain" {
  domain       = "${var.dns_prefix}-auth"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
}

# Representa a “aplicação” que vai se autenticar ou usar o pool de usuários
resource "aws_cognito_user_pool_client" "videocoreapp_cognito_client" {
  name                                  = "${var.dns_prefix}_user_pool_client"
  user_pool_id                          = aws_cognito_user_pool.cognito_user_pool.id
  generate_secret                       = false
  supported_identity_providers          = ["COGNITO"] # https://stackoverflow.com/questions/49979314/invalid-request-error-on-aws-cognito-custom-ui-page

  allowed_oauth_flows_user_pool_client  = true

  # Define a forma como o aplicativo irá obter o token após a autenticação
  allowed_oauth_flows                   = ["code", "implicit"]

  # Especifica quais informações um aplicativo terá acesso após obter um token
  allowed_oauth_scopes                  = ["email", "openid"]

  # Define os fluxos de autenticação permitidos para que o aplicativo consiga obter um token
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

  # Atributos que o aplicativo poderá ler do usuário autenticado
  read_attributes = [
    "sub",
    "given_name",
    "email",
    "email_verified",
    "name",
    "preferred_username"
  ]

  # URLs para onde o usuário será redirecionado após o login
  callback_urls = var.callback_urls

}

resource "azurerm_key_vault_secret" "aws_cognito_user_pool_id" {
  name         = "aws-cognito-user-pool-id"
  value        = aws_cognito_user_pool.cognito_user_pool.id
  key_vault_id = var.akv_id

  tags = {
    microservice = "any"
    resource  = "cognito"
  }

}