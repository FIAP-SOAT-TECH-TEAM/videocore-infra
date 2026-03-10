# 🏗️ VideoCore Infra

<div align="center">

Infraestrutura base do ecossistema VideoCore, provisionando AKS, Application Gateway, APIM, Key Vault, Cognito e demais serviços fundamentais. Desenvolvido como parte do curso de Arquitetura de Software da FIAP (Tech Challenge).

</div>

<div align="center">
  <a href="#visao-geral">Visão Geral</a> •
  <a href="#arquitetura">Arquitetura</a> •
  <a href="#repositorios">Repositórios</a> •
  <a href="#tecnologias">Tecnologias</a> •
  <a href="#instalacao">Instalação</a> •
  <a href="#deploy">Fluxo de Deploy</a> •
  <a href="#contribuicao">Contribuição</a>
</div><br>

---

<h2 id="visao-geral">📋 Visão Geral</h2>

O **VideoCore Infra** é o repositório responsável por provisionar toda a infraestrutura base do sistema VideoCore na **Azure Cloud** e **AWS**, incluindo rede, orquestração, API Gateway, secrets, messaging e autenticação.

### Principais Responsabilidades

- **Orquestração**: Azure Kubernetes Service (AKS) para microsserviços
- **API Gateway**: Azure API Management (APIM) com rate limiting e subscription keys
- **Rede**: VNet com múltiplas subnets para isolamento de serviços
- **Segurança**: Azure Key Vault para gerenciamento de secrets
- **Autenticação**: AWS Cognito como Identity Provider (IdP)
- **Messaging**: Azure Service Bus para comunicação assíncrona
- **Storage**: Azure Blob Storage para armazenamento de vídeos e imagens
- **Monitoramento**: Application Insights para telemetria

### Módulos Terraform

| Módulo | Descrição |
|--------|-----------|
| **resource_group** | Grupo de recursos central |
| **public_ip** | IP público para Ingress do AKS |
| **vnet** | Topologia de rede com múltiplas subnets |
| **aks** | Azure Kubernetes Service |
| **appgw** | Application Gateway (WAF + Load Balancing) |
| **azure_key_vault** | Gerenciamento de secrets |
| **app-insights** | Monitoramento e telemetria |
| **cognito** | AWS Cognito (User Pool + Client) |
| **azure_function** | Serverless compute |
| **apim** | API Management |
| **azure_service_bus** | Filas e tópicos de mensageria |
| **blob** | Azure Blob Storage |
| **cloud_front** | CDN para frontend |
| **event_grid** | Event Grid para notificações |
| **helm** | Deploy de Helm charts no AKS |

---

<h2 id="arquitetura">🧱 Arquitetura</h2>

<details>
<summary>Expandir para mais detalhes</summary>

### 🌐 Topologia de Rede

| Subnet | CIDR | Função |
|--------|------|--------|
| **AKS Nodes** | 10.0.2.0/24 | Nós do Kubernetes |
| **APIM** | 10.0.3.0/24 | API Management |
| **Azure Functions PE** | 10.0.4.0/24 | Private Endpoints |
| **Service Bus** | 10.0.5.0/24 | Messaging |
| **Application Gateway** | 10.0.6.0/24 | Load Balancer (Layer 7) |

### 📨 Azure Service Bus

| Recurso | Nome | Função |
|---------|------|--------|
| **Queue** | `process.queue` | Fila de processamento de vídeos |
| **Queue** | `process.error.queue` | Fila de erros |
| **Topic** | `process.status.topic` | Tópico de atualização de status |
| **Subscription** | `reports.process.status.topic.subscription` | Subscription do Reports |
| **Subscription** | `notification.process.status.topic.subscription` | Subscription de notificações |

### 🔐 Azure Key Vault

Armazena secrets sensíveis, incluindo:
- Credenciais AWS (Cognito)
- Credenciais de mail server
- Connection strings de serviços

### 🔑 AWS Cognito

- **User Pool**: Gerenciamento de identidade de usuários
- **App Client**: Configuração de auth flows (USER_PASSWORD_AUTH, USER_SRP_AUTH)
- **Callback URLs**: Integração com frontend

### 🐳 Docker Compose (Ambiente Local)

| Serviço | Descrição | Porta |
|---------|-----------|-------|
| **Azure Service Bus Emulator** | Emulação de filas e tópicos | 5672 |
| **SQL Server** | Backend do emulador Service Bus | 1433 |
| **Azurite** | Emulador Azure Blob Storage | 10000-10002 |
| **LocalStack** | Emulação de serviços AWS (Cognito) | 4566 |
| **MailDev** | Servidor SMTP para testes | 1080/1025 |

### 📦 Estrutura do Projeto

