#!/bin/bash
dockerfile=dockerfile.$$
username=`whoami`
userId=`id -u $username`
image="$username:mros_humble"

infoLocalConf()
{
    echo "$HOME/local.conf should be:"
    echo "CONFIG_WIFI_SSID=\"YourWifiId\""
    echo "CONFIG_WIFI_PSK=\"YourWifiPassword\""
    echo "CONFIG_AGENT_ADDRESS=\"ipAddressOfRosAgent\""
    exit
}

echo Checking $HOME/local.conf
if [ -f $HOME/local.conf ]; then
    . $HOME/local.conf
    [ -z "$CONFIG_WIFI_SSID" ] && echo "ERROR: CONFIG_WIFI_SSID not found in $HOME/local.conf" && infoLocalConf
    [ -z "$CONFIG_WIFI_PSK" ] && echo "ERROR: CONFIG_WIFI_PSK not found in $HOME/local.conf" && infoLocalConf
    [ -z "$CONFIG_AGENT_ADDRESS" ] && echo "ERROR: CONFIG_AGENT_ADDRESS not found in $HOME/local.conf" && infoLocalConf
else
    echo "Error: $HOME/local.conf Not Found!!!"
    infoLocalConf 
fi
echo "FROM cliu5764/microros.humble" >> $dockerfile
echo "RUN useradd -u $userId $username" >> $dockerfile
echo "RUN adduser $username sudo" >> $dockerfile
echo "RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers" >> $dockerfile
echo "USER $username" >> $dockerfile
echo "CMD /bin/bash"

echo "Building docker image $image"
docker build -t $image -f $dockerfile .

[ $? != 0 ] && "ERROR on building docker image $image!! exiting..." && exit

echo "_____________________________________________________________________________________"
echo "* A docker image $image has been set up. To build, please run"
echo "docker run -v $PWD:$PWD -v $HOME:$HOME -it $image"
echo "* You should be inside the docker container, you can build by running the followings"
echo "cd $PWD"
echo "./setup.sh"
