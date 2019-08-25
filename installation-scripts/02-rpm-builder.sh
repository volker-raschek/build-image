#!/bin/bash

set -e

VERSION=v0.3.1
TMP_DIR=$(mktemp -d)

git clone --branch ${VERSION} https://github.com/Richterrettich/rpm-builder.git ${TMP_DIR} &&
  make -C ${TMP_DIR} build_linux &&
  cp ${TMP_DIR}/target/x86_64-unknown-linux-musl/release/rpm-builder /usr/local/bin/rpm-builder
