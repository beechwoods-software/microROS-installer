#!/bin/bash

#set -x
set -e

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
mkdir -p microros_ws
cd microros_ws
[ -d src/micro_ros_setup ] || git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
pushd src/micro_ros_setup
  for x in $prgdir/micro_ros_setup/* ; do
      echo "`pwd` patch -p 1 < $x"
      patch -p 1 < $x
  done
popd

# Update dependencies using rosdep
echo put this back sudo apt update && rosdep update
rosdep install --from-paths src --ignore-src -y

# Install pip
echo put this back sudo apt-get install python3-pip

# Build micro-ROS tools and source them
colcon build
source install/local_setup.bash

ros2 run micro_ros_setup create_firmware_ws.sh zephyr $board 2>&1 | tee /tmp/microros-zephyr-$board.log

$prgdir/patch_microros.sh ${board}
    
