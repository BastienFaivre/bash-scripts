#!/bin/bash
#
# Remove the environment

# import utility functions
. ./utils/utils.sh

delete_softlinks() {
  # remove all softlinks
  for script in $(find ./scripts -name "*.sh"); do
    sudo srm -drz  "$(cat ./utils/target-directory.txt)/$(basename "${script}" .sh)"
  done
  # remove target directory
  rm ./utils/target-directory.txt
}

remove_permission() {
  sudo find ./scripts -name "*.sh" -exec chmod a-x {} \;
}

echo 'bash-scripts uninstall'
# ask for super user
utils::ask_sudo
# check that the target directory is known
if [[ ! -f "./utils/target-directory.txt" ]]; then
  utils::err "Target directory not found."
  exit 1
fi
# delete softlinks
utils::exec_cmd 'delete_softlinks' 'Delete soft links'
# remove permission
utils::exec_cmd 'remove_permission' 'Remove permission'
# Done
echo 'Uninstall finished!'
