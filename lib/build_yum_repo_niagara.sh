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

build_yum_repo_niagara()
{

	#
	# PTS stuff
	#

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svpts --version=7.30.0431 --latest
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svprotocols --version=16.06.2130 --latest

	# Usage Management PTS

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svusagemanagementpts --version=5.20.0201 --latest

	# Experimental

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svpts --version=7.30.0431 --latest
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svprotocols --version=16.06.2130 --latest

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svusagemanagementpts --version=5.20.0201 --latest

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svpts --version=7.40.0052 --latest-of-serie
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svpts --version=7.40.0052 --latest-of-serie


	#
	# SDE stuff
	#

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svsde --version=7.45.0305 --latest
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svsde --version=7.45.0305 --latest

	# Usage Management

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svusagemanagement --version=5.20.0201 --latest
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svusagemanagement --version=5.20.0201 --latest

	# Subscriber Mapping

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svsubscribermapping --version=7.45.0003 --latest
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=subscriber_mapping --version=7.45-0003 --latest

	# Experimental

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos7 --product=svsde --version=7.50.0052 --latest-of-serie
	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svsde --version=7.50.0052 --latest-of-serie


	#
	# SPB stuff
	#

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svspb --version=6.65.0019 --latest

	# NDS

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svreports --version=6.65.0005 --latest


	# Experimental

	./svauto.sh --yum-repo-builder --release-code-name=niagara --release=dev --base-os=centos6 --product=svspb --version=7.00.0044 --latest-of-serie

}
