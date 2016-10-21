#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=centos6 --ansible-roles=svrad-pts
