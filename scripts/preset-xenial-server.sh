#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,ubuntu_install=server,os_release=ocata" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ssh_keypair,post-cleanup"
