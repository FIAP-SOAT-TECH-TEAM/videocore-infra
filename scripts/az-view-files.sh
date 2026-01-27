#!/bin/bash

ACCOUNT_NAME="devstoreaccount1"
ACCOUNT_KEY="Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="
BLOB_ENDPOINT="http://127.0.0.1:10000/devstoreaccount1"
CONTAINER_NAME="images"

az storage blob list \
  --account-name "$ACCOUNT_NAME" \
  --account-key "$ACCOUNT_KEY" \
  --blob-endpoint "$BLOB_ENDPOINT" \
  --container-name "$CONTAINER_NAME" \
  --output table