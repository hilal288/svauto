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

TODAY=$(date +"%Y%m%d")

# Create a file that contains the build date
if  [ ! -f build-date.txt ]
then

        echo $TODAY > build-date.txt
        BUILD_DATE=`cat build-date.txt`

else

        BUILD_DATE=`cat build-date.txt`

fi

if ! source svauto.conf
then
	echo "File svauto.conf not found, aborting!"
	echo "Run svauto.sh from your SVAuto sub directory."

	exit 1
fi

if ! source lib/include_tools.inc
then
	echo "File lib/include_tools.inc not found, aborting!"
	exit 1
fi

ANSIBLE_COUNTER_1=1

ANSIBLE_COUNTER_2=1

BUILD_RAND=$(openssl rand -hex 4)

# If there are no arguments to script, bork...
if (( "$#" == 0 )); then
	echo "ERROR: No arguments were specified. " >&2
	exit 1
fi

for i in "$@"
do
case $i in

        --base-os=*)

                BASE_OS="${i#*=}"
                shift
                ;;

	--operation=*)

		OPERATION="${i#*=}"
		shift
		;;

        --cloud-services-mode=*)

		CLOUD_SERVICES_MODE="${i#*=}"
		shift
		;;

	--cpu-check)

		cpu_check
		shift
		;;

	--hostname-check)

		hostname_check
		shift
		;;

	# Options starting with --ansible-* are passed to Ansible itself,
	# or being used by dynamic stuff.

	--dump)

		ANSIBLE_DUMP="yes"
		shift
		;;

        --ansible-remote-user=*)

                ANSIBLE_REMOTE_USER="${i#*=}"
                shift
                ;;

	--ansible-inventory-builder=*)

		ANSIBLE_INVENTORY_ENTRY="${i#*=}"

		for H in $ANSIBLE_INVENTORY_ENTRY; do

			declare "ANSIBLE_HOST_ENTRY_$ANSIBLE_COUNTER_1"="$H"

			(( ANSIBLE_COUNTER_1++ ))

		done

		ANSIBLE_INVENTORY_TOTAL=$[$ANSIBLE_COUNTER_1 -1]

		shift
		;;

	--ansible-playbook-builder=*)

		ANSIBLE_PLAYBOOK_ENTRY="${i#*=}"

		for P in $ANSIBLE_PLAYBOOK_ENTRY; do

			declare "ANSIBLE_PLAYBOOK_ENTRY_$ANSIBLE_COUNTER_2"="$P"

			(( ANSIBLE_COUNTER_2++ ))

		done

		ANSIBLE_PLAYBOOK_TOTAL=$[$ANSIBLE_COUNTER_2 -1]

		shift
		;;

	--ansible-extra-vars=*)

		ALL_ANSIBLE_EXTRA_VARS="${i#*=}"
		ANSIBLE_EXTRA_VARS="$( echo $ALL_ANSIBLE_EXTRA_VARS | sed s/,/\ /g )"
		shift
		;;

	--ansible-manual-inventory)

		ANSIBLE_MANUAL_INVENTORY="yes"
		shift
		;;

	--vagrant=*)

		VAGRANT_MODE="${i#*=}"
		shift
		;;

	#
	# SVAuto Yum Repo Builder specific options - BEGIN
	#

	--yum-repo-builder)

		YUM_REPO_BUILDER="yes"
		shift
		;;

	--release-code-name=*)

		RELEASE_CODE_NAME="${i#*=}"
		shift
		;;

	--latest)

		LATEST="yes"
		shift
		;;

	--latest-of-serie)

		LATEST_OF_SERIE="yes"
		shift
		;;

	#
	# SVAuto Yum Repo Builder specific options - END
	#

	#
	# Packer Builder specific options - BEGIN
	#

	--packer-builder)

		PACKER_BUILDER="yes"
		shift
		;;

        --product=*)

                PRODUCT="${i#*=}"
		PLATFORM="LNX"
                shift
                ;;

        --version=*)

		VERSION="${i#*=}"
		shift
		;;

        --product-variant=*)

		PRODUCT_VARIANT="${i#*=}"
		shift
		;;

        --packer-to-openstack)

		PACKER_TO_OS="yes"
		shift
		;;

	--packer-max-tries=*)

		MAX_TRIES="${i#*=}"
		shift
		;;

	--vm-xml)

		VM_XML="yes"
		shift
		;;

	--qcow2)

		QCOW2="yes"
		shift
		;;

	--vmdk)

		VMDK="yes"
		shift
		;;

	--ovf)

		OVF="yes"
		shift
		;;

	--ova)

		OVF="yes"
		OVA="yes"
		shift
		;;

	--vhd)

		VHD="yes"
		shift
		;;

	--vhdx)

		VHDX="yes"
		shift
		;;

	--vdi)

		VDI="yes"
		shift
		;;

	--sha256sum)

		SHA256SUM="yes"
		shift
		;;

	#
	# Packer Builder specific options - END
	#

	# Options starting with --os-* are OpenStack related
	--os-project=*)

		OS_PROJECT="${i#*=}"
		shift
		;;

	--os-stack-name=*)

		OS_STACK_NAME="${i#*=}"
		shift
		;;

        --os-import-images)

	        OS_IMPORT_IMAGES="yes"
		shift
		;;

        --os-hybrid-firewall)

		OS_HYBRID_FW="yes"
		shift
		;;

        --os-no-security-groups)

		OS_NO_SEC="yes"
		shift
		;;

	--os-open-provider-nets-to-regular-users)

		OS_OPEN_PROVIDER_NETS_TO_REGULAR_USERS="yes"
		shift
		;;

	--move2webroot=*)

		MOVE2WEBROOT_BUILD="${i#*=}"
		shift
		;;

	--update-web-dir-sha256sums)

		UPDATE_WEB_DIR_SHA256SUMS="yes"
		shift
		;;

	--update-web-dir-symlink)

		UPDATE_WEB_DIR_SYMLINK="yes"
		shift
		;;

	--runtime-mode=*)

		RUNTIME_MODE="${i#*=}"
		shift
		;;

	--heat-templates=*)

		HEAT_TEMPLATES="${i#*=}"
		shift
		;;

	--make-public-web-dir)

		MK_PUB_WEB_DIR="yes"
		shift
		;;

	--libvirt-files=*)

		LIBVIRT_FILES="${i#*=}"
		shift
		;;

        --release=*)

                RELEASE="${i#*=}"
                shift
                ;;

        --centos-network-setup)

	        CENTOS_NETWORK_SETUP="yes"
		shift
		;;

	# Options starting with --ubuntu-* are Ubuntu related
        --ubuntu-detect-default-nic)

	        UBUNTU_DETECT_DEFAULT_NIC="yes"
		shift
		;;

	--clean-all)

		CLEAN_ALL="yes"
		shift
		;;

	--dry-run)

		DRY_RUN="yes"
		shift
		;;

	*)
		echo "ERROR: <$i> is an unrecognized command." >&2
		exit 1
		;;

