Micro-ros installation helper

To use in the root of your target directory run

setup.sh -a \<app\> -b \<board\> -r \<git server\>

app defaults to soilsenor

board defaults to esp32

repo defaults to ssh://git@lm-gitlab.beechwoods.com:7999

The setup script calls install_microros.sh which clones the necessary repositories and applies local patches to them.

The setup script then  clones two apps, weatherstation and soilsensor from the repo. it also clones the idl/weatherstation custom idl from the repo. Micro Ros cannot build idl as part of the application and it must be separated and placed in the microros_ws/firmware/mcu_ws directory for it to be built.

The setup script then builds the chosen application and also creates and builds  mircro_ros_agent. Currently it does not run the agent becuase you can apt install it on Ubuntu and it will always be running.

To modify and rebuild the app make sure that you source these two files

source /opt/ros/\$ROS_DISTRO/setup.bash

source install/local_setup.bash

You can then build your app with the

ros2 run micro_ros_setup build_firmware.sh

command