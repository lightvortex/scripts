#!/bin/bash
# Copyright (C) 2019-2020 lightvortex
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
echo //syncing//
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
echo //enable ccache//
export USE_CCACHE=1
ccache -M 50G
echo //build env setup//
virtualenv2 venv
source venv/bin/activate
. build/env*
while true; do
    read -p "Do you wish to clean build?" yn
    case $yn in
        [Yy]* ) make clean; break;;
        [Nn]* ) echo "Making Dirty Build"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo -e "Please enter a device"
echo "1)chiron"
echo "2)nx531j"
echo "3)both"
read -r device
if [[ $device -eq 1 ]]
then 
    echo //building chiron//
    echo -e "Please enter a Version"
    echo "1)non-gapps"
    echo "2)gapps"
    echo "3)both"
    read -r gapps
        if [[ $gapps -eq 1 ]]
        then
            echo //building chiron nongapps//
            export WITH_GAPPS=false
            brunch chiron
            echo //build complete copying Non-gapps version//
            mv /home/lightvortex/havoc/out/target/product/chiron/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
        elif [[ $gapps -eq 2 ]]
        then
            echo //building gapps version//
            export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
            brunch chiron
            echo //build complete//
            echo //copying//
            mv /home/lightvortex/havoc/out/target/product/chiron/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
        else  
            echo //building chiron nongapps//
            export WITH_GAPPS=false
            brunch chiron
            echo //build complete copying Non-gapps version//
            mv /home/lightvortex/havoc/out/target/product/chiron/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
            echo //cleaning build//
            make clean
            echo //building gapps version//
            export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
            brunch chiron
            echo //build complete//
            echo //copying//
            mv /home/lightvortex/havoc/out/target/product/chiron/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
        fi
elif [[ $device -eq 2 ]]
then
    echo //building nx531j//
    echo -e "Please enter a Version"
    echo "1)non-gapps"
    echo "2)gapps"
    echo "3)both"
    read -r gapps
        if [[ $gapps -eq 1 ]]
        then
            echo //building nx531j nongapps//
            export WITH_GAPPS=false
            brunch nx531j
            echo //build complete copying Non-gapps version//
            mv /home/lightvortex/havoc/out/target/product/nx531j/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
        elif [[ $gapps -eq 2 ]]
        then
            echo //building gapps version//
            export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
            brunch nx531j
            echo //build complete//
            echo //copying//
            mv /home/lightvortex/havoc/out/target/product/nx531j/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
          else  
            echo //building nx531j nongapps//
            export WITH_GAPPS=false
            brunch nx531j
            echo //build complete copying Non-gapps version//
            mv /home/lightvortex/havoc/out/target/product/nx531j/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
            echo //cleaning build//
            make clean
            echo //building gapps version//
            export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
            brunch nx531j
            echo //build complete//
            echo //copying//
            mv /home/lightvortex/havoc/out/target/product/nx531j/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
        fi
else
    echo //building both//
    echo //building chiron nongapps//
    export WITH_GAPPS=false && make clean
    brunch chiron
    echo //build complete copying Non-gapps version//
    mv /home/lightvortex/havoc/out/target/product/chiron/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
    echo //cleaning build//
    make clean
    echo //building chiron gapps version//
    export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
    brunch chiron
    echo //build complete//
    echo //copying//
    mv /home/lightvortex/havoc/out/target/product/chiron/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
    make clean
    echo //building nx531j//
    echo //building nx531j nongapps//
    export WITH_GAPPS=false && make clean
    brunch nx531j
    echo //build complete copying Non-gapps version//
    mv /home/lightvortex/havoc/out/target/product/nx531j/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
    echo //cleaning build//
    make clean
    echo //building nx531j gapps version//
    export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
    brunch nx531j
    echo //build complete//
    echo //copying//
    mv /home/lightvortex/havoc/out/target/product/nx531j/Havoc*.zip /home/lightvortex/havoc/Havoc*.zip
fi
end=`date +%s`
runtime=$((end-start))
echo "Time Taken $runtime"
break;

