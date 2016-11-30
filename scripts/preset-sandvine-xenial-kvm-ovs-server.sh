#! /bin/bash

./svauto.sh --cpu-check --hostname-check --base-os=ubuntu16 \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,regular_system_user=ubuntu,ubuntu_install=server,os_release=newton" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ssh_keypair,hyper_kvm,openvswitch;openvswitch_mode=regular,libvirt;pts_version=7.40.0164;sde_version=7.50.0230;spb_version=6.65.0078,os_clients,post-cleanup"
