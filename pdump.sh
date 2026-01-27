#!/bin/bash
set -e

# importing a pg_dump that has been exported using -Fc e.g: `pg_dump -Fc -d mydb > db.dump.sql`
# also clears the DB before importing
FILE=$1
DBNAME=$2

if [ -z "$FILE" ]
then
      echo "Error: Please pass the file to save the dump to as the first parameter"
      exit 1
fi

if [ -z "FILE" ]
then
      echo "Error: Please pass the database to dump 2nd paramter"
      exit 1
fi

source .env
NETWORK=${COMPOSE_PROJECT}_dbs
# using -n public to avoid import extensions, see --if-exists
docker run --rm --link postgres:$PG_DOMAIN -v $FILE:/tmp/dumpsql -e PGREQUIRESSL=1 -e PGSSLMODE=require -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest pg_dump -d -Fc -h $PG_DOMAIN -U postgres -d $DBNAME > /tmp/dumpsql
