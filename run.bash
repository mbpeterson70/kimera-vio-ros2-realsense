#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# ROS_VARS="-e ROS_MASTER_URI=http://10.29.255.192:11311 -e ROS_IP=10.29.255.192 -e ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
# KIMERA_VARS="-e CAMERA=$KIMERA_VIO_CAMERA"

# docker run -it --rm --net=host \
# 	$ROS_VARS $KIMERA_VARS \
# 	kimera-vio-docker

export ROS_IP=$(ip route get 192.168.0.1 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
export ROS_MASTER_URI=http://$ROS_IP:11311
export KIMERA_VIO_ROS2_REALSENSE_DIR=$SCRIPT_DIR

tmuxp load $SCRIPT_DIR/run.yaml