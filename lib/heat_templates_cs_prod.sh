#! /bin/bash

heat_templates_cs_prod()
{

	echo
	echo "Copying Cloud Services Heat Templates for release into tmp/cs-rel subdirectory..."

	cp misc/os-heat-templates/sandvine-stack-0.1* tmp/cs-rel
	cp misc/os-heat-templates/sandvine-stack-nubo-0.1* tmp/cs-rel

	sed -i -e 's/{{pts_image}}/cs-svpts-'$SANDVINE_RELEASE'-centos7-amd64/g' tmp/cs-rel/*.yaml
	sed -i -e 's/{{sde_image}}/cs-svsde-'$SANDVINE_RELEASE'-centos7-amd64/g' tmp/cs-rel/*.yaml
	sed -i -e 's/{{spb_image}}/cs-svspb-'$SANDVINE_RELEASE'-centos6-amd64/g' tmp/cs-rel/*.yaml
	#sed -i -e 's/{{csd_image}}/cs-svcsd-'$SANDVINE_RELEASE'-centos6-amd64/g' tmp/cs-rel/*.yaml

}
