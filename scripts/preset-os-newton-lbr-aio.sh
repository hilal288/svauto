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
YOUR_DOMAIN="yourdomain.com"
UBUNTU_PRIMARY_INTERFACE="em1"

clear

echo
echo "Welcome to SVAuto's OpenStack Newton deployment!"
echo

echo
echo "Deploying OpenStack..."
echo
echo "Bridge Mode: Linux Bridges"
echo

# Hardcoded values, bad but, good for a moment...
#
# os_external=dumm0
# os_data=dumm1

./svauto.sh --cpu-check --hostname-check \
	--ubuntu-detect-default-nic \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="os_aio,localhost,ansible_connection=local,regular_system_user=ubuntu,os_release=newton,ubuntu_primary_interface=$UBUNTU_PRIMARY_INTERFACE,os_dns_domain=$YOUR_DOMAIN,os_public_addr=$UBUNTU_HOSTNAME.$YOUR_DOMAIN,os_admin_addr=$UBUNTU_HOSTNAME.$YOUR_DOMAIN,deployment_mode=yes,os_mgmt=$UBUNTU_PRIMARY_INTERFACE" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ubuntu-network-setup;ubuntu_network_mode=dhcp;ubuntu_setup_dummy_nics=yes;ubuntu_enable_ip_masquerade=yes;os_neutron_lbr_enabled=yes,os_clients,ssh_keypair,os_mysql,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,hyper_kvm,os_nova;os_nova_ctrl=yes;os_nova_cmpt=yes;linuxnet_interface_driver=nova.network.linux_net.LinuxBridgeInterfaceDriver,os_keypair,os_nova_flavors,os_neutron;os_aio=yes;os_neutron_ctrl=yes;os_neutron_net=yes;os_neutron_lbr_enabled=yes;neutron_interface_driver=linuxbridge;os_external=dummy0;os_data=dummy1,os_ext_net,os_horizon,os_heat,post-cleanup"
