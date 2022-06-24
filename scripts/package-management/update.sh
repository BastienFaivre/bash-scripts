#!/bin/bash
#
# Update all the packages

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../utils/utils.sh

echo 'Update all packages'
# ask for super user
utils::ask_sudo
# error tracker
error=0
# iterate on all package managers and update
for manager in $(find "${PATH_TO_SCRIPT}" -mindepth 1 -type d); do
  utils::exec_cmd "$(basename "${manager}")-update" \
    "Update $(basename "${manager}") packages"
  ((error|=$?))
done
# Done
if [[ "${error}" -eq 0 ]]; then
  echo 'Update finished!'
else
  utils::err 'Update incomplete.'
  exit 1
fi
