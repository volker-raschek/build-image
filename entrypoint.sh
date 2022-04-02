#!/bin/bash

IFS=$'\n'

# generate makepkg.conf
MAKEPKG_ENV_VARS=($(env | sort | grep --perl-regexp '^MAKEPKG_.*'))
for ENV_VAR in ${MAKEPKG_ENV_VARS[@]}; do
  KEY=$(echo ${ENV_VAR} | cut --delimiter="=" --fields="1" | sed 's/MAKEPKG_//' | tr '[:lower:]' '[:upper:]')
  VALUE=$(echo ${ENV_VAR} | cut --delimiter="=" --fields="2-")
  echo "${KEY}='${VALUE}'" >> ${HOME}/.makepkg.conf
done

# import gpg key
if [ ! -z ${GPG_KEY+x} ]; then

  echo -e ${GPG_KEY} | gpg --import

  # trust gpg key
  for fpr in $(gpg --list-keys --with-colons | awk -F: '/fpr:/ {print $10}' | sort -u); do
    echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key $fpr trust
  done
fi

# add ssh private key
if [ ! -z ${SSH_KEY+x} ]; then
  mkdir --parents ${HOME}/.ssh
  sudo chmod 0700 ${HOME}/.ssh
  echo -e ${SSH_KEY} > ${HOME}/.ssh/key
  sudo chmod 0600 ${HOME}/.ssh/key
  echo -e "Host *\n  IdentityFile ~/.ssh/key" > ${HOME}/.ssh/config
fi

/bin/bash ${@}