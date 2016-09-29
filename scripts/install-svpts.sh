#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos7 --ansible-roles=bootstrap,grub-conf,svpts,post-cleanup
