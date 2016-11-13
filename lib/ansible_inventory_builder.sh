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


# Outputs an Ansible Inventory file
ansible_inventory_builder()
{

	COUNTER_1=1


	while [ $COUNTER_1 -le $ANSIBLE_INVENTORY_TOTAL ]
	do

		ITEM=1

		for i in $(eval echo "\$ANSIBLE_HOST_ENTRY_${COUNTER_1}" | sed "s/,/ /g")
		do

			if [ $ITEM == 1 ]; then

				declare "ANSIBLE_HOST_GROUP_$COUNTER_1"="$i"

				echo

				eval echo "[\$ANSIBLE_HOST_GROUP_$COUNTER_1]"

			fi


			if [ $ITEM == 2 ]; then

				echo -n "$i "

				if [ ! -z "$ANSIBLE_REMOTE_USER" ]
				then
					echo -n "ansible_user=$ANSIBLE_REMOTE_USER "
				fi

			fi


			if [ ! $ITEM -le 2 ]; then echo -n "$i " ; fi


			(( ITEM++ ))

		done

		echo

		(( COUNTER_1++ ))

	done

}
