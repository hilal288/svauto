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

packer_build_sandvine_lab()
{

	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# Linux SVPTS 7.35 on CentOS 7
	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,setup-default-interface,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS,vmware-tools,labify;setup_server=svpts,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT


	# Linux SVPTS 7.35 on CentOS 6 with Linux 3.18 from Xen 4.6 official repo
	./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,centos-xen,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS,labify;setup_server=svpts,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT


	# Linux SVSDE 7.50 on CentOS 6
	./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,nginx,svsde;sde_version=$SDE_VERSION,labify,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT


	# Linux SVSDE 7.50 on CentOS 7
	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --qcow2 --vmd --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,setup-default-interface,nginx,svsde;sde_version=$SDE_VERSION,labify,vmware-tools,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT


	# Linux SVSPB 6.65 on CentOS 6
	./svauto.sh --packer-builder --base-os=centos6 --release=dev --product=svspb --version=$SPB_VERSION --product-variant=vpl-1 --qcow2 --vmd --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,sandvine_yum_host=$SV_YUM_HOST" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,postgresql,svspb;spb_version=$SPB_VERSION,labify,vmware-tools,post-cleanup-image;setup_server=svspb,power-cycle" \
		--packer-max-tries=3 $DRY_RUN_OPT


	./svauto.sh --libvirt-files=sandvine-dev-lab

	./svauto.sh --move2webroot=sandvine-dev-lab

        ./svauto.sh --update-web-dir-sums

        ./svauto.sh --update-web-dir-symlink

}
