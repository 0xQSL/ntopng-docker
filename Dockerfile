# based on ubuntu 16.04 to run below's commands
FROM ubuntu:16.04
MAINTAINER Javier Junquera <javier.junquera.sanchez@gmail.com># this is the original author of this docker file

# declare the working directory by environment variable
ENV WORKDIR /ntop
# set working directory
WORKDIR ${WORKDIR}

# install packages that required for build
RUN apt-get update && \
  apt-get install -y \
  build-essential \
  git \
  bison \
  flex \
  libxml2-dev \
  libpcap-dev \
  libtool \
  libtool-bin \
  rrdtool \
  librrd-dev \
  autoconf \
  automake \
  autogen \
  redis-server \
  wget \
  libsqlite3-dev \
  libhiredis-dev \
  libgeoip-dev \
  libcurl4-openssl-dev \
  libpango1.0-dev \
  libcairo2-dev \
  libnetfilter-queue-dev \
  zlib1g-dev \
  libssl-dev \
  libcap-dev \
  libnetfilter-conntrack-dev \
  libtool-bin \
  libmysqlclient-dev \
  && rm -rf /var/lib/apt/lists/*

# clone nDPI project with latest stable version
RUN git clone https://github.com/ntop/nDPI.git nDPI && cd nDPI && git reset --hard 0e11abc77fb8b2b969a19e341261394184ad4b4c

# clone ntopng project with latest stable version
RUN git clone https://github.com/ntop/ntopng.git ntopng && cd ntopng && git reset --hard fa4615f95326ff3db4ca5f59d2cee0f113a2d2d3

# copy a make script from local directory
COPY Makefile .

# compile program
RUN make -j48

# make compiled program has excutable permission
RUN ["chmod", "+x", "ntopng/ntopng"]

# copy a startup script from local directory inside docker
COPY start.sh .

# make startup script excutable
RUN ["chmod", "+x", "start.sh"]

# make docker can connect from host with specific port
EXPOSE 3000

# declare when run the docker, which sciprt need to call
ENTRYPOINT ["/ntop/start.sh"]
