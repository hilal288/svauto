#! /bin/bash

move2webroot_cs_prod()
{

	WEB_ROOT_CS_RELEASE="$WEB_ROOT_CS_RELEASE/$BUILD_DATE"

        echo
        echo "Moving all images created during this build, to the Web Root."


        find packer/build* -name "*.raw" -exec rm -f {} \;

        find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_CS_RELEASE \;
        find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_CS_RELEASE \;
        find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_CS_RELEASE \;
        find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_CS_RELEASE \;
        find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_CS_RELEASE \;
        find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_CS_RELEASE \;


        if [ "$HEAT_TEMPLATES" == "cs" ]
        then

                echo
                echo "Copying Cloud Services Heat Templates for release into public web subdirectory..."

                cp tmp/cs-rel/sandvine-stack-0.1-three-1.yaml $WEB_ROOT_CS_RELEASE/cloudservices-stack-$SANDVINE_RELEASE-1.yaml
                cp tmp/cs-rel/sandvine-stack-0.1-three-flat-1.yaml $WEB_ROOT_CS_RELEASE/cloudservices-stack-$SANDVINE_RELEASE-flat-1.yaml
                cp tmp/cs-rel/sandvine-stack-0.1-three-vlan-1.yaml $WEB_ROOT_CS_RELEASE/cloudservices-stack-$SANDVINE_RELEASE-vlan-1.yaml
                cp tmp/cs-rel/sandvine-stack-0.1-three-rad-1.yaml $WEB_ROOT_CS_RELEASE/cloudservices-stack-$SANDVINE_RELEASE-rad-1.yaml
                cp tmp/cs-rel/sandvine-stack-nubo-0.1-stock-gui-1.yaml $WEB_ROOT_CS_RELEASE/cloudservices-stack-nubo-$SANDVINE_RELEASE-stock-gui-1.yaml
                #cp tmp/cs-rel/sandvine-stack-0.1-four-1.yaml $WEB_ROOT_CS_RELEASE/cloudservices-stack-$SANDVINE_RELEASE-micro-1.yaml

        fi

}
