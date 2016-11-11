#! /bin/bash

libvirt_files()
{

        echo
        echo "Copying Libvirt files for release into tmp/cs subdirectory..."

        cp misc/libvirt/* tmp/sv/

        find packer/build* -name "*.xml" -exec cp {} tmp/sv/ \;

        sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-vpl-1-centos7-amd64/g' tmp/sv/libvirt-qemu.hook
	
}
