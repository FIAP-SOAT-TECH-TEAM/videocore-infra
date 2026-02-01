#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "===== Parando infraestrutura ====="

check_docker() {
  docker info &>/dev/null
  return $?
}

if ! check_docker; then
  echo "ERRO: O Docker não está rodando."
  exit 1
fi

cd "$PROJECT_ROOT/docker" || {
  echo "ERRO: Diretório docker não encontrado."
  exit 1
}

INFRA_CONTAINERS=$(docker ps --filter "name=videocore-(azure-service-bus-emulator|azure-service-bus-emulator-sql-server|azure-blob-emulator|smtp-server|localstack)" --format "{{.Names}}")

if [ -z "$INFRA_CONTAINERS" ]; then
  echo "Nenhum contêiner de infraestrutura em execução."
  exit 0
fi

echo "Contêineres em execução:"
echo "$INFRA_CONTAINERS"
echo

echo "-> Parando serviços de infraestrutura..."
docker compose stop \
  azure-service-bus-emulator \
  azure-service-bus-emulator-sql-server \
  azure-blob-storage-emulator \
  smtp-server \
  localstack

STILL_RUNNING=$(docker ps --filter "name=videocore-(azure-service-bus-emulator|azure-service-bus-emulator-sql-server|azure-blob-emulator|smtp-server|localstack)" --format "{{.Names}}")

if [ -z "$STILL_RUNNING" ]; then
  echo "===== Infraestrutura parada com sucesso ====="
else
  echo "AVISO: Alguns contêineres ainda estão em execução:"
  echo "$STILL_RUNNING"
  echo "-> Forçando parada completa..."
  docker compose down

  STILL_RUNNING=$(docker ps --filter "name=videocore-(azure-service-bus-emulator|azure-service-bus-emulator-sql-server|azure-blob-emulator|smtp-server|localstack)" --format "{{.Names}}")
  if [ -z "$STILL_RUNNING" ]; then
    echo "===== Infraestrutura parada com sucesso ====="
  else
    echo "ERRO: Não foi possível parar todos os contêineres."
    echo "Verifique manualmente com: docker ps"
  fi
fi