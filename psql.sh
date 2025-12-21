#!/bin/bash
set -e
source .env
NETWORK=$(COMPOSE_PROJECT)_dbs
docker run --rm --link postgres:$PG_DOMAIN -e PGSSLROOTCERT=/etc/ssl/certs/ca-certificates.crt -e PGREQUIRESSL=1 -e PGSSLMODE=verify-full -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgre:latest psql -h $PG_DOMAIN -U postgres
