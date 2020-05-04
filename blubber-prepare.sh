#!/usr/bin/env bash

DIR=`pwd`

m_error() {
  echo $1
  exit 2
}

install_go() {
  echo "Installing Go"
  cd ${DIR}/blubber
  if [ ! -f /tmp/go1.13.linux-amd64.tar.gz ]; then
   if ! wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz -O /tmp/go1.13.linux-amd64.tar.gz; then
     m_error "Unable to download Go lang 1.13 from Google!"
   fi
  fi
  if [ ! -d ${DIR}/blubber/go ]; then
    tar xvfz /tmp/go1.13.linux-amd64.tar.gz
  fi
  echo "Go installed"
}

install_symbolset() {
  cd ${DIR}/blubber/symbolset

  cd server
  if ! go build .; then
    m_error "Failed to build Symbolset!"
  fi

  if [ ! -d lexdata ]; then
    git clone git@github.com:stts-se/lexdata.git
  else
    cd lexdata
    if ! git pull; then
      m_error "Unable to update lexdata from git repo"
    fi
    cd ..
  fi

  /bin/bash setup.sh lexdata ss_files

  echo "Starting Symbolset server. Will wait a minute for it to start up and download any dependencies, and then kill it."
  ./server -ss_files ss_files &
  SYMBOLSET_PID=$!
  for i in $(seq 1 6); do
    sleep 10
    echo "${i}0/60 seconds slept before killing server..."
  done
  kill ${SYMBOLSET_PID}
}


if [ ! -d ${DIR}/blubber ]; then
  cd ${DIR}
  cp -r . /tmp/symbolset_tmp
  mkdir blubber
  cd blubber
  mv /tmp/symbolset_tmp symbolset
fi

if [ ! -d ${DIR}/blubber/go ]; then
  install_go
fi

export GOROOT=${DIR}/blubber/go
export GOPATH=${DIR}/blubber/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

install_symbolset

echo "Successfully prepared Symbolset! Now run ./blubber-build.sh"
