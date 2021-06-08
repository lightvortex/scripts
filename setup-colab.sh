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
echo "Setting UP COLAB PLEASE WAIT 5MINS"
    echo //Setting up Ubuntu//
    sudo apt-get update
    sudo apt-get install git
    mkdir ~/bin
    PATH=~/bin:$PATH
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
    git clone https://github.com/akhilnarang/scripts scripts
    cd scripts
    . setup/android*.sh
cd ~/
echo 'export USE_CCACHE=1' >> .bashrc;
echo "Done"
runtime=$((end-start))
####################
#  Special thanks  #
####################
# @akhilnarang for his build environment scripts.
# @nathanchance for his guide to setup arch&Ubuntu.
