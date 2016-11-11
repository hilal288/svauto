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

	cpu_check

	hostname_check


	if [ "$OS_AIO" == "yes" ]
	then
		EXTRA_VARS="$EXTRA_VARS os_aio=yes "
	fi


	if [ "$UBUNTU_NETWORK_DETECT_DEFAULT_NIC" == "openstack" ]
	then
		EXTRA_VARS="$EXTRA_VARS os_mgmt=$UBUNTU_PRIMARY_INTERFACE "
	
	fi


	# http://docs.openstack.org/networking-guide/scenario_legacy_lb.html
	if [ "$OS_BRIDGE_MODE" == "LBR" ]
	then
		EXTRA_VARS="$EXTRA_VARS br_mode=LBR "
		EXTRA_VARS="$EXTRA_VARS linuxnet_interface_driver=nova.network.linux_net.LinuxBridgeInterfaceDriver "
		EXTRA_VARS="$EXTRA_VARS neutron_interface_driver=neutron.agent.linux.interface.BridgeInterfaceDriver "
		EXTRA_VARS="$EXTRA_VARS mechanism_drivers=linuxbridge "
		EXTRA_VARS="$EXTRA_VARS firewall_driver=iptables "
	fi

	# http://docs.openstack.org/networking-guide/scenario_legacy_ovs.html
	if [ "$OS_BRIDGE_MODE" == "OVS" ]
	then 
		EXTRA_VARS="$EXTRA_VARS br_mode=OVS "
		EXTRA_VARS="$EXTRA_VARS linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver "
		EXTRA_VARS="$EXTRA_VARS neutron_interface_driver=neutron.agent.linux.interface.OVSInterfaceDriver "
		EXTRA_VARS="$EXTRA_VARS mechanism_drivers=openvswitch "

		if [ "$OS_HYBRID_FW" == "yes" ]
		then
			EXTRA_VARS="$EXTRA_VARS firewall_driver=iptables_hybrid "
		else
			EXTRA_VARS="$EXTRA_VARS firewall_driver=openvswitch "
		fi
	fi


	# Disabling Security Groups entirely
	if [ "$OS_NO_SEC" == "yes" ]
	then
		EXTRA_VARS="$EXTRA_VARS firewall_driver=neutron.agent.firewall.NoopFirewall "
	fi


	# Configuring FQDN and Domain
	EXTRA_VARS="$EXTRA_VARS openstack_release=$OS_RELEASE "
	EXTRA_VARS="$EXTRA_VARS your_domain=$DOMAIN "
	EXTRA_VARS="$EXTRA_VARS public_addr=$FQDN "
	EXTRA_VARS="$EXTRA_VARS controller_addr=$FQDN "


	EXTRA_VARS="$EXTRA_VARS regular_system_user=$WHOAMI "


	if [ "$OS_OPEN_PROVIDER_NETS_TO_REGULAR_USERS" == "yes" ]
	then
		EXTRA_VARS="$EXTRA_VARS os_open_provider_nets_to_regular_users=yes "
	fi


	ANSIBLE_PLAYBOOK_FILE="top-level-playbook-$BUILD_RAND.yml"


	echo
	echo "Creating Ansible Playbook: \"ansible/$ANSIBLE_PLAYBOOK_FILE\"."


#	NOTE 1: For now, lib/os_deploy.sh only supports OpenStack AIO deployments.


	ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" \
		--ansible-playbook-builder="localhost,bootstrap:base_os_upgrade=yes:ubuntu_network_setup=yes:ubuntu_network_mode=dhcp:ubuntu_setup_dummy_nics=yes:ubuntu_setup_iptables_rc_local=yes,os_clients,ssh_keypair,os_mysql,os_mysql_db,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,hyper_kvm,os_nova,os_keypair,os_nova_flavors,os_neutron,os_ext_net,os_horizon,os_heat,post-cleanup" --ansible-extra-vars="openstack_release=mitaka,os_aio=yes" >> ansible/$ANSIBLE_PLAYBOOK_FILE


#	NOTE 2: Those are the options that can be used for OpenStack multi-node deployments (here only as a reference).


#	ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" --ansible-hosts=os_controller_nodes \
#		--roles=bootstrap,grub-conf,os_clients,ssh_keypair,os_mysql,os_mysql_db,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,os_nova,os_keypair,os_nova_flavors,os_neutron,os_ext_net,os_horizon,os_heat,post-cleanup >> $ANSIBLE_PLAYBOOK_FILE
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
		echo "ansible-playbook -c local $ANSIBLE_PLAYBOOK_FILE -e $ANSIBLE_EXTRA_VARS $EXTRA_VARS"
		echo

	else

		echo
		echo "* Running Ansible, deploying OpenStack:"

		echo
		pushd ansible

		ansible-playbook -c local $ANSIBLE_PLAYBOOK_FILE -e \""$ANSIBLE_EXTRA_VARS $EXTRA_VARS"\"

	fi

}
