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

	PTS_VERSION="7.35.0032"
	SDE_VERSION="7.50.0132"
	SPB_VERSION="6.65.0078"


	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# Linux SVPTS 7.35 on CentOS 7
	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,nginx,svpts,vmware-tools,post-cleanup-image --disable-autoconf --static-repo --versioned-repo \
		--packer-max-tries=3 --setup-default-interface-script $DRY_RUN_OPT


	# Linux SVPTS 7.35 on CentOS 6 with Linux 3.18 from Xen 4.6 official repo
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--roles=centos-xen,cloud-init,bootstrap,grub-conf,nginx,svpts,vmware-tools,post-cleanup-image --disable-autoconf --static-repo --versioned-repo \
		--packer-max-tries=3 $DRY_RUN_OPT


	# Linux SVSDE 7.50 on CentOS 6
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --vmdk --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,nginx,svsde,vmware-tools,post-cleanup-image --disable-autoconf --static-repo --versioned-repo \
		--packer-max-tries=3 $DRY_RUN_OPT


	# Linux SVSDE 7.50 on CentOS 7
	./image-factory.sh --release=dev --base-os=centos7 --base-os-upgrade --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --vmd --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,nginx,svsde,vmware-tools,post-cleanup-image --disable-autoconf --static-repo --versioned-repo \
		--packer-max-tries=3 --setup-default-interface-script $DRY_RUN_OPT


	# Linux SVSPB 6.65 on CentOS 6
	./image-factory.sh --release=dev --base-os=centos6 --base-os-upgrade --product=svspb --version=$SPB_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --vmd --vhd --vm-xml --sha256sum \
		--roles=cloud-init,bootstrap,grub-conf,postgresql,svspb,vmware-tools,post-cleanup-image,power-cycle --disable-autoconf --static-repo --versioned-repo \
		--packer-max-tries=3 $DRY_RUN_OPT


	if [ "$LIBVIRT_FILES" == "yes" ]
	then

                if [ "$DRY_RUN" == "yes" ]
                then

                        echo
                        echo "Not copying Libvirt files! Skipping this step..."

                else

			echo
			echo "Copying Libvirt files for release into tmp/cs subdirectory..."

			cp misc/libvirt/* tmp/sv/

			find packer/build* -name "*.xml" -exec cp {} tmp/sv/ \;

			sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-vpl-1-centos7-amd64/g' tmp/sv/libvirt-qemu.hook

		fi

	fi


	if [ "$MOVE2WEBROOT" == "yes" ]
	then

                if [ "$DRY_RUN" == "yes" ]
                then
                        echo
                        echo "Not moving to web root! Skipping this step..."
                else

			echo
			echo "Moving all images created during this build, to the Web Root."
			echo "Also, doing some clean ups, to free the way for subsequent builds..."


			find packer/build* -name "*.raw" -exec rm -f {} \;

			find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_STOCK_LAB \;
			find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_STOCK_LAB \;
			find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_STOCK_LAB \;
			find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_STOCK_LAB \;
			find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_STOCK_LAB \;
			find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_STOCK_LAB \;


			echo
			echo "Merging SHA256SUMS files together..."

			cd $WEB_ROOT_STOCK_LAB

			cat *.sha256 > SHA256SUMS
			rm -f *.sha256

			cd - &>/dev/null


			echo
			echo "Updating symbolic link \"current\" to point to \"$BUILD_DATE\"..."

			cd $WEB_ROOT_STOCK_MAIN

			rm -f current
			ln -s $BUILD_DATE current

			cd - &>/dev/null


			# Free the way for subsequent builds:
			rm -rf packer/build*

		fi

	fi

}
