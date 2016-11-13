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


# Outputs an Ansible top-level Playbook file
ansible_playbook_builder()
{

	COUNTER_1=1


	while [ $COUNTER_1 -le $ANSIBLE_PLAYBOOK_TOTAL ]
	do

		ITEM=1

		for i in $(eval echo "\$ANSIBLE_PLAYBOOK_ENTRY_${COUNTER_1}" | sed "s/,/ /g")
		do

			if [ $ITEM == 1 ]; then

				declare "ANSIBLE_HOST_GROUP_$COUNTER_1"=$(echo "$i")

				echo ""
				eval echo "- hosts: \$ANSIBLE_HOST_GROUP_$COUNTER_1"
				echo "  user: $ANSIBLE_REMOTE_USER"
				echo "  become: yes"
				echo "  roles:"

			fi

			SUB_ITEM=1

			if [[ $i == *\;* ]]; then

				for p in $(echo $i | sed "s/;/ /g")
				do

					if [ $SUB_ITEM == 1 ]; then

						declare "ROLE_NAME_$COUNTER_1"=$(echo "$p")

						(( SUB_ITEM++ ))

						continue

					fi

					declare "ROLE_PARAM_NAME_$COUNTER_1_$SUB_ITEM"=$(echo $p | cut -d = -f 1)
					declare "ROLE_PARAM_VALUE_$COUNTER_1_$SUB_ITEM"=$(echo $p | cut -d = -f 2)

					(( SUB_ITEM++ ))

				done

				PARAMS_TOTAL=$[$SUB_ITEM -1]

				COUNTER_2=2


				eval echo -n "\ \ - { role: \$ROLE_NAME_$COUNTER_1,\ "

				while [ $COUNTER_2 -le $PARAMS_TOTAL ]
				do

					eval echo -n "\$ROLE_PARAM_NAME_$COUNTER_1_$COUNTER_2: \'\$ROLE_PARAM_VALUE_$COUNTER_1_$COUNTER_2\'"

					if [ $COUNTER_2 -ne $PARAMS_TOTAL ]; then echo -n ", "; fi

					(( COUNTER_2++ ))

				done

				echo " }"

			else

				if [ $ITEM -ne 1 ]; then echo "  - $i" ; fi

			fi

			(( ITEM++ ))

		done

		(( COUNTER_1++ ))

#		if [ "$ANSIBLE_FORCE_PLAYBOOK_BUILD" == "yes" ]; then break; fi

	done

}
