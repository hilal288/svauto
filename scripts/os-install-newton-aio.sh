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


UBUNTU_HOSTNAME="controller-1"
DOMAIN="yourdomain.com"
UBUNTU_PRIMARY_INTERFACE="em1"


clear


echo
echo "Welcome to SVAuto's OpenStack Newton deployment!"
echo


echo
echo "Deploying OpenStack..."
echo
echo "Bridge Mode: Open vSwitch"
echo


pushd ~/svauto


# Hardcoded values, bad but, good for a moment...
#
# os_external=dumm0
# os_data=dumm1


./svauto.sh --ubuntu-network-detect-default-nic \
	--ansible-run-against=local \
	--ansible-remote-user=root \
	--ansible-inventory-builder="os_aio,localhost,ansible_connection=local,regular_system_user=ubuntu,base_os=ubuntu16,openstack_release=newton,ubuntu_primary_interface=$UBUNTU_PRIMARY_INTERFACE,your_domain=$YOUR_DOMAIN,public_addr=$UBUNTU_HOSTNAME.$YOUR_DOMAIN,controller_addr=$UBUNTU_HOSTNAME.$YOUR_DOMAIN,deployment_mode=yes,os_mgmt=$UBUNTU_PRIMARY_INTERFACE" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes;ubuntu_network_setup=yes;ubuntu_network_mode=dhcp;ubuntu_setup_dummy_nics=yes;ubuntu_setup_iptables_rc_local=yes,os_clients,ssh_keypair,os_mysql,os_mysql_db,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,hyper_kvm,os_nova;os_nova_ctrl=yes;os_nova_cmpt=yes;linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver,os_keypair,os_nova_flavors,os_neutron;os_aio=yes;os_neutron_ctrl=yes;os_neutron_net=yes;br_mode=OVS;neutron_interface_driver=neutron.agent.linux.interface.OVSInterfaceDriver;os_external=dummy0;os_data=dummy1,os_ext_net,os_horizon,os_heat,post-cleanup"
