# lighttpd-docker

![GitHub license](https://img.shields.io/github/license/PDOK/lighttpd-docker)
![GitHub release](https://img.shields.io/github/release/PDOK/lighttpd-docker.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/pdok/lighttpd.svg)

A simple [lighttpd](https://www.lighttpd.net/) image that doesn't use an entrypoint script.

## TL;DR

```docker
docker build -t pdok/lighttpd .
docker run -p 80:80 --name lighttpd-example -v `pwd`/config:/srv/lighttpd pdok/lighttpd

docker stop lighttpd-example
docker rm lighttpd-example
```

## Introduction

This project aims to fulfill the need in creating a lighttpd container that is deployable on a scalable infrastructure, like [Kubernetes](https://kubernetes.io/). This means that this images is based on a lightweight base-image and tries to have no specific configuration, like COPY commands in the Dockerfile.

## What will it do

It will start a small container containing lighttpd.

## Usage

### Build

```docker
docker build -t pdok/lighttpd .
```

### Run

This image can be run straight from the commandline. A volume needs to be mounted on the container directory /srv/lighttpd/config. The mounted volume needs to contain a `lighttpd.conf` file.

```docker
docker run -p 80:80 --name lighttpd-example -v `pwd`/config:/srv/lighttpd pdok/lighttpd
```

Running the example above will create a service on the url <http://localhost/>

The ENV variables that can be set are the following

```env
DEBUG
MIN_PROCS
MAX_PROCS
MAX_LOAD_PER_PROC
IDLE_TIMEOUT
```

The ENV variables have a default value set in the Dockerfile.
