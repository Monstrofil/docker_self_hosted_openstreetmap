#!/usr/bin/env bash

echo "
user=${POSTGRES_USER}
password=${POSTGRES_PASSWORD}
host=${POSTGRES_HOST}
database=${POSTGRES_DB}
" >> /dbAuth.txt

echo "Database access settings:"
cat  /dbAuth.txt

mkdir -p /var/replications/minute/
while [[ true ]]; do
  echo "[$(date)] Replicating database..."
  /usr/bin/osmosis -q --replicate-apidb authFile=/dbAuth.txt --write-replication workingDirectory=/var/replications/minute/
  echo "[$(date)] ...done"
  sleep "${REPLICATE_PERIOD:-60}"
done
