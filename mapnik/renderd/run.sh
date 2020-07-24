#!/usr/bin/env bash

MAPNIK_XML_PATH="/openstreetmap-carto/mapnik.xml"

# replace config stubs with real values
sed -i "s/\${PG_HOSTNAME}/${POSTGRES_HOST}/g" "${MAPNIK_XML_PATH}"
sed -i "s/\${PG_DBNAME}/${POSTGRES_DB}/g" "${MAPNIK_XML_PATH}"
sed -i "s/\${PG_USERNAME}/${POSTGRES_USER}/g" "${MAPNIK_XML_PATH}"
sed -i "s/\${PG_PASSWORD}/${POSTGRES_PASSWORD}/g" "${MAPNIK_XML_PATH}"

rm -rf /var/run/renderd/mod_tile/*

cd /mod_tile && renderd -f -c "${RENDERD_CONF_PATH}"
