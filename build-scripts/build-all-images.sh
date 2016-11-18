#! /bin/bash

# Begin
./svauto.sh --make-public-web-dir

# Sandvine Production-Ready Images (but not released)
./build-scripts/packer-build-sandvine.sh
./svauto.sh --move2webroot=sandvine-dev
./svauto.sh --clean-all

# For testing
./build-scripts/packer-build-sandvine-lab.sh
./svauto.sh --move2webroot=sandvine-dev-lab
./svauto.sh --clean-all

# Sandvine plus Cloud Services
./build-scripts/packer-build-cs.sh
./build-scripts/packer-build-cs-vmware.sh 
./svauto.sh --move2webroot=cs-dev
./svauto.sh --clean-all

# For testing
./build-scripts/packer-build-cs-lab.sh
./svauto.sh --move2webroot=cs-dev-lab
./svauto.sh --clean-all

# Sandvile plus Cloud Services to release
./build-scripts/packer-build-cs-release.sh
./svauto.sh --move2webroot=cs-prod
./svauto.sh --clean-all

# End
./svauto.sh --update-web-dir-sha256sums
./svauto.sh --update-web-dir-symlink
