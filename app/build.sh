#!/usr/bin/env bash

# Expects the first arg ($1) to be the image used for building
IMAGE=$1

# Build the dockerfile in the current directory and push it to the registry give by IMAGE
docker build ./ -t $IMAGE
docker push $IMAGE
