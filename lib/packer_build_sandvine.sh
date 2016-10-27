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

	PTS_VERSION="7.35.0032"
	SDE_VERSION="7.50.0132"
	SPB_VERSION="6.65.0078"
	SVNDA_VERSION="5.20.0018"

	SVTSE_VERSION_EXPERIMENTAL="1.00.0041.pts_tse_dev_integration"


	if [ "$DRY_RUN" == "yes" ]; then
		export DRY_RUN_OPT="--dry-run"
	fi


	#
	# STABLE
	#

	# Linux SVPTS 7.35 on CentOS 7
	./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,svpts,vmware-tools,post-cleanup-image --static-repo --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVPTS 7.35 on CentOS 6 with Linux 3.18 from Xen 4.6 official repo
	./svauto.sh --image-factory --release=dev --base-os=centos6 --base-os-upgrade --product=svpts --version=$PTS_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=centos-xen,cloud-init,bootstrap,grub-conf,nginx,svpts,vmware-tools,post-cleanup-image --static-repo --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVSDE 7.45 on CentOS 6
	./svauto.sh --image-factory --release=dev --base-os=centos6 --base-os-upgrade --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,nginx,svsde,vmware-tools,post-cleanup-image --static-repo --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVSDE 7.45 on CentOS 7
	./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svsde --version=$SDE_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,svsde,vmware-tools,post-cleanup-image --static-repo --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	# Linux SVSPB 6.65 on CentOS 6
	./svauto.sh --image-factory --release=dev --base-os=centos6 --base-os-upgrade --product=svspb --version=$SPB_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,nginx,postgresql,svspb,vmware-tools,post-cleanup-image,power-cycle --static-repo --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT


	#
	# EXPERIMENTAL
	#

	# SVTSE 1.00 on CentOS 7
#	./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svtse --version=$SVTSE_VERSION_EXPERIMENTAL --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
#		--ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,svtse,vmware-tools,post-cleanup-image --static-repo --versioned-repo \
#		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT

	# SVNDA 5.20 on CentOS 7
	./svauto.sh --image-factory --release=dev --base-os=centos7 --base-os-upgrade --product=svnda --version=$SVNDA_VERSION --product-variant=vpl-1 --operation=sandvine --qcow2 --ova --vhd --vm-xml --sha256sum \
		--ansible-roles=cloud-init,bootstrap,grub-conf,udev-rules,nginx,postgresql,svnda,vmware-tools,post-cleanup-image --static-repo --versioned-repo \
		--packer-max-tries=3 --packer-to-openstack --os-project=svauto $DRY_RUN_OPT



	if [ "$HEAT_TEMPLATES" == "yes" ]
	then

                if [ "$DRY_RUN" == "yes" ]
                then

                        echo
                        echo "Not copying Heat Templates! Skipping this step..."

                else

			echo
			echo "Copying Sandvine's Heat Templates into tmp/sv subdirectory..."

			cp misc/os-heat-templates/sandvine-stack-0.1* tmp/sv
			cp misc/os-heat-templates/sandvine-stack-nubo-0.1* tmp/sv

			sed -i -e 's/{{pts_image}}/svpts-'$PTS_VERSION'-vpl-1-centos7-amd64/g' tmp/sv/*.yaml
			sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-vpl-1-centos7-amd64/g' tmp/sv/*.yaml
			sed -i -e 's/{{spb_image}}/svspb-'$SPB_VERSION'-vpl-1-centos6-amd64/g' tmp/sv/*.yaml
			#sed -i -e 's/{{csd_image}}/svcsd-16.06.0013-csd-1-centos6-amd64/g' tmp/sv/*.yaml

		fi

	fi


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

			find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_STOCK \;
			find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_STOCK \;
			find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_STOCK \;
#			find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_STOCK \;
			find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_STOCK \;
			find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_STOCK \;


			echo
			echo "Merging SHA256SUMS files together..."

			cd $WEB_ROOT_STOCK

			cat *.sha256 > SHA256SUMS
			rm -f *.sha256

			cd - &>/dev/null


			echo
			echo "Updating symbolic link \"current\" to point to \"$BUILD_DATE\"..."

			cd $WEB_ROOT_STOCK_MAIN

			rm -f current
			ln -s $BUILD_DATE current

			cd - &>/dev/null


			if [ "$HEAT_TEMPLATES" == "yes" ]
			then

				echo
				echo "Copying Sandvine's Heat Templates into web public subdirectory..."

				cp tmp/sv/sandvine-stack-0.1-three-1.yaml $WEB_ROOT_STOCK/
				cp tmp/sv/sandvine-stack-0.1-three-flat-1.yaml $WEB_ROOT_STOCK/
				cp tmp/sv/sandvine-stack-0.1-three-vlan-1.yaml $WEB_ROOT_STOCK/
				cp tmp/sv/sandvine-stack-0.1-three-rad-1.yaml $WEB_ROOT_STOCK/
				cp tmp/sv/sandvine-stack-nubo-0.1-stock-gui-1.yaml $WEB_ROOT_STOCK/
				#cp tmp/sv/sandvine-stack-0.1-four-1.yaml $WEB_ROOT_STOCK/

			fi


			if [ "$INSTALLATION_HELPER" == "yes" ]
			then

				echo
				echo "Creating Sandvine installation helper script (dev)..."

				cp misc/self-extract/* tmp/sv/

				cd tmp/sv/

				tar -cf sandvine-files.tar *.yaml *.hook *.xml

				cat extract.sh sandvine-files.tar > sandvine-helper.sh_tail

				sed -i -e 's/{{sandvine_release}}/'$SANDVINE_RELEASE'/g' sandvine-helper.sh_template

				sed -i -e 's/read\ FTP_USER//g' sandvine-helper.sh_template
				sed -i -e 's/read\ \-s\ FTP_PASS//g' sandvine-helper.sh_template
				sed -i -e 's/\-\-user=\$FTP_USER\ \-\-password=\$FTP_PASS\ //g' sandvine-helper.sh_template

                                sed -i -e 's/{{svpts_image_name}}/'svpts-'$PTS_VERSION'-vpl-1-centos7-amd64'/g' sandvine-helper.sh_template
                                sed -i -e 's/{{svsde_image_name}}/'svsde-'$SDE_VERSION'-vpl-1-centos7-amd64'/g' sandvine-helper.sh_template
                                sed -i -e 's/{{svspb_image_name}}/'svspb-'$SPB_VERSION'-vpl-1-centos6-amd64'/g' sandvine-helper.sh_template

                                sed -i -e 's/{{packages_server}}/'$SVAUTO_MAIN_HOST'/g' sandvine-helper.sh_template
				sed -i -e 's/{{packages_path}}/images\/platform\/stock\/'$RELEASE_CODE_NAME'\/current/g' sandvine-helper.sh_template

				cat sandvine-helper.sh_template sandvine-helper.sh_tail > sandvine-helper.sh

				chmod +x sandvine-helper.sh

				cd - &>/dev/null

				cp tmp/sv/sandvine-helper.sh $WEB_ROOT_STOCK

			fi


			# Free the way for subsequent builds:
			rm -rf packer/build*

		fi

	fi

}
