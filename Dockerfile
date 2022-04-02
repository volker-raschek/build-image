FROM docker.io/library/archlinux:latest

ENV BUILD_USER=build

RUN pacman --sync --refresh --noconfirm --sysupgrade sudo

RUN echo "${BUILD_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${BUILD_USER} && \
    useradd --create-home --home-dir /home/${BUILD_USER} --shell /bin/bash ${BUILD_USER}
USER ${BUILD_USER}

# execute local files
COPY installation-scripts /tmp/installation-scripts
RUN for f in {00-pacman-mirror.sh,01-rustup.sh}; do sudo /tmp/installation-scripts/$f; done && \
    sudo rm --recursive --force /tmp/installation-scripts
ENV PATH="/home/${BUILD_USER}/.cargo/bin:/${BUILD_USER}/go/bin:${PATH}"

# Install PKGs from public repositories
RUN sudo pacman --sync --refresh --noconfirm --sysupgrade \
      awk \
      base-devel \
      bash-completion \
      docker \
      gcc \
      git \
      gnupg \
      go \
      make \
      pacman-contrib \
      podman \
      which \
      zip

RUN sudo usermod --append --groups docker ${BUILD_USER}

# Install PKGs from private repositories
RUN sudo pacman --sync --refresh --noconfirm --sysupgrade \
      oracle-instantclient-basic \
      oracle-instantclient-jdbc \
      oracle-instantclient-odbc \
      oracle-instantclient-sdk \
      oracle-instantclient-sqlplus \
      oracle-instantclient-tools \
      rpm-builder

WORKDIR /workspace
VOLUME [ "/workspace" ]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
