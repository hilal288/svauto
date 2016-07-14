#! /bin/bash

curl -L https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos7 --roles=bootstrap,grub-conf,svpts,post-cleanup
