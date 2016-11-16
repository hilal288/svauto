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

packer_build_cs_release()
{

        if [ "$DRY_RUN" == "yes" ]
        then
                echo
                echo "Not requesting FTP account details on dry run! Skipping this step..."

                export DRY_RUN_OPT="--dry-run"
        else
		echo
		echo "Enter your Sandvine's FTP (ftp.support.sandvine.com) account details:"
		echo
		echo -n "Username: "
		read FTP_USER
		echo -n "Password: "
		read -s FTP_PASS

        	sed -i -e 's/ftp_username:.*/ftp_username: '$FTP_USER'/g' ansible/group_vars/all
        	sed -i -e 's/ftp_password:.*/ftp_password: '$FTP_PASS'/g' ansible/group_vars/all
	fi


	#
	# Production ready images for being released to the public
	#

	# SDE on CentOS 6 + Cloud Services SDE + Cloud Services Daemon (back / front)
	./svauto.sh --packer-builder --release=prod --base-os=centos6 --product=cs-svsde --version=$SANDVINE_RELEASE --qcow2 --ova --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,base-os-auto-config,centos-network-setup,centos-firewall-setup,svsde;sde_version=$SDE_VERSION,svusagemanagement;um_version=$UM_VERSION,svsubscribermapping;sm_version=$SM_C7_VERSION,svcs-svsde,svcs,sandvine-auto-config;setup_mode=cloud-services;setup_sub_option=default,vmware-tools,cleanrepo,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT

	# SPB on CentOS 6 + Cloud Services customizations
	./svauto.sh --packer-builder --release=prod --base-os=centos6 --product=cs-svspb --version=$SANDVINE_RELEASE --qcow2 --ova --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,base-os-auto-config,centos-network-setup,centos-firewall-setup,postgresql,svspb;spb_version=$SPB_VERSION,svmcdtext;spb_protocols_version=$SPB_PROTOCOLS_VERSION,svreports;nds_version=$NDS_VERSION,svcs-svspb,sandvine-auto-config;setup_mode=cloud-services;setup_sub_option=default,vmware-tools,cleanrepo,post-cleanup-image,power-cycle" \
		--packer-max-tries=3 $DRY_RUN_OPT

	# PTS on CentOS 7 + Cloud Services customizations
	./svauto.sh --packer-builder --release=prod --base-os=centos7 --product=cs-svpts --version=$SANDVINE_RELEASE --qcow2 --ova --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes,grub-conf,udev-rules,base-os-auto-config,centos-network-setup,centos-firewall-setup,svpts;pts_version=$PTS_VERSION,svusagemanagementpts;um_version=$UM_VERSION,svcs-svpts,sandvine-auto-config;setup_mode=cloud-services;setup_sub_option=default,vmware-tools,cleanrepo,post-cleanup-image" \
		--lock-el7-kernel-upgrade --packer-max-tries=3 $DRY_RUN_OPT


        ./svauto.sh --heat-templates=cs-prod

        ./svauto.sh --libvirt-files=cs-prod

        ./svauto.sh --move2webroot=cs-prod

        ./svauto.sh --update-web-dir-sums

        ./svauto.sh --update-web-dir-symlink


}
