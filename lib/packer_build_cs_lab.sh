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

packer_build_cs_lab()
{

	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# SDE 7.50 on CentOS 7 + Cloud Services SDE + Cloud Services Daemon (back / front) - Labified
	./svauto.sh --packer-builder --release=dev --base-os=centos7 --product=svsde --version=$SDE_VERSION --product-variant=cs-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,static_packages_server=$STATIC_PACKAGES_SERVER,static_repo=true,versioned_repo=true" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap,grub-conf,setup-default-interface,nginx,svsde,svusagemanagement,svsubscribermapping,svcs-svsde,svcs,vmware-tools,labify,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT

	# SPB 6.65 on CentOS 6 + Cloud Services - Labified
	./svauto.sh --packer-builder --release=dev --base-os=centos6 --product=svspb --version=$SPB_VERSION --product-variant=cs-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos6,deployment_mode=yes,static_packages_server=$STATIC_PACKAGES_SERVER,static_repo=true,versioned_repo=true" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap,grub-conf,postgresql,svspb,svmcdtext,svreports,svcs-svspb,vmware-tools,labify,post-cleanup-image,power-cycle" \
		--packer-max-tries=3 $DRY_RUN_OPT

	# PTS 7.35 on CentOS 7 + Cloud Services - Linux 3.10, DPDK 16.07, requires igb_uio - Labified
	./svauto.sh --packer-builder --release=dev --base-os=centos7 --product=svpts --version=$PTS_VERSION --product-variant=cs-1 --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,static_packages_server=$STATIC_PACKAGES_SERVER,static_repo=true,versioned_repo=true" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap,grub-conf,setup-default-interface,nginx,svpts,svusagemanagementpts,svcs-svpts,vmware-tools,labify;setup_mode=cloud-services,post-cleanup-image" \
		--packer-max-tries=3 $DRY_RUN_OPT


        ./svauto.sh --libvirt-files=cs-dev-lab

        # ./svauto.sh --move2webroot=cs-dev-lab

}
