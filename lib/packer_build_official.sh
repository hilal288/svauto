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

packer_build_official()
{

	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# PTS 7.30 on CentOS 7 - Linux 3.10, DPDK 16.07, requires igb_uio
	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svpts --version=7.30 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,svpts,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --operation=sandvine \
		--packer-max-tries=3

	# SDE 7.45 on CentOS 7
	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svsde --version=7.45 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,svsde,svusagemanagement,svsubscribermapping,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --operation=sandvine \
		--packer-max-tries=3

       	# SDE 7.45 on CentOS 6
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svsde --version=7.45 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,svsde,svusagemanagement,svsubscribermapping,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --operation=sandvine \
		--packer-max-tries=3

	# SPB 6.65 on CentOS 6 - No NDS
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svspb --version=6.65 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,svspb,sandvine-auto-config,vmware-tools,post-cleanup-image,power-cycle $DRY_RUN_OPT --operation=sandvine \
		--packer-max-tries=3


	#
	# EXPERIMENTAL
	#

	# PTS 7.30 on CentOS 6 - Linux 3.18 from Xen 4.6 Repo + DPDK 16.04 with Xen Support, no igb_uio needed
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svpts --version=7.30 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=centos-xen,cloud-init,bootstrap,grub-conf,svpts,vmware-tools,post-cleanup-image $DRY_RUN_OPT --operation=sandvine \
		--packer-max-tries=3


	# PTS 7.40 on CentOS 6 - Linux 2.6, old DPDK 1.8, requires igb_uio
#	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svpts --version=7.40 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--roles=cloud-init,bootstrap,grub-conf,svpts,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --versioned-repo --operation=sandvine

	# PTS 7.40 on CentOS 7 - Linux 3.10, DPDK 16.07, requires igb_uio
	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svpts --version=7.40 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,svpts,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --versioned-repo --operation=sandvine \
		--packer-max-tries=3

	# PTS 7.40 on CentOS 6 - Linux 3.18 from Xen 4.6 Repo + DPDK 16.07 with Xen Support, no igb_uio needed
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svpts --version=7.40 --product-variant=xen-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=centos-xen,cloud-init,bootstrap,grub-conf,svpts,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --versioned-repo --operation=sandvine \
		--packer-max-tries=3

	# PTS 7.40 on CentOS 7 - Linux 3.18 from Xen 4.6 Repo + DPDK 16.04 with Xen Support, no igb_uio needed
#	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svpts --version=7.40 --product-variant=xen-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--roles=centos-xen,cloud-init,bootstrap,grub-conf,svpts,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --versioned-repo --experimental-repo --operation=sandvine


	# SDE 7.45 on CentOS 6 - Linux 3.18
#	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svsde --version=7.45 --product-variant=xen-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--roles=centos-xen,cloud-init,bootstrap,grub-conf,svsde,svusagemanagement,svsubscribermapping,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --operation=sandvine

	# SDE 7.45 on CentOS 7 - Linux 3.18
#	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svsde --version=7.45 --product-variant=xen-1 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--roles=centos-xen,cloud-init,bootstrap,grub-conf,svsde,svusagemanagement,svsubscribermapping,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --operation=sandvine

	# SDE 7.45 on CentOS 7
#	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svsde --version=7.45 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--roles=centos-xen,cloud-init,bootstrap,grub-conf,svsde,svusagemanagement,svsubscribermapping,sandvine-auto-config,vmware-tools,post-cleanup-image --versioned-repo $DRY_RUN_OPT --operation=sandvine

       	# SDE 7.45 on CentOS 6
#	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svsde --version=7.45 --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--roles=cloud-init,bootstrap,grub-conf,svsde,svusagemanagement,svsubscribermapping,sandvine-auto-config,vmware-tools,post-cleanup-image --versioned-repo $DRY_RUN_OPT --operation=sandvine


	# SPB 7.00 on CentOS 6 - No NDS
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svspb --version=7.00 --qcow2 --ova --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,svspb,sandvine-auto-config,vmware-tools,post-cleanup-image $DRY_RUN_OPT --versioned-repo --operation=sandvine \
		--packer-max-tries=3

}
