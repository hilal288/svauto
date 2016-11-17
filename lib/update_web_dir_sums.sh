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

update_web_dir_sums()
{

	echo
	echo "Merging SHA256SUMS files together..."
	
	if pushd $WEB_ROOT_CS_LAB &>/dev/null		; then cat *.sha256 > SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
	if pushd $WEB_ROOT_CS_RELEASE &>/dev/null	; then cat *.sha256 > SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
	if pushd $WEB_ROOT_CS &>/dev/null		; then cat *.sha256 > SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
	if pushd $WEB_ROOT_STOCK_LAB &>/dev/null	; then cat *.sha256 > SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
	if pushd $WEB_ROOT_STOCK &>/dev/null		; then cat *.sha256 > SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi

}
