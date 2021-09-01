FROM docker.io/library/archlinux:latest

RUN pacman --sync --refresh --noconfirm --sysupgrade \
      awk \
      bash-completion \
      docker \
      gcc \
      git \
      go \
      make \
      podman \
      which \
      zip

# execute local files
COPY installation-scripts /tmp/installation-scripts
RUN for f in {00-pacman-mirror.sh,01-rustup.sh}; do /tmp/installation-scripts/$f; done && \
    rm --recursive --force /tmp/installation-scripts
ENV PATH="/root/.cargo/bin:/root/go/bin:${PATH}"

# Install PKGs from own repo
RUN pacman --sync --refresh --noconfirm --sysupgrade \
      oracle-instantclient-basic \
      oracle-instantclient-jdbc \
      oracle-instantclient-odbc \
      oracle-instantclient-sdk \
      oracle-instantclient-sqlplus \
      oracle-instantclient-tools \
      rpm-builder

WORKDIR /workspace