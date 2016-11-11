#! /bin/bash

installation_helper()
{

	echo
	echo "Creating Sandvine installation helper script (dev)..."

	cp misc/self-extract/* tmp/sv/

	echo
	pushd tmp/sv

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

	cp sandvine-helper.sh ../../$WEB_ROOT_STOCK/$BUILD_DATE

	echo
	popd

}
