#!/bin/bash
#
# Remove the environment

# import utility functions
. ./utils/utils.sh

remove_softlinks() {
  # remove all softlinks
  for script in $(find ./scripts -name "*.sh"); do
    sudo rm /usr/local/bin/"$(basename "${script}" .sh)"
  done
}

echo 'bash-scripts uninstall'
# ask for super user
sudo -v
utils::exec_cmd 'remove_softlinks' 'Remove soft links'
# Done
echo 'Uninstall finished!'
