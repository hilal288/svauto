# Requirements checks

source lib/cpu_check.sh
source lib/hostname_check.sh


# Packer build presets (TODO: move it to scripts/)

source lib/packer_build_cs_release.sh
source lib/packer_build_cs.sh
source lib/packer_build_cs_vmware.sh
source lib/packer_build_cs_lab.sh

source lib/packer_build_sandvine.sh
source lib/packer_build_sandvine_lab.sh
source lib/packer_build_sandvine_experimental.sh


# Builders

source lib/ansible_inventory_builder.sh
source lib/ansible_playbook_builder.sh
source lib/packer_builder.sh
source lib/vagrant_builder.sh
source lib/yum_repo_builder.sh


# Post Packer build helpers

source lib/mkwebrootsubdirs.sh

source lib/update_web_dir_sums.sh
source lib/update_web_dir_symlink.sh

source lib/libvirt_files.sh
source lib/libvirt_files_cs.sh

source lib/heat_templates.sh
source lib/heat_templates_cs.sh

source lib/move2webroot.sh
source lib/move2webroot_cs.sh
