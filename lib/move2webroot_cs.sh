#! /bin/bash

move2webroot_cs()
{

	WEB_ROOT_CS="$WEB_ROOT_CS/$BUILD_DATE"

        echo
        echo "Moving all images created during this build, to the Web Root."


	find packer/build* -name "*.raw" -exec rm -f {} \;

	find packer/build* -name "*.sha256" -exec mv {} $WEB_ROOT_CS \;
	find packer/build* -name "*.xml" -exec mv {} $WEB_ROOT_CS \;
	find packer/build* -name "*.qcow2c" -exec mv {} $WEB_ROOT_CS \;
#	find packer/build* -name "*.vmdk" -exec mv {} $WEB_ROOT_CS \;
	find packer/build* -name "*.vhd*" -exec mv {} $WEB_ROOT_CS \;
	find packer/build* -name "*.ova" -exec mv {} $WEB_ROOT_CS \;


        if [ "$HEAT_TEMPLATES" == "cs" ]
        then

                echo
                echo "Copying Cloud Services Heat Templates into web public subdirectory..."

                cp tmp/cs/sandvine-stack-0.1-three-1.yaml $WEB_ROOT_CS/cloudservices-stack-0.1.yaml
                cp tmp/cs/sandvine-stack-0.1-three-flat-1.yaml $WEB_ROOT_CS/cloudservices-stack-0.1-flat-1.yaml
                cp tmp/cs/sandvine-stack-0.1-three-vlan-1.yaml $WEB_ROOT_CS/cloudservices-stack-0.1-vlan-1.yaml
                cp tmp/cs/sandvine-stack-0.1-three-rad-1.yaml $WEB_ROOT_CS/cloudservices-stack-0.1-rad-1.yaml
                cp tmp/cs/sandvine-stack-nubo-0.1-stock-gui-1.yaml $WEB_ROOT_CS/cloudservices-stack-nubo-0.1-stock-gui-1.yaml
                cp tmp/cs/sandvine-stack-0.1-four-1.yaml $WEB_ROOT_CS/cloudservices-stack-0.1-four-1.yaml

        fi

}
