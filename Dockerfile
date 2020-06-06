ARG BASE_IMAGE

FROM ${BASE_IMAGE}

COPY installation-scripts /tmp/installation-scripts
RUN  /tmp/installation-scripts/00-pacman-mirror.sh

RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade docker go gcc make git rpm-builder which zip

ENV PATH="/root/.cargo/bin:/root/go/bin:${PATH}"

RUN for f in {01-rustup.sh,02-github-release.sh,03-go-bindata.sh}; do /tmp/installation-scripts/$f; done && \
    rm --recursive --force /tmp/installation-scripts

WORKDIR /workspace