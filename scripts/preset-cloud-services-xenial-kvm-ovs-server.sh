#! /bin/bash

DEFAULT_NIC="eno1"

DNS_1="8.8.4.4"
DNS_2="8.8.8.8"

LINUX_USER="sandvine"

./svauto.sh --cpu-check --hostname-check \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,regular_system_user=$LINUX_USER,ubuntu_install=server,os_release=newton,openvswitch_mode=regular" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf,ubuntu-network-setup;ubuntu_primary_interface=$DEFAULT_NIC;ubuntu_enable_ip_masquerade=yes;ubuntu_primary_interface_via_ifupdown=yes;ubuntu_setup_dummy_nics=yes,ssh_keypair,hyper_kvm,openvswitch,openvswitch_bridges;openvswitch_stack_1_bridges=yes,dnsmasq;dns_1=$DNS_1;dns_2=$DNS_2,config-drive;vm_hostname=stack-1-pts-1,config-drive;vm_hostname=stack-1-sde-1,config-drive;vm_hostname=stack-1-spb-1,download-images;download_group=cloud-services;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,libvirt;image_group=cloud-services;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,apache2;apache_reverse_proxy=yes;public_addr=stack-1-sde-1.sandvine.rocks;csd_fqdn_or_ip=stack-1-sde-1,os_clients,post-cleanup"
