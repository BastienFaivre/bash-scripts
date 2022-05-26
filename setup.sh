#!/bin/bash
#
# Set up of the environment

# import utility functions
. ./utils/utils.sh

install_prerequisites() {
  sudo cat ./requirements/apt.txt | xargs sudo apt-get install -y
}

give_permission() {
  sudo find ./scripts -name "*.sh" -exec chmod a+x {} \;
  # also give permission to the clean script
  sudo chmod a+x ./clean.sh
}

create_softlinks() {
  # create softlinks without file extension
  for script in $(find ./scripts -name "*.sh"); do
    sudo ln -s "$(realpath "${script}")" /usr/local/bin/"$(basename "${script}" .sh)"
  done
}

echo 'bash-scripts setup'
# ask for super user
sudo -v
# install prerequisites
utils::exec_cmd 'install_prerequisites' 'Install prerequisites'
# Give execute permissions to the scripts
utils::exec_cmd 'give_permission' 'Give permission to scripts'
# Create softlinks to /usr/local/bin which is usually already in the PATH
utils::exec_cmd 'create_softlinks' 'Create soft links in /usr/local/bin'
# Done
echo 'Setup finished!'
