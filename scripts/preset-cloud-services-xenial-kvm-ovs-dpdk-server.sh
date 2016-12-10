#! /bin/bash

./svauto.sh --cpu-check --hostname-check \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,regular_system_user=ubuntu,ubuntu_install=server,os_release=newton,openvswitch_mode=dpdk" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf;enable_hugepages=yes;grub_nr_1g_pages=32,ssh_keypair,hyper_kvm,dpdk;enable_hugepages=yes;dpdk_nr_1g_pages=32;dpdk_id_1=0000:06:00.0;dpdk_driver_1=uio_pci_generic;dpdk_id_2=0000:06:00.1;dpdk_driver_2=uio_pci_generic,openvswitch,openvswitch_bridges;openvswitch_stack_1_bridges=yes;openvswitch_net_mode=flat,dnsmasq;dns_1=8.8.4.4;dns_2=8.8.8.8,config-drive;vm_hostname=stack-1-pts-1,config-drive;vm_hostname=stack-1-sde-1,config-drive;vm_hostname=stack-1-spb-1,download-images;download_group=cloud-services;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,libvirt;image_group=cloud-services;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,apache2;apache_reverse_proxy=yes;public_addr=stack-1-sde-1.sandvine.rocks;csd_fqdn_or_ip=stack-1-sde-1,os_clients,post-cleanup"
