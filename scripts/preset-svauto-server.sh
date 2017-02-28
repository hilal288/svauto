#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,ubuntu_install=server,os_release=ocata" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,apache2,hyper_kvm,hyper_lxd,hyper_virtualbox,docker,vagrant,amazon_ec2_tools,redhat_tools_ubuntu,os_clients,packer,vsftpd,download-images;download_group=iso,post-cleanup"
