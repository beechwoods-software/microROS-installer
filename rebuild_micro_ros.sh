#!/bin/bash
#set -x
set -e
export ROS_DISTRO=humble

pushd microros_ws
  source /opt/ros/$ROS_DISTRO/setup.bash
  source install/local_setup.bash

  ros2 run micro_ros_setup build_firmware.sh
  ros2 run micro_ros_setup create_agent_ws.sh
  ros2 run micro_ros_setup build_agent.sh --cmake-args -Wno-dev

popd
