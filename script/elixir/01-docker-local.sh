#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset

export LOCAL_PORT=8000
export APP_PORT=5000
export APP_NAME=sebastian

docker build --progress=plain \
    --build-arg dashboard_username=admin \
    --build-arg dashboard_password=admin \
    -t $APP_NAME . &&

docker run -p $LOCAL_PORT:$APP_PORT -e PORT=$APP_PORT -e HTTP_BASIC_AUTH_USERNAME=admin -e HTTP_BASIC_AUTH_PASSWORD=admin $APP_NAME
