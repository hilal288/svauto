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


for i in "$@"
do
case $i in

        --base-os=*)

                BASE_OS="${i#*=}"
                shift
                ;;

	--ansible-run-against=*)

		ANSIBLE_RUN_AGAINST="${i#*=}"
		shift
		;;

	--ansible-remote-user=*)

		ANSIBLE_REMOTE_USER="${i#*=}"
		shift
		;;

	--ansible-inventory-builder=*)

		ANSIBLE_INVENTORY_ENTRY_1="${i#*=}"
		shift
		;;

	--ansible-playbook-builder=*)

		ANSIBLE_PLAYBOOK_ENTRY_1="${i#*=}"
		shift
		;;

	--ansible-extra-vars=*)

		ALL_ANSIBLE_EXTRA_VARS="${i#*=}"
		shift
		;;

esac
done


clear


echo
echo "Welcome to SVAuto, the Sandvine Automation!"

echo
echo "Installing SVAuto basic dependencies (Git & Ansible):"


case $BASE_OS in

	ubuntu*)

		echo
		echo "Running: \"sudo apt install ansible\""

		sudo apt -y install software-properties-common &>/dev/null
		sudo add-apt-repository -y ppa:ansible/ansible &>/dev/null
		sudo apt update &>/dev/null
		sudo apt -y install git ansible &>/dev/null

		;;

	centos*)

		echo
		echo "Running: \"sudo yum install git ansible\""

		sudo yum --enablerepo=epel-testing -y install git ansible libselinux-python &>/dev/null
		;;

	*)

	        echo
		echo "O.S. not detected, aborting!"

		exit 1

		;;

esac


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


if  [ ! -f ~/svauto/svauto.sh ]
then
	echo
	echo "WARNING!"
	echo "SVAuto main script not found, Git clone might have failed."

	echo

	exit 1
fi


pushd ~/svauto &>/dev/null

./svauto.sh --ansible-run-against="$ANSIBLE_RUN_AGAINST" --ansible-remote-user="$ANSIBLE_REMOTE_USER" --ansible-inventory-builder="$ANSIBLE_INVENTORY_ENTRY_1" --ansible-playbook-builder="$ANSIBLE_PLAYBOOK_ENTRY_1" --ansible-extra-vars="base_os=$BASE_OS,$ALL_ANSIBLE_EXTRA_VARS"
