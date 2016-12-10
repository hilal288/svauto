#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,ubuntu_install=desktop,openvswitch_mode=regular" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,openvswitch,openvswitch_bridges,hyper_kvm,dnsmasq,download-images;download_group=iso,post-cleanup"
