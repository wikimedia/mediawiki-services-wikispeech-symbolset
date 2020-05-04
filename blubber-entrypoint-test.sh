#!/usr/bin/env bash

echo "Starting Symbolset..."

DIR=`pwd`

export GOROOT=${DIR}/go
export GOPATH=${DIR}/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

cd ${DIR}/symbolset/server
./server -host 0.0.0.0 -port 8771 -ss_files ss_files &
PID=$!
sleep 10
if ! kill -0 ${PID}; then
  echo "ERROR: Service process has prematurely ended!"
  exit 1
fi
wget -O /dev/null -o /dev/null "http://localhost:8771/symbolset/content/sv-se_ws-sampa-DEMO"
EXIT_CODE=$?
kill ${PID}
if [ ${EXIT_CODE} -ne 0 ]; then
  echo "ERROR: Test failed!"
else
  echo "Test successful!"
fi
exit ${EXIT_CODE}

