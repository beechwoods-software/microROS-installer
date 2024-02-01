Micro-ros installation helper

To use in the root of your target directory run

setup.sh -a \<app\> -b \<board\>

app defaults to ping_pong

board defaults to rpi_pico_w (other options that have beent tested are: esp32_devkitc_wroom, esp32c3_devkitm).

The setup script calls install_microros.sh which clones the necessary repositories and applies local patches to them.

The setup script then clones the ping_pong app from the repo. 

The setup script then builds the chosen application and also creates and builds  mircro_ros_agent. Currently it does not run the agent becuase you can apt install it on Ubuntu and it will always be running.

To modify and rebuild the app make sure that you source these two files

source /opt/ros/\$ROS_DISTRO/setup.bash

source install/local_setup.bash

You can then build your app with the

ros2 run micro_ros_setup build_firmware.sh

command


Picolib seems to have an issue with rand() and srand(). While the application links, it crashes. With alternate implemenations, the application works correctly. The patches in this package change the definitions of these functions to:

void
srand (unsigned int seed)
{
  srandom(seed);
}

int
rand (void)
{
  return (int) random();
}
