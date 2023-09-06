#!/bin/bash
#set -x
set -e
board=esp32
app=soilsensor
repo=ssh://git@lm-gitlab.beechwoods.com:7999
#repo=ssh@192.168.111.100:/git
while getopts "a:b:r:gh" OPTION; do
    case $OPTION in
	a)
	    app=$OPTARG
	    ;;
	b)
	    board=$OPTARG
	    ;;
	r)
	    repo=$OPTARG
	    ;;
	h)
	    echo "Usage: setup -a <app> -b <board> -r repo"
	    exit 0
	    ;;
	*)
	    echo "Usage: setup -a <app> -b <board> -r repo"
	    exit -1
	    ;;
    esac
done
echo Board: $board app: $app repo: $repo
tmpname=`readlink -f  $0`
prgdir=`dirname $tmpname`
$prgdir/install_microros.sh ${board}
pushd microros_ws/firmware/zephyr_apps/apps
  git clone -b master $repo/zephyr/soilsensor
  git clone -b main $repo/micro-ros/weatherstation

popd
pushd microros_ws/firmware/mcu_ws
  git clone -b main $repo/micro-ros/idl/weatherstation
popd
pushd microros_ws
  source /opt/ros/$ROS_DISTRO/setup.bash
  source  install/local_setup.bash
  ros2 run micro_ros_setup configure_firmware.sh $app  --transport udp -i 192.168.2.2 -p 8888
  ros2 run micro_ros_setup build_firmware.sh  2>&1 | tee /tmp/microros_build_zephyr_${board}.log
  ros2 run micro_ros_setup create_agent_ws.sh
  source  install/local_setup.bash
  ros2 run micro_ros_setup build_agent.sh --cmake-args -Wno-dev
#  ros2 run micro_ros_agent micro_ros_agent udp4
popd

#echo run 'ros2 run micro_ros_agent micro_ros_agent udp4 -p 8888'
