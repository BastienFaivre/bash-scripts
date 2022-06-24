#!/bin/bash
#
# Remove the environment

# import utility functions
. ./utils/utils.sh

delete_softlinks() {
  # trap any error
  trap "return 1" ERR
  # remove all softlinks
  for script in $(find ./scripts -name "*.sh"); do
    sudo srm -drz  "$(cat ./utils/target-directory.txt)/$(basename "${script}" .sh)"
  done
  # remove target directory
  rm ./utils/target-directory.txt
  # remove the trap
  trap - ERR
}

remove_permission() {
  # trap any error
  trap "return 1" ERR
  sudo find ./scripts -name "*.sh" -exec chmod a-x {} \;
  # remove the trap
  trap - ERR
}

echo 'bash-scripts uninstall'
# ask for super user
utils::ask_sudo
# check that the target directory is known
if [[ ! -f "./utils/target-directory.txt" ]]; then
  utils::err 'Target directory ./utils/target-directory.txt not found.'
  exit 1
fi
# error tracker
error=0
# delete softlinks
utils::exec_cmd 'delete_softlinks' 'Delete soft links'
((error|=$?))
# remove permission
utils::exec_cmd 'remove_permission' 'Remove permission'
((error|=$?))
# Done
if [[ "${error}" -eq 0 ]]; then
  echo 'Uninstall finished!'
else
  utils::err 'Unistallation imcomplete.'
  exit 1
fi
