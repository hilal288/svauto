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

	SVTSE_VERSION="1.00"
	SVPTS_VERSION="7.40.0123.pts_tse_dev_integration"
	SVTCPA_VERSION="5.40"
	SVNDA_VERSION="5.20"


	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# EXPERIMENTAL
	#


        # Linux SVPTS 7.40 on CentOS 7
        ./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svpts --version=$SVPTS_VERSION --product-variant=vpl-test-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
                --ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,svpts,vmware-tools,post-cleanup-image --versioned-repo \
                --packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# Linux SVTSE 1.00 on CentOS 7
	./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svtse --version=$SVTSE_VERSION --product-variant=vpl-test-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,svtse,vmware-tools,post-cleanup-image --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# Linux SVTCP Accelerator 5.40 on CentOS 7
	./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svtcpa --version=$SVTCPA_VERSION --product-variant=vpl-test-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,svtcpa,vmware-tools,post-cleanup-image --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

#	# Linux SVNDA 5.20 on Centos 7
#        ./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svnda --version=$SVNDA_VERSION --product-variant=vpl-test-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
#                --ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,postgresql,svnda,vmware-tools,post-cleanup-image --versioned-repo \
#                --packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT



	if [ "$LIBVIRT_FILES" == "yes" ]
	then

                if [ "$DRY_RUN" == "yes" ]
                then

                        echo
                        echo "Not copying Libvirt files! Skipping this step..."

                else

			echo
			echo "Copying Libvirt files for release into tmp/cs subdirectory..."

			cp misc/libvirt/* tmp/cs/

			find packer/build* -name "*.xml" -exec cp {} tmp/cs/ \;

			sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-cs-1-centos7-amd64/g' tmp/cs/libvirt-qemu.hook

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

			find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_CS \;
			find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_CS \;
			find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_CS \;
#			find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_CS \;
			find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_CS \;
			find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_CS \;


			echo
			echo "Merging SHA256SUMS files together..."

			cd $WEB_ROOT_CS

			cat *.sha256 > SHA256SUMS
			rm -f *.sha256

			cd - &>/dev/null


        	        echo
        	        echo "Updating symbolic link \"current\" to point to \"$BUILD_DATE\"..."

			cd $WEB_ROOT_CS_MAIN

			rm -f current
			ln -s $BUILD_DATE current

			cd - &>/dev/null


			# Free the way for subsequent builds:
			rm -rf packer/build*

		fi

	fi

}
