#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu16 --ansible-run-against="local" --ansible-remote-user="root" --ansible-inventory-builder="all,localhost,ansible_connection=local,base_os=ubuntu16,ubuntu_install=desktop,os_release=newton" --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ubuntu-mate-desktop,ssh_keypair,hyper_kvm,hyper_virtualbox,vagrant,os_clients,google-chrome,scudcloud,sublime,ccollab-client,post-cleanup"
