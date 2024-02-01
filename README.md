# Scripts to help install a Micro-ROS build

To use in the root of your target directory run
```
setup.sh -a \<app\> -b \<board\>
```
## Overview:
_app_ defaults to ping_pong

_board_ defaults to _rpi_pico_w_ (other options that have beent tested are: _esp32_devkitc_wroom_, _esp32c3_devkitm_).

The setup script calls _install_microros.sh_ which clones the necessary repositories and applies local patches to them.

The setup script then clones the _ping_pong_ app from the repo. 

The setup script then builds the chosen application and also creates and builds _mircro_ros_agent_. Currently it does not run the agent becuase you can apt install it on Ubuntu and it will always be running.

## Building a Micro-ROS app:
To modify and rebuild the app make sure that you source these two files:
```
source /opt/ros/\$ROS_DISTRO/setup.bash
source install/local_setup.bash
```
You can then build your app with the command:
```
ros2 run micro_ros_setup build_firmware.sh
```
Picolib seems to have an issue with _rand()_ and _srand()_. While the application links, it crashes. With alternate implemenations, the application works correctly. The patches in this package change the definitions of these functions to:
```
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
```
