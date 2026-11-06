#!/bin/bash
# build.sh - builds the Docker image

REPO=ragulgandhi/prod  
<<<<<<< HEAD
TAG=1
=======
TAG=$2      
>>>>>>> origin/main

echo "Building image $REPO:$TAG ..."

# Build the image from the Dockerfile in this folder
docker build -t $REPO:$TAG -t $REPO:latest .

echo "Build finished!"
