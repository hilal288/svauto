#! /bin/bash

move2webroot()
{

	WEB_ROOT_STOCK="$WEB_ROOT_STOCK/$BUILD_DATE"

        echo
        echo "Moving all images created during this build, to the Web Root."


        find packer/build* -name "*.raw" -exec rm -f {} \;

	find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_STOCK \;
	find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_STOCK \;


        if [ "$HEAT_TEMPLATES" == "yes" ]
        then

                echo
                echo "Copying Sandvine's Heat Templates into web public subdirectory..."

                cp tmp/sv/sandvine-stack-*.yaml $WEB_ROOT_STOCK/

        fi

}
