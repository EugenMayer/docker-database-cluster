#!/bin/bash
set -e
source .env
NETWORK=${COMPOSE_PROJECT}_dbs
docker run --rm --link postgres:$PG_DOMAIN -e PGREQUIRESSL=1 -e PGSSLMODE=require -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest psql -h $PG_DOMAIN -U postgres
