#!/bin/bash
#
# Manage apt packages and update the package list

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../../utils/utils.sh

# import configuration
. "${PATH_TO_SCRIPT}"/../package-management.conf

usage() {
  echo "Usage: apt-manage [COMMAND] <package> [OPTIONS]"
  echo 'COMMAND:'
  echo '  help, --help  Display this help message'
  echo '  i,    install Install the package'
  echo '  r,    remove  Remove the package'
  echo 'OPTIONS:'
  echo '  -l, --list    Update the package list only'
}

manage_package() {
  trap 'return 1' ERR
  if [[ "${install}" = 'true' ]]; then
    # install the package
    sudo apt-get -y install "${package}"
  else
    # remove the package
    sudo apt-get -y remove "${package}"
  fi
  trap - ERR
}

update_package_list() {
  # check if the package is in the list
  line=$(grep -xn "${package}" \
    "${PACKAGE_LISTS_REPO_PATH}"/lists/apt-packages.txt | cut -d: -f1)
  # start trap here since grep returns error if the package is not found
  trap 'return 1' ERR
  if [[ "${install}" = 'true' ]]; then
    # if the package is not in the list, add it
    if [[ -z "${line}" ]]; then
      echo "${package}" >> "${PACKAGE_LISTS_REPO_PATH}"/lists/apt-packages.txt
      # update git repository
      git -C "${PACKAGE_LISTS_REPO_PATH}" add ./lists/apt-packages.txt
      git -C "${PACKAGE_LISTS_REPO_PATH}" commit -m "feat: Added apt package ${package}"
      git -C "${PACKAGE_LISTS_REPO_PATH}" push
    fi
  else
    # if the package is in the list, remove it
    if [[ ! -z "${line}" ]]; then
      sed -i "${line}d" "${PACKAGE_LISTS_REPO_PATH}"/lists/apt-packages.txt
      # update git repository
      git -C "${PACKAGE_LISTS_REPO_PATH}" add ./lists/apt-packages.txt
      git -C "${PACKAGE_LISTS_REPO_PATH}" commit -m "feat: Removed apt package ${package}"
      git -C "${PACKAGE_LISTS_REPO_PATH}" push
    fi
  fi
  trap - ERR
}

# read command
command="${1}"
shift
# check if a command is provided
if [[ -z "${command}" ]]; then
  usage
  exit 0
fi
# evaluate command
install=false
case "${command}" in
  help|--help) usage; exit 0;;
  i|install) install=true;;
  r|remove) ;; # just keep install=false
  *) utils::err "Unknown command passed: ${command}"; usage; exit 1;;
esac

# read package
package="${1}"
shift
# check if a package is provided
if [[ -z "${package}" ]]; then
  utils::err 'No package provided.'
  usage
  exit 1
fi
# check that the package exists
apt-cache show "${package}" > /dev/null 2>&1
if [[ "$?" -ne 0 ]]; then
    utils::err "Package ${package} does not exist."
  exit 1
fi

# read options
list=false
while [[ $# -gt 0 ]]; do
  case "${1}" in
    -l|--list) list=true;;
    *) utils::err "Unknown parameter passed: ${1}"; usage; exit 1;;
  esac
  shift
done

# install or remove package is --list is not provided
error=0
if [[ "${list}" = false ]]; then
  dpkg -s "${package}" > /dev/null 2>&1
  res="$?"
  if [[ "${install}" = 'true' ]]; then
    # check that the package is not already installed
    if [[ "${res}" -eq 0 ]]; then
      utils::err "Package ${package} is already installed."
      exit 1
    fi
    echo "Install package ${package}"
    # ask for super user
    utils::ask_sudo
    # install the package
    utils::exec_cmd 'manage_package' 'Install package'
    error="$?"
  else
    # check that the package is not already removed
    if [[ "${res}" -ne 0 ]]; then
      utils::err "Package ${package} is not installed."
      exit 1
    fi
    echo "Remove package ${package}"
    # ask for super user
    utils::ask_sudo
    # remove the package
    utils::exec_cmd 'manage_package' 'Remove package'
    error="$?"
  fi
else
  if [[ "${install}" = 'true' ]]; then
    echo "Add package ${package} to the list"
  else
    echo "Remove package ${package} from the list"
  fi
fi

# do not update package list if the installation or removal failed
if [[ "${error}" -ne 0 ]]; then
  if [[ "${install}" = 'true' ]]; then
    utils::err 'Package list not updated because installation failed.'
  else
    utils::err 'Package list not updated because removal failed.'
  fi
  exit 1
fi
# update the package list
utils::exec_cmd 'update_package_list' 'Update package list'
# Done
if [[ "$?" -eq 0 ]]; then
  if [[ "${list}" = false ]]; then
    if [[ "${install}" = 'true' ]]; then
      echo 'Installation finished!'
    else
      echo 'Removal finished!'
    fi
  else
    echo 'Package list updated!'
  fi
else
  utils::err 'Failed to update package list.'
  exit 1
fi
