#! /bin/bash

curl -s https://raw.githubusercontent.com/sandvine-eng/svauto/dev/svauto.sh | bash -s -- --svauto-deployments --base-os=ubuntu16 --ansible-roles=bootstrap,grub-conf,apache2,hyper_kvm,hyper_lxd,hyper_virtualbox,docker,vagrant,amazon_ec2_tools,redhat_tools_ubuntu,os_clients,packer,vsftpd,post-cleanup --ansible-extra-vars="disable_autoconf=yes,ubuntu_install=desktop"
