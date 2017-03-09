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

if ! source svauto.conf
then

	echo "File svauto.conf not found, aborting!"
	echo "Run svauto.sh from your SVAuto sub directory."

	exit 1

fi

#
# STABLE
#

# SVTSE on CentOS 7
./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svtse --version=$TSE_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,centos-network-setup;activate_eth1=no;centos_eth1_onboot=no,udev-rules,dpdk-igb-uio-dkms,nginx,svtse;svtse_version=$TSE_VERSION;sandvine_yum_host=$SV_YUM_HOST,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto # --dry-run
