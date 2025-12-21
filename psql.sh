#!/bin/bash
set -e
source .env
NETWORK=database-cluster_dbs
docker run --rm --link postgres:$PG_DOMAIN -e PGSSLROOTCERT=/etc/ssl/certs/ca-certificates.crt -e PGREQUIRESSL=1 -e PGSSLMODE=verify-full -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgre:latest psql -h $PG_DOMAIN -U postgres