```
videocore-infra/
├── terraform/
│   ├── main.tf               # Orquestração de 27+ módulos
│   ├── variables.tf           # 50+ variáveis de configuração
│   ├── outputs.tf             # Outputs para repositórios dependentes
│   ├── datasources.tf         # Data sources remotos
│   ├── backend.tf             # Estado remoto (Azure Storage)
│   └── modules/
│       ├── resource_group/
│       ├── vnet/
│       ├── aks/
│       ├── appgw/
│       ├── azure_key_vault/
│       ├── cognito/
│       ├── azure_function/
│       ├── apim/
│       ├── azure_service_bus/
│       ├── blob/
│       ├── cloud_front/
│       ├── event_grid/
│       ├── helm/
│       ├── acr/
│       ├── app-insights/
│       └── public_ip/
├── docker/
│   ├── docker-compose.yml     # 6 serviços para desenvolvimento
│   ├── config.json            # Configuração Service Bus (queues/topics)
│   └── env-example
├── scripts/
│   ├── init-user.sh           # Setup LocalStack + usuário teste
│   ├── az-integration.sh      # Integração Azure
│   ├── sbcli/                 # CLI Go para Service Bus (AMQP)
│   │   ├── main.go
│   │   └── amqp/
│   └── infra-*.sh             # Scripts de ciclo de vida
└── .github/workflows/
    ├── ci.yaml                # Terraform fmt/validate/plan
    └── cd.yaml                # Terraform apply
```

### 🧑‍💻 Script de Inicialização (init-user.sh)

- Cria User Pool no LocalStack
- Configura App Client com auth flows
- Cria usuário de teste (`jao@videocore.com`)
- Confirma cadastro automaticamente

</details>

---

<h2 id="repositorios">📁 Repositórios do Ecossistema</h2>

| Repositório | Responsabilidade | Tecnologias |
|-------------|------------------|-------------|
| **videocore-infra** | Infraestrutura base (este repositório) | Terraform, Azure, AWS |
| **videocore-db** | Banco de dados | Terraform, Azure Cosmos DB |
| **videocore-frontend** | Interface web do usuário | Next.js 16, React 19, TypeScript |
| **videocore-reports** | Microsserviço de relatórios | Java 25, Spring Boot 4, Cosmos DB |
| **videocore-worker** | Microsserviço de processamento de vídeo | Java 25, Spring Boot 4, FFmpeg |
| **videocore-observability** | Stack de observabilidade | OpenTelemetry, Jaeger, Prometheus, Grafana |

---

<h2 id="tecnologias">🔧 Tecnologias</h2>

| Categoria | Tecnologia |
|-----------|------------|
| **IaC** | Terraform |
| **Cloud (Azure)** | AKS, APIM, App Gateway, Key Vault, Service Bus, Blob Storage, App Insights |
| **Cloud (AWS)** | Cognito |
| **Emulação** | LocalStack, Azurite, MailDev |
| **Container Registry** | Azure Container Registry (ACR) |
| **CDN** | CloudFront |
| **CLI** | Go (sbcli - Service Bus AMQP) |
| **CI/CD** | GitHub Actions |

---

<h2 id="instalacao">🚀 Instalação e Uso</h2>

### Desenvolvimento Local

```bash
# Clonar repositório
git clone https://github.com/FIAP-SOAT-TECH-TEAM/videocore-infra.git
cd videocore-infra

# Configurar variáveis de ambiente
cp docker/env-example docker/.env

# Subir serviços locais (Service Bus, Azurite, LocalStack, MailDev)
./video start:infra

# Inicializar usuário de teste no Cognito (LocalStack)
./scripts/init-user.sh
```

### CLI Service Bus (sbcli)

```bash
cd scripts/sbcli
make build
./sbcli --help
```

---

<h2 id="deploy">⚙️ Fluxo de Deploy</h2>

<details>
<summary>Expandir para mais detalhes</summary>

### Pipeline

1. **Pull Request** → CI: Terraform Format, Validate e Plan
2. **Revisão e Aprovação** → Mínimo 1 aprovação de CODEOWNER
3. **Merge para Main** → CD: Terraform Apply

### Autenticação

- **OIDC**: Token emitido pelo GitHub
- **Azure AD Federation**: Confia no emissor GitHub
- **Service Principal**: Autentica sem secret

### Ordem de Provisionamento

```
1. videocore-infra          (AKS, VNET, APIM - este repositório)
2. videocore-db             (Cosmos DB)
3. videocore-observability  (Jaeger, Prometheus, Grafana)
4. videocore-reports        (Microsserviço de relatórios)
5. videocore-worker         (Microsserviço de processamento)
6. videocore-frontend       (Interface web)
```

### Proteções

- Branch `main` protegida
- Nenhum push direto permitido
- Todos os checks devem passar

</details>

---

<h2 id="contribuicao">🤝 Contribuição</h2>

### Fluxo de Contribuição

1. Crie uma branch a partir de `main`
2. Implemente suas alterações
3. Abra um Pull Request
4. Aguarde aprovação de um CODEOWNER

### Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

<div align="center">
  <strong>FIAP - Pós-graduação em Arquitetura de Software</strong><br>
  Tech Challenge
</div>