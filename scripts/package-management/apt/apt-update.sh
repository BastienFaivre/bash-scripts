#!/bin/bash
#
# Update apt packages

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../../utils/utils.sh

echo 'Update apt packages'
# ask for super user
utils::ask_sudo
# trap any error
trap "utils::err 'An error occured while updating the packages'; exit 1" ERR
# update and clean apt packages
sudo apt-get update
sudo apt-get --with-new-pkgs upgrade -y --show-progress
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove --purge -y --show-progress
# remove the trap
trap - ERR
# Done
echo 'Update finished!'