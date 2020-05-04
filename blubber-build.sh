#!/usr/bin/env bash

# clean up previous builds
docker rm wikispeech-symbolset-test
docker rmi --force wikispeech-symbolset-test

docker rm wikispeech-symbolset
docker rmi --force wikispeech-symbolset

# build docker
blubber .pipeline/blubber.yaml test | docker build --tag wikispeech-symbolset-test --file - .
blubber .pipeline/blubber.yaml production | docker build --tag wikispeech-symbolset --file - .