esac
done

ANSIBLE_INVENTORY_FILE="ansible-hosts-$BUILD_RAND"

ANSIBLE_PLAYBOOK_FILE="ansible-playbook-$BUILD_RAND.yml"

ANSIBLE_EXTRA_VARS_FILE="@ansible-extra-vars-$BUILD_RAND.json"

# SVAuto Ansible Inventory Builder
#
# This function stores Ansible's Inventory in memory.

if [ ! -z "$ANSIBLE_INVENTORY_ENTRY" ]
then

	ANSIBLE_INVENTORY_FILE_IN_MEM=$(ansible_inventory_builder)

	if [ "$ANSIBLE_DUMP" == yes ];
	then

		echo
		echo "Dumping Inventory \"$ANSIBLE_INVENTORY_FILE\" from memory:"

		echo "$ANSIBLE_INVENTORY_FILE_IN_MEM"

	fi

fi

# SVAuto Ansible Playbook Builder
#
# This function stores Ansible's Top-Level Playbook in memory.

if [ ! -z "$ANSIBLE_PLAYBOOK_ENTRY" ]
then

	ANSIBLE_PLAYBOOK_FILE_IN_MEM=$(ansible_playbook_builder)

	if [ "$ANSIBLE_DUMP" == "yes" ]
	then

		echo
		echo "Dumping Top-Level Playbook \"$ANSIBLE_PLAYBOOK_FILE\' from memory:"

		echo "$ANSIBLE_PLAYBOOK_FILE_IN_MEM"

	fi

fi

#
# SVAuto Packer Builder - To build images using Packer and Ansible
#

if [ "$PACKER_BUILDER" == "yes" ]
then

	packer_builder

	exit 0

fi

#
# SVAuto Vagrant - To bootstrap boxes using Vagrant and Ansible
#

if [ ! -z "$VAGRANT_MODE" ];
then

	vagrant_builder

	exit 0

fi

#
# SVAuto Local Yum Repo - To host Sandvine's RPM packages locally and install
# from it.
#

if [ "$YUM_REPO_BUILDER" == "yes" ]
then

	yum_repo_builder

	exit 0

fi

#
# Operation System setup on playbook vars
#

