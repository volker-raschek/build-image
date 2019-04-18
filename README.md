# build-image [![Build Status](https://travis-ci.com/volker-raschek/build-image.svg?branch=master)](https://travis-ci.com/volker-raschek/build-image)
This project contains only files to build a build container image.

## golang
Execute this in your root folder of your go project.
```bash
$ docker run \
    --rm \
    --volume ${PWD}:/workspace \
    volkerraschek/build-image:latest \
      go build
```