#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -d "$SCRIPT_DIR/dependencies" ]; then
    # install zenoh
    sudo apt update && sudo apt install ros-jazzy-rmw-zenoh-cpp
    
    mkdir $SCRIPT_DIR/dependencies && pushd $SCRIPT_DIR/dependencies 

    # clone and build ros-jazzy-ros1-bridged
    git clone https://github.com/TommyChangUMD/ros-${ROS_DISTRO}-ros1-bridge-builder.git
    cd ros-${ROS_DISTRO}-ros1-bridge-builder
    git checkout 3c9e0b5ef792002bb01a85b28e54b0b8ce593d2f
    docker build . -t ros-${ROS_DISTRO}-ros1-bridge-builder

    cd ..
    docker run --rm ros-${ROS_DISTRO}-ros1-bridge-builder | tar xvzf -
    popd
fi

pushd $SCRIPT_DIR

docker build -t kimera-vio-docker -f $SCRIPT_DIR/docker/Dockerfile .
popd