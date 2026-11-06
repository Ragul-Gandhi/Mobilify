#!/bin/bash
# build.sh - builds the Docker image

REPO=ragulgandhi/prod  
TAG=$2      

echo "Building image $REPO:$TAG ..."

# Build the image from the Dockerfile in this folder
docker build -t $REPO:$TAG -t $REPO:latest .

echo "Build finished!"
