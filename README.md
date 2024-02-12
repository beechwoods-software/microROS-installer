# Scripts to help install a Micro-ROS build on Ubuntu 22.04
To use in the root of your target directory run
```
setup.sh -a <app> -b <board>
```

# Docker container to build Micro-ROS build on other operating systems
The instructions in the section above should work in a clean Ubuntu 22.04 install, but may not work in other variants of Linux or in an Ubuntu 22.04 that has been modified such that it's environment is not compatible. This docker build should solve most of those problems, and will probably even allow you to build in an OS other than Linux with minor changes (it is known to work in Mac OS, for example, provided that the environment variable _HOME_ is changed from _"/home/{username}"_ to _"/Users/{username}"_). The docker container can also be used to run the micro-ROS agent, but _docker run_ will need to be run with a _-p 8888:8888_ argument in order for the agent's UDP port to be visible outside of the container.

To build in a docker container, run this script and follow the instructions in its output:
```
./docker_setup.sh
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
### Picolib wrapper functions
Picolib seems to have an issue with _rand()_ and _srand()_. While the application links, it crashes. With alternate implemenations, the application works correctly. The patches in this package have changed the definitions of these functions to:
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
