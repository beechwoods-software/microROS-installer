
CURDIR=`basename $PWD`
if [ ${CURDIR} !=  "micro_ros_setup" ]; then
  echo not in micro_ros_setup directory
  exit -1
fi
git diff config/client_ros2_packages.txt            >~/microros/004_client_ros2_packages.patch 
git diff config/client_uros_packages.repos          >~/microros/006_client_uros_packages.patch 
git diff config/zephyr/dev_ros2_packages.txt        >~/microros/005-dev_ros2_packages.patch
git diff config/zephyr/generic/build.sh             >~/microros/002_build_sh.patch
git diff config/zephyr/generic/client-colcon.meta   >~/microros/007-client-colocon-meta.patch
git diff config/zephyr/generic/create.sh            >~/microros/001_create_sh.patch
git diff config/zephyr/generic/supported_platforms  >~/microros/003_supported_platforms.patch
git diff scripts/create_firmware_ws.sh              >~/microros/008-create_firmware.patch
git diff scripts/create_ws.shscripts/create_ws.sh   >~/microros/009_create_ws.patch
