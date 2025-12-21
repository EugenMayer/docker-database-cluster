#!/bin/bash
set -e

MARIADB_TAG=12.1

source .env
NETWORK=docker-database-cluster_dbs
docker run --rm --link mariadb:$MYSQL_DOMAIN -v $PWD:/workdir -e MYSQL_PWD="${MARIADB_ROOT_PASSWORD}" -it --network $NETWORK mariadb:$MARIADB_TAG mariadb -h $MYSQL_DOMAIN -u root --ssl --ssl-verify-server-cert
