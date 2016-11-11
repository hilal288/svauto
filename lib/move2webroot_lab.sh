#! /bin/bash

move2webroot_lab()
{

	WEB_ROOT_STOCK_LAB="$WEB_ROOT_STOCK_LAB/$BUILD_DATE"

        echo
        echo "Moving all images created during this build, to the Web Root."


        find packer/build* -name "*.raw" -exec rm -f {} \;

        find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_STOCK_LAB \;
        find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_STOCK_LAB \;
        find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_STOCK_LAB \;
        find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_STOCK_LAB \;
        find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_STOCK_LAB \;
        find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_STOCK_LAB \;

}
