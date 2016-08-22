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

svauto_deployments()
{

	BUILD_RAND=$(openssl rand -hex 4)

	PLAYBOOK_FILE="playbook-"$BUILD_RAND".yml"


	echo
	echo "Bootstrapping --base-os=\"$BASE_OS\" via Ansible with the folllwing roles and vars:"
	echo
	echo "Roles: "$ALL_ANSIBLE_ROLES"."
	echo "Extra Vars: "$ALL_ANSIBLE_EXTRA_VARS"."


	echo
	echo "Building Ansible top-level Playbook..."

	echo
	ansible_playbook_builder --ansible-remote-user=\"root\" --ansible-hosts="localhost" --roles="$ALL_ANSIBLE_ROLES" > ansible/tmp/$PLAYBOOK_FILE


	echo
	echo "Running Ansible with Playbook: \"$PLAYBOOK_FILE\"."

	echo
	cd ~/svauto/ansible
	ansible-playbook -c local "tmp/$PLAYBOOK_FILE" --extra-vars "base_os=$BASE_OS $ANSIBLE_EXTRA_VARS"

}
