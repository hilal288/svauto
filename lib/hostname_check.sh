#! /bin/bash

hostname_check()
{

	# Detect some of the local settings:
	WHOAMI=$(whoami)
	UBUNTU_HOSTNAME=$(hostname)
	FQDN=$(hostname -f)
	DOMAIN=$(hostname -d)


	# If the hostname and hosts file aren't configured according, abort.
	if [ -z $UBUNTU_HOSTNAME ]; then
		echo "Hostname not found... Configure the file /etc/hostname with your hostname. ABORTING!"

		exit 1
	fi

	if [ -z $DOMAIN ]; then
		echo "Domain not found... Configure the file /etc/hosts with your \"IP + FQDN + HOSTNAME\". ABORTING!"

		exit 1
	fi

	if [ -z $FQDN ]; then
		echo "FQDN not found... Configure your /etc/hosts according. ABORTING!"

		exit 1
	fi


	# Display local configuration
	echo
	echo "The detected local configuration are:"
	echo
	echo -e "* Username:"'\t'$WHOAMI
	echo -e "* Hostname:"'\t'$UBUNTU_HOSTNAME
	echo -e "* FQDN:"'\t''\t'$FQDN
	echo -e "* Domain:"'\t'$DOMAIN

}
