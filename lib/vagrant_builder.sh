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

# Second version of vagrant-builder.sh, still very basic but, supports dynamic
# playbook.

# Golang and NodeJS on CentOS 6 and 7:
#
# ./svauto.sh --vagrant=up --base-os=centos6 --product=svcs-build
# ./svauto.sh --vagrant=up --base-os=centos7 --product=svcs-build

# Build Sandvine Boxes
#
# ./svauto.sh --vagrant=up --base-os=centos7 --product=svsde
# ./svauto.sh --vagrant=up --base-os=centos7 --product=svpts
# ./svauto.sh --vagrant=up --base-os=centos6 --product=svspb

vagrant_builder()
{

	#VAGRANT_DEFAULT_PROVIDER=libvirt

	RAND_PORT=`awk -v min=1025 -v max=9999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`

	ANSIBLE_PLAYBOOK_FILE="vagrant-run-$BUILD_RAND.yml"


	case "$BASE_OS" in

		ubuntu14)
			VBOX="ubuntu/trusty64"
			;;

		ubuntu16)
			VBOX="ubuntu/xenial64"
			;;

		centos6)
			VBOX="centos/6"
			;;

		centos7)
			VBOX="centos/7"
			;;

		*)

			echo
			echo "Usage: $0 --base-os={ubuntu14|ubuntu16|centos6|centos7}"

	                exit 1
	                ;;

	esac


	case "$PRODUCT" in

		svpts)

			VM_NAME="svpts_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=svpts_1,bootstrap,svpts >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		svspb)

			VM_NAME="svspb_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=svspb_1,bootstrap,svspb >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		svsde)

			VM_NAME="svsde_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=svsde_1,bootstrap,svsde >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		svcs-build)

			VM_NAME="svcs_build_1"

			ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-playbook-builder=svcs_build_1,bootstrap,golang-env,nodejs-env,ccollab-client,vmware-tools,post-cleanup >> ansible/$ANSIBLE_PLAYBOOK_FILE
			;;

		*)

			echo
			echo "You must select a product to boot it up..."

			exit 1
			;;

	esac


	echo
	echo "Entering into: \"vagrant/$VM_NAME\" subdir and runnig \"vagrant $VAGRANT_MODE\" for you!"

	case "$VAGRANT_MODE" in

		up)

			mkdir -p vagrant/$VM_NAME

			cp vagrant/Vagrantfile_template vagrant/$VM_NAME/Vagrantfile


			sed -i -e 's/vagrant_run:.*/vagrant_run: "yes"/' ansible/group_vars/all

			sed -i -e 's/packages_server:.*/packages_server: \"'$SVAUTO_MAIN_HOST'\"/' ansible/group_vars/all
			sed -i -e 's/static_packages_server:.*/static_packages_server: \"'$STATIC_PACKAGES_SERVER'\"/' ansible/group_vars/all


			VBOX_SANITIZED=$(echo $VBOX | sed -e 's/\//\\\//g')


			sed -i -e 's/{{base_os}}/'$BASE_OS'/g' vagrant/$VM_NAME/Vagrantfile
			sed -i -e 's/{{vm_box}}/'$VBOX_SANITIZED'/g' vagrant/$VM_NAME/Vagrantfile
			sed -i -e 's/{{vm_name}}/'$VM_NAME'/g' vagrant/$VM_NAME/Vagrantfile
			sed -i -e 's/{{ssh_local_port}}/'$RAND_PORT'/g' vagrant/$VM_NAME/Vagrantfile


			sed -i -e 's/{{ansible_playbook_file}}/'$ANSIBLE_PLAYBOOK_FILE'/g' vagrant/$VM_NAME/Vagrantfile


			if [ "$DRY_RUN" == "yes" ]
			then

				echo
				echo "Not running \"vagrant up\"!"
				echo "Just creating the Vagrantfile for you, under vagrant/\"vagrant/$VM_NAME\" subdir..."
				echo

			else

				cd vagrant/$VM_NAME

				echo
				vagrant up --provider=libvirt

			fi

			;;

		ssh)

			cd vagrant/$VM_NAME
			vagrant ssh

			;;

		destroy)

			cd vagrant/$VM_NAME
			vagrant destroy

			;;

		provision)

			cd vagrant/$VM_NAME
			vagrant provision

			;;

	esac

}
