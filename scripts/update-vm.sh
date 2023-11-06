#!/usr/bin/env bash

set -e -o pipefail

export REPO_ROOT=~/vm-setup
export ANSIBLE_FORCE_COLOR=true

check_ansible() {
    big_step "Checking Ansible..."
    if ansible --version > /dev/null 2>&1; then
        echo "Ansible $ANSIBLE_VERSION is already installed."
    else
        step "Installing Ansible version $ANSIBLE_VERSION"
        sudo apt update -yq
        sudo apt install ansible -yq
    fi
}

copy_repo_and_symlink_self() {
    big_step "Copying the repository into the VM..."
    if mountpoint -q /vagrant; then
        step "Copying /vagrant to $REPO_ROOT"
        sudo apt install rsync -yq
        rsync -avh --progress /vagrant/ $REPO_ROOT/ --delete --exclude-from /vagrant/.gitignore
        step "Fixing permissions..."
        chmod 0755 "$REPO_ROOT/scripts/update-vm.sh"
    else
        echo "Skipped because /vagrant is not mounted"
    fi
}

update_vm() {
    big_step "Updating the VM via Ansible..."
    cd $REPO_ROOT
    # Append extra vars and role tags if they exist
    local role_tags
    [[ -n "$ROLE_TAGS" ]] && role_tags="--tags $ROLE_TAGS"
    local extra_vars
    [[ -f "site.local.yml" ]] && extra_vars="--extra-vars @site.local.yml"

    step "Triggering the Ansible run with $role_tags and $extra_vars"
    ansible-playbook -i "localhost," -c local main.yml -vv $role_tags $extra_vars
}

big_step() {
    echo -e "\n=====================================\n>>>>>> $1\n=====================================\n"
}

step() {
    echo -e "\n\n>>>>>> $1\n-------------------------------------\n"
}

check_ansible
copy_repo_and_symlink_self
update_vm
