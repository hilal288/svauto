#! /bin/bash

# Copyright 2016, Sandvine Incorporated.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


clear


echo
echo "Welcome to OpenStack Mitaka Deployment!"
echo


echo
echo "Running: \"sudo apt install git ansible\""


sudo apt-get -y install software-properties-common &>/dev/null
sudo add-apt-repository -y ppa:sandvine/packages &>/dev/null
sudo apt-get update &>/dev/null
sudo apt-get -y install git ansible &>/dev/null


if  [ ! -d ~/svauto ]
then
        echo
        echo "Downloading SVAuto into your home directory..."
        echo

        cd ~
        git clone -b dev https://github.com/sandvine-eng/svauto.git
else
        echo
        echo "Apparently, you already have SVAuto, enjoy it!"
        echo
fi


echo
echo "Deploying OpenStack..."
echo
echo "Bridge Mode: Open vSwitch"
echo

pushd ~/svauto

./svauto.sh --operation=openstack --base-os=ubuntu16 --ubuntu-network-detect-default-nic --os-release=mitaka --os-aio --os-bridge-mode=OVS --ansible-extra-vars="deployment_mode=yes"
