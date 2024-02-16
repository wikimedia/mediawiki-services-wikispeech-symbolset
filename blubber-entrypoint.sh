#!/usr/bin/env bash

echo "Starting Symbolset..."

DIR=`pwd`

cd ${DIR}/symbolset/server
./server -host 0.0.0.0 -port 8771 -ss_files ss_files
