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

# Linux SVPTS on CentOS 7
./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos7,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,dpdk-igb-uio-dkms,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

# Linux SVPTS on CentOS 6 with Linux 3.18 from Xen 4.6 official repo
./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos6,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST" \
	--ansible-playbook-builder="svbox,centos-xen,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


# Linux SVSDE on CentOS 6
./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos6,is_packer=yes" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,svsde;sde_version=$SDE_VERSION;sandvine_yum_host=$SV_YUM_HOST,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


# Linux SVSDE on CentOS 7
./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos7,is_packer=yes" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,svsde;sde_version=$SDE_VERSION;sandvine_yum_host=$SV_YUM_HOST,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


# Linux SVSPB on CentOS 6
./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svspb --version=$SPB_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum --ansible-remote-user=root \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos6,is_packer=yes" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,postgresql,svspb;spb_version=$SPB_VERSION;sandvine_yum_host=$SV_YUM_HOST,vmware-tools,post-cleanup-image;setup_server=svspb,power-cycle" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


#
# Experimental Builds 
#

# SVTSE on CentOS 7
./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svtse --version=$TSE_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos7,is_packer=yes" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,svtse;svtse_version=$TSE_VERSION;sandvine_yum_host=$SV_YUM_HOST,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

# SVNDA on CentOS 7
./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svnda --version=$NDA_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,base_os=centos7,is_packer=yes" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,postgresql,svnda;svnda_version=$NDA_VERSION;sandvine_yum_host=$SV_YUM_HOST,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


./svauto.sh --heat-templates=sandvine-dev

./svauto.sh --libvirt-files=sandvine-dev

./svauto.sh --move2webroot=sandvine-dev

./svauto.sh --update-web-dir-sums

./svauto.sh --update-web-dir-symlink
