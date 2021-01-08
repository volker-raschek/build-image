ARG BASE_IMAGE

FROM ${BASE_IMAGE}

RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade awk bash-completion docker go gcc make git which zip

COPY installation-scripts /tmp/installation-scripts

# Install PKGs from own repo
RUN  /tmp/installation-scripts/00-pacman-mirror.sh
RUN pacman --sync \
           --refresh \
           --noconfirm \
           --sysupgrade \
              docker-pushrm \
              oracle-instantclient-basic \
              oracle-instantclient-jdbc \
              oracle-instantclient-odbc \
              oracle-instantclient-sdk \
              oracle-instantclient-sqlplus \
              oracle-instantclient-tools \
              rpm-builder

ENV PATH="/root/.cargo/bin:/root/go/bin:${PATH}"

RUN for f in {01-rustup.sh,02-go-bindata.sh}; do /tmp/installation-scripts/$f; done && \
    rm --recursive --force /tmp/installation-scripts

WORKDIR /workspace