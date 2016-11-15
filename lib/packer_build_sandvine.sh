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

packer_build_sandvine()
{

	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# Linux SVPTS on CentOS 7
	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_repo=$STATIC_PACKAGES_SERVER" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes;svauto_yum_url=$SVAUTO_MAIN_HOST;release_code_name=$RELEASE_CODE_NAME,grub-conf,udev-rules,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVPTS on CentOS 6 with Linux 3.18 from Xen 4.6 official repo
	./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svpts-servers,localhost,base_os=centos6,deployment_mode=yes,sandvine_yum_repo=$STATIC_PACKAGES_SERVER" \
		--ansible-playbook-builder="svpts-servers,centos-xen,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes;svauto_yum_url=$SVAUTO_MAIN_HOST;release_code_name=$RELEASE_CODE_NAME,grub-conf,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVSDE on CentOS 6
	./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="sv-box,localhost,base_os=centos6,deployment_mode=yes" \
		--ansible-playbook-builder="sv-box,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,svsde;sde_version=$SDE_VERSION;sandvine_yum_repo=$STATIC_PACKAGES_SERVER,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVSDE on CentOS 7
	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="sv-box,localhost,base_os=centos7,deployment_mode=yes" \
		--ansible-playbook-builder="sv-box,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,svsde;sde_version=$SDE_VERSION;sandvine_yum_repo=$STATIC_PACKAGES_SERVER,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVSPB on CentOS 6
	./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svspb --version=$SPB_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum --ansible-remote-user=root \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="sv-box,localhost,base_os=centos6,deployment_mode=yes" \
		--ansible-playbook-builder="sv-box,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,postgresql,svspb;spb_version=$SPB_VERSION;sandvine_yum_repo=$STATIC_PACKAGES_SERVER,vmware-tools,post-cleanup-image;setup_server=svspb,power-cycle" \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	#
	# EXPERIMENTAL
	#

	# SVTSE on CentOS 7
#	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svtse --version=$TSE_EXPERIMENTAL_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--ansible-remote-user="root" \
#		--ansible-inventory-builder="sv-box,localhost,base_os=centos7,deployment_mode=yes" \
#		--ansible-playbook-builder=svtse-servers,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,svtse;svtse_version=$SVTSE_VERSION;sandvine_yum_repo=$STATIC_PACKAGES_SERVER,vmware-tools,post-cleanup-image \
#		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# SVNDA on CentOS 7
#	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svnda --version=$SVNDA_VERSION --product-variant=vpl-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--ansible-remote-user="root" \
#		--ansible-inventory-builder="sv-box,localhost,base_os=centos7,deployment_mode=yes" \
#		--ansible-playbook-builder=svnda-servers,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,postgresql,svnda;svnda_version=$SVNDA_VERSION;sandvine_yum_repo=$STATIC_PACKAGES_SERVER,vmware-tools,post-cleanup-image \
#		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


        ./svauto.sh --heat-templates=sandvine-dev

        ./svauto.sh --libvirt-files=sandvine-dev

        ./svauto.sh --move2webroot=sandvine-dev

        ./svauto.sh --update-web-dir-sums

        ./svauto.sh --update-web-dir-symlink

}
