FROM ubuntu:18.04

RUN apt update
RUN apt install -y git wget

RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.2/osmosis-0.48.2.tgz \
  && mkdir osmosis && cd osmosis && tar xvf ../osmosis-0.48.2.tgz && rm ../osmosis-0.48.2.tgz
RUN ln -s ${pwd}/osmosis/bin/osmosis /usr/bin/osmosis
RUN ls -la /usr/bin/osmosis

RUN apt install -y default-jre

COPY run.sh /run.sh

ENTRYPOINT bash /run.sh
