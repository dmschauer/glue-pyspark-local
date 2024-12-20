FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

# prepare to install geopandas
# follow https://gist.github.com/abelcallejo/e75eb93d73db6f163b076d0232fc7d7e
USER root

RUN yum update -y
RUN yum install gcc-c++.x86_64 cpp.x86_64 sqlite-devel.x86_64 libtiff.x86_64 cmake3.x86_64 libpng-devel python3-devel python-devel libxml2-devel libxslt-devel postgresql postgresql-devel -y

WORKDIR /tmp
RUN wget https://download.osgeo.org/proj/proj-6.1.1.tar.gz
RUN tar -xvf proj-6.1.1.tar.gz

WORKDIR /tmp/proj-6.1.1
RUN ./configure
RUN make
RUN make install

WORKDIR /tmp
RUN wget https://github.com/OSGeo/gdal/releases/download/v3.2.1/gdal-3.2.1.tar.gz
RUN tar -xvf gdal-3.2.1.tar.gz

WORKDIR /tmp/gdal-3.2.1
RUN ./configure --with-proj=/usr/local --with-python --with-libpng --with-libpng-devel
RUN make
RUN make install

# upgrade pip for convenience
WORKDIR /home/glue_user/workspace
RUN /usr/local/bin/python3 -m pip install --upgrade pip

# start container as base image provided standard user
WORKDIR /home/glue_user/workspace
USER glue_user