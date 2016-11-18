# Requirements checks

source lib/cpu_check.sh
source lib/hostname_check.sh


# Builders

source lib/ansible_inventory_builder.sh
source lib/ansible_playbook_builder.sh
source lib/packer_builder.sh
source lib/vagrant_builder.sh
source lib/yum_repo_builder.sh


# Post Packer build helpers

source lib/mkwebrootsubdirs.sh

source lib/update_web_dir_sha256sums.sh
source lib/update_web_dir_symlink.sh

source lib/libvirt_files.sh
source lib/libvirt_files_cs.sh

source lib/heat_templates.sh
source lib/heat_templates_cs.sh

source lib/move2webroot.sh
source lib/move2webroot_cs.sh
source lib/move2webroot_cs_lab.sh
