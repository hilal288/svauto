#! /bin/bash

# Copyright 2016, Sandvine Incorporated.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
