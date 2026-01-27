#!/bin/bash
set -e

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

# importing a pg_dump that has been exported using plan text  e.g: `pg_dump  -d mydb > db.dump.sql`
# will not cleanup DB before importing, use prestore.sh for that
source .env
NETWORK=${COMPOSE_PROJECT}_dbs
docker run --rm --link postgres:$PG_DOMAIN -v $FILE:/tmp/dumpsql -e PGREQUIRESSL=1 -e PGSSLMODE=require -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest psql -h $PG_DOMAIN -U postgres $DBNAME -f /tmp/dumpsql
