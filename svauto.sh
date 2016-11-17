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

	# Options starting with --ansible-* are passed to Ansible itself,
	# or being used by dynamic stuff.

	--ansible-run-against=*)

		/bin/true
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

	--dump)

		ANSIBLE_DUMP="yes"
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

        --os-project=*)

		OS_PROJECT="${i#*=}"
		shift
		;;

        --cloud-services-mode=*)

		CLOUD_SERVICES_MODE="${i#*=}"
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

        --os-stack-type=*)

                OS_STACK_TYPE="${i#*=}"
                shift
                ;;

        --os-release=*)

	        OS_RELEASE="${i#*=}"
		shift
		;;

        --os-bridge-mode=*)

	        OS_BRIDGE_MODE="${i#*=}"
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

	--labify)

		LABIFY="yes"
		shift
		;;

	--move2webroot=*)

		MOVE2WEBROOT_BUILD="${i#*=}"
		shift
		;;

	--update-web-dir-sums)

		UPDATE_WEB_DIR_SUMS="yes"
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


	--libvirt-files=*)

		LIBVIRT_FILES="${i#*=}"
		shift
		;;

	--installation-helper=*)

		INSTALLATION_HELPER="${i#*=}"
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
        --ubuntu-network-detect-default-nic)

	        UBUNTU_NETWORK_DETECT_DEFAULT_NIC="yes"
		shift
		;;


        --download-images=*)

	        DOWNLOAD_IMAGES="${i#*=}"
		shift
		;;

	--libvirt-install-images)

		LIBVIRT_INSTALL_IMAGES="yes"
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
		echo "Ansible's Inventory in memory:"

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
		echo "Ansible's Top-Level Playbook in memory:"

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

if [ ! -z "$BASE_OS" ]
then
	EXTRA_VARS="base_os=$BASE_OS "
fi

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

if [ "$UBUNTU_NETWORK_DETECT_DEFAULT_NIC" == "yes" ]
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

	if pushd $SVAUTO_DIR &>/dev/null
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

case $DOWNLOAD_IMAGES in

	iso-for-kvm)

		echo
		echo "Download ISO images into Libvirt subdir:"

		sudo mkdir /var/lib/libvirt/ISO -p

		pushd /var/lib/libvirt/ISO

		sudo wget -c $UBUNTU1604_64_ISO
		sudo wget -c $UBUNTU1404_64_ISO
		sudo wget -c $CENTOS7_64_ISO
		sudo wget -c $CENTOS6_64_ISO

		popd

		exit 0

		;;

	sandvine)

		echo
		echo "Enter your Sandvine's FTP (ftp.support.sandvine.com) account details:"
		echo

		echo -n "Username: "
#		read FTP_USER

		echo -n "Password: "
#		read -s FTP_PASS

		echo

		pushd downloads

#		wget -c --user=$FTP_USER --password=$FTP_PASS $PTS_IMG_URL
#		wget -c --user=$FTP_USER --password=$FTP_PASS $SDE_IMG_URL
#		wget -c --user=$FTP_USER --password=$FTP_PASS $SPB_IMG_URL

		wget -c $PTS_IMG_URL
		wget -c $SDE_IMG_URL
		wget -c $SPB_IMG_URL

		popd

		exit 0

		;;

	cloud-services)

		echo
		echo "TODO!"

		;;

	generic)

		echo

		pushd downloads

		wget -c $UBUNTU1604_64_CLOUD_IMG_URL
		wget -c $UBUNTU1404_64_CLOUD_IMG_URL
		wget -c $UBUNTU1204_64_CLOUD_IMG_URL
		wget -c $DEBIAN8_64_CLOUD_IMG_URL
		wget -c $CENTOS7_64_CLOUD_IMG_URL
		wget -c $CENTOS6_64_CLOUD_IMG_URL
		wget -c $CIRROS03_64_CLOUD_IMG_URL

		popd

		exit0

		;;

esac

#
# Post-Image creation options
#

if [ "$UPDATE_WEB_DIR_SUMS" == "yes" ]
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

if [ ! -z "$INSTALLATION_HELPER" ]
then

	case "$INSTALLATION_HELPER" in

		sandvine-dev)
			installation_helper
			;;

		cs-dev)
			installation_helper_cs
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

