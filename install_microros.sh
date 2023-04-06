#!/bin/bash

if [ -z ${ROS_DISTRO} ]; then
  echo ROS_DISTRO not set
  exit -1
fi
board=esp32
if [ -n "${1}" ]; then
board=$1
fi
tmpname=`readlink -f  $0`
prgdir=`dirname $tmpname`

# Source the ROS 2 installation
source /opt/ros/$ROS_DISTRO/setup.bash

# Create a workspace and download the micro-ROS tools
mkdir microros_ws
cd microros_ws
git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
pushd src/micro_ros_setup
  for x in $prgdir/00* ; do
    patch -p 1 < $x
  done
popd

# Update dependencies using rosdep
echo put this back sudo apt update && rosdep update
rosdep install --from-paths src --ignore-src -y

# Install pip
# echo put this back sudo apt-get install python3-pip

# Build micro-ROS tools and source them
colcon build
source install/local_setup.bash

ros2 run micro_ros_setup create_firmware_ws.sh zephyr $board 2>&1 | tee /tmp/microros-zephyr-$board.log

pushd firmware/zephyr_apps
  for x in $prgdir/zephyr_apps_patches/* ; do
    patch -p 1 < $x
  done
popd
  
pushd firmware/mcu_ws/uros/rcutils
for x in $prgdir/mcu_rutils_patches/* ; do
    patch -p 1 < $x
  done
popd
  
pushd firmware/dev_ws/ament/ament_cmake
for x in $prgdir/ament_cmake/* ; do
    patch -p 1 < $x
  done
popd

pushd firmware/zephyrproject/zephyr
  for x in $prgdir/zephyr_patches/* ; do
    patch -p 1 < $x
  done
popd

pushd firmware/mcu_ws/uros/rosidl_typesupport
for x in $prgdir/rosidl_typesupport_patches/* ; do
    patch -p 1 < $x
  done
popd

