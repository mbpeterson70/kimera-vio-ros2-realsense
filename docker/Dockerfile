# Adapted from https://github.com/fishberg/kimera-vio-docker

FROM ros:foxy-ros1-bridge

# timedatectl list-timezones
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -q -y --no-install-recommends apt-utils
RUN apt-get install -q -y --no-install-recommends net-tools iproute2 iputils-ping
RUN apt-get install -q -y --no-install-recommends git tmux vim neovim tmuxp
# needed for system dependencies
RUN apt-get install -q -y --no-install-recommends \
      cmake build-essential unzip pkg-config autoconf \
      libboost-all-dev \
      libjpeg-dev libpng-dev libtiff-dev \
      libvtk6-dev libgtk-3-dev \
      libatlas-base-dev gfortran \
      libparmetis-dev \
      python3-wstool python3-catkin-tools
# needed for misc ros pacakges; can be simplified for lighter container
RUN apt-get install -q -y --no-install-recommends ros-noetic-desktop-full
# needed for mesh_rviz_plugins
RUN apt-get install -q -y --no-install-recommends \
      ros-noetic-image-geometry ros-noetic-pcl-ros ros-noetic-cv-bridge
# needed for gtsam
RUN apt-get install -q -y --no-install-recommends libtbb-dev
# needed catkin build
RUN apt-get install -q -y --no-install-recommends libtool
RUN apt-get autoremove -y
RUN apt-get clean
#RUN rm -rf /var/lib/apt/lists/*

ENV ROS_DIR=/opt/ros/noetic
ENV WORKSPACE=/root/catkin_ws

RUN mkdir -p $WORKSPACE/src
WORKDIR $WORKSPACE
RUN catkin init
RUN catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -DGTSAM_TANGENT_PREINTEGRATION=OFF
RUN catkin config --merge-devel

WORKDIR $WORKSPACE/src
RUN git clone https://github.com/MIT-SPARK/Kimera-VIO-ROS.git

RUN wstool init
RUN wstool merge Kimera-VIO-ROS/install/kimera_vio_ros_https.rosinstall
RUN wstool update

# fix Kimera-VIO
WORKDIR $WORKSPACE/src/Kimera-VIO
#RUN git checkout origin/feature/hydra

# fix gtsam
WORKDIR $WORKSPACE/src/gtsam
RUN git checkout c4184e192b4605303cc0b0d51129e470eb4b4ed1

# fix mesh_rviz_plugins
#COPY "./copy/mesh_rviz_plugins.patch" /root
#WORKDIR $WORKSPACE/src/mesh_rviz_plugins
#RUN patch < /root/mesh_rviz_plugins.patch

# DEBUG
#WORKDIR ${WORKSPACE}/src
#RUN rm -rf $(ls | grep -v image_undistort)

# MOVE UP; needed for image_undistort
#RUN apt-get install -q -y --no-install-recommends libnlopt-dev 

# catkin build
SHELL ["/bin/bash", "-c"]
WORKDIR ${WORKSPACE}
#RUN source $ROS_DIR/setup.bash
#ENV CMAKE_PREFIX_PATH=/opt/ros/noetic
#RUN catkin env
# https://stackoverflow.com/questions/55206227/why-bashrc-is-not-executed-when-run-docker-container
RUN source $ROS_DIR/setup.bash && catkin build -j 16

COPY "./kimera-vio-ros1-docker" "${WORKSPACE}/src/kimera-vio-ros1-docker"
RUN source $ROS_DIR/setup.bash && catkin build kimera_vio_ros1_docker


COPY "./docker/entrypoint.bash" /
COPY "./docker/kimera_vio.yaml" /
COPY "./docker/tmux.conf" /root/.tmux.conf
ENTRYPOINT ["/entrypoint.bash"]
