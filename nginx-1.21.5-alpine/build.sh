#!/bin/bash

NGINX_VERSION=$1
ENABLED_MODULES=$2

if [ "$ENABLED_MODULES" = "" ] || [ "$NGINX_VERSION" = "" ] ; then
   echo "No additional modules enabled and no NGINX_VERSION, exiting";
   exit 1;
fi

TAG=${NGINX_VERSION}-alpine-thirdlib

echo "docker build  -t davidcun/nginx:$TAG --build-arg NGINX_VERSION=$NGINX_VERSION --build-arg ENABLE_MODULES=$ENABLE_MODULES -f ./Dockerfile ."
docker build  -t davidcun/nginx:$TAG --build-arg NGINX_VERSION="$NGINX_VERSION" --build-arg ENABLED_MODULES="$ENABLED_MODULES" -f ./Dockerfile .