# Kimera-VIO-ROS2-RealSense

This repo enables using [Kimera-VIO](https://github.com/MIT-SPARK/Kimera-VIO) with [Intel RealSense cameras](https://www.intelrealsense.com/) in ROS2.

Kimera-VIO is a visual-inertial odometry package created by MIT Spark Lab. 
[Kimera-VIO-ROS](https://github.com/MIT-SPARK/Kimera-VIO-ROS) only supports ROS1, so this repo was created to enable continuation of Kimera-VIO for the new age of ROS2 :)

This repo builds Kimera-VIO-ROS in a docker and a ROS1-2 bridge locally. 
RealSense camera images are then bridged from ROS2 to ROS1 locally and then communicated in ROS1 to the docker image. 

Credits:
* [Original Kimera-VIO repo](https://github.com/MIT-SPARK/Kimera-VIO)
* [Andrew Fishberg's kimera-vio-docker for running on bags](https://github.com/fishberg/kimera-vio-docker)
* [Tommy Chang's ROS1/2 bridge builder](https://github.com/TommyChangUMD/ros-jazzy-ros1-bridge-builder)

## Prerequisites

Before using this repo the following should be installed:
* [Docker](https://www.docker.com/get-started/)
* [ROS2](https://docs.ros.org/en/jazzy/index.html) (Humble or Jazzy)
* [Intel RealSense ROS2 Wrapper](https://github.com/IntelRealSense/realsense-ros)

Additional dependencies can be installed with:

```
sudo apt install tmux tmuxp ros-${ROS_DISTRO}-rmw-zenoh-cpp
```

## Building

First source ROS2:

```
source /opt/ros/<ros distro>
```

Then build the ROS1/2 bridge and Docker image:

```
git clone https://github.com/mbpeterson70/kimera-vio-ros2-realsense.git
cd kimera-vio-ros2-realsense
./build.bash
```

## Run

Plug in your RealSense camera (currently supporting only D455) and run

```
./run.bash
```

This will start a tmux session that runs your camera node, the ROS1/2 bridge, and Kimera-VIO in a docker. 

By virtue of the dynamic bridge, you will only be able to see topics coming from ROS1 that are being actively subscribed to by a node. 
That means you won't be able to see the output from Kimera-VIO to topics like `/tf` and `/d455/kimera_vio_ros/odometry` unless have a node actively subscribing to them. 
To make it easy to check that everything is working, you can run `./run.bash true` which will create a dummy node to subscribe to `/d455/kimera_vio_ros/odometry` so that you can easily echo it in ros2.

To exit cleanly, you can just push enter in the default focus tmux pane after starting.
