#!/bin/bash

set -e
USER=$1
DATABASE=$2
PASSWORD=$3
FORCESSL=${4:-yes}


MARIADB_TAG=12.1
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
CMD="docker run --rm --link mariadb:$MYSQL_DOMAIN -e MYSQL_PWD="${MARIADB_ROOT_PASSWORD}" -it --network $NETWORK mariadb:$MARIADB_TAG mariadb -h $MYSQL_DOMAIN -u root --ssl --ssl-verify-server-cert -e"

if [ "${FORCESSL}" = "yes" ]; then
  echo "forcing ssl for user $USER"
  REQUIRESSL=" REQUIRE SSL"
else
  echo "ssl not enforced for user $USER"
  REQUIRESSL=""
fi


$CMD "CREATE USER IF NOT EXISTS ${USER} IDENTIFIED BY '${PASSWORD}'${REQUIRESSL}"
$CMD "CREATE DATABASE IF NOT EXISTS ${DATABASE}"
$CMD "GRANT ALL PRIVILEGES ON ${DATABASE} . * TO ${USER}@'%'"
$CMD "FLUSH PRIVILEGES;"

echo "- Created user $USER"
echo "- Created database $DATABASE"
echo "- Your Password is: $PASSWORD"
echo "- Enforce sSL: $FORCESSL"
