#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd $SCRIPT_DIR

docker build -t kimera-vio-docker -f $SCRIPT_DIR/docker/Dockerfile .
popd