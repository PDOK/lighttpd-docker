FROM debian:buster-slim as builder

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Amsterdam 
ENV LIGHTTPD_VERSION=1.4.53

# https://redmine.lighttpd.net/projects/lighttpd/wiki/DevelGit
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    make \
    autoconf \
    automake \
    pkg-config \
    libtool \
    m4 \
    git \
    libssl-dev \
    libpcre3-dev \
    zlib1g-dev \
    libbz2-dev \
    liblua5.2-dev \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --single-branch -b lighttpd-${LIGHTTPD_VERSION} https://git.lighttpd.net/lighttpd/lighttpd1.4/ /usr/local/src/lighttpd-${LIGHTTPD_VERSION}

RUN cd /usr/local/src/lighttpd-${LIGHTTPD_VERSION} && ./autogen.sh && ./configure --with-lua --with-openssl \
   --disable-dependency-tracking && \
    make && \
    make install

FROM debian:buster-slim as service

ENV LIGHTTPD_MOD_MAGNET_VERSION=1.4.53-4+deb10u1

COPY --from=builder /usr/local/sbin /usr/local/sbin
COPY --from=builder /usr/local/lib /usr/local/lib

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    liblua5.2-0 \
    lighttpd-mod-magnet=${LIGHTTPD_MOD_MAGNET_VERSION} \
  && rm -rf /var/lib/apt/lists/*

ENV DEBUG 0
ENV MIN_PROCS 1
ENV MAX_PROCS 3
ENV MAX_LOAD_PER_PROC 4
ENV IDLE_TIMEOUT 20

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/srv/lighttpd/lighttpd.conf"]
