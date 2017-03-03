#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE=`date +%Y-%m-%dT%T%z`

SCRIPT_DIR=$(dirname "$0")

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

if [[ -z "$COMMIT" ]] ; then
    echo "Cannot find COMMIT env var"
    exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD="sudo docker"
fi
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)

DOCKER_REPO=${GROUP}/${REPO}
$DOCKER_CMD build \
    --build-arg BUILD_VERSION=$BUILD_VERSION \
    --build-arg BUILD_DATE=$BUILD_DATE \
    --build-arg COMMIT=$COMMIT \
    -t ${DOCKER_REPO}:${COMMIT} $CODE_DIR/Dockerfile;