#! /bin/bash

curl -s https://github.com/tmartinx/svauto/raw/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos7 --ansible-remote-user="root" --ansible-inventory-builder="all,localhost,ansible_connection=local" --ansible-playbook-builder="localhost,bootstrap;base_os_upgrade=yes,grub-conf" --ansible-extra-vars="spb_service_ip=1.1.1.1,cluster_name=sandvine"
