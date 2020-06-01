FROM archlinux/base:latest

RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade go gcc make git which zip

ENV PATH="/root/.cargo/bin:/root/go/bin:${PATH}"

COPY installation-scripts /tmp/installation-scripts
RUN chmod +x /tmp/installation-scripts/* && \
    for f in $(ls /tmp/installation-scripts); do /tmp/installation-scripts/$f; done && \
    rm --recursive --force /tmp/installation-scripts

WORKDIR /workspace