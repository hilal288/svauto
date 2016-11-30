#! /bin/bash

./svauto.sh --base-os=ubuntu16 \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,ubuntu_install=desktop" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,hyper_kvm,post-cleanup"
