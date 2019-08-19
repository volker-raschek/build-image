FROM archlinux/base:latest

RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade go gcc make git go-bindata

RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh && \
    chmod +x /tmp/rustup.sh && \
    /tmp/rustup.sh -y && \
    source ${HOME}/.cargo/env && \
    rustup target add x86_64-unknown-linux-musl

ENV PATH='/root/.cargo/bin:${PATH}'

WORKDIR /workspace