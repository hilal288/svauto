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

packer_build_sandvine_experimental()
{

	TSE_EXPERIMENTAL_VERSION="1.00.0041"

	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# EXPERIMENTAL
	#


        # Linux PTS on CentOS 7
#        ./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svpts --version=$PTS_EXPERIMENTAL_VERSION --product-variant=vpl-test-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--ansible-remote-user="root" \
#		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_repo=$STATIC_PACKAGES_SERVER" \
#                --ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes;svauto_yum_url=$SVAUTO_MAIN_HOST;release_code_name=$RELEASE_CODE_NAME,grub-conf,udev-rules,nginx,svpts;pts_version=$PTS_VERSION,svprotocols;pts_protocols_version=$PTS_PROTOCOLS_VERSION,vmware-tools,post-cleanup-image" \
#                --packer-max-tries=1 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# Linux SVTSE on CentOS 7
	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svtse --version=$TSE_EXPERIMENTAL_VERSION --product-variant=vpl-test-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_repo=$STATIC_PACKAGES_SERVER" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes;svauto_yum_url=$SVAUTO_MAIN_HOST;release_code_name=$RELEASE_CODE_NAME,grub-conf,udev-rules,nginx,svtse;svtse_version=$TSE_EXPERIMENTAL_VERSION,vmware-tools,post-cleanup-image" \
		--packer-max-tries=1 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# Linux SVTCP Accelerator on CentOS 7
	./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svtcpa --version=$TCPA_VERSION --product-variant=vpl-test-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-remote-user="root" \
		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_repo=$STATIC_PACKAGES_SERVER" \
		--ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes;sandvine_main_yum_repo=yes;svauto_yum_url=$SVAUTO_MAIN_HOST;release_code_name=$RELEASE_CODE_NAME,grub-conf,udev-rules,nginx,svtcpa;svtcpa_version=$TCPA_VERSION,vmware-tools,post-cleanup-image" \
		--packer-max-tries=1 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

#	# Linux NDA on Centos 7
#        ./svauto.sh --packer-builder --base-os=centos7 --release=dev --product=svnda --version=$NDA_VERSION --product-variant=vpl-test-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--ansible-remote-user=root \
#		--ansible-inventory-builder="svbox,localhost,ansible_connection=local,base_os=centos7,deployment_mode=yes,sandvine_yum_repo=$STATIC_PACKAGES_SERVER" \
#                --ansible-playbook-builder="svbox,cloud-init,bootstrap;base_os_upgrade=yes,grub-conf,udev-rules,nginx,postgresql,svnda;svnda_version=$NDA_VERSION,vmware-tools,post-cleanup-image" \
#                --packer-max-tries=1 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

}
