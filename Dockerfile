FROM archlinux/base:latest

RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade go make git

WORKDIR /workspace