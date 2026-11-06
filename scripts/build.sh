#!/bin/bash

set -e

REPO=$1
TAG=$2

echo "Building image ${REPO}:${TAG} ..."

docker build \
  -t ${REPO}:${TAG} \
  -t ${REPO}:latest \
  .

echo "Build finished!"
