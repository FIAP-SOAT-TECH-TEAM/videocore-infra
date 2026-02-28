# Pré-carga LocalStack

# Criar User Pool
echo "-> Criando User Pool no LocalStack..."
USER_POOL_NAME="test-user-pool"
USER_POOL_ID=$(docker exec videocore-localstack awslocal cognito-idp create-user-pool \
    --pool-name "$USER_POOL_NAME" \
    --query 'UserPool.Id' --output text)
echo "-> User Pool criado: $USER_POOL_ID"

# Criar User Pool Client
echo "-> Criando User Pool Client no LocalStack..."
USER_POOL_CLIENT_NAME="test-user-pool-client"
USER_POOL_CLIENT_ID=$(docker exec videocore-localstack awslocal cognito-idp create-user-pool-client \
    --user-pool-id "$USER_POOL_ID" \
    --client-name "$USER_POOL_CLIENT_NAME" \
    --generate-secret \
    --explicit-auth-flows \
        ALLOW_ADMIN_USER_PASSWORD_AUTH \
        ALLOW_USER_PASSWORD_AUTH \
        ALLOW_REFRESH_TOKEN_AUTH \
    --query 'UserPoolClient.ClientId' --output text)
echo "-> User Pool Client criado: $USER_POOL_CLIENT_ID"

# Criar usuário pré-carregado
USER_JSON=$(docker exec videocore-localstack awslocal cognito-idp admin-create-user \
    --user-pool-id "$USER_POOL_ID" \
    --username "jao" \
    --user-attributes \
        Name=email,Value=jao@videocore.com \
        Name=name,Value=João \
    --query 'User.Attributes' --output json)

SUBJECT_ID=$(echo "$USER_JSON" | jq -r '.[] | select(.Name=="sub") | .Value')
echo "-> Usuário pré-carregado com sucesso!"
echo "-> Subject ID: $SUBJECT_ID"