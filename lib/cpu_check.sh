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

cpu_check()
{

	# Doing CPU checks
	if [ "$DRY_RUN" == "yes" ]
	then

		echo
		echo "Not running CPU checks on --dry-run..."

	else

		# Verifying if you have enough CPU Cores.
		echo
		echo "Verifying if you have enough CPU Cores..."

		CPU_CORES=$(grep -c ^processor /proc/cpuinfo)

		if [ $CPU_CORES -lt 4 ]
		then
			echo
			echo "WARNING!!!"
			echo
			echo "You do not have enough CPU Cores to run this system!"

			exit 1
		else
			echo
			echo "Okay, good, you have enough CPU Cores, proceeding..."
		fi


		# Verifying if host have Virtualization enabled, abort it if doesn't have.
		echo
		echo "Verifying if your CPU supports Virtualization..."

		sudo apt-get -y install cpu-checker 2>&1 > /dev/null

		if /usr/sbin/kvm-ok 2>&1 > /dev/null
		then
			echo
			echo "OK, Virtualization supported, proceeding..."
		else
			echo "WARNING!!!"
			echo
			echo "Virtualization NOT supported on this CPU or it is not enabled on your BIOS"

			exit 1
		fi

	fi

}
