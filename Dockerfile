# using tag debian:buster-slim to automatically receive updates on buster
# assuming debian:buster-slim is stable enough, so no breaking changes

FROM debian:buster-slim as builder
LABEL maintainer="PDOK dev <https://github.com/PDOK/lighttpd-docker/issues>"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Amsterdam
ENV LIGHTTPD_VERSION=1.4.67

# https://redmine.lighttpd.net/projects/lighttpd/wiki/DevelGit
# hadolint ignore=DL3008
RUN apt-get -y update \
  && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  ca-certificates \
  git \
  libbz2-dev \
  liblua5.2-dev \
  libpcre2-dev \
  libssl-dev \
  libtool \
  m4 \
  make \
  pkg-config \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --single-branch -b lighttpd-${LIGHTTPD_VERSION} https://git.lighttpd.net/lighttpd/lighttpd1.4/ /usr/local/src/lighttpd-${LIGHTTPD_VERSION}

WORKDIR /usr/local/src/lighttpd-${LIGHTTPD_VERSION}

RUN ./autogen.sh \
  && ./configure \
  --with-lua \
  --with-openssl \
  --disable-dependency-tracking \
  && make \
  && make install

FROM debian:buster-slim as service
LABEL maintainer="PDOK dev <https://github.com/PDOK/lighttpd-docker/issues>"

RUN useradd --no-log-init -U -r www

COPY --from=builder /usr/local/sbin /usr/local/sbin
COPY --from=builder /usr/local/lib /usr/local/lib

COPY /config/lighttpd.conf /srv/lighttpd/lighttpd.conf
COPY /www/index.html /var/www/index.html

# hadolint ignore=DL3008
RUN apt-get -y update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  libcap2-bin \
  liblua5.2-0 \
  wget \
  && rm -rf /var/lib/apt/lists/*

# allow non root user to bind to port 80 with lighttpd binary
RUN setcap 'cap_net_bind_service=+ep' /usr/local/sbin/lighttpd

# hadolint ignore=DL3059
RUN mkdir -p /var/cache/lighttpd/compress && \
  chown -R www:www /var/cache/lighttpd/compress


ENV DEBUG 0
ENV MIN_PROCS 1
ENV MAX_PROCS 3
ENV MAX_LOAD_PER_PROC 4
ENV IDLE_TIMEOUT 20

EXPOSE 80
STOPSIGNAL SIGINT
CMD ["lighttpd", "-D", "-f", "/srv/lighttpd/lighttpd.conf"]
