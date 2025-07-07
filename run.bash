#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export BRIDGE_ODOMETRY=${1:-false}
export ROS_IP=127.0.0.1
export ROS_MASTER_URI=http://$ROS_IP:11311
export KIMERA_VIO_ROS2_REALSENSE_DIR=$SCRIPT_DIR
export KIMERA_VIO_CAMERA=${KIMERA_VIO_CAMERA:-d455}

tmuxp load $SCRIPT_DIR/run.yaml