# cpu_check

# hostname_check

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
		echo "cd ~/svauto"
		echo "./svauto.sh --os-project=\"demo\" --os-stack-name=sv-stack-1 --os-stack-type=stock --ansible-remote-user=sandvine"
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

        case "$OS_STACK_TYPE" in

                # TODO: Auto detected all instances automatically:

                stock)

                        PTS_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-pts-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SDE_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-sde-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SPB_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-spb-1 | awk $'{print $2}'` | awk $'{print $4}')
                        ;;

                svcsd)

                        PTS_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-pts-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SDE_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-sde-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SPB_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-spb-1 | awk $'{print $2}'` | awk $'{print $4}')
                        CSD_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-svcsd-1 | awk $'{print $2}'` | awk $'{print $4}')
                        ;;

                svnda)

                        PTS_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-pts-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SDE_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-sde-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SPB_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-spb-1 | awk $'{print $2}'` | awk $'{print $4}')
                        NDA_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-nda-1 | awk $'{print $2}'` | awk $'{print $4}')
                        ;;

                svtse-demo-mycloud)

                        PTS_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-pts-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SDE_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-sde-1 | awk $'{print $2}'` | awk $'{print $4}')
                        SPB_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-spb-1 | awk $'{print $2}'` | awk $'{print $4}')
                        TSE_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-tse-1 | awk $'{print $2}'` | awk $'{print $4}')
                        TCPA_ACCESS=$(nova floating-ip-list 2>/dev/null | grep `nova list | grep $OS_STACK_NAME-tcpa-1 | awk $'{print $2}'` | awk $'{print $4}')
                        ;;


		*)

			echo
			echo "Usage: $0 --os-stack-type={stock|svcsd|svnda|svtse-demo-mycloud}"

			exit 1
			;;

        esac

	if [ -z $PTS_ACCESS ] || [ -z $SDE_ACCESS ] || [ -z $SPB_ACCESS ] #|| [ -z $CSD_ACCESS ]
	then
		echo
		echo "Warning! No compatible Instances was detected on your \"$OS_STACK_NAME\" Stack!"
		echo "Possible causes are:"
		echo
		echo " * Missing Floating IP for one or more Sandvine's Instances."
		echo " * You're running a Stack that is not compatbile with Sandvine's rquirements."
		echo

		exit 1
	fi

	echo
	echo "The following Sandvine-compatible Instances was detected on your \"$OS_STACK_NAME\" Stack:"
	echo
	echo Floating IPs of:
	echo
	echo PTS: $PTS_ACCESS
	echo SDE: $SDE_ACCESS
	echo SPB: $SPB_ACCESS

	if [ "$OPERATION" == "cloud-services" ] && [ "$OS_STACK_TYPE" == "stock" ]; then echo SVCSD: $SDE_ACCESS; fi
	if [ "$OPERATION" == "cloud-services" ] && [ "$OS_STACK_TYPE" == "svcsd" ]; then echo SVCSD: $CSD_ACCESS; fi

	if [ "$OS_STACK_TYPE" == "svnda" ]; then echo NDA: $NDA_ACCESS; fi

	if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]; then echo TSE: $TSE_ACCESS; fi
	if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]; then echo TCPA: $TCPA_ACCESS; fi

	pushd ansible &>/dev/null

	ANSIBLE_INVENTORY_FILE="openstack-hosts-$BUILD_RAND"

	echo
	echo "Creating Ansible Inventory: \"ansible/$ANSIBLE_INVENTORY_FILE\"."

	ANSIBLE_INVENTORY_TOTAL=4

	ANSIBLE_HOST_ENTRY_1="all:vars,ansible_user=$ANSIBLE_REMOTE_USER,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME,sandvine_yum_host=$SV_YUM_HOST"
	ANSIBLE_HOST_ENTRY_2="svpts-servers,$PTS_ACCESS,base_os=centos7"
	ANSIBLE_HOST_ENTRY_3="svsde-servers,$SDE_ACCESS,base_os=centos7"
	ANSIBLE_HOST_ENTRY_4="svspb-servers,$SPB_ACCESS,base_os=centos6"

	ansible_inventory_builder > $ANSIBLE_INVENTORY_FILE

	if [ "$OPERATION" == "cloud-services" ]
	then

		if [ "$OS_STACK_TYPE" == "stock" ]
		then

			ANSIBLE_INVENTORY_TOTAL=1

			ANSIBLE_HOST_ENTRY_1="svcs-servers,$SDE_ACCESS,base_os=centos7"

			ansible_inventory_builder >> $ANSIBLE_INVENTORY_FILE

		fi

		if [ "$OS_STACK_TYPE" == "svcsd" ]
		then

			ANSIBLE_INVENTORY_TOTAL=1

			ANSIBLE_HOST_ENTRY_1="svcs-servers,$CSD_ACCESS,base_os=centos7"

			ansible_inventory_builder >> $ANSIBLE_INVENTORY_FILE

		fi

	fi

	if [ "$OS_STACK_TYPE" == "svnda" ]
	then

		ANSIBLE_INVENTORY_TOTAL=1

		ANSIBLE_HOST_ENTRY_1="svnda-servers,$NDA_ACCESS,base_os=centos7"

		ansible_inventory_builder >> $ANSIBLE_INVENTORY_FILE

	fi

	if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]
	then

		ANSIBLE_INVENTORY_TOTAL=2

		ANSIBLE_HOST_ENTRY_1="svtse-servers,$TSE_ACCESS,base_os=centos7"
		ANSIBLE_HOST_ENTRY_2="svtcpa-servers,$TCPA_ACCESS,base_os=centos7"

		ansible_inventory_builder >> $ANSIBLE_INVENTORY_FILE

		OPERATION="svtse-demo"

	fi

	popd &>/dev/null

