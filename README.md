# build-image

[![Build Status](https://travis-ci.com/volker-raschek/build-image.svg?branch=master)](https://travis-ci.com/volker-raschek/build-image)
[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/build-image)](https://hub.docker.com/r/volkerraschek/build-image)

This project contains only files to build a build container image.

## golang

To use this image for building golang applications execute this in your root
folder of your go project.

```bash
$ docker run \
    --rm \
    --volume ${PWD}:/workspace \
    volkerraschek/build-image:latest \
      go build
```

## rust

If you want to compile instead go rust sourcecode, than you can do it similar to the golang example.

```bash
$ docker run \
    --rm \
    --volume ${PWD}:/workspace \
    volkerraschek/build-image:latest \
      cargo build --release
```
