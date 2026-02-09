#!/bin/bash

ACCOUNT_NAME="devstoreaccount1"
ACCOUNT_KEY="Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="
BLOB_ENDPOINT="http://127.0.0.1:10000/devstoreaccount1"
CONTAINER_NAME="images"

LATEST_BLOB=$(az storage blob list \
  --account-name "$ACCOUNT_NAME" \
  --account-key "$ACCOUNT_KEY" \
  --blob-endpoint "$BLOB_ENDPOINT" \
  --container-name "$CONTAINER_NAME" \
  --query "sort_by([], &properties.lastModified)[-1].name" \
  --output tsv)

if [ -z "$LATEST_BLOB" ]; then
  echo "Nenhum arquivo encontrado no container images"
  exit 1
fi

FILE_NAME="$(basename "$LATEST_BLOB")"

az storage blob download \
  --account-name "$ACCOUNT_NAME" \
  --account-key "$ACCOUNT_KEY" \
  --blob-endpoint "$BLOB_ENDPOINT" \
  --container-name "$CONTAINER_NAME" \
  --name "$LATEST_BLOB" \
  --file "scripts/assets/$FILE_NAME"