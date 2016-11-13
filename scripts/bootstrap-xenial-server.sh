#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=ubuntu16 --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes;ubuntu_install=server,grub-conf,hyper_kvm,openvswitch;openvswitch_mode=regular,os_clients,post-cleanup"
