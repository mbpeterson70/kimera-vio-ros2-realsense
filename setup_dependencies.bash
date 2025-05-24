# clone and build ros-jazzy-ros1-bridge
git clone https://github.com/TommyChangUMD/ros-${ROS_DISTRO}-ros1-bridge-builder.git
cd ros-${ROS_DISTRO}-ros1-bridge-builder
git checkout 3c9e0b5ef792002bb01a85b28e54b0b8ce593d2f
docker build . -t ros-${ROS_DISTRO}-ros1-bridge-builder

cd ..
docker run --rm ros-${ROS_DISTRO}-ros1-bridge-builder | tar xvzf -