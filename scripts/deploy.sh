#!/bin/bash
# deploy.sh - runs the application from the Docker image

REPO=ragulgandhi/prod
TAG=$2
NAME=mob-con         # name for the running container
HOST_PORT=8081    # port on the server you will open in the browser
APP_PORT=80  # port the app uses inside the container

echo "Deploying $REPO:$TAG ..."

# 1. Download the image from Docker Hub
docker pull $REPO:$TAG

# 2. Stop and remove the old container (ignore errors if it doesn't exist)
docker stop $NAME || true
docker rm $NAME || true

# 3. Start the new container in the background
docker run -d --name $NAME -p $HOST_PORT:$APP_PORT $REPO:$TAG

echo "Done! App is running on port $HOST_PORT"
