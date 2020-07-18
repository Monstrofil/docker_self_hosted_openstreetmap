FROM ubuntu:18.04 AS renderd

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

ARG POSTGRES_USER
ARG POSTGRES_DB
ARG POSTGRES_PASSWORD
ARG POSTGRES_HOST

# install Python and all the mapnik dependencies
RUN apt-get update -y
RUN apt-get install -y autoconf apache2-dev libtool libxml2-dev libbz2-dev libgeos-dev libgeos++-dev libproj-dev gdal-bin libmapnik-dev mapnik-utils python-mapnik python3-psycopg2

RUN apt-get install -y git

RUN git clone -b switch2osm git://github.com/SomeoneElseOSM/mod_tile.git && \
cd mod_tile && \
./autogen.sh && ./configure && make -j 4

RUN cd mod_tile && make install && make install-mod_tile

RUN apt-get install -y nodejs-dev node-gyp libssl1.0-dev npm nodejs software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
RUN add-apt-repository ppa:rmescandon/yq
RUN apt update
RUN apt install yq -y

RUN git clone -b v5.2.0 --depth=1 git://github.com/gravitystorm/openstreetmap-carto.git && \
cd openstreetmap-carto && npm install -g carto && carto -v

RUN cd openstreetmap-carto && cat project.mml | head
#RUN cd openstreetmap-carto && yq w -i project.mml _parts.osm2pgsql.dbname "${POSTGRES_DB}"
#RUN cd openstreetmap-carto && yq w -I 4 -i project.mml _parts.osm2pgsql.host "${POSTGRES_HOST}"
RUN apt-get install python3-pip -y
#RUN cd openstreetmap-carto && python3 -m pip install pyYAML && python3 -c "import yaml; a = yaml.load(open('project.mml')); a._parts.osm2pgsql.dbname = '${POSTGRES_DB}'; a['_parts']['osm2pgsql.host = '${POSTGRES_HOST}'; yaml.dump(a, open('project.mml', 'w')) \
#"
RUN cd openstreetmap-carto && sed -i '/^    dbname:.*/a\ \ \ \ host: "postgis_renderd"' project.mml
RUN cd openstreetmap-carto && sed -i '/^    dbname:.*/a\ \ \ \ user: "dev"' project.mml
RUN cd openstreetmap-carto && sed -i "s/dbname: \"gis\"/dbname: \"${POSTGRES_DB}\"/g" project.mml
RUN cd openstreetmap-carto && cat project.mml | grep osm2pgsql: -A 10

RUN cd openstreetmap-carto && carto project.mml > mapnik.xml

COPY ne_110m_admin_0_boundary_lines_land.zip openstreetmap-carto/data/ne_110m_admin_0_boundary_lines_land.zip
RUN cd openstreetmap-carto && ls data && python3 scripts/get-shapefiles.py --no-download -u

RUN  apt-get install -y fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont
RUN cat /usr/local/etc/renderd.conf

RUN sed -i "s /home/renderaccount/src/openstreetmap-carto/mapnik.xml /openstreetmap-carto/mapnik.xml g" /usr/local/etc/renderd.conf \
  && sed -i 's localhost 0.0.0.0 g' /usr/local/etc/renderd.conf

RUN mkdir /var/run/renderd
RUN mkdir /var/lib/mod_tile

ENTRYPOINT renderd -f -c /usr/local/etc/renderd.conf

FROM renderd AS apache

RUN apt-get install -y apache2

RUN echo "LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so" >> /etc/apache2/conf-available/mod_tile.conf
RUN a2enconf mod_tile

RUN cat /usr/local/etc/renderd.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf