# Scripts and patches to help build Micro-ROS apps on Zephyr 3.5
This repository contains a set of scripts and patches intended to simplify the building of a Zephyr image with a Micro-ROS application. It currently has the ability to build applications that use UDP over WiFi for transport on the following microcontroller boards: Raspberry Pi Pico W, ESP32, and ESP32c3. Other transport methods and board types should be possible with minor modifications.

## Overview:
_app_ defaults to ping_pong

_board_ defaults to _rpi_pico_w_ (other options that have been tested are: _esp32_devkitc_wroom_, _esp32c3_devkitm_).

The setup script calls _install_microros.sh_ which clones the necessary repositories and applies local patches to them.

The setup script then clones the _ping_pong_ app from the repo. 

The setup script then builds the chosen application and also creates and builds _mircro_ros_agent_. The agent is a ROS2 application that runs on your build machine and acts as a gateway between the microcontroller devices running Micro-ROS applications and larger devices running ROS2 applications.

## Setting up a build system to build Micro-ROS:

### Option 1 - Building in Ubuntu 22.04 without Docker
To use in the root of your target directory run
```
setup.sh -a <app> -b <board>
```

### Option 2 - Docker container to build Micro-ROS build on other operating systems
The procedure described in "Option 1" should work in a clean Ubuntu 22.04 install, but may not work in other variants of Linux or in an Ubuntu 22.04 that has been modified such that it's environment is not compatible. This docker build should solve most of those problems, and will probably even allow you to build in an OS other than Linux with minor changes (it is known to work in Mac OS, for example, provided that the environment variable _HOME_ is changed from _"/home/{username}"_ to _"/Users/{username}"_). The docker container can also be used to run the micro-ROS agent, but _docker run_ will need to be run with a _-p 8888:8888_ argument in order for the agent's UDP port to be visible outside of the container.

To build in a docker container, run this script and follow the instructions in its output:
```
./docker_setup.sh
```

## Rebuilding the Micro-ROS app after initial setup of build system:
Once the initial setup and build has been completed, ros2 commands can be used to rebuild the applicaton and image. The procedure is the same regardless of whether you're building within Docker. To modify and rebuild the app make sure that you source these two files:
```
source /opt/ros/\$ROS_DISTRO/setup.bash
source install/local_setup.bash
```
You can then build your app with the command:
```
ros2 run micro_ros_setup build_firmware.sh
```
