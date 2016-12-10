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

# SDE on CentOS 7 + Cloud Services SDE + Cloud Services Daemon (back / front) - Labified
./svauto.sh --packer-builder --release=dev --base-os=centos7 --product=svsde --version=$SDE_VERSION --product-variant=cs-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME,setup_mode=cloud-services,setup_sub_option=default,pts_srvc_ip=192.168.192.150,sde_srvc_ip=192.168.192.140,spb_srvc_ip=192.168.192.130" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,centos-network-setup;activate_eth1=no;centos_eth1_onboot=no,setup-default-interface,nginx,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,svcs,sandvine-auto-config;setup_server=svsde,sandvine-auto-config;setup_server=svcs,vmware-tools,labify,post-cleanup-image" \
	--packer-max-tries=3 $DRY_RUN_OPT

# SPB on CentOS 6 + Cloud Services - Labified
./svauto.sh --packer-builder --release=dev --base-os=centos6 --product=svspb --version=$SPB_VERSION --product-variant=cs-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,centos-network-setup;activate_eth1=no;centos_eth1_onboot=no,postgresql,svspb;spb_version=$SPB_VERSION,svmcdtext;spb_protocols_version=$SPB_PROTOCOLS_VERSION,svreports;nds_version=$NDS_VERSION,svcs-svspb,sandvine-auto-config;setup_server=svspb;setup_mode=cloud-services;setup_sub_option=default;pts_srvc_ip=192.168.192.150;sde_srvc_ip=192.168.192.140;spb_srvc_ip=192.168.192.130,vmware-tools,labify,post-cleanup-image,power-cycle" \
	--packer-max-tries=3 $DRY_RUN_OPT

# PTS on CentOS 7 + Cloud Services - Linux 3.10, DPDK 16.07, requires igb_uio - Labified
./svauto.sh --packer-builder --release=dev --base-os=centos7 --product=svpts --version=$PTS_VERSION --product-variant=cs-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="svbox,localhost,is_packer=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
	--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,centos-network-setup;activate_eth1=no;centos_eth1_onboot=no,setup-default-interface,dpdk-igb-uio-dkms,nginx,svpts;pts_version=$PTS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svnbi-base-pts;svnbi_version=$NBI_VERSION,svcs-svpts,sandvine-auto-config;setup_server=svpts;setup_mode=cloud-services;setup_sub_option=default;pts_srvc_ip=192.168.192.150;sde_srvc_ip=192.168.192.140;spb_srvc_ip=192.168.192.130,vmware-tools,labify;setup_mode=cloud-services,post-cleanup-image" \
	--packer-max-tries=3 $DRY_RUN_OPT
