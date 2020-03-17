#!/usr/bin/env bash

# Copyright (C) 2019-2020 LightVortex
#
# This guide is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This guide is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
start=`date +%s`
echo -e "Please enter a OS"
echo "1)ARCH"
echo "2)Ubuntu"
read -r OS

if [[ $OS -eq 1 ]]
then 
    echo //setting up ARCH//
    # Update
    sudo pacman -Syyu
    sudo pacman -S git repo
    git clone https://github.com/akhilnarang/scripts scripts
    cd scripts
    . setup/arch*.sh
else
    echo //Setting up Ubuntu//
    sudo apt-get update
    sudo apt-get install git repo 
    git clone https://github.com/akhilnarang/scripts scripts
    cd scripts
    . setup/android*.sh
fi
cd ~/
while true; do
    read -p "Do you have java memory issues?" yn
    case $yn in
        [Yy]* )
        echo -e "enter size in GB"
        read -r size
        echo 'export _JAVA_OPTIONS=-Xmx${size}G ' >> .bashrc; 
        break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
while true; do
    read -p "Do you need swap?" yn
    case $yn in
        [Yy]* )
        echo -e "enter size in GB"
        read -r swap
        sudo fallocate -l ${swap}G /swapfile
        sudo mkswap /swapfile
        sudo chmod 600 /swapfile
        sudo swapon /swapfile
        sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
        break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo 'export USE_CCACHE=1' >> .bashrc;
echo "Dont forget to run 
virtualenv2 venv
source venv/bin/activate"
echo "Done"
end=`date +%s`
runtime=$((end-start))
echo "Time Taken $runtime"
####################
#  Special thanks  #
####################
# @akhilnarang for his build environment scripts.
# @nathanchance for his guide to setup arch&Ubuntu.
