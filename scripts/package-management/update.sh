#!/bin/bash
#
# Update all the packages

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../utils/utils.sh

# import configuration
. "${PATH_TO_SCRIPT}"/package-management.conf

usage() {
  echo 'Usage: update [OPTIONS]'
  echo 'OPTIONS:'
  echo '      --help     Display this help message'
  echo '  -h, --shutdown Shutdown the system after update'
  echo '  -r, --reboot   Reboot the system after update'
  echo '  -f, --force    Force shutdown/reboot if the update failed'
  echo "Note 1: if both --shutdown and --reboot are provided, --shutdown will\
 be used."
  echo "Note 2: by default, the system will not be shutdown/rebooted if the\
 update failed."
  echo "        Use --force to override this behavior."
}

#default arguments value
shutdown=false
reboot=false
force=false
# read arguments
while [[ "$#" -gt 0 ]]; do
  case ${1} in
    --help) usage; exit 0;;
    -h|--shutdown) shutdown=true;;
    -r|--reboot) reboot=true;;
    -f|--force) force=true;;
    *) utils::err "Unknown parameter passed: ${1}"; usage; exit 1;;
  esac;
  shift;
done

echo 'Update all packages'
# ask for super user
utils::ask_sudo
# error tracker
error=0
# iterate on all package managers and update
for manager in $(find "${PATH_TO_SCRIPT}" -mindepth 1 -type d); do
  # only update the chosen package managers
  chosen=UPDATE_$(basename "${manager}")
  if [[ ${!chosen} = true ]]; then
    utils::exec_cmd "$(basename "${manager}")-update" \
      "Update $(basename "${manager}") packages"
    ((error|=$?))
  else
    echo "$(basename "${manager}") packages update skipped as defined in" \
      "config file"
  fi
done
# Done
if [[ "${error}" -eq 0 ]]; then
  echo 'Update finished!'
  # shutdown/reboot if needed
  if [[ "${shutdown}" = true ]]; then
    shutdown -h now
  elif [[ "${reboot}" = true ]]; then
    shutdown -r now
  fi
else
  utils::err 'Update incomplete.'
  # shutdown/reboot if needed
  if [[ "${force}" = true ]]; then
    if [[ "${shutdown}" = true ]]; then
      shutdown -h now
    elif [[ "${reboot}" = true ]]; then
      shutdown -r now
    fi
  fi
  exit 1
fi
