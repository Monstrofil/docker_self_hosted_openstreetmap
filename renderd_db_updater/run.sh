#!/usr/bin/env bash

if [[ ! -e state.txt ]]; then
  wget -O state.txt https://tileserver.monstrofil.xyz/replications/minute/000/000/000.state.txt
fi

echo ${PGPASSWORD}

osmosis --read-apidb host="${POSTGRES_HOST}" database="${POSTGRES_DB}" user="${POSTGRES_USER}" password="${POSTGRES_PASSWORD}" --write-pbf file="data.osm.pbf"
#wget -O data.osm.pbf http://download.geofabrik.de/europe/monaco-latest.osm.pbf
ls -la

psql -d "${POSTGRES_DB}" --host postgis_renderd -U "${POSTGRES_USER}" -c "create extension IF NOT EXISTS hstore;"
#psql -d "${POSTGRES_DB}" --host postgis_renderd -U "${POSTGRES_USER}" -c "create extension IF NOT EXISTS postgis;"

wget https://raw.githubusercontent.com/gravitystorm/openstreetmap-carto/master/openstreetmap-carto.style
wget https://raw.githubusercontent.com/gravitystorm/openstreetmap-carto/master/openstreetmap-carto.lua

osm2pgsql --create --slim --hstore --style openstreetmap-carto.style --tag-transform-script openstreetmap-carto.lua -d "${POSTGRES_DB}" -H postgis_renderd -U "${POSTGRES_USER}" -r pbf data.osm.pbf

while true; do

  osmosis --read-replication-interval workingDirectory=. --simplify-change --write-xml-change - | \
    osm2pgsql --append -s -C 300 -G --hstore --style openstreetmap-carto.style --tag-transform-script openstreetmap-carto.lua --host=postgis_renderd -d "${POSTGRES_DB}" -U "${POSTGRES_USER}" -r xml -

  sleep 10
done