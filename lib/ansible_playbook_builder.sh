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

	for i in "$@"; do

		case $i in

		        --ansible-remote-user=*)

		                ANSIBLE_REMOTE_USER="${i#*=}"
		                shift
		                ;;

		        --ansible-hosts=*)

		                ANSIBLE_HOSTS="${i#*=}"
		                shift
		                ;;

		        --roles=*)

		                ALL_ROLES="${i#*=}"
		                ROLES="$( echo $ALL_ROLES | sed s/,/\ /g )"
		                shift
		                ;;

		        --get-facts)

		                GET_FACTS="yes"
		                shift
		                ;;

		esac

	done


	if [ "$GET_FACTS" == "yes" ]
	then
		echo ""
		echo "- hosts: all"
		echo "  tasks: [ ]"

		unset GET_FACTS
	fi


	echo ""
	echo "- hosts: $ANSIBLE_HOSTS"
	echo "  user: $ANSIBLE_REMOTE_USER"
	echo "  become: yes"
	echo "  roles:"


	for Y in $ROLES; do

		if [ "$Y" == "sandvine-auto-config" ];
		then

			SANDVINE_AUTO_CONFIG="yes"

		fi

	done


	for Y in $ROLES; do

		if [ "$Y" != "sandvine-auto-config" ]; then
			echo "  - $Y"
		fi

	done


	if [ "$SANDVINE_AUTO_CONFIG" == "yes" ] && [ "$CONFIG_ONLY_MODE" == "yes" ]
	then

		for Y in $ANSIBLE_HOSTS; do

			case $Y in

				svpts-servers)
					echo "  - { role: sandvine-auto-config, setup_server: 'svpts' }"
					;;

				svsde-servers)
					echo "  - { role: sandvine-auto-config, setup_server: 'svsde' }"
					;;

				svspb-servers)
					echo "  - { role: sandvine-auto-config, setup_server: 'svspb' }"
					;;

				svnda-servers)
					echo "  - { role: sandvine-auto-config, setup_server: 'svnda' }"
					;;

				svtse-servers)
					echo "  - { role: sandvine-auto-config, setup_server: 'svtse' }"
					;;

				svtcpa-servers)
					echo "  - { role: sandvine-auto-config, setup_server: 'svtcpa' }"
					;;

			esac

		done

	else

		for X in $ROLES; do

			case $X in

				svpts)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svpts' }"
					fi
					;;

				svsde)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svsde' }"
					fi
					;;

				svspb)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svspb' }"
					fi
					;;

				svnda)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svnda' }"
					fi
					;;

				svtse)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svtse' }"
					fi
					;;

				svtcpa)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svtcpa' }"
					fi
					;;

				svcs)

					echo "  - role: $X"

					if [ "$SANDVINE_AUTO_CONFIG" == "yes" ];
					then
						echo "  - { role: sandvine-auto-config, setup_server: 'svcs' }"
					fi
					;;

			esac

		done

	fi

}
