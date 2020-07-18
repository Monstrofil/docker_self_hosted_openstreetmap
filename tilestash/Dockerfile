FROM ubuntu:18.04

# install Python and all the mapnik dependencies
RUN apt-get update -y
RUN apt-get install -y libjpeg-dev zlib1g-dev python3 python3-setuptools python3-dev python3-pip python3-gdal libboost-python-dev software-properties-common libmapnik3.0 libmapnik-dev mapnik-utils python3-mapnik

# symlink the native extensions so Python can pick them up
RUN ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
RUN ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib
RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_python.so /usr/lib
RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_thread.so /usr/lib

RUN python3 --version

# install tilestache, mapnik, and dependencies
RUN pip3 install Pillow tilestache simplejson werkzeug sympy Blit

RUN pip3 install uwsgi

COPY config.cfg .
COPY style.xml .
COPY world_merc.shp .
COPY world_merc.dbf .
COPY world_merc.shx .
COPY world_merc.prj .

ENTRYPOINT uwsgi --http 0.0.0.0:8080 --eval 'import TileStache; \
application = TileStache.WSGITileServer("/config.cfg")'