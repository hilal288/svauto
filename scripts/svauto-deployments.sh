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


for i in "$@"
do
case $i in

	--base-os=*)

	        BASE_OS="${i#*=}"
	        shift
	        ;;

	--ansible-roles=*)

	        ANSIBLE_ROLES="${i#*=}"
	        shift
	        ;;

	--ansible-extra-vars=*)

	        ANSIBLE_EXTRA_VARS="${i#*=}"
	        shift
	        ;;

esac
done


echo
echo "Welcome to SVAuto, the Sandvine Automation!"


echo
echo "Installing SVAuto basic dependencies (Git & Ansible):"


case $BASE_OS in

	ubuntu*)

		echo

		sudo apt -y install software-properties-common

		sudo add-apt-repository -y ppa:sandvine/packages

		sudo apt update

		sudo apt -y install git ansible

		;;

	centos*)

		echo

		sudo yum --enablerepo=epel-testing -y install git ansible libselinux-python

		;;

	*)

                echo
                echo "Operation System not detected, aborting!"

                exit 1

                ;;

esac


echo


if  [ ! -d ~/svauto ]; then
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


if  [ ! -f ~/svauto/svauto.sh ]; then
	echo
	echo "WARNING!"
	echo "SVAuto main script not found, Git clone might have failed."

	echo
	exit 1
fi


cd ~/svauto
./svauto.sh --svauto-deployments --base-os=\"$BASE_OS\" --ansible-roles=\"$ANSIBLE_ROLES\" --ansible-extra-vars=\"$ANSIBLE_EXTRA_VARS\"
