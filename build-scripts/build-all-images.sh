#! /bin/bash

# Begin
./svauto.sh --make-public-web-dir

# Sandvine plus Cloud Services
./build-scripts/packer-build-cs.sh
./svauto.sh --move2webroot=cs-dev

./build-scripts/packer-build-cs-vmware.sh 
./svauto.sh --move2webroot=cs-dev

# For testing
./build-scripts/packer-build-cs-lab.sh
./svauto.sh --move2webroot=cs-dev-lab

# Sandvile plus Cloud Services to release
./build-scripts/packer-build-cs-release.sh
./svauto.sh --move2webroot=cs-prod

# Sandvine Production-Ready Images (but not released)
./build-scripts/packer-build-centos7-svpts.sh
./build-scripts/packer-build-centos7-svsde.sh
./build-scripts/packer-build-centos7-svtse.sh
./build-scripts/packer-build-centos7-svnda.sh
./build-scripts/packer-build-centos7-svtcpa.sh

./build-scripts/packer-build-centos7-svspb.sh

./build-scripts/packer-build-centos6-svpts.sh
./build-scripts/packer-build-centos6-svsde.sh
./build-scripts/packer-build-centos6-svspb.sh

./svauto.sh --move2webroot=sandvine-dev

# For testing
./build-scripts/packer-build-sandvine-lab.sh
./svauto.sh --move2webroot=sandvine-dev-lab

# End
./svauto.sh --update-web-dir-sha256sums
./svauto.sh --update-web-dir-symlink
./svauto.sh --clean-all
