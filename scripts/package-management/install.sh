#!/bin/bash
#
# Update all the packages

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../utils/utils.sh

# import configuration
. "${PATH_TO_SCRIPT}"/package-management.conf

usage() {
  echo 'Usage: install [OPTIONS]'
  echo 'OPTIONS:'
  echo '      --help     Display this help message'
}

echo 'Install saved packages'
# ask for super user
utils::ask_sudo
# check if the package lists repo exists
if [[ ! -d "${PACKAGE_LISTS_REPO_PATH}/lists" ]]; then
  utils::err "The package lists repo does not exist"
  exit 1
fi
# error tracker
error=0
# iterate on all package managers and install
for manager in $(find "${PATH_TO_SCRIPT}" -mindepth 1 -type d); do
  # only install the chosen package managers
  chosen=INSTALL_$(basename "${manager}")
  if [[ ${!chosen} = true ]]; then
    utils::exec_cmd "$(basename "${manager}")-install" \
      "Install $(basename "${manager}") packages"
    ((error|=$?))
  else
    echo "$(basename "${manager}") packages install skipped as defined in" \
      "config file"
  fi
done
# Done
if [[ ${error} -eq 0 ]]; then
  echo 'All packages installed'
else
  utils::err 'Some packages failed to install'
fi