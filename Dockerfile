FROM archlinux/base:latest

RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade go gcc make git go-bindata

WORKDIR /workspace