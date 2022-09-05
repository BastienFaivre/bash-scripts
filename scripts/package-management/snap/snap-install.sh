#!/bin/bash
#
# Update all the packages

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../../utils/utils.sh

# import configuration
. "${PATH_TO_SCRIPT}"/../package-management.conf

usage() {
  echo 'Usage: snap-install [OPTIONS]'
  echo 'OPTIONS:'
  echo '      --help     Display this help message'
}

install_saved_packages() {
  # trap any error
  trap 'return 1' ERR
  # install all saved packages one by one
  while read -r package; do
    sudo snap install "${package}"
  done < "${PACKAGE_LISTS_REPO_PATH}/lists/snap-packages.txt"
  # remove the trap
  trap - ERR
}

echo 'Install saved packages'
# ask for super user
utils::ask_sudo
# check if the package list exists
if [[ ! -f "${PACKAGE_LISTS_REPO_PATH}/lists/snap-packages.txt" ]]; then
  utils::err "The package list does not exist"
  exit 1
fi
# error tracker
error=0
# install all saved packages
utils::exec_cmd "install_saved_packages" "Install saved snap packages"
((error|=$?))
# Done
if [[ ${error} -eq 0 ]]; then
  echo 'All packages installed'
else
  utils::err 'Some packages failed to install'
fi
