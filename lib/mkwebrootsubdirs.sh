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

mkwebrootsubdirs()
{

	# Web Public directory details
	
	WEB_ROOT_STOCK_LAB=$WEB_ROOT_STOCK_MAIN/$BUILD_DATE/lab
	WEB_ROOT_STOCK_RELEASE=$WEB_ROOT_STOCK_MAIN/$BUILD_DATE/to-be-released
	WEB_ROOT_STOCK_RELEASE_LAB=$WEB_ROOT_STOCK_MAIN/$BUILD_DATE/to-be-released/lab
	
	WEB_ROOT_CS_LAB=$WEB_ROOT_CS_MAIN/$BUILD_DATE/lab
	WEB_ROOT_CS_RELEASE=$WEB_ROOT_CS_MAIN/$BUILD_DATE/to-be-released
	WEB_ROOT_CS_RELEASE_LAB=$WEB_ROOT_CS_MAIN/$BUILD_DATE/to-be-released/lab
	
	
	# Creating the Web directory structure:
	mkdir -p $WEB_ROOT_STOCK_LAB
	mkdir -p $WEB_ROOT_STOCK_RELEASE
	
	mkdir -p $WEB_ROOT_CS_LAB
	mkdir -p $WEB_ROOT_CS_RELEASE

}