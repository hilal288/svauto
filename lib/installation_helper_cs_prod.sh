#! /bin/bash

installation_helper_cs_prod()
{

	echo
	echo "Creating Cloud Services installation helper script..."

	cp misc/self-extract/* tmp/cs-rel/

	echo
	pushd tmp/cs-rel

	mv sandvine-stack-0.1-three-1.yaml cloudservices-stack-$SANDVINE_RELEASE-1.yaml
	mv sandvine-stack-0.1-three-flat-1.yaml cloudservices-stack-$SANDVINE_RELEASE-flat-1.yaml
	mv sandvine-stack-0.1-three-vlan-1.yaml cloudservices-stack-$SANDVINE_RELEASE-vlan-1.yaml
	mv sandvine-stack-0.1-three-rad-1.yaml cloudservices-stack-$SANDVINE_RELEASE-rad-1.yaml
	mv sandvine-stack-nubo-0.1-stock-gui-1.yaml cloudservices-stack-nubo-$SANDVINE_RELEASE-stock-gui-1.yaml
	#mv sandvine-stack-0.1-four-1.yaml cloudservices-stack-$SANDVINE_RELEASE-four-1.yaml

	rm sandvine-stack-0.1-four-1.yaml

	mv libvirt-qemu.hook cs-svsde-$SANDVINE_RELEASE-centos7-amd64.hook

	tar -cf sandvine-files.tar *.yaml *.hook *.xml

	cat extract.sh sandvine-files.tar > sandvine-helper.sh_tail

	sed -i -e 's/{{sandvine_release}}/'$SANDVINE_RELEASE'/g' sandvine-helper.sh_template

	sed -i -e 's/{{svpts_image_name}}/'cs-svpts-\\$RELEASE-centos7-amd64'/g' sandvine-helper.sh_template
	sed -i -e 's/{{svsde_image_name}}/'cs-svsde-\\$RELEASE-centos7-amd64'/g' sandvine-helper.sh_template
	sed -i -e 's/{{svspb_image_name}}/'cs-svspb-\\$RELEASE-centos6-amd64'/g' sandvine-helper.sh_template

	sed -i -e 's/{{packages_server}}/'$PUBLIC_PACKAGES_SERVER'/g' sandvine-helper.sh_template
	sed -i -e 's/{{packages_path}}/release\/CloudServices\/\$RELEASE/g' sandvine-helper.sh_template

	cat sandvine-helper.sh_template sandvine-helper.sh_tail > cloudservices-helper.sh

	chmod +x cloudservices-helper.sh

	cp cloudservices-helper.sh ../../$WEB_ROOT_CS_RELEASE/$BUILD_DATE

	echo
	popd

}
