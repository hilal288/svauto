#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu16 --ansible-roles=bootstrap,grub-conf,hyper_kvm,hyper_virtualbox,vagrant,os_clients,google-chrome,scudcloud,sublime,ccollab-client,post-cleanup --ansible-extra-vars="base_os_upgrade=yes,ubuntu_install=desktop"
