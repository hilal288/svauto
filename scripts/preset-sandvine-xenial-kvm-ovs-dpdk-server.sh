#! /bin/bash

./svauto.sh --cpu-check --hostname-check --base-os=ubuntu16 \
	--ansible-remote-user="root" \
	--ansible-inventory-builder="all,localhost,ansible_connection=local,regular_system_user=ubuntu,ubuntu_install=server,os_release=newton" \
	--ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf;enable_hugepages=yes;grub_nr_1g_pages=16,ssh_keypair,hyper_kvm,dpdk;enable_hugepages=yes;dpdk_nr_1g_pages=16;dpdk_id_1=0000:06:00.0;dpdk_driver_1=uio_pci_generic;dpdk_id_2=0000:06:00.1;dpdk_driver_2=uio_pci_generic,openvswitch;openvswitch_mode=dpdk,libvirt;pts_version=7.40.0182;sde_version=7.50.0230;spb_version=6.65.0078,os_clients,post-cleanup"
