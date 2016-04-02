#!/bin/bash
ANSIBLE_MIN_VER=2.0.1.0
ANSIBLE_STATUS=1

# Environment sanitization
export PATH=/usr/bin:$PATH

# Select which role group to use
# currently available:
# - common (default)
if [ "$#" == 0 ];
then
    GROUP=common
else
    GROUP=$1
fi

# Ensure we're on Linux -- Mac not supported yet
if [ `uname` != 'Linux' ];
then
    echo "ERROR - we currently only support Linux"
    exit 1
fi

echo "Installing ansible"
sudo apt-get --assume-yes install software-properties-common > /dev/null
if ! grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep ansible/ansible > /dev/null; then
    sudo apt-add-repository ppa:ansible/ansible -y > /dev/null
    sudo apt-get update > /dev/null
fi
sudo apt-get --assume-yes install ansible > /dev/null

pushd `dirname $0` &>/dev/null
# git submodule init && git submodule update
ansible-playbook \
  -c local -i 'localhost,' \
  --extra-vars="group_role=$GROUP" \
  local.yml
popd &>/dev/null

