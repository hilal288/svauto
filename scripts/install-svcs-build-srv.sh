#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos6 --roles=bootstrap,grub-conf,golang-env,nodejs-env,post-cleanup