#
# Ubuntu Settings
#

if [ "$OS_HYBRID_FW" == "yes" ]
then
	EXTRA_VARS="$EXTRA_VARS firewall_driver=iptables_hybrid "
else
	EXTRA_VARS="$EXTRA_VARS firewall_driver=openvswitch "
fi

# Disabling Security Groups entirely
if [ "$OS_NO_SEC" == "yes" ]
then
	EXTRA_VARS="$EXTRA_VARS firewall_driver=neutron.agent.firewall.NoopFirewall "
fi

if [ "$OS_OPEN_PROVIDER_NETS_TO_REGULAR_USERS" == "yes" ]
then
	EXTRA_VARS="$EXTRA_VARS os_open_provider_nets_to_regular_users=yes "
fi

if [ "$UBUNTU_DETECT_DEFAULT_NIC" == "yes" ]
then

	# Configuring the default interface
	unset UBUNTU_PRIMARY_INTERFACE
	UBUNTU_PRIMARY_INTERFACE=$(ip r | grep default | awk '{print $5}')

	if [ -z "$UBUNTU_PRIMARY_INTERFACE" ]
	then
		echo
		echo "ABORTING! Ubuntu's primary network interface not detected!"
		echo "Are you sure that your Ubuntu have a default gateway configured?"

		exit 1
	fi

	echo
	echo "Your primary network interface is:"
	echo "dafault route via:" $UBUNTU_PRIMARY_INTERFACE

	EXTRA_VARS="$EXTRA_VARS ubuntu_primary_interface=$UBUNTU_PRIMARY_INTERFACE "
	EXTRA_VARS="$EXTRA_VARS os_mgmt=$UBUNTU_PRIMARY_INTERFACE "

fi

#
# SVAuto Functions
#

