#!/usr/bin/env bash

#
# This script is executed from within the docker image during Blubber build.
#

mkdir symbolset
mv * symbolset

m_error() {
  echo $1
  exit 2
}

install_symbolset() {
  cd /srv/symbolset

  cd server
  if ! go build .; then
    m_error "Failed to build Symbolset!"
  fi

  if [ ! -d lexdata ]; then
    if ! git clone https://github.com/stts-se/wikispeech-lexdata.git lexdata; then
      m_error "Unable to clone lexdata from git repo"
    fi
  else
    cd lexdata
    if ! git pull; then
      m_error "Unable to update lexdata from git repo"
    fi
    cd ..
  fi

  if ! /bin/bash setup.sh lexdata ss_files; then
    m_error "setup.sh lexdata ss_files failed"
  fi

  echo "Starting Symbolset server. Will wait a minute for it to start up and download any dependencies, and then kill it."
  ./server -ss_files ss_files &
  SYMBOLSET_PID=$!
  for i in $(seq 1 6); do
    sleep 10
    echo "${i}0/60 seconds slept before killing server..."
  done
  kill ${SYMBOLSET_PID}
}

install_symbolset

echo "Successfully prepared Symbolset!"