fi

echo
echo "Creating Ansible Playbook: \"ansible/$ANSIBLE_PLAYBOOK_FILE\"."

pushd ansible &>/dev/null

if [ "$CENTOS_NETWORK_SETUP" == "yes" ]
then

	if [ "$OS_STACK_TYPE" == "svnda" ]
	then

		ANSIBLE_PLAYBOOK_TOTAL=1

		ANSIBLE_PLAYBOOK_ENTRY_1="svnda-servers,centos-network-setup"

		ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
	fi


	if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]
	then
		ANSIBLE_PLAYBOOK_TOTAL=2

		ANSIBLE_PLAYBOOK_ENTRY_1="svtcpa-servers,centos-network-setup"
		ANSIBLE_PLAYBOOK_ENTRY_2="svtse-servers,centos-network-setup"

		ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
	fi

	ANSIBLE_PLAYBOOK_TOTAL=3

	ANSIBLE_PLAYBOOK_ENTRY_1="svspb-servers,centos-network-setup"
	ANSIBLE_PLAYBOOK_ENTRY_2="svsde-servers,centos-network-setup"
	ANSIBLE_PLAYBOOK_ENTRY_3="svpts-servers,centos-network-setup;setup_server=svpts"

	ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE

fi

if [ -n "$RUNTIME_MODE" ]
then

	case "$RUNTIME_MODE" in
	
		config-only)
	
			echo
			echo "Configuring Sandvine Platform with Ansible..."
	
			if [ "$OS_STACK_TYPE" == "svnda" ]
			then
	
				ANSIBLE_PLAYBOOK_TOTAL=1
	
				ANSIBLE_PLAYBOOK_ENTRY_1="svnda-servers,sandvine-auto-config;setup_server=svnda;setup_mode=$OPERATION"
	
				ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
			fi
	
			if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]
			then
	
				ANSIBLE_PLAYBOOK_TOTAL=2
	
				ANSIBLE_PLAYBOOK_ENTRY_1="svtcpa-servers,sandvine-auto-config;setup_server=svtcpa;setup_mode=$OPERATION"
				ANSIBLE_PLAYBOOK_ENTRY_2="svtse-servers,sandvine-auto-config;setup_server=svtse;setup_mode=$OPERATION;license_server=$LICENSE_SERVER"
	
				ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
			fi
	
			if [ "$OPERATION" == "cloud-services" ] && [ -z "$CLOUD_SERVICES_MODE" ]
			then
	
				echo
				echo "For operation=cloud-services, you have to also, specify --cloud-services-mode=default|mdm"
	
				exit 1
	
			fi
	
			if [ "$OPERATION" == "sandvine" ]; then CLOUD_SERVICES_MODE=null; fi
	
			ANSIBLE_PLAYBOOK_TOTAL=3
	
			ANSIBLE_PLAYBOOK_ENTRY_1="svspb-servers,sandvine-auto-config;setup_server=svspb;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
			ANSIBLE_PLAYBOOK_ENTRY_2="svsde-servers,sandvine-auto-config;setup_server=svsde;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE"
			ANSIBLE_PLAYBOOK_ENTRY_3="svpts-servers,sandvine-auto-config;setup_server=svpts;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE;license_server=$LICENSE_SERVER"
	
			ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
			;;
	
		full-deployment)
	
			echo
			echo "Deploying Sandvine's RPM packages with Ansible..."
	
			case $OPERATION in
	
				sandvine)
	
					ANSIBLE_PLAYBOOK_TOTAL=3
	
					ANSIBLE_PLAYBOOK_ENTRY_1="svpts-servers,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,sandvine-auto-config;setup_mode=$OPERATION;deployment_mode=yes;license_server=$LICENSE_SERVER,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_2="svsde-servers,bootstrap;base_os_upgrade=yes,svsde;sde_version=$SDE_VERSION,sandvine-auto-config;setup_mode=$OPERATION;deployment_mode=yes,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_3="svspb-servers,bootstrap;base_os_upgrade=yes,svspb;spb_version=$SPB_VERSION;deployment_mode=yes,sandvine-auto-config;setup_mode=$OPERATION;deployment_mode=yes,post-cleanup,power-cycle"
	
					ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
					;;
	
				cloud-services)
	
					ANSIBLE_PLAYBOOK_TOTAL=3
	
					ANSIBLE_PLAYBOOK_ENTRY_1="svpts-servers,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svcs-svpts,sandvine-auto-config;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE;license_server=$LICENSE_SERVER,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_2="svsde-servers,bootstrap;base_os_upgrade=yes,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,svcs,sandvine-auto-config;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE,post-cleanup,power-cycle"
					ANSIBLE_PLAYBOOK_ENTRY_3="svspb-servers,bootstrap;base_os_upgrade=yes,svspb;spb_version=$SPB_VERSION,svmcdtext;spb_protocols_version=$SPB_PROTOCOLS_VERSION,svreports;nds_version=$NDS_VERSION,svcs-svspb,sandvine-auto-config;setup_mode=$OPERATION;setup_sub_option=$CLOUD_SERVICES_MODE,post-cleanup,power-cycle"
	
					ansible_playbook_builder >> $ANSIBLE_PLAYBOOK_FILE
					;;
	
			esac
			;;
	
		*)
	
			echo
			echo "Warning! Runtime mode not supported!"
			echo "Usage: $0 --runtime-mode={full-deployemnt|config-only}"
	
			exit 1
			;;
	
	esac

