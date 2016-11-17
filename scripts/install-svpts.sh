#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/scripts/svauto-deployments.sh | bash -s -- --base-os=centos7 --ansible-remote-user="root" --ansible-inventory-builder="all,localhost,ansible_connection=local,base_os=centos7" --ansible-playbook-builder="localhost,bootstrap,grub-conf,svpts,post-cleanup"
