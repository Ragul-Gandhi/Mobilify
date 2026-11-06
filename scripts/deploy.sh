#!/bin/bash

set -e

REPO=$1
TAG=$2
NAME=$3
HOST_PORT=$4
APP_PORT=$5

echo "Deploying ${REPO}:${TAG} ..."

docker pull ${REPO}:${TAG}

docker stop ${NAME} || true
docker rm ${NAME} || true

docker run -d \
  --name ${NAME} \
  -p ${HOST_PORT}:${APP_PORT} \
  ${REPO}:${TAG}

echo "Done! App is running on port ${HOST_PORT}"
