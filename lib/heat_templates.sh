#! /bin/bash

heat_templates()
{

       echo
       echo "Copying Sandvine's Heat Templates into tmp/sv subdirectory..."

       cp misc/os-heat-templates/sandvine-stack-0.1* tmp/sv
       cp misc/os-heat-templates/sandvine-stack-nubo-0.1* tmp/sv

       sed -i -e 's/{{pts_image}}/svpts-'$PTS_VERSION'-vpl-1-centos7-amd64/g' tmp/sv/*.yaml
       sed -i -e 's/{{sde_image}}/svsde-'$SDE_VERSION'-vpl-1-centos7-amd64/g' tmp/sv/*.yaml
       sed -i -e 's/{{spb_image}}/svspb-'$SPB_VERSION'-vpl-1-centos6-amd64/g' tmp/sv/*.yaml
       sed -i -e 's/{{csd_image}}/svcsd-'$CSD_VERSION'-isolated-svcsd-1-centos7-amd64/g' tmp/sv/*.yaml
	
}
