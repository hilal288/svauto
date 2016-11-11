#! /bin/bash

installation_helper_cs()
{

	echo
	echo "Creating Cloud Services installation helper script (dev)..."

	cp misc/self-extract/* tmp/cs/

	echo
	pushd tmp/cs

	tar -cf sandvine-files.tar *.yaml *.hook *.xml

	cat extract.sh sandvine-files.tar > sandvine-helper.sh_tail

	sed -i -e 's/{{sandvine_release}}/'$SANDVINE_RELEASE'/g' sandvine-helper.sh_template

	sed -i -e 's/read\ FTP_USER//g' sandvine-helper.sh_template
	sed -i -e 's/read\ \-s\ FTP_PASS//g' sandvine-helper.sh_template
	sed -i -e 's/\-\-user=\$FTP_USER\ \-\-password=\$FTP_PASS\ //g' sandvine-helper.sh_template

	sed -i -e 's/{{svpts_image_name}}/'svpts-'$PTS_VERSION'-cs-1-centos7-amd64'/g' sandvine-helper.sh_template
	sed -i -e 's/{{svsde_image_name}}/'svsde-'$SDE_VERSION'-cs-1-centos7-amd64'/g' sandvine-helper.sh_template
	sed -i -e 's/{{svspb_image_name}}/'svspb-'$SPB_VERSION'-cs-1-centos6-amd64'/g' sandvine-helper.sh_template

	sed -i -e 's/{{packages_server}}/'$SVAUTO_MAIN_HOST'/g' sandvine-helper.sh_template
	sed -i -e 's/{{packages_path}}/images\/platform\/cloud-services\/'$RELEASE_CODE_NAME'\/current/g' sandvine-helper.sh_template

	cat sandvine-helper.sh_template sandvine-helper.sh_tail > sandvine-cs-helper.sh

	chmod +x sandvine-cs-helper.sh

	cp sandvine-cs-helper.sh ../../$WEB_ROOT_CS/$BUILD_DATE

	echo
	popd

}
