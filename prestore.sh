#!/bin/bash
set -e

FILE=$1
DBNAME=$2

if [ -z "$FILE" ]
then
      echo "Error: Please pass the file to import first paramter"
      exit 1
fi

if [ -z "FILE" ]
then
      echo "Error: Please pass the target database name as 2nd paramter"
      exit 1
fi

source .env
NETWORK=${COMPOSE_PROJECT}_dbs
docker run --rm --link postgres:$PG_DOMAIN -v $FILE:/tmp/dumpsql -e PGREQUIRESSL=1 -e PGSSLMODE=require -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest pg_restore -h $PG_DOMAIN -U postgres -d $DBNAME --clean -f /tmp/dumpsql
