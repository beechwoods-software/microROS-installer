#!/bin/bash
curdir=`pwd`
cd microros_ws/src/micro_ros_setup
git clean -fd
git reset --hard

cd $curdir
rm -rf microros_ws/firmware
