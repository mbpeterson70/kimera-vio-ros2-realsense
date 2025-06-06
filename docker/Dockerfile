# Adapted from https://github.com/fishberg/kimera-vio-docker

FROM ubuntu:20.04

# Avoid interactive tzdata configuration
ENV DEBIAN_FRONTEND=noninteractive

# timedatectl list-timezones
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Essentials
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -q -y --no-install-recommends apt-utils
RUN apt-get install -q -y --no-install-recommends net-tools iproute2 iputils-ping
RUN apt-get install -q -y --no-install-recommends git tmux vim neovim tmuxp curl

RUN apt update && apt install -y \
    lsb-release \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
    build-essential \
    python3-pip \
    git \
    vim \
    tmux \
    tmuxp \
    libtbb-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up ROS repository
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# Install ROS Noetic
RUN apt update && apt install -y \
    ros-noetic-desktop-full
#     && rm -rf /var/lib/apt/lists/*

# needed for system dependencies
RUN apt-get install -q -y --no-install-recommends \
      cmake build-essential unzip pkg-config autoconf
RUN apt-get install -q -y --no-install-recommends libboost-all-dev 
RUN apt-get install -q -y --no-install-recommends libjpeg-dev libpng-dev libtiff-dev 
RUN apt-get install -q -y --no-install-recommends libvtk6-dev libgtk-3-dev 
RUN apt-get install -q -y --no-install-recommends libatlas-base-dev gfortran 
RUN apt-get install -q -y --no-install-recommends libparmetis-dev 
RUN apt-get install -q -y --no-install-recommends python3-wstool python3-catkin-tools

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

# catkin build
SHELL ["/bin/bash", "-c"]
WORKDIR ${WORKSPACE}
# build with half the available threads otherwise memory runs out
RUN source $ROS_DIR/setup.bash && catkin build -j $(( $(nproc) / 2 ))

COPY "./kimera-vio-ros1-docker" "${WORKSPACE}/src/kimera-vio-ros1-docker"
RUN source $ROS_DIR/setup.bash && catkin build kimera_vio_ros1_docker

COPY "./docker/entrypoint.bash" /
COPY "./docker/kimera_vio.yaml" /
COPY "./docker/tmux.conf" /root/.tmux.conf
ENTRYPOINT ["/entrypoint.bash"]
