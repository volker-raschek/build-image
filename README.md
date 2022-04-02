# build-image

[![Build Status](https://drone.cryptic.systems/api/badges/volker.raschek/build-image/status.svg)](https://drone.cryptic.systems/volker.raschek/build-image)
[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/build-image)](https://hub.docker.com/r/volkerraschek/build-image)

This project contains all sources to build the container image
`docker.io/volkerraschek/build-image`. The primary goal of the image is only to
provide an environment to compile source code for `go` or `rust` and package
compiled binaries as PKG for Arch Linux or as RPM for RHEL based distributions.

## Supported environment variables

### gnupg

#### GNUPG_KEY

Import private gpg key via `GPG_KEY`. The private key must be escaped to import
the key inside the container image correctly. For example:

```bash
GPG_FPR=YOUR_GPG_FINGERPRINT
GPG_KEY=$(gpg --armor --export-secret-keys ${GPG_FPR} | cat -e | sed -e 's/\$/\\n/g' -e 's/^[ \t]*//g')
```

### makepkg

The `makepkg.conf` configuration is composed from the environment variables with
the prefix `MAKEPKG_`. Below are some examples:

`MAKEPKG_PACKAGER="Hugo McKinnock <hugo.mckinnock@example.local>"`
`MAKEPKG_GPGKEY="0123456789"`
`MAKEPKG_PKGEXT=.pkg.tar.zst"`

### ssh

#### SSH_KEY

Import private ssh key via `SSH_KEY`. The private key must be escaped to import
the key inside the container image correctly. For example:

```bash
SSH_KEY=$(cat -e ${HOME}/.ssh/id_rsa | sed -e 's/\$/\\n/g')
```

## Usage

### golang

To use this image for building golang applications execute this in your root
folder of your go project.

```bash
$ docker run \
    --rm \
    --volume ${PWD}:/workspace \
    volkerraschek/build-image:latest \
      go build
```

### makepkg

With the following example will be an package be build for Arch Linux. Execute
the commond in the root directory of the project, where the `PKGBUILD` file is
located.

```bash
$ docker run \
    --env MAKEPKG_PACKAGER="Max Mustermann <max.mustermann@example.com" \
    --rm \
    --volume ${PWD}:/workspace \
    volkerraschek/build-image:latest \
      makepkg
```

### rust

If you want to compile instead go rust sourcecode, than you can do it similar to
the golang example.

```bash
$ docker run \
    --rm \
    --volume ${PWD}:/workspace \
    volkerraschek/build-image:latest \
      cargo build --release
```
