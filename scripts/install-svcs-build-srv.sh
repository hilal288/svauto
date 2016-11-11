#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos7 --ansible-playbook-builder="localhost,bootstrap:base_os_upgrade=yes,grub-conf,golang-env,nodejs-env,post-cleanup"
