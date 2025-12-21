#!/bin/bash

set -e

USER=$1
DATABASE=$2
PASSWORD=$3

if [ -z "$USER" ]
then
      echo "Error: Please pass the desired user as first paramter"
      exit 1
fi

if [ -z "$DATABASE" ]
then
      echo "Error:lease pass the desired database as second paramter"
      exit 1
fi

if [ -z "$PASSWORD" ]
then
      echo "Generating password (since not set as 3rd parameter)"
      PASSWORD=`tr -cd '[:alnum:]' < /dev/urandom | fold -w40 | head -n1`
fi

source .env
NETWORK=$(COMPOSE_PROJECT)_dbs
CMD="docker run --rm --link postgres:$PG_DOMAIN -e PGREQUIRESSL=1 -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest psql -h $PG_DOMAIN -U postgres -c"

$CMD "CREATE USER ${USER} WITH LOGIN PASSWORD '${PASSWORD}'"
$CMD "CREATE DATABASE ${DATABASE}"
$CMD "ALTER DATABASE ${DATABASE} owner to ${USER}"

echo "- Created user $USER"
echo "- Created database $DATABASE"
echo "- Your Password is: $PASSWORD"
