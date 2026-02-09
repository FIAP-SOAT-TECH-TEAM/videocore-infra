#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "===== Iniciando infraestrutura ====="

check_docker() {
  docker info &>/dev/null
  return $?
}

if ! check_docker; then
  echo "ERRO: O Docker não está rodando."
  echo "Inicie o Docker Desktop e tente novamente."
  exit 1
fi

cd "$PROJECT_ROOT/docker" || {
  echo "ERRO: Diretório docker não encontrado."
  exit 1
}

# SQL Server do Service Bus Emulator
echo "-> Iniciando SQL Server do Azure Service Bus Emulator..."
docker compose up -d azure-service-bus-emulator-sql-server

SQL_RETRIES=30
SQL_COUNT=0
while [ $SQL_COUNT -lt $SQL_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-azure-service-bus-emulator-sql-server 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> SQL Server está em execução!"
    break
  fi
  SQL_COUNT=$((SQL_COUNT + 1))
  echo "Aguardando SQL Server... ($SQL_COUNT/$SQL_RETRIES)"
  sleep 3
done

# Azure Service Bus Emulator
echo "-> Iniciando Azure Service Bus Emulator..."
docker compose up -d azure-service-bus-emulator

SB_RETRIES=30
SB_COUNT=0
while [ $SB_COUNT -lt $SB_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-azure-service-bus-emulator 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Azure Service Bus Emulator está em execução!"
    break
  fi
  SB_COUNT=$((SB_COUNT + 1))
  echo "Aguardando Azure Service Bus Emulator... ($SB_COUNT/$SB_RETRIES)"
  sleep 2
done

# SMTP (MailDev)
echo "-> Iniciando servidor SMTP (MailDev)..."
docker compose up -d smtp-server

SMTP_RETRIES=15
SMTP_COUNT=0
while [ $SMTP_COUNT -lt $SMTP_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-smtp-server 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Servidor SMTP está em execução!"
    break
  fi
  SMTP_COUNT=$((SMTP_COUNT + 1))
  echo "Aguardando SMTP... ($SMTP_COUNT/$SMTP_RETRIES)"
  sleep 2
done

# Azurite (Azure Blob Storage Emulator)
echo "-> Iniciando Azure Blob Storage Emulator (Azurite)..."
docker compose up -d azure-blob-storage-emulator

AZ_RETRIES=20
AZ_COUNT=0
while [ $AZ_COUNT -lt $AZ_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-azure-blob-emulator 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Azurite está em execução!"
    break
  fi
  AZ_COUNT=$((AZ_COUNT + 1))
  echo "Aguardando Azurite... ($AZ_COUNT/$AZ_RETRIES)"
  sleep 2
done

# LocalStack (AWS Emulator)
echo "-> Iniciando LocalStack (Emulador AWS)..."
docker compose up -d localstack
LS_RETRIES=20
LS_COUNT=0
while [ $LS_COUNT -lt $LS_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-localstack 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> LocalStack está em execução!"
    break
  fi
  LS_COUNT=$((LS_COUNT + 1))
  echo "Aguardando LocalStack... ($LS_COUNT/$LS_RETRIES)"
  sleep 2
done

echo
echo "===== Infraestrutura iniciada com sucesso ====="
echo
echo "Serviços disponíveis:"
echo "- Azure Service Bus Emulator"
echo "- SMTP (MailDev)"
echo "- Azure Blob Storage (Azurite)"
echo "- LocalStack (Emulador AWS)"
echo
echo "Use 'docker compose ps' para verificar o status."