#!/bin/bash

# Initialize pacman-key ring
pacman-key --init

# Add GPG Key
pacman-key --recv-keys 9B146D11A9ED6CA7E279EB1A852BCC170D81A982
pacman-key --lsign 9B146D11A9ED6CA7E279EB1A852BCC170D81A982

# Add additional pacman mirrors
cat >> /etc/pacman.conf << 'EOF'

[cs_any]
Server = https://aur.cryptic.systems/any/

[cs_x86_64]
Server = https://aur.cryptic.systems/x86_64/
EOF
