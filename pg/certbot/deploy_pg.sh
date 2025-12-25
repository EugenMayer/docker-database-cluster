#!/bin/sh

set -e

# chown certs so pg can access them
cp -Lr /etc/letsencrypt/live/${PG_DOMAIN}/cert.pem /pg_certificates/server.crt
cp -Lr /etc/letsencrypt/live/${PG_DOMAIN}/privkey.pem /pg_certificates/server.key
cp -Lr /etc/letsencrypt/live/${PG_DOMAIN}/chain.pem /pg_certificates/chain.crt
cp -Lr /etc/letsencrypt/live/${PG_DOMAIN}/fullchain.pem /pg_certificates/fullchain.crt
chown 999:999 /pg_certificates -R
chmod 770 /pg_certificates/
