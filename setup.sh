#!/bin/bash
#
# Set up of the environment

# import utility functions
. ./utils/utils.sh

usage() {
  echo "Usage: ./setup.sh [OPTIONS]"
  echo "OPTIONS:"
  echo -e "\t-h, --help\t\t\tDisplay this help message"
  echo -e "\t-t, --target-directory\t\tTarget directory to install the scripts.\
 Default: /usr/local/bin"
}

install_prerequisites() {
  sudo cat ./requirements/apt.txt | xargs sudo apt-get install -y
}

give_permission() {
  sudo find ./scripts -name "*.sh" -exec chmod a+x {} \;
  # also give permission to the clean script
  sudo chmod a+x ./clean.sh
}

create_softlinks() {
  # create target directory if it doesn't exist
  mkdir -p "${target}"
  # create softlinks without file extension
  for script in $(find ./scripts -name "*.sh"); do
    sudo ln -s "$(realpath "${script}")" \
      ""${target}"/$(basename "${script}" .sh)"
  done
}

# default target directory
target='/usr/local/bin'
# retrieve the target directory if specified
while [[ "$#" -gt 0 ]]; do 
  case ${1} in
    -h|--help) usage; exit 0;;
    -t|--target-directory) target="${2}"; shift;;
    *) echo "Unknown parameter passed: ${1}"; usage; exit 1;;
  esac;
  shift;
done
# save target directory
echo "${target}" > ./utils/target-directory.txt

echo 'bash-scripts setup'
# ask for super user
utils::ask_sudo
# install prerequisites
utils::exec_cmd 'install_prerequisites' 'Install prerequisites'
# Give execute permissions to the scripts
utils::exec_cmd 'give_permission' 'Give permission to scripts'
# Create softlinks to /usr/local/bin which is usually already in the PATH
utils::exec_cmd 'create_softlinks' "Create soft links in "${target}""
# Done
echo 'Setup finished!'
