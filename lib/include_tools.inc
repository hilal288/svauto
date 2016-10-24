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

source svauto.conf

source lib/os_deploy.sh

source lib/move2webroot.sh

source lib/build_yum_repo_agawa.sh
source lib/build_yum_repo_niagara.sh
source lib/build_yum_repo_yukon.sh

source lib/packer_build_cs_release.sh
source lib/packer_build_cs.sh
source lib/packer_build_cs_lab.sh

source lib/packer_build_sandvine.sh
source lib/packer_build_sandvine_lab.sh
source lib/packer_build_sandvine_experimental.sh

source lib/ansible_playbook_builder.sh

source lib/svauto_deployments.sh

source lib/image_factory.sh
