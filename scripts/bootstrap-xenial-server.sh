#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu16 --ansible-run-against="local" --ansible-remote-user="root" --ansible-inventory-builder="all,localhost,ansible_connection=local,regular_system_user=ubuntu,base_os=ubuntu16,openstack_release=newton" --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes;ubuntu_install=server,grub-conf,hyper_kvm,os_clients,post-cleanup"
