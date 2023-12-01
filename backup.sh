#!/bin/bash

PATH=$PATH:$HOME/minio-binaries/
BACKUP_DIR_DB=$HOME/mastodon/backups/postgresql

db_backup() {
  BACKUP_FILE=db_$(date +%Y-%m-%dT%H-%M-%S).sql.xz

  echo "Start db_backup."

  echo "Run pg_dump."
  docker compose exec db pg_dump -U postgres postgres | xz > "$BACKUP_DIR_DB/$BACKUP_FILE"

  echo "Run mc cp."
  mc mirror --json --overwrite --remove "$BACKUP_DIR_DB" s3/mastodon-db

  echo "Run old db backup remover."
  find "$BACKUP_DIR_DB" -type f -name "*.sql.xz" -mtime +10 -ls
  find "$BACKUP_DIR_DB" -type f -name "*.sql.xz" -mtime +10 -exec rm {} \;

  echo "End db_backup."
}

s3_backup() {
  echo "Start s3_backup."

  mc mirror --json --overwrite --remove  mastodon/mastodon-files s3/mastodon-files

  echo "End s3_backup."
}

config_backup() {
  echo "Start s3_backup."

  mc mirror --json --overwrite --remove  mastodon/mastodon-files s3/mastodon-files

  echo "End s3_backup."
}

all_backup() {
  echo "Start all_backup."

  db_backup
  s3_backup

  echo "End all_backup."
}

usage() {
  echo help
}

if [ $# -eq 0 ]; then
  echo "Args not found"
  exit 1
fi

if type "$1" 2>/dev/null | grep -q 'function'; then
  "$1"
else
  echo "Args not found: $1"
  exit 1
fi
