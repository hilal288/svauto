#! /bin/bash

./svauto.sh --ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,ubuntu_install=desktop,os_release=ocata" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ubuntu-desktop,ssh_keypair,hyper_kvm,openvswitch;openvswitch_mode=regular,hyper_virtualbox,vagrant,os_clients,google-chrome,mattermost,sublime,skype,teamviewer,ccollab-client,post-cleanup"
