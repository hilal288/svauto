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

os_deploy()
{

	ANSIBLE_PLAYBOOK_FILE="tmp/openstack-aio-$BUILD_RAND.yml"


	# Validade the OS_BRIDGE_MODE variable.
	if ! [[ "$OS_BRIDGE_MODE" == "OVS" || "$OS_BRIDGE_MODE" == "LBR" ]]
	then
		echo
		echo "Aborting!!!"
		echo "You need to correctly specify the Bridge Mode for your OpenStack."
		echo
		echo "For Open vSwitch based deployments:"
		echo "./svauto.sh --br-mode=OVS --base-os=ubuntu16 --base-os-upgrade=yes --os-release=mitaka --deployment-mode"
		echo
		echo "For Linux Bridges based deployments:"
		echo "./svauto.sh --br-mode=LBR --base-os=ubuntu16 --base-os-upgrade=yes --os-release=mitaka --deployment-mode"

		exit 1
	fi


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


	# Detect some of the local settings:
	WHOAMI=$(whoami)
	UBUNTU_HOSTNAME=$(hostname)
	FQDN=$(hostname -f)
	DOMAIN=$(hostname -d)


	# If the hostname and hosts file aren't configured according, abort.
	if [ -z $UBUNTU_HOSTNAME ]; then
		echo "Hostname not found... Configure the file /etc/hostname with your hostname. ABORTING!"

		exit 1
	fi

	if [ -z $DOMAIN ]; then
		echo "Domain not found... Configure the file /etc/hosts with your \"IP + FQDN + HOSTNAME\". ABORTING!"

		exit 1
	fi

	if [ -z $FQDN ]; then
		echo "FQDN not found... Configure your /etc/hosts according. ABORTING!"

		exit 1
	fi


	# Display local configuration
	echo
	echo "The detected local configuration are:"
	echo
	echo -e "* Username:"'\t'$WHOAMI
	echo -e "* Hostname:"'\t'$UBUNTU_HOSTNAME
	echo -e "* FQDN:"'\t''\t'$FQDN
	echo -e "* Domain:"'\t'$DOMAIN


	# Message about ansible/group_vars/all configuration
	echo
	echo "Configuring your ansible/group_vars/all file, as follows:"

	# Configuring Bridge Mode on group_vars/all
	echo
	echo "* The Bridge Mode is set to "$OS_BRIDGE_MODE"..."

	# http://docs.openstack.org/networking-guide/scenario_legacy_lb.html
	if [ "$OS_BRIDGE_MODE" == "LBR" ]
	then
		sed -i -e 's/br_mode:.*/br_mode: "LBR"/' ansible/group_vars/all
		sed -i -e 's/linuxnet_interface_driver:.*/linuxnet_interface_driver: "nova.network.linux_net.LinuxBridgeInterfaceDriver"/' ansible/group_vars/all
		sed -i -e 's/neutron_interface_driver:.*/neutron_interface_driver: "neutron.agent.linux.interface.BridgeInterfaceDriver"/' ansible/group_vars/all
		sed -i -e 's/mechanism_drivers:.*/mechanism_drivers: "linuxbridge"/' ansible/group_vars/all
		sed -i -e 's/firewall_driver:.*/firewall_driver: "iptables"/' ansible/group_vars/all
	fi

	# http://docs.openstack.org/networking-guide/scenario_legacy_ovs.html
	if [ "$OS_BRIDGE_MODE" == "OVS" ]
	then 
		sed -i -e 's/br_mode:.*/br_mode: "OVS"/' ansible/group_vars/all
		sed -i -e 's/linuxnet_interface_driver:.*/linuxnet_interface_driver: "nova.network.linux_net.LinuxOVSInterfaceDriver"/' ansible/group_vars/all
		sed -i -e 's/neutron_interface_driver:.*/neutron_interface_driver: "neutron.agent.linux.interface.OVSInterfaceDriver"/' ansible/group_vars/all
		sed -i -e 's/mechanism_drivers:.*/mechanism_drivers: "openvswitch"/' ansible/group_vars/all

		if [ "$OS_HYBRID_FW" == "yes" ]
		then
			sed -i -e 's/firewall_driver:.*/firewall_driver: "iptables_hybrid"/' ansible/group_vars/all
		else
			sed -i -e 's/firewall_driver:.*/firewall_driver: "openvswitch"/' ansible/group_vars/all
		fi
	fi


	# Disabling Security Groups entirely
	if [ "$OS_NO_SEC" == "yes" ]
	then
		echo
		echo "* WARNING! Disabling Security Groups (null firewall_driver) for your entire Cloud environment!"

		sed -i -e 's/firewall_driver:.*/firewall_driver: "neutron.agent.firewall.NoopFirewall"/' ansible/group_vars/all
	fi


	# Configuring FQDN and Domain on group_vars/all
	echo
	echo "* The detected settings like OpenStack release, hostnames, etc..."

	sed -i -e 's/openstack_release:.*/openstack_release: "'$OS_RELEASE'"/' ansible/group_vars/all

	sed -i -e 's/your_domain:.*/your_domain: "'$DOMAIN'"/' ansible/group_vars/all

	sed -i -e 's/public_addr:.*/public_addr: "'$FQDN'"/' ansible/group_vars/all
	sed -i -e 's/controller_addr:.*/controller_addr: "'$FQDN'"/' ansible/group_vars/all


	# Configuring ansible/group_vars/all and ansible/hosts
	echo
	echo "* Your current \"$WHOAMI\" user..."

	sed -i -e 's/regular_system_user:.*/regular_system_user: "'$WHOAMI'"/' ansible/group_vars/all


	echo
	echo "* Enabling \"localhost\" host on ansible/hosts..."

	sed -i -e 's/^#localhost/localhost/' ansible/hosts


	if [ "$OS_AIO" == "yes" ]
	then
		echo
		echo "* OpenStack AIO activated..."

		sed -i -e 's/os_aio:.*/os_aio: "yes"/' ansible/group_vars/all
	fi


	if [ "$OS_OPEN_PROVIDER_NETS_TO_REGULAR_USERS" == "yes" ]
	then
		echo
		echo "* Opening Provider Networks to all regular users! Security risk!"

		sed -i -e 's/os_open_provider_nets_to_regular_users:.*/os_open_provider_nets_to_regular_users: "yes"/' ansible/group_vars/all
	fi


	echo
	echo "* Building top-level Ansible's Playbook file."

	ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-hosts=os_aio \
		--roles=bootstrap,os_clients,ssh_keypair,os_mysql,os_mysql_db,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,os_glance_images,hyper_kvm,os_nova,os_keypair,os_nova_flavors,os_neutron,os_ext_net,os_horizon,os_heat,post-cleanup >> ansible/$ANSIBLE_PLAYBOOK_FILE

#	ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-hosts=os_controller_nodes \
#		--roles=bootstrap,grub-conf,os_clients,ssh_keypair,os_mysql,os_mysql_db,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,os_glance_images,os_nova,os_keypair,os_nova_flavors,os_neutron,os_ext_net,os_horizon,os_heat,post-cleanup >> $ANSIBLE_PLAYBOOK_FILE
#
#	ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-hosts=os_network_nodes \
#		--roles=bootstrap,grub-conf,os_neutron,post-cleanup >> $ANSIBLE_PLAYBOOK_FILE
#
#	ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-hosts=os_compute_nodes \
#		--roles=bootstrap,grub-conf,hyper_kvm,os_nova,os_neutron,post-cleanup >> $ANSIBLE_PLAYBOOK_FILE


	if [ "$DRY_RUN" == "yes" ]
	then
		echo
		echo "Not running Ansible on --dry-run!"
		echo "Just preparing the environment variables, so you can run Ansible manually, like:"
		echo
		echo "cd ~/svauto/ansible"
		echo "ansible-playbook $ANSIBLE_PLAYBOOK_FILE --extra-vars \"deployment_mode=yes\""
		echo
		echo "And a second run after a successful deployment:"
		echo
		echo "ansible-playbook $ANSIBLE_PLAYBOOK_FILE"
		echo
	else
		echo
		echo "* Running Ansible, deploying OpenStack:"

		if [ "$DEPLOYMENT_MODE" == "yes" ];
		then
			cd ~/svauto/ansible
			ansible-playbook $ANSIBLE_PLAYBOOK_FILE --extra-vars "deployment_mode=yes"
		else

			cd ~/svauto/ansible
			ansible-playbook $ANSIBLE_PLAYBOOK_FILE
		fi
	fi

}
