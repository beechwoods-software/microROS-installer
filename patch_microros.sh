#!/bin/bash
tmpname=`readlink -f  $0`
prgdir=`dirname $tmpname`

  
pushd firmware/dev_ws/ament/ament_cmake
for x in $prgdir/ament_cmake/* ; do
    patch -p 1 < $x
  done
popd
pushd firmware/zephyrproject/modules/lib/picolibc
for x in $prgdir/picolib/*; do
    patch -p1 < $x
done
popd
pushd firmware/mcu_ws/ros2/common_interfaces
for x in $prgdir/ros2_common_interfaces/*; do
    patch -p1 < $x
done
popd
pushd firmware/mcu_ws/ros2/libyaml_vendor
for x in $prgdir/ros2_libyaml/*; do
    patch -p1 < $x
done
popd
pushd firmware/mcu_ws/ros2/rcl_logging
for x in $prgdir/ros2_rcl_logging_interface/*; do
    patch -p1 <$x
done
popd

# rosidl_dynamic_typesupport and rosidl_typesupport directories
# don't exist anymore, but the same stuff is probably under rosidl directory

#pushd firmware/mcu_ws/ros2/rosidl_dynamic_typesupport
#for x in $prgdir/ros2_rosidl_dynamic_typesupport/*; do
#    patch -p1 <$x
#done
#popd
#pushd firmware/mcu_ws/uros/rosidl_typesupport
#for x in $prgdir/rosidl_typesupport_patches/* ; do
#    patch -p 1 < $x
#  done
#popd

#pushd firmware/mcu_ws/uros/tracetools
#  for x in $prgdir/tracetools/*; do
#    patch -p1 < $x
#  done
#popd
pushd firmware/mcu_ws/uros/micro_ros_msgs
for x in $prgdir/uros_micro_ros_msgs_patches/*; do
    patch -p1 <$x
done
popd
pushd firmware/mcu_ws/uros/micro_ros_utilities
for x in $prgdir/uros_micro_ros_utilities/*; do
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
pushd firmware/mcu_ws/uros/rcutils
for x in $prgdir/uros_rcutils/* ; do
    patch -p 1 < $x
  done
popd  

pushd firmware/mcu_ws/uros/rmw_microxrcedds
for x in $prgdir/uros_rmw_microxrcedds/*; do
    patch -p1 <$x
done
popd


pushd firmware/mcu_ws/uros/rosidl_typesupport_microxrcedds
for x in $prgdir/uros_rosidl_typesupport_microxrcedds/*; do
    patch -p1 <$x
done
popd
pushd firmware/zephyr_apps
  for x in $prgdir/zephyr_apps_patches/* ; do
    patch -p 1 < $x
  done
popd
pushd firmware/zephyrproject/zephyr
  for x in $prgdir/zephyr_patches/* ; do
    patch -p 1 < $x
  done
popd
