#! /bin/bash

libvirt_files_cs()
{

	echo
	echo "Copying Libvirt files for release into tmp/cs subdirectory..."

	cp misc/libvirt/* tmp/cs/

	find packer/build* -name "*.xml" -exec cp {} tmp/cs/ \;

	sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-cs-1-centos7-amd64/g' tmp/cs/libvirt-qemu.hook

}
