#!/bin/bash
set -e
tmpname=`readlink -f  $0`
prgdir=`dirname $tmpname`

# applyPatches <destination> <patchDirectoryUnder$prgdir>
applyPatches()
{
    if [ -d $1 ]; then
        pushd $1
        for x in $prgdir/$2/*; do
            patch -p 1 < $x
        done
        popd
    else
        echo "Warning: Directory `pwd`/$1 doesn't exist!!!"
    fi
}
  
applyPatches firmware/dev_ws/ament/ament_cmake ament_cmake
applyPatches firmware/zephyrproject/modules/lib/picolibc picolib
applyPatches firmware/mcu_ws/ros2/common_interfaces ros2_common_interfaces
applyPatches firmware/mcu_ws/ros2/libyaml_vendor ros2_libyaml
applyPatches firmware/mcu_ws/ros2/rcl_logging ros2_rcl_logging_interface

#These directories don't exist anymore (though the refactored code may just live under rosidl/
#applyPatches firmware/mcu_ws/ros2/rosidl_dynamic_typesupport ros2_rosidl_dynamic_typesupport
#applyPatches firmware/mcu_ws/uros/rosidl_typesupport rosidl_typesupport_patches

applyPatches firmware/mcu_ws/uros/tracetools tracetools
applyPatches firmware/mcu_ws/uros/micro_ros_msgs uros_micro_ros_msgs_patches
applyPatches firmware/mcu_ws/uros/micro_ros_utilities uros_micro_ros_utilities
applyPatches firmware/mcu_ws/uros/rcl uros_rcl
applyPatches firmware/mcu_ws/uros/rclc uros_rclc
applyPatches firmware/mcu_ws/uros/rcutils uros_rcutils
applyPatches firmware/mcu_ws/eProsima/Micro-XRCE-DDS-Client Micro-XRCE-DDS-Client
applyPatches firmware/mcu_ws/uros/rmw_microxrcedds uros_rmw_microxrcedds
applyPatches firmware/mcu_ws/uros/rosidl_typesupport_microxrcedds uros_rosidl_typesupport_microxrcedds
applyPatches firmware/zephyr_apps zephyr_apps_patches
applyPatches firmware/zephyrproject/zephyr zephyr_patches
