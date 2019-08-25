#!/bin/bash

set -e

curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh && \
  chmod +x /tmp/rustup.sh && \
  /tmp/rustup.sh -y && \
  source ${HOME}/.cargo/env && \
  rustup target add x86_64-unknown-linux-musl