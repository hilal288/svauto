
# SVAuto - The Sandvine Automation

SVAuto is a Open Source Automation Tool, it glues together a series of different tools for building immutable servers images (QCoWs, OVAs, VHDs) and for Infrastructure Automation (Servers or Desktops).

With SVAuto, you can create QCoWs, VMDKs, OVAs, and much more, with Vagrant or Packer, both with Ansible! When with Packer, it uses ISO Images as a base. Vagrant uses regular CentOS / Ubuntu boxes that are located on Atlassian host.

Also, you can deploy Sandvine's RPM Packages on top of any supported CentOS 6 or 7, be it bare-metal, Cloud-based images, regular KVM, VMWare, Xen, Hyper-V, Vagrant and etc.

Looking forward to add support for Linux Containers (LXD and Docker).

It uses the following Open Source projects:

* Ubuntu Xenial 16.04
* Ansible 2.2
* Packer 0.12.3
* QEmu 2.8
* VirtualBox 5.0
* Vagrant 1.8
* Docker 1.10
* LXD 2.0
* Amazon EC2 AMI & API Tools

It contains Ansible Playbooks for Automated deployments of:

* Ubuntu
* CentOS
* Sandvine Platform RPM Packages
* OpenStack on Ubuntu LTS

*NOTES:*

*For using Ansible against remore locations, make sure you can ssh to your instances using key authentication.*

*SVAuto was designed for Ubuntu Xenial 16.04 (latest LTS), Server or Desktop. However, many Ansible roles works on CentOS as well.*

## Downloading

Download SVAuto into your home directory (Designed for Ubuntu LTS):

    cd ~
    git clone https://github.com/tmartinx/svauto

## Bootstrapping local systems with the "Preset Scripts"

Bootstrap Ubuntu 16.04 Desktop, it upgrades and installs many useful applications, like Google Chrome, Code Collab, Atom, Skype, MatterMost, TeamViewer and etc...

    cd ~/svauto
    ./scripts/preset-xenial-desktop.sh

Bootstrap Ubuntu 16.04 Server, it upgrades and install a few applications for Servers.

    cd ~/svauto
    ./scripts/preset-xenial-server.sh

## Creating O.S. Images: QCoW, OVAs, VHD, etc 

### Bootstrapping your Ubuntu (Desktop or Server) for SVAuto

To build QCoWs/OVA images with Packer and Ansible, you have to "Bootstrap Ubuntu For SVAuto", so you can take advantage of all SVAuto's features.

NOTE: The following procedure download a few ISO images from the Internet, and store it under Libvirt's directory.

Ubuntu Desktop

    cd ~/svauto
    ./scripts/preset-svauto-desktop.sh

Ubuntu Server

    cd ~/svauto
    ./scripts/preset-svauto-server.sh

After this, you'll be able to use Packer to build O.S. Images with Ansible!

*NOTE: You can edit those small scripts and add "--dry-run" to svauto.sh line, this way, it doesn't run Ansible against your localhost, it only outputs Ansible's Inventory and Playbook files. Then, you can run "cd ~/svauto/ansible ; ansible-playbook -i ansible-hosts-XXXX ansible-playbook-XXXX.yml" later, if you want.*

#### Packer, baby steps

To make sure that your Packer installation is good and that you can actually run it and have a RAW Image in the end of the process, lets go baby steps first.

SVAuto comes with bare-minimum Packer Templates, also very minimal Kickstart and Preseed files.

Building an Ubuntu 16.04 RAW Image with just Packer:

    cd ~/svauto
    packer build packer/ubuntu16.yaml

Building a CentOS 7 RAW Image with just Packer:

    cd ~/svauto
    packer build packer/centos7.yaml

NOTE: The resulting images are created under packer/ubuntu16-tmpl or packer/centos7-tmpl or ...

#### Packer and Ansible

Those small Packer Templates tested on previous baby steps, are the base for the rest of "SVAuto Image Factory".

For example: packer/ubuntu16.yaml is the base for packer/ubuntu16-template.yaml, where the "template.yaml" is used by "svauto.sh".

SVAuto basically glues together Packer and Ansible, under temporaries subdirectories (packer/build-something), it then goes there and runs "packer build" for you.

Building an Ubuntu 16.04 QCoW (compressed) with Packer and Ansible:

    cd ~/svauto
    ./build-scripts/packer-build-ubuntu16.sh

Building a CentOS 7 QCoW (compressed) with Packer and Ansible:

    cd ~/svauto
    ./build-scripts/packer-build-centos7.sh

*NOTE: those O.S. Images have Cloud Init support and its file system grows automatically in a Cloud Environment!*

*NOTE: You can edit those small scripts and add "--dry-run" to svauto.sh line, this way, it doesn't run Packer, it only outputs the Packer template and the related Ansible's files for that Packer build. Then, you can run "cd ~/svauto ; packer build packer/build-something-XXXX-packer-files/something-packer.yaml" later, if you want.*

### Building Sandvine Product's Images

Now that we know how to build very basic CentOS and Ubuntu Images, let's extend this idea, by using more Ansible's Roles, to install more things on the O.S. Images.

*NOTE: Go to ~/svauto subdirectory to run the next commands.*

PTS on CentOS 7:

    ./build-scripts/packer-build-centos7-svpts.sh

PTS on CentOS 6:

    ./build-scripts/packer-build-centos6-svpts.sh

SDE on CentOS 7:

    ./build-scripts/packer-build-centos7-svsde.sh

SDE on CentOS 6

    ./build-scripts/packer-build-centos6-svsde.sh

SPB on CentOS 6:

    ./build-scripts/packer-build-centos6-svspb.sh

NDA on CentOS 7:

    ./build-scripts/packer-build-centos7-svnda.sh

SPB on CentOS 7:

    ./build-scripts/packer-build-centos7-svspb.sh

TCP Accelerator on CentOS 7:

    ./build-scripts/packer-build-centos7-svtcpa.sh

TSE on CentOS 7:

    ./build-scripts/packer-build-centos7-svtse.sh

### Cleaning it up

To remove the remporary files, run:

    cd ~/svauto
    ./svauto.sh --clean-all
