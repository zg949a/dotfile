#!/bin/bash
#

#mkdir utmp
#sudo apt-get install mount
#sudo mount /dev/sdc1 /home/zgz/utmp

cp sources.list /etc/apt/sources.list

sudo apt update

sudo apt upgrade

sudo apt install sudo

sudo apt install firmware-iwlwifi

echo OK!

sudo apt install pip

cd

cd Netdisk/
sudo python3 -m pip install --upgarde pip
sudo pip3 install requests
sudo pip3 install bypy
bypy info
#sync netdisk
bypy download
