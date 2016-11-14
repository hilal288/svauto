#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu16 --ansible-run-against="local" --ansible-remote-user="root" --ansible-inventory-builder="all,localhost,ansible_connection=local,base_os=ubuntu16" --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes;ubuntu_install=desktop,grub-conf,hyper_kvm,post-cleanup"
