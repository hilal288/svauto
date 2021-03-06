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

# NA
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svnda --latest

# TSE
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svtse --latest

# TCP Accelerator
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svtcpa --latest

# PTS
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svpts --latest
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svprotocols --latest

# Usage Management PTS
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svusagemanagementpts --latest

# Experimental
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svpts --latest
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svprotocols --latest
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svusagemanagementpts --latest

# SDE
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svsde --latest
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svsde --latest

# Usage Management
./svauto.sh --yum-repo-builder --base-os=centos7 --product=svusagemanagement --latest
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svusagemanagement --latest

# Subscriber Mapping
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svsubscribermapping --latest
./svauto.sh --yum-repo-builder --base-os=centos7 --product=subscriber_mapping --latest

# SPB
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svspb --latest

# SVMCDTEXT (Protocols)
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svmcdtext --latest

# NDS
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svreports --latest

# Control Center
./svauto.sh --yum-repo-builder --base-os=centos6 --product=svcontrol-center --latest
