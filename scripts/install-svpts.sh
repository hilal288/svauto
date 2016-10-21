#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=centos7 --ansible-roles=bootstrap,grub-conf,svpts,post-cleanup
