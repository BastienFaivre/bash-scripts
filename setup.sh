#!/bin/bash
#
# Set up of the environment

# import utility functions
. ./utils/utils.sh

usage() {
  echo 'Usage: ./setup.sh [OPTIONS]'
  echo 'OPTIONS:'
  echo '             --help                    Display this help message'
  echo "  -t <path>, --target-directory <path> Target directory to install\
 the scripts."
  echo "                                       Default: "${target}""
}

install_prerequisites() {
  # trap any error
  trap 'return 1' ERR
  sudo cat ./requirements/apt.txt | xargs sudo apt-get install -y
  # remove the trap
  trap - ERR
}

give_permission() {
  # trap any error
  trap 'return 1' ERR
  sudo find ./scripts -name "*.sh" -exec chmod a+x {} \;
  # also give permission to the clean script
  sudo chmod a+x ./clean.sh
  # remove the trap
  trap - ERR
}

create_softlinks() {
  # trap any error
  trap 'return 1' ERR
  # create target directory if it doesn't exist
  mkdir -p "${target}"
  # create softlinks without file extension
  for script in $(find ./scripts -name '*.sh'); do
    sudo ln -fs "$(realpath "${script}")" \
      ""${target}"/$(basename "${script}" .sh)"
  done
  # remove the trap
  trap - ERR
}

# default target directory
target='/usr/local/bin'
# read arguments
while [[ "$#" -gt 0 ]]; do 
  case ${1} in
    --help) usage; exit 0;;
    -t|--target-directory) target="${2}"; shift;;
    *) utils::err "Unknown parameter passed: ${1}"; usage; exit 1;;
  esac;
  shift;
done
# save target directory
echo "${target}" > ./utils/target-directory.txt

echo 'bash-scripts setup'
# ask for super user
utils::ask_sudo
# error tracker
error=0
# install prerequisites
utils::exec_cmd 'install_prerequisites' 'Install prerequisites'
((error|=$?))
# Give execute permissions to the scripts
utils::exec_cmd 'give_permission' 'Give permission to scripts'
((error|=$?))
# Create softlinks to /usr/local/bin which is usually already in the PATH
utils::exec_cmd 'create_softlinks' "Create soft links in "${target}""
((error|=$?))
# Done
if [[ "${error}" -eq 0 ]]; then
  echo 'Setup finished!'
else
  utils::err 'Setup imcomplete.'
  exit 1
fi
