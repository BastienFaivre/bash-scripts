#!/bin/bash
#
# Remove the environment

# import utility functions
. ./utils/utils.sh

remove_softlinks() {
  # remove all softlinks
  for script in $(find ./scripts -name "*.sh"); do
    sudo rm "$(cat ./utils/target-directory.txt)/$(basename "${script}" .sh)"
  done
  # remove target directory
  rm ./utils/target-directory.txt
}

echo 'bash-scripts uninstall'
# ask for super user
utils::ask_sudo
  # check that the target directory is known
  if [[ ! -f "./utils/target-directory.txt" ]]; then
    utils::err "Target directory not found."
    exit 1
  fi
# remove softlinks
utils::exec_cmd 'remove_softlinks' 'Remove soft links'
# Done
echo 'Uninstall finished!'
