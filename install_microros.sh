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
mkdir microros_ws
cd microros_ws
git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
pushd src/micro_ros_setup
  for x in $prgdir/micro_ros_setup/* ; do
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

#pushd firmware/mcu_ws/uros/tracetools
#  for x in $prgdir/tracetools/*; do
#    patch -p1 < $x
#  done
#popd

pushd firmware/mcu_ws/ros2/libyaml_vendor
for x in $prgdir/ros2_libyaml/*; do
    patch -p1 < $x
done
popd

pushd firmware/mcu_ws/ros2/common_interfaces
for x in $prgdir/ros2_common_interfaces/*; do
    patch -p1 < $x
done
popd

pushd firmware/zephyrproject/modules/lib/picolibc
for x in $prgdir/picolib/*; do
    patch -p1 < $x
done
popd
pushd firmware/mcu_ws/ros2/rcl_logging
for x in $prgdir/ros2_rcl_logging_interface/*; do
    patch -p1 <$x
done
popd
pushd firmware/mcu_ws/uros/rcl
for x in $prgdir/uros_rcl/*; do
    patch -p1 <$x
done
popd
pushd firmware/mcu_ws/uros/rclc
for x in $prgdir/uros_rclc/*; do
    patch -p1 <$x
done
popd
    
    
	 

    
	 
    
