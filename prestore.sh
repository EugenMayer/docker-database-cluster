#!/bin/bash
set -e

# importing a pg_dump that has been exported using -Fc e.g: `pg_dump -Fc -d mydb > db.dump.sql`
# also clears the DB before importing
FILE=$1
DBNAME=$2

if [ -z "$FILE" ]
then
      echo "Error: Please pass the file to import first parameter"
      exit 1
fi

if [ -z "$DBNAME" ]
then
      echo "Error: Please pass the target database name as 2nd parameter"
      exit 1
fi

source .env
NETWORK=${COMPOSE_PROJECT}_dbs
# using -n public to avoid import extensions, see --if-exists
docker run --rm --link postgres:$PG_DOMAIN -v $FILE:/tmp/dumpsql -e PGREQUIRESSL=1 -e PGSSLMODE=require -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest pg_restore -h $PG_DOMAIN -U postgres -d $DBNAME -n public --clean /tmp/dumpsql