fi

if [ "$LABIFY" == "yes" ]
then

	if [ -z "$RUNTIME_MODE" ]
	then

		echo
		echo "Warning! Labify require --runtime-mode=something, aborting!"
		echo

		exit 1

	fi

	echo
	echo "Labifying the playbook, so it can work against lab's Instances..."

	echo
	echo "You'll need to copy and paste each hostname here, after running profilemgr..."

	echo
	echo -n "Type the PTS hostname: "
	read PTS_HOSTNAME

	echo
	echo -n "Type the SDE hostname: "
	read SDE_HOSTNAME

	echo
	echo -n "Type the SPB hostname: "
	read SPB_HOSTNAME

	PTS_ACCESS_TMP=$PTS_HOSTNAME.$DNS_DOMAIN
	SDE_ACCESS_TMP=$SDE_HOSTNAME.$DNS_DOMAIN
	SPB_ACCESS_TMP=$SPB_HOSTNAME.$DNS_DOMAIN

	PTS_ACCESS=`echo $PTS_ACCESS_TMP | awk '{print tolower($0)}'`
	SDE_ACCESS=`echo $SDE_ACCESS_TMP | awk '{print tolower($0)}'`
	SPB_ACCESS=`echo $SPB_ACCESS_TMP | awk '{print tolower($0)}'`

	ANSIBLE_INVENTORY_FILE="tmp/lab-hosts-$BUILD_RAND"

	echo
	echo "Creating Ansible Inventory: \"ansible/$ANSIBLE_INVENTORY_FILE\"."

	ANSIBLE_INVENTORY_TOTAL=5

	ANSIBLE_HOST_ENTRY_1="all:vars,ansible_user=$ANSIBLE_REMOTE_USER,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME,sandvine_yum_host=$SV_YUM_HOST"
	ANSIBLE_HOST_ENTRY_2="svpts-servers,$PTS_ACCESS,base_os=centos7"
	ANSIBLE_HOST_ENTRY_3="svsde-servers,$SDE_ACCESS,base_os=centos7"
	ANSIBLE_HOST_ENTRY_4="svspb-servers,$SPB_ACCESS,base_os=centos6"
	ANSIBLE_HOST_ENTRY_5="svcs-servers,$SDE_ACCESS,base_os=centos7"

	ansible_inventory_builder > $ANSIBLE_INVENTORY_FILE

