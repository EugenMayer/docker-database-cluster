#!/bin/bash

set -e

USER=$1
DATABASE=$2

if [ -z "$USER" ]
then
      echo "Error: Please pass the desired user as first paramter"
      exit 1
fi

if [ -z "$DATABASE" ]
then
      echo "Error:lease pass the desired database as second parameter"
      exit 1
fi

read -p "Will drop database $DATABASE and remove all data.  Also dropping user $USER. Are you sure (Y/y)? " -n 1
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

source .env
NETWORK=$(COMPOSE_PROJECT)_dbs
CMD="docker run --rm --link postgres:$PG_DOMAIN -e PGREQUIRESSL=1 -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest psql -h $PG_DOMAIN -U postgres -c"

$CMD "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DATABASE'"
$CMD "DROP DATABASE $DATABASE;"
$CMD "DROP USER ${USER}"

echo "- Removed user $USER"
echo "- Removed database $DATABASE"
