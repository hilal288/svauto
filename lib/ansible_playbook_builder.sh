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

	ANSIBLE_COUNTER_1=1


	for i in "$@"
	do
	case $i in


	        --ansible-remote-user=*)

	                ANSIBLE_REMOTE_USER="${i#*=}"
	                shift
			;;

		--ansible-playbook-builder=*)

			ANSIBLE_HOST_ENTRY="${i#*=}"

			for W in $ANSIBLE_HOST_ENTRY; do

				declare "ANSIBLE_HOST_$ANSIBLE_COUNTER_1"="$W"

				(( ANSIBLE_COUNTER_1++ ))

			done

			shift
			;;

	esac
	done


	HOSTS_TOTAL=$[$ANSIBLE_COUNTER_1 -1]

	COUNTER_2=1


	while [ $COUNTER_2 -le $HOSTS_TOTAL ] || [ "$ANSIBLE_FORCE_PLAYBOOK_BUILD" == "yes" ]
	do

		ITEM=1

		for i in $(eval echo "\$ANSIBLE_HOST_${COUNTER_2}" | sed "s/,/ /g")
		do

			if [ $ITEM == 1 ]; then

				declare "ANSIBLE_HOST_GROUP_$COUNTER_2"=$(echo "$i")

				echo ""
				eval echo "- hosts: \$ANSIBLE_HOST_GROUP_$COUNTER_2"
				echo "  user: $ANSIBLE_REMOTE_USER"
				echo "  become: yes"
				echo "  roles:"

			fi

			SUB_ITEM=1

			if [[ $i == *:* ]]; then

				for p in $(echo $i | sed "s/:/ /g")
				do

					if [ $SUB_ITEM == 1 ]; then

						declare "ROLE_NAME_$COUNTER_2"=$(echo "$p")

						(( SUB_ITEM++ ))

						continue

					fi

					declare "ROLE_PARAM_NAME_$COUNTER_2_$SUB_ITEM"=$(echo $p | cut -d = -f 1)
					declare "ROLE_PARAM_VALUE_$COUNTER_2_$SUB_ITEM"=$(echo $p | cut -d = -f 2)

					(( SUB_ITEM++ ))

				done

				PARAMS_TOTAL=$[$SUB_ITEM -1]

				COUNTER_3=2


				eval echo -n "\ \ - { role: \$ROLE_NAME_$COUNTER_2,\ "

				while [ $COUNTER_3 -le $PARAMS_TOTAL ]
				do

					eval echo -n "\$ROLE_PARAM_NAME_$COUNTER_2_$COUNTER_3: \'\$ROLE_PARAM_VALUE_$COUNTER_2_$COUNTER_3\'"

					if [ $COUNTER_3 -ne $PARAMS_TOTAL ]; then echo -n ", "; fi

					(( COUNTER_3++ ))

				done

				echo " }"

			else

				if [ $ITEM -ne 1 ]; then echo "  - $i" ; fi

			fi

			(( ITEM++ ))

		done

		(( COUNTER_2++ ))

		if [ "$ANSIBLE_FORCE_PLAYBOOK_BUILD" == "yes" ]; then break; fi

	done

}
