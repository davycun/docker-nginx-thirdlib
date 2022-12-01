#!/bin/bash

NGINX_VERSION=1.23.2
TAG=${NGINX_VERSION}-alpine-forward

echo "docker build  -t davidcun/nginx:$TAG --build-arg NGINX_VERSION=$NGINX_VERSION -f ./Dockerfile ."
docker build  -t davidcun/nginx:$TAG --build-arg NGINX_VERSION="$NGINX_VERSION" -f ./Dockerfile .