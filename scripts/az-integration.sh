#!/bin/bash
# Publica um vídeo no Azurite e emite um evento no Azure Service Bus via AMQP 1.0
# usando protonj2-sender executado em Docker

set -e

# ===============================
# CONFIGURAÇÕES – AZURITE
# ===============================
AZURITE_ACCOUNT_NAME="devstoreaccount1"
AZURITE_ACCOUNT_KEY="Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="
AZURITE_BLOB_ENDPOINT="http://127.0.0.1:10000/devstoreaccount1"
CONTAINER_NAME="videos"
IMAGE_CONTAINER_NAME="images"

# ===============================
# CONFIGURAÇÕES – SERVICE BUS (AMQP)
# ===============================
SERVICEBUS_HOST="localhost"
SERVICEBUS_AMQP_PORT="5672"
SERVICEBUS_QUEUE="process.queue"
SERVICEBUS_SAS_KEY_NAME="RootManageSharedAccessKey"
SERVICEBUS_SAS_KEY="SAS_KEY_VALUE"

# ===============================
# EVENT GRID (METADADOS)
# ===============================
SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
RESOURCE_GROUP="Storage"
STORAGE_ACCOUNT_NAME="my-storage-account"

# ===============================
# INPUTS
# ===============================
VIDEO_PATH="scripts/assets/elephants_dream.mp4"
VIDEO_NAME="$(basename "$VIDEO_PATH")"

if [ ! -f "$VIDEO_PATH" ]; then
  echo "Arquivo não encontrado: $VIDEO_PATH"
  exit 1
fi

read -p "Informe a minutagem para captura das imagens (ex: 01 = a cada 1 minuto): " VIDEO_TIMESTAMPS
echo ""

# ===============================
# IDS
# ===============================
read -p "Informe o userId (Criado no LocalStack Cognito): " USER_ID
echo ""

if [ -z "$USER_ID" ]; then
  echo "userId é obrigatório."
  exit 1
fi

REQUEST_ID="$(uuidgen)"

BLOB_RELATIVE_PATH="${CONTAINER_NAME}/${USER_ID}/${REQUEST_ID}/${VIDEO_NAME}"
BLOB_NAME="${USER_ID}/${REQUEST_ID}/${VIDEO_NAME}"

# ===============================
# UPLOAD PARA AZURITE
# ===============================
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$AZURITE_ACCOUNT_NAME" \
  --account-key "$AZURITE_ACCOUNT_KEY" \
  --blob-endpoint "$AZURITE_BLOB_ENDPOINT" \
  >/dev/null

az storage container create \
  --name "$IMAGE_CONTAINER_NAME" \
  --account-name "$AZURITE_ACCOUNT_NAME" \
  --account-key "$AZURITE_ACCOUNT_KEY" \
  --blob-endpoint "$AZURITE_BLOB_ENDPOINT" \
  >/dev/null

az storage blob upload \
  --container-name "$CONTAINER_NAME" \
  --file "$VIDEO_PATH" \
  --name "$BLOB_NAME" \
  --account-name "$AZURITE_ACCOUNT_NAME" \
  --account-key "$AZURITE_ACCOUNT_KEY" \
  --blob-endpoint "$AZURITE_BLOB_ENDPOINT" \
  --metadata \
    frame_cut="$VIDEO_TIMESTAMPS" \
    user_id="$USER_ID" \
    request_id="$REQUEST_ID" \
  --content-type "video/mp4" \
  >/dev/null

echo "Upload do vídeo concluído no Azurite."
echo ""

# ===============================
# EVENTO – CLOUD EVENT 1.0
# ===============================
BLOB_URL="$AZURITE_BLOB_ENDPOINT/$BLOB_RELATIVE_PATH"
EVENT_ID="$REQUEST_ID"
EVENT_TIME="$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"
CONTENT_LENGTH="$(stat -c%s "$VIDEO_PATH")"

# https://learn.microsoft.com/en-us/azure/event-grid/event-schema-blob-storage?tabs=cloud-event-schema#microsoftstorageblobcreated-event
EVENT_PAYLOAD=$(cat <<EOF
{
  "source": "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Storage/storageAccounts/${STORAGE_ACCOUNT_NAME}",
  "subject": "/blobServices/default/containers/${CONTAINER_NAME}/blobs/${VIDEO_NAME}",
  "type": "Microsoft.Storage.BlobCreated",
  "time": "${EVENT_TIME}",
  "id": "${EVENT_ID}",
  "data": {
    "api": "PutBlockList",
    "clientRequestId": "${EVENT_ID}",
    "requestId": "${EVENT_ID}",
    "eTag": "0x0000000000000000",
    "contentType": "video/mp4",
    "contentLength": ${CONTENT_LENGTH},
    "blobType": "BlockBlob",
    "accessTier": "Default",
    "url": "${BLOB_URL}",
    "sequencer": "00000000000000000000000000000000",
    "storageDiagnostics": {
      "batchId": "${EVENT_ID}"
    }
  },
  "specversion": "1.0"
}
EOF
)

# ===============================
# SERVICE BUS – AMQP (SAS)
# ===============================
# AMQP 1.0 com SASL PLAIN
# amqp://<KeyName>:<Key>@<host>:5672/<entity>

AMQP_URL="amqp://${SERVICEBUS_SAS_KEY_NAME}:${SERVICEBUS_SAS_KEY}@${SERVICEBUS_HOST}:${SERVICEBUS_AMQP_PORT}/${SERVICEBUS_QUEUE}"

# ===============================
# PUBLICAR EVENTO VIA AMQP (DOCKER)
# ===============================
echo "Publicando evento no Azure Service Bus via AMQP (5672) usando Docker..."
./scripts/sbcli/sbcli -conn "$AMQP_URL" -queue "$SERVICEBUS_QUEUE"  -msg "$EVENT_PAYLOAD"
    
echo "Evento publicado com sucesso."
echo ""

echo "--------------------------------"
echo "Integração concluída com sucesso!"
echo ""
echo "Blob URL: $BLOB_URL"
echo "userId: $USER_ID"
echo "requestId: $REQUEST_ID"
echo "--------------------------------"