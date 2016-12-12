#! /bin/bash

DEFAULT_NIC="eno1"

DNS_1="8.8.4.4"
DNS_1="8.8.8.8"

DPDK0_NIC="0000:06:00.0"
DPDK1_NIC="0000:06:00.1"

./svauto.sh --cpu-check --hostname-check \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,regular_system_user=ubuntu,ubuntu_install=server,os_release=newton,openvswitch_mode=dpdk" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf;enable_hugepages=yes;grub_nr_1g_pages=32,ubuntu-network-setup;ubuntu_primary_interface=$DEFAULT_NIC;ubuntu_enable_ip_masquerade=yes;ubuntu_primary_interface_via_ifupdown=yes;ubuntu_setup_dummy_nics=yes,ssh_keypair,hyper_kvm,dpdk;enable_hugepages=yes;dpdk_nr_1g_pages=32;dpdk_id_1=$DPDK0_NIC;dpdk_driver_1=uio_pci_generic;dpdk_id_2=$DPDK1_NIC;dpdk_driver_2=uio_pci_generic,openvswitch,openvswitch_bridges;openvswitch_stack_1_bridges=yes;openvswitch_net_mode=flat,dnsmasq;dns_1=$DNS_1;dns_2=$DNS_2,config-drive;vm_hostname=stack-1-pts-1,config-drive;vm_hostname=stack-1-sde-1,config-drive;vm_hostname=stack-1-spb-1,download-images;download_group=sandvine;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,libvirt;image_group=sandvine;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,os_clients,post-cleanup"
