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

#
# *** OBSOLETE SCRIPT ***
#
# Keeping it for reference only.
#
# With future versions of SVAuto, we'll be able to dynamically build OpenStack
# on Vagrant, by just passing Ansible roles we want.

WHOAMI=vagrant

HOSTNAME=controller-1
FQDN=controller-1.yourdomain.com
DOMAIN=yourdomain.com


# Display local configuration
echo
echo "The hardcoded local configuration is:"
echo
echo -e "* Username:"'\t'$WHOAMI
echo -e "* Hostname:"'\t'$HOSTNAME
echo -e "* FQDN:"'\t''\t'$FQDN
echo -e "* Domain:"'\t'$DOMAIN


echo
echo "Configuring ansible/group_vars/all file based on current environment..."
sed -i -e 's/controller-1.yourdomain.com/'$FQDN'/g' ansible/group_vars/all
sed -i -e 's/yourdomain.com/'$DOMAIN'/g' ansible/group_vars/all


echo
echo "Configuring ansible/group_vars_all with your current "$WHOAMI" user..."
sed -i -e 's/{{ubuntu_user}}/'$WHOAMI'/g' ansible/group_vars/all


DEFAULT_GW_INT=eth0


echo 
echo "Your primary network interface is:"
echo "dafault route via:" $DEFAULT_GW_INT


echo
echo "Preparing Ansible variable based on current default gateway interface..."

sed -i -e 's/os_mgmt:.*/os_mgmt: "'$PRIMARY_INTERFACE'"/' ansible/group_vars/all


echo
echo "Building top-level Ansible's Playbook file."

ANSIBLE_PLAYBOOK_FILE="openstack-aio-$BUILD_RAND.yml"

ansible_playbook_builder --ansible-remote-user=\"{{\ regular_system_user\ }}\" \
	--ansible-playbook-builder=os_vagrant_aio,bootstrap,os_clients,ssh_keypair,os_mysql,os_mysql_db,os_rabbitmq,os_memcached,apache2,os_keystone,os_glance,os_glance_images,hyper_kvm,os_nova,os_keypair,os_nova_flavors,os_neutron,os_ext_net,os_horizon,os_heat,post-cleanup >> ansible/$ANSIBLE_PLAYBOOK_FILE

sed -i -e 's/{{openstack-aio-top-book}}/"'$ANSIBLE_PLAYBOOK_FILE'"/' Vagrantfile


echo
echo "Running Ansible through Vagrant, deploying OpenStack:"
echo

vagrant up --provider=libvirt
