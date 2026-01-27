#!/bin/bash
set -e

# importing a pg_dump that has been exported using -Fc e.g: `pg_dump -Fc -d mydb > db.dump.sql`
# also clears the DB before importing
TARGET_FOLDER=$1
DBNAME=$2

if [ -z "$TARGET_FILE" ]
then
      echo "Error: Please pass the target file to save the dump to as the first parameter"
      exit 1
fi

if [ -z "$DBNAME" ]
then
      echo "Error: Please pass the database to dump 2nd parameter"
      exit 1
fi

echo "Saving dump of '$DBNAME' to file: $TARGET_FILE"

source .env
NETWORK=${COMPOSE_PROJECT}_dbs
# using -n public to avoid import extensions, see --if-exists
docker run --rm --link postgres:$PG_DOMAIN -e PGREQUIRESSL=1 -e PGSSLMODE=require -e PGPASSWORD=${POSTGRES_PASSWORD} -it --network $NETWORK postgres:latest pg_dump -h $PG_DOMAIN -U postgres -Fc -d $DBNAME > $TARGET_FILE
