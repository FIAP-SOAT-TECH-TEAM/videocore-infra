# Pré-carga LocalStack

# Criar User Pool
echo "-> Criando User Pool no LocalStack..."
USER_POOL_NAME="test-user-pool"
USER_POOL_ID=$(docker exec videocore-localstack awslocal cognito-idp create-user-pool \
    --pool-name "$USER_POOL_NAME" \
    --query 'UserPool.Id' --output text)
echo "-> User Pool criado: $USER_POOL_ID (Atualize environment variables onde necessário)"

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
echo "-> Subject ID: $SUBJECT_ID (Utilize isto no cabeçalho 'Auth-Subject' para autenticação simulada, ou para disparo de eventos em tempo de desenvolvimento)"