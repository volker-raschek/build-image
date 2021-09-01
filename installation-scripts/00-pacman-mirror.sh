#!/bin/bash

set -e

cat > /etc/pacman.d/gnupg/dirmngr.conf <<EOF
keyserver hkps://hkps.pool.sks-keyservers.net:443
keyserver hkp://pool.sks-keyservers.net:80
EOF

# Initialize pacman-key ring
pacman-key --init
# pacman-key --refresh-keys

# Add additional pacman mirrors
cat >> /etc/pacman.conf <<EOF

[any]
SigLevel = Optional TrustAll
Server = https://aur.cryptic.systems/any/

[x86_64]
SigLevel = Optional TrustAll
Server = https://aur.cryptic.systems/x86_64/

[oracle]
SigLevel = Optional TrustAll
Server = http://linux.shikadi.net/arch/oracle/x86_64/
EOF
