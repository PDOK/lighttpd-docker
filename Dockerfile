FROM debian:buster-slim
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Amsterdam

ENV LIGHTTPD_VERSION=1.4.53-4

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
	lighttpd=${LIGHTTPD_VERSION} \
  && rm -rf /var/lib/apt/lists/*

ENV DEBUG 0
ENV MIN_PROCS 1
ENV MAX_PROCS 3
ENV MAX_LOAD_PER_PROC 4
ENV IDLE_TIMEOUT 20

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/srv/lighttpd/config/lighttpd.conf"]