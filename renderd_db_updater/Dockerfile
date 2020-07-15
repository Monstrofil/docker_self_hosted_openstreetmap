FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt update
RUN apt install -y git wget unzip postgresql

RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.2/osmosis-0.48.2.tgz \
  && mkdir osmosis && cd osmosis && tar xvf ../osmosis-0.48.2.tgz && rm ../osmosis-0.48.2.tgz
RUN ln -s ${pwd}/osmosis/bin/osmosis /usr/bin/osmosis
RUN ls -la /usr/bin/osmosis

RUN apt install -y default-jre

RUN apt-get install -y make cmake g++ libboost-dev libboost-system-dev \
  libboost-filesystem-dev libexpat1-dev zlib1g-dev \
  libbz2-dev libpq-dev libproj-dev lua5.2 liblua5.2-dev
RUN git clone git://github.com/openstreetmap/osm2pgsql.git
RUN cd osm2pgsql && mkdir build && cd build && cmake .. && make && make install

RUN mkdir /updater
WORKDIR /updater

COPY configuration.txt .
COPY run.sh .

ENTRYPOINT bash run.sh
