output "cognito_user_pool_id" {
  description = "ID do Cognito User Pool"
  value       = aws_cognito_user_pool.cognito_user_pool.id
}

output "cognito_user_pool_client_id" {
  description = "ID do Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.foodcoreapp_cognito_client.id
}

output "cognito_code_login_url" {
  description = "URL de login do Cognito User Pool (usando o fluxo de authorization code)"
  value = "https://${aws_cognito_user_pool_domain.cognito_user_pool_domain.domain}.auth.${var.aws_location}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.foodcoreapp_cognito_client.id}&response_type=code&scope=email+openid&redirect_uri=${var.callback_urls[0]}"
}

output "cognito_code_get_token_url" {
  description = "URL para obtenção do token do Cognito User Pool (usando o fluxo de authorization code)"
  value = "https://${aws_cognito_user_pool_domain.cognito_user_pool_domain.domain}.auth.${var.aws_location}.amazoncognito.com/oauth2/token"
}

# Implicit flow não retorna refresh token: https://stackoverflow.com/questions/74756468/how-do-i-get-refreshtoken-after-implicit-grant-flow
output "cognito_implicit_login_url" {
  description = "URL de login do Cognito User Pool (usando o fluxo implícito)"
  value = "https://${aws_cognito_user_pool_domain.cognito_user_pool_domain.domain}.auth.${var.aws_location}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.foodcoreapp_cognito_client.id}&response_type=token&scope=email+openid&redirect_uri=${var.callback_urls[0]}"
}

output "guest_user_email" {
  description = "Email do usuário convidado (guest)"
  value       = local.guest_user_email
}