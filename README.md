# lighttpd-docker

[![GitHub license](https://img.shields.io/github/license/PDOK/lighttpd-docker)](https://github.com/PDOK/lighttpd-docker/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/PDOK/lighttpd-docker.svg)](https://github.com/PDOK/lighttpd-docker/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/pdok/lighttpd.svg)](https://hub.docker.com/r/pdok/lighttpd)

A simple [lighttpd](https://www.lighttpd.net/) image that doesn't use an entrypoint script.

## TL;DR

```docker
docker build -t pdok/lighttpd .
docker run --rm -d -v `pwd`/www/:/var/www -p 80:80 --name lighttpd-example pdok/lighttpd
docker stop lighttpd-example
```

## Introduction

This project aims to fulfill the need in creating a [lighttpd](https://www.lighttpd.net/) container that is deployable on a scalable infrastructure, like [Kubernetes](https://kubernetes.io/). This means that this image is based on a lightweight base-image.

The image comes with a default, overridable [`lighttdp.conf`](config/lighttpd.conf) file that is specifically aimed at serving static files for a web application.

## What will it do

It will start a small container containing lighttpd.

## Usage

### Build

```docker
docker build -t pdok/lighttpd .
```

### Run

This image can be run straight from the commandline. Both the default configuration file and the default asset directory can be overridden from the commandline:

- override default configuration file by mounting a directory with a `lighttpd.conf` file at `/srv/lighttpd` in the container
- override default asset directory by mounting a directory with assets to serve at `/var/www` in the container

```sh
docker run --rm -p 80:80 --name lighttpd-example -v `pwd`/config:/srv/lighttpd -v `pwd`/www:/var/www pdok/lighttpd
```

Running the example above will create a service on the url <http://localhost/>

The environment variables that can be set are the following:

- `DEBUG`
- `MIN_PROCS`
- `MAX_PROCS`
- `MAX_LOAD_PER_PROC`
- `IDLE_TIMEOUT`

The environment variables have a default value set in the Dockerfile.

### Use image in another Docker image

See below example for how to use this image to build another image to serve out static files:

```sh
work_dir="/tmp/$(uuidgen)"
mkdir "$work_dir"
cd "$work_dir"
echo "<h1>TEST</h1>" > index.html

cat > Dockerfile << EOF
FROM pdok/lighttpd
COPY index.html /var/www/index.html
EOF

docker build -t pdok/lighttpd-test .
docker run -p 80:80 pdok/lighttpd-test
```

## Misc

### How to Contribute

Make a pull request...

### Contact

Contacting the maintainers can be done through the issue tracker.
