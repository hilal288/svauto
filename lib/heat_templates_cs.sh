#! /bin/bash

heat_templates_cs()
{

	echo
	echo "Copying Cloud Services Heat Templates into tmp/cs subdirectory..."

	cp misc/os-heat-templates/sandvine-stack-0.1* tmp/cs
	cp misc/os-heat-templates/sandvine-stack-nubo-0.1* tmp/cs

	sed -i -e 's/{{pts_image}}/svpts-'$PTS_VERSION'-cs-1-centos7-amd64/g' tmp/cs/*.yaml
	sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-cs-1-centos7-amd64/g' tmp/cs/*.yaml
	sed -i -e 's/{{spb_image}}/svspb-'$SPB_VERSION'-cs-1-centos6-amd64/g' tmp/cs/*.yaml
	sed -i -e 's/{{csd_image}}/svcsd-'$CSD_VERSION'-isolated-svcsd-1-centos7-amd64/g' tmp/cs/*.yaml

}
