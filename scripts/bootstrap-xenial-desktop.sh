#! /bin/bash

curl -L https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu16 --roles=bootstrap,grub-conf,hyper_kvm,hyper_virtualbox,vagrant,os_clients,scudcloud,sublime,ccollab-client,post-cleanup --extra-vars="base_os_upgrade=yes ubuntu_install=desktop"