if [ "$CLEAN_ALL" == "yes" ]
then

	if pushd $SVAUTO_DIR
	then
		echo
		echo "Cleaning it up..."

		rm -rf build-date.txt packer/build* tmp/cs-rel/* tmp/cs/* tmp/sv/* tmp/*.qcow2c tmp/*.img ansible/*.retry ansible/*.yml ansible/*-hosts-* ansible/*-extra-vars-* ansible/facts_storage

		echo

		exit 0
	else
		echo
		echo "Not cleaning anything! Could not enter into SVAuto's subdir..."

		exit 1
	fi

fi

# Before doing Packer buils in series, we need to create the public webdir
if [ "$MK_PUB_WEB_DIR" == "yes" ]
then

	mkwebrootsubdirs

	exit 0

fi

#
# Post-Image creation options
#

if [ "$UPDATE_WEB_DIR_SHA256SUMS" == "yes" ]
then

	update_web_dir_sha256sums

	exit 0

fi

if [ "$UPDATE_WEB_DIR_SYMLINK" == "yes" ]
then

	update_web_dir_symlink

	exit 0

fi

if [ ! -z "$MOVE2WEBROOT_BUILD" ]
then

	case "$MOVE2WEBROOT_BUILD" in

		sandvine-dev)

			move2webroot
			;;

		sandvine-dev-lab)

			move2webroot_lab
			;;

		cs-dev)

			move2webroot_cs
			;;

		cs-dev-lab)

			move2webroot_cs_lab
			;;

		cs-prod)

			move2webroot_cs_prod
			;;

	esac

	exit 0

fi

if [ ! -z "$HEAT_TEMPLATES" ]
then

	case "$HEAT_TEMPLATES" in

		sandvine-dev)
			heat_templates
			;;

		cs-dev)
			heat_templates_cs
			;;
	esac

	exit 0

fi

if [ ! -z "$LIBVIRT_FILES" ]
then

	case "$LIBVIRT_FILES" in

		sandvine-dev)
			libvirt_files
			;;

		cs-dev)
			libvirt_files_cs
			;;
	esac

	exit 0

fi

if [ -z "$ANSIBLE_REMOTE_USER" ]
then

	echo
	echo "Warning! You must specify the --ansible-remote-user option!"
	echo "Example: --ansible-remote-user=sandvine"

	exit 1

fi

if [ -n "$OS_PROJECT" ]
then

	if [ ! -f ~/$OS_PROJECT-openrc.sh ]
	then
		echo
		echo "OpenStack Credentials for "$OS_PROJECT" account not found, aborting!"

		exit 1
	else
		echo
		echo "Loading OpenStack credentials for "$OS_PROJECT" account..."

		source ~/$OS_PROJECT-openrc.sh
	fi

	if [ -z $OS_STACK_NAME ]
	then
		echo
		echo "You did not specified the destination Stack to deploy Sandvine's RPM Packages."
		echo "However, the following Stack(s) was detected under your account:"
		echo

		openstack stack list 2>/dev/null

		echo
		echo "Run this script with the following arguments:"
		echo
		echo "pushd ~/svauto"
		echo "./svauto.sh --os-project=demo --os-stack-name=sv-stack-1 --ansible-remote-user=sandvine"
		echo
		echo
		echo "If you don't have a Sandvine compatible Stack up and running."
		echo "To launch one, run:"
		echo
		echo "openstack stack create -t ~/svauto/misc/os-heat-templates/sandvine-stack-0.1-stock-three-1.yaml sv-stack-1"
		echo
		echo "NOTE: You'll need to configure the *_images inside of the above Heat template."
		echo
		echo "Aborting!"

		exit 1
	fi

	if openstack stack show $OS_STACK_NAME 2>/dev/null
	then
		echo
		echo "Stack found, proceeding..."
	else
		echo
		echo "Stack not found! Aborting..."

		exit 1
	fi

	ANSIBLE_HOSTS_NAMES=$(./ansible/inventory/05-openstack.py --list | jq -r '._meta.hostvars[].openstack.name')
	ANSIBLE_HOSTS_IPS=$(./ansible/inventory/05-openstack.py --list | jq -r '._meta.hostvars[].ansible_ssh_host')

	echo "$ANSIBLE_HOSTS_NAMES" > /tmp/svauto-ansible-tmp-names-$BUILD_DATE
	echo "$ANSIBLE_HOSTS_IPS" > /tmp/svauto-ansible-tmp-ips-$BUILD_DATE

	ANSIBLE_HOSTS_LIST=$(paste -d" " /tmp/svauto-ansible-tmp-names-$BUILD_DATE /tmp/svauto-ansible-tmp-ips-$BUILD_DATE)

	STACK_LIST_FILE="/tmp/stack-list-$BUILD_RAND.txt"

	echo "$ANSIBLE_HOSTS_LIST" | grep "$OS_STACK_NAME" > "$STACK_LIST_FILE"

	echo
	echo "The following Sandvine-compatible Instances was detected on your \"$OS_STACK_NAME\" Stack:"
	echo
	echo Hostnames and IP access:
	echo
	cat "$STACK_LIST_FILE"

	pushd ansible &>/dev/null

	ANSIBLE_INVENTORY_FILE="${OS_STACK_NAME}-stack-hosts-${BUILD_RAND}"

	echo
	echo "Creating Ansible's Inventory: \"ansible/$ANSIBLE_INVENTORY_FILE\"."

	ANSIBLE_INVENTORY_TOTAL=1

	ANSIBLE_HOST_ENTRY_1="all:vars,ansible_user=$ANSIBLE_REMOTE_USER,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME,sandvine_yum_host=$SV_YUM_HOST"

	ansible_inventory_builder > $ANSIBLE_INVENTORY_FILE

	TMP_FILE="/tmp/inventory-tmp-$BUILD_RAND.txt"

	ansible_inventory_builder_hybrid_os >> $ANSIBLE_INVENTORY_FILE

	popd &>/dev/null

fi

pushd ansible &>/dev/null

if [ "$CENTOS_NETWORK_SETUP" == "yes" ]
then

	echo
	echo "CentOS Network Setup requested."

	ANSIBLE_PLAYBOOK_TOTAL=1

	ANSIBLE_PLAYBOOK_ENTRY_1="all,centos-network-setup"

	ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE

fi

if [ -n "$RUNTIME_MODE" ]
then

	echo
	echo "Creating Ansible's Top-Level Playbook : \"ansible/$ANSIBLE_PLAYBOOK_FILE\"."

	case "$RUNTIME_MODE" in
	
		sandvine-auto-config)

			echo
			echo "Configuring Sandvine Platform with Ansible..."

			if [ "$OPERATION" == "cloud-services" ] && [ -z "$CLOUD_SERVICES_MODE" ]
			then

				echo
				echo "For operation=cloud-services, you have to also, specify --cloud-services-mode=default|mdm"

				exit 1

			fi

			case "$OPERATION" in

				sandvine)

					CLOUD_SERVICES_MODE=null

					ANSIBLE_PLAYBOOK_TOTAL=3

					ANSIBLE_PLAYBOOK_ENTRY_1="spb-servers,sandvine-auto-config;setup_server=svspb;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
					ANSIBLE_PLAYBOOK_ENTRY_2="sde-servers,sandvine-auto-config;setup_server=svsde;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
					ANSIBLE_PLAYBOOK_ENTRY_3="pts-servers,sandvine-auto-config;setup_server=svpts;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE;license_server=$LICENSE_SERVER"

					ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
					;;

				cloud-services)

					ANSIBLE_PLAYBOOK_TOTAL=4

					ANSIBLE_PLAYBOOK_ENTRY_1="spb-servers,sandvine-auto-config;setup_server=svspb;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
					ANSIBLE_PLAYBOOK_ENTRY_2="sde-servers,sandvine-auto-config;setup_server=svsde;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
					ANSIBLE_PLAYBOOK_ENTRY_3="sde-servers,sandvine-auto-config;setup_server=svcs;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
					ANSIBLE_PLAYBOOK_ENTRY_4="pts-servers,sandvine-auto-config;setup_server=svpts;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE;license_server=$LICENSE_SERVER"

					ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
					;;

			esac

			;;

		deployment)

			echo
			echo "Deploying Sandvine's RPM packages with Ansible..."

			case $OPERATION in

				sandvine)

					ANSIBLE_PLAYBOOK_TOTAL=3

					ANSIBLE_PLAYBOOK_ENTRY_1="pts-servers,bootstrap;base_os_upgrade=yes,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_2="sde-servers,bootstrap;base_os_upgrade=yes,nginx,svsde;sde_version=$SDE_VERSION,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_3="spb-servers,bootstrap;base_os_upgrade=yes,nginx,postgresql,svspb;spb_version=$SPB_VERSION,post-cleanup,power-cycle"

					ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
					;;

				cloud-services)

					ANSIBLE_PLAYBOOK_TOTAL=3

					ANSIBLE_PLAYBOOK_ENTRY_1="pts-servers,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svcs-svpts,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_2="sde-servers,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,nginx,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,svcs,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_3="spb-servers,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,nginx,postgresql,svspb;spb_version=$SPB_VERSION,svmcdtext;spb_protocols_version=$SPB_PROTOCOLS_VERSION,svreports;nds_version=$NDS_VERSION,svcs-svspb,post-cleanup,power-cycle"

					ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
					;;

			esac
			;;

		*)

			echo
			echo "Warning! Runtime mode not supported!"
			echo "Usage: $0 --runtime-mode={deployemnt|sandvine-auto-config}"

			exit 1
			;;

	esac

fi

if [ "$ANSIBLE_MANUAL_INVENTORY" == "yes" ]
then

	if [ -z "$RUNTIME_MODE" ]
	then

		echo
		echo "Warning! Manual Inventory mode requires --runtime-mode={full-deployemnt|config-only}, aborting!"
		echo

		exit 1

	fi

	echo
	echo "Creating an Ansible Inventory manually, so it can work against remote hosts"
	echo "that doesn't have APIs as a source for a dynamic inventory."

	echo
	echo "You'll need to type the hostname or IP address of each remote server"

	echo
	echo "NOTE: To use hostnames or FQDNs, you must be able to reach the hosts by name."

	echo
	echo -n "Type the PTS #1 hostname or IP: "
	read PTS_HOSTNAME

	echo
	echo -n "Type the SDE #1 hostname or IP: "
	read SDE_HOSTNAME

	echo
	echo -n "Type the SPB #1 hostname or IP: "
	read SPB_HOSTNAME

	PTS_ACCESS=`echo $PTS_HOSTNAME | awk '{print tolower($0)}'`
	SDE_ACCESS=`echo $SDE_HOSTNAME | awk '{print tolower($0)}'`
	SPB_ACCESS=`echo $SPB_HOSTNAME | awk '{print tolower($0)}'`

	ANSIBLE_INVENTORY_FILE="manual-hosts-$BUILD_RAND"

	pushd ansible &>/dev/null

	echo
	echo "Creating Ansible Inventory: \"ansible/$ANSIBLE_INVENTORY_FILE\"."

	ANSIBLE_INVENTORY_TOTAL=5

	ANSIBLE_HOST_ENTRY_1="all:vars,ansible_user=$ANSIBLE_REMOTE_USER,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME,sandvine_yum_host=$SV_YUM_HOST"
	ANSIBLE_HOST_ENTRY_2="pts-servers,$PTS_ACCESS"
	ANSIBLE_HOST_ENTRY_3="sde-servers,$SDE_ACCESS"
	ANSIBLE_HOST_ENTRY_4="spb-servers,$SPB_ACCESS"
	ANSIBLE_HOST_ENTRY_5="svcs-servers,$SDE_ACCESS"

	ansible_inventory_builder > $ANSIBLE_INVENTORY_FILE

	popd &>/dev/null

fi

popd &>/dev/null

ansible_runner
