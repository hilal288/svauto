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

# SVSDE on CentOS 7 + Cloud Services SDE + Cloud Services Daemon (back / front)
./svauto.sh --packer-builder --base-os=centos7 --product=svsde --version=$SDE_VERSION --product-variant=cs-1 --ova --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME,setup_mode=cloud-services,setup_sub_option=default,pts_srvc_ip=192.168.192.150,sde_srvc_ip=192.168.192.140,spb_srvc_ip=192.168.192.130" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules;eth0_pci_id=0000:03:00.0;eth1_pci_id=0000:0b:00.0,centos-network-setup;activate_eth1=no;eth1_bootproto=static;centos_eth1_ip=192.168.192.140;centos_eth1_mask=255.255.255.128,firewalld;setup_server=svcs,nginx,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,svcs,sandvine-auto-config;setup_server=svsde,sandvine-auto-config;setup_server=svcs,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

# SVSPB on CentOS 6 + Cloud Services
./svauto.sh --packer-builder --base-os=centos6 --product=svspb --version=$SPB_VERSION --product-variant=cs-1 --ova --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,centos-network-setup;activate_eth1=no;eth1_bootproto=static;centos_eth1_ip=192.168.192.130;centos_eth1_mask=255.255.255.128,firewalld;setup_server=svspb,postgresql,svspb;spb_version=$SPB_VERSION,svmcdtext;spb_protocols_version=$SPB_PROTOCOLS_VERSION,svreports;nds_version=$NDS_VERSION,svcs-svspb,sandvine-auto-config;setup_server=svspb;setup_mode=cloud-services;setup_sub_option=default;pts_srvc_ip=192.168.192.150;sde_srvc_ip=192.168.192.140;spb_srvc_ip=192.168.192.130,vmware-tools,post-cleanup-image,power-cycle" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

# SVPTS on CentOS 7 + Cloud Services - Linux 3.10, DPDK 16.07
./svauto.sh --packer-builder --base-os=centos7 --product=svpts --version=$PTS_VERSION --product-variant=cs-1 --ova --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules;eth0_pci_id=0000:03:00.0;eth1_pci_id=0000:0b:00.0,dpdk-igb-uio-dkms,centos-network-setup;activate_eth1=no;eth1_bootproto=static;centos_eth1_ip=192.168.192.150;centos_eth1_mask=255.255.255.128,firewalld,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svnbi-base-pts;svnbi_version=$NBI_VERSION,svcs-svpts,sandvine-auto-config;setup_server=svpts;setup_mode=cloud-services;setup_sub_option=default;pts_srvc_ip=192.168.192.150;sde_srvc_ip=192.168.192.140;spb_srvc_ip=192.168.192.130;pts_set_port_control_1_1=0000:03:00.0;pts_set_port_service_1_2=0000:0b:00.0;pts_set_port_fastpath_1_3=0000:13:00.0;pts_set_port_fastpath_1_4=0000:1b:00.0,vmware-tools,post-cleanup-image" \
	--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT
