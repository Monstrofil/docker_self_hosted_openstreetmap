FROM ubuntu:18.04 AS npm_builder
ARG OPENSTREETMAP_HOST

RUN apt update

RUN apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt update \
   && apt install -y \
   nodejs \
   git
RUN npm install yarn -g

RUN git clone -b release --depth=1 https://github.com/openstreetmap/iD.git

RUN cd iD && sed -i 's https://www.openstreetmap.org ${OPENSTREETMAP_HOST} ' modules/services/osm.js
RUN cd iD && npm install && npm run all && npm build --prod


# ENTRYPOINT npm start

FROM nginx:latest AS nginx_id_editor
COPY --from=npm_builder iD/dist /usr/share/nginx/html
