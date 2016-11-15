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

packer_build_cs()
{

	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# SVSDE on CentOS 7 + Cloud Services SDE + Cloud Services Daemon (back / front)
	./svauto.sh --packer-builder --base-os=centos7 --product=svsde --version=$SDE_VERSION --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,nginx,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,svcs,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# SVSDE on CentOS 6 + Cloud Services SDE + Cloud Services Daemon (back / front)
	./svauto.sh --packer-builder --base-os=centos6 --product=svsde --version=$SDE_VERSION --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,nginx,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C6_VERSION,svcs-svsde,svcs,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# SVSPB on CentOS 6 + Cloud Services
	./svauto.sh --packer-builder --base-os=centos6 --product=svspb --version=$SPB_VERSION --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,postgresql,svspb;spb_version=$SPB_VERSION,svmcdtext;spb_protocols_version=$SPB_PROTOCOLS_VERSION,svreports;nds_version=$NDS_VERSION,svcs-svspb,vmware-tools,post-cleanup-image,power-cycle" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# SVPTS on CentOS 7 + Cloud Services - Linux 3.10, DPDK 16.07
	./svauto.sh --packer-builder --base-os=centos7 --product=svpts --version=$PTS_VERSION --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svcs-svpts,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# SVSDE on CentOS 7 + Cloud Services SDE only - No Cloud Services daemon here
	./svauto.sh --packer-builder --base-os=centos7 --product=svsde --version=$SDE_VERSION --product-variant=isolated-svsde-cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,nginx,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# Cloud Services Daemon (back / front) on CentOS 7 - No SDE here
	./svauto.sh --packer-builder --base-os=centos7 --product=svcsd --version=$CSD_VERSION --product-variant=isolated-svcsd-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,nginx,svcs,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	#
	# Experimental builds
	#

	# SVPTS on CentOS 6 + Cloud Services - Linux 3.18 from Xen 4.6 official repo, DPDK 16.04, don't requires igb_uio
	./svauto.sh --packer-builder --base-os=centos6 --product=svpts --version=$PTS_VERSION --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST,svauto_yum_host=$SVAUTO_YUM_HOST,release_code_name=$RELEASE_CODE_NAME" \
		--ansible-playbook-builder="svbox,centos-xen,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svcs-svpts,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	#
	# BUILD ENVIRONMENT
	#

	# Cloud Services Build Server (back / front) on CentOS 6 (old Golang 1.5)
	./svauto.sh --packer-builder --base-os=centos6 --product=devops --version=6 --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes" \
	        --ansible-playbook-builder="svbox,centos-xen,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,golang-env,nodejs-env,ccollab-client,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# Cloud Services Build Server (back / front) on CentOS 7 (new Golang 1.6)
	./svauto.sh --packer-builder --base-os=centos7 --product=devops --version=7 --product-variant=cs-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes" \
	        --ansible-playbook-builder="svbox,centos-xen,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,base-os-auto-config,centos-network-setup;activate_eth1=no,centos-firewall-setup,golang-env,nodejs-env,ccollab-client,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


        ./svauto.sh --heat-templates=cs-dev

        ./svauto.sh --libvirt-files=cs-dev

        ./svauto.sh --move2webroot=cs-dev

        ./svauto.sh --update-web-dir-sums

        ./svauto.sh --update-web-dir-symlink

}
