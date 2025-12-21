#!/bin/bash

set -e

DATABASE=$1

if [ -z "$DATABASE" ]
then
      echo "Error:lease pass the desired database as second paramter"
      exit 1
fi

read -p "Will drop database $DATABSE and remove all data. Are you sure (Y/y)? " -n 1

[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

source .env
NETWORK=database-cluster_dbs
CMD="docker run --rm --link postgres:$PG_DOMAIN -e PGREQUIRESSL=1 -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest psql -h $PG_DOMAIN -U postgres -c"

$CMD "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DATABASE';"
$CMD "drop database $DATABASE;"

echo "- Dropped database $DATABASE"
