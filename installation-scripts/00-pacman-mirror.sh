#!/bin/bash

cat > /etc/pacman.d/gnupg/dirmngr.conf <<EOF
keyserver hkps://hkps.pool.sks-keyservers.net:443
keyserver hkp://pool.sks-keyservers.net:80
EOF

# Initialize pacman-key ring
pacman-key --init
pacman-key --refresh-keys

# Add GPG Key
pacman-key --recv-keys 9B146D11A9ED6CA7E279EB1A852BCC170D81A982
pacman-key --lsign 9B146D11A9ED6CA7E279EB1A852BCC170D81A982

# Add additional pacman mirrors
cat >> /etc/pacman.conf <<EOF

[any]
Server = https://aur.cryptic.systems/any/

[x86_64]
Server = https://aur.cryptic.systems/x86_64/
EOF
