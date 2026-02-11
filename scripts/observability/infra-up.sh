#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "===== Iniciando infraestrutura ====="

# Verificar se o Docker está rodando
check_docker() {
  docker info &>/dev/null
  return $?
}

if ! check_docker; then
  echo "ERRO: O Docker não está rodando."
  echo "Inicie o Docker e tente novamente."
  exit 1
fi

# Ir para o diretório docker/observability
cd "$PROJECT_ROOT/../docker/observability" || {
  echo "ERRO: Diretório docker de observability não encontrado."
  exit 1
}

# Iniciar Open Telemetry Collector
echo "-> Iniciando Open Telemetry Collector..."
docker compose up -d otel-collector

OTEL_RETRIES=15
OTEL_COUNT=0
while [ $OTEL_COUNT -lt $OTEL_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-otel-collector 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Open Telemetry Collector está em execução!"
    break
  fi
  OTEL_COUNT=$((OTEL_COUNT + 1))
  echo "Aguardando Open Telemetry Collector... ($OTEL_COUNT/$OTEL_RETRIES)"
  sleep 2
done

# Iniciar Jaeger
echo "-> Iniciando Jaeger..."
docker compose up -d jaeger

JAEGER_RETRIES=15
JAEGER_COUNT=0
while [ $JAEGER_COUNT -lt $JAEGER_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-jaeger 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Jaeger está em execução!"
    break
  fi
  JAEGER_COUNT=$((JAEGER_COUNT + 1))
  echo "Aguardando Jaeger... ($JAEGER_COUNT/$JAEGER_RETRIES)"
  sleep 2
done

# Iniciar Prometheus
echo "-> Iniciando Prometheus..."
docker compose up -d prometheus

PROMETHEUS_RETRIES=15
PROMETHEUS_COUNT=0
while [ $PROMETHEUS_COUNT -lt $PROMETHEUS_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-prometheus 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Prometheus está em execução!"
    break
  fi
  PROMETHEUS_COUNT=$((PROMETHEUS_COUNT + 1))
  echo "Aguardando Prometheus... ($PROMETHEUS_COUNT/$PROMETHEUS_RETRIES)"
  sleep 2
done

# Iniciar Loki
echo "-> Iniciando Loki..."
docker compose up -d loki

LOKI_RETRIES=15
LOKI_COUNT=0
while [ $LOKI_COUNT -lt $LOKI_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-loki 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Loki está em execução!"
    break
  fi
  LOKI_COUNT=$((LOKI_COUNT + 1))
  echo "Aguardando Loki... ($LOKI_COUNT/$LOKI_RETRIES)"
  sleep 2
done

# Iniciar Grafana
echo "-> Iniciando Grafana..."
docker compose up -d grafana

GRAFANA_RETRIES=15
GRAFANA_COUNT=0
while [ $GRAFANA_COUNT -lt $GRAFANA_RETRIES ]; do
  STATUS=$(docker inspect --format='{{.State.Status}}' videocore-grafana 2>/dev/null)
  if [ "$STATUS" = "running" ]; then
    echo "-> Grafana está em execução!"
    break
  fi
  GRAFANA_COUNT=$((GRAFANA_COUNT + 1))
  echo "Aguardando Grafana... ($GRAFANA_COUNT/$GRAFANA_RETRIES)"
  sleep 2
done

echo
echo "===== Infraestrutura iniciada com sucesso ====="
echo
echo "Serviços disponíveis:"
echo "- Open Telemetry Collector"
echo "- Jaeger"
echo "- Prometheus"
echo "- Loki"
echo "- Grafana"
echo
echo "Use 'docker compose ps' para verificar o status."