fi

popd &>/dev/null

if [ "$DRY_RUN" == "yes" ]
then

	echo
	echo "Not running Ansible on dry run..."

        echo
        echo "NOTE: You can manually run Ansible by typing:"
        echo
        echo "cd ansible"
        echo "ansible-playbook -i $ANSIBLE_INVENTORY_FILE $ANSIBLE_PLAYBOOK_FILE"
        echo

else

        echo
        echo "SVAuto is running Ansible:"

        echo
	echo "pushd ansible"

	echo
	pushd ansible

	if [ -z "$OS_PROJECT" ] || [ -z "$RUNTIME_MODE" ]
	then

		echo
		echo "Creating both Ansible's Inventory and the Playbook..."


		echo "$ANSIBLE_INVENTORY_FILE_IN_MEM" >> $ANSIBLE_INVENTORY_FILE

		echo "$ANSIBLE_PLAYBOOK_FILE_IN_MEM" >> $ANSIBLE_PLAYBOOK_FILE

		#echo "$ANSIBLE_EXTRA_VARS_FILE_IN_MEM" > $ANSIBLE_EXTRA_VARS_FILE

	fi

	echo
	echo "ansible-playbook -i $ANSIBLE_INVENTORY_FILE $ANSIBLE_PLAYBOOK_FILE"

	if ansible-playbook -i $ANSIBLE_INVENTORY_FILE $ANSIBLE_PLAYBOOK_FILE # -e \""$ANSIBLE_EXTRA_VARS $EXTRA_VARS"\"
	then

		echo
		echo "Ansilble applied the playbook correctly... Success!"
		echo

		if [ ! -z $OS_STACK_NAME ] || [ "$LABIFY" == "yes" ]
		then

			echo "Your brand new Sandvine's Stack is reachable through SSH:"

			echo
			echo "ssh sandvine@$PTS_ACCESS # PTS"
			echo "ssh sandvine@$SDE_ACCESS # SDE"
			echo "ssh sandvine@$SPB_ACCESS # SPB"

			if [ "$OPERATION" == "cloud-services" ] && [ "$OS_STACK_TYPE" == "stock" ]; then echo "ssh sandvine@$SDE_ACCESS # SVCS"; fi
			if [ "$OPERATION" == "cloud-services" ] && [ "$OS_STACK_TYPE" == "svcsd" ]; then echo "ssh sandvine@$CSD_ACCESS # SVCS"; fi

			if [ "$OS_STACK_TYPE" == "svnda" ]; then echo "ssh sandvine@$NDA_ACCESS # NDA"; fi

			if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]; then echo "ssh sandvine@$TSE_ACCESS # TSE"; fi
			if [ "$OS_STACK_TYPE" == "svtse-demo-mycloud" ]; then echo "ssh sandvine@$TCPA_ACCESS # TCP Accelerator"; fi

		else

			echo
			echo "Ansible Playbook failed to apply! ABORTING!!!"
			echo

			exit 1

		fi

	fi

	popd

fi
