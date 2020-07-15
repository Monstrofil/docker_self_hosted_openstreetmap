FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update -y
RUN apt-get install -y ruby2.5 libruby2.5 ruby2.5-dev bundler \
                     libmagickwand-dev libxml2-dev libxslt1-dev nodejs \
                     apache2 apache2-dev build-essential git-core firefox-geckodriver \
                     postgresql postgresql-contrib libpq-dev libsasl2-dev \
                     imagemagick libffi-dev libgd-dev libarchive-dev libbz2-dev

#RUN gem2.5 update --system
#RUN gem2.5 install bundler

#RUN tzdata tzdata/Areas select Europe

RUN git clone --depth=1 https://github.com/openstreetmap/openstreetmap-website.git

RUN cd openstreetmap-website && bundle install

RUN apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt update
RUN apt install nodejs -y
RUN npm install yarn -g
RUN cd openstreetmap-website && bundle exec rake yarn:install

COPY database.yml openstreetmap-website/config/database.yml

RUN cd openstreetmap-website \
  && touch config/settings.local.yml \
  && cp config/example.storage.yml config/storage.yml

WORKDIR openstreetmap-website

RUN echo ${PGPASSWORD}

RUN apt install -y wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
RUN apt update
RUN apt -y install postgresql-client-12

RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.1/osmosis-0.48.1.tgz \
  && tar xvf osmosis-0.48.1.tgz

RUN apt install -y default-jre

RUN sed -i 's/openstreetmap.example.com/tileserver.monstrofil.xyz/g' config/settings.yml \
  && sed -i 's/OpenStreetMap <openstreetmap@example.com>/OpenStreetMap <openstreetmap@tileserver.monstrofil.xyz>/g' config/settings.yml \
  && sed -i 's/#id_key: ""/id_key: "7puZ4X2jAueYxlb6SgD2LPKaip1gpFLcpNW09WZl"/g' config/settings.yml

ARG TILESERVER_HOST

COPY config/OpenStreetMap.js vendor/assets/openlayers/OpenStreetMap.js
#RUN sed -i 's/[TILESERVER_URL]/${TILESERVER_HOST}/g' vendor/assets/openlayers/OpenStreetMap.js
RUN sed -i 's https://tile.openstreetmap.org https://tiles.openstreetmap.org.ua/tile g' vendor/assets/leaflet/leaflet.osm.js

COPY config/db.sql /migrations/db.sql

ENTRYPOINT rm -f /openstreetmap-website/tmp/pids/server.pid \
#   && PGPASSWORD=${POSTGRES_PASSWORD} psql --host=postgis --user=${POSTGRES_USER} -d ${POSTGRES_DB} -f /migrations/db.sql \
#  && bundle exec rake db:create \
#  && PGPASSWORD=${POSTGRES_PASSWORD} psql --host=postgis --user=${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE EXTENSION btree_gist" \
#  && PGPASSWORD=${POSTGRES_PASSWORD} psql --host=postgis --user=${POSTGRES_USER} -d ${POSTGRES_DB} -f db/functions/functions.sql \
#  && bundle exec rake db:migrate \
  && bundle exec rails server --binding=0.0.0.0 --port=80