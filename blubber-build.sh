#!/usr/bin/env bash

# clean up previous builds
docker rm wikispeech-symbolset-test
docker rmi --force wikispeech-symbolset-test

docker rm wikispeech-symbolset
docker rmi --force wikispeech-symbolset

# build docker
docker build --tag wikispeech-symbolset-test --file .pipeline/blubber.yaml --target test .
docker build --tag wikispeech-symbolset --file .pipeline/blubber.yaml --target production .
