#!/bin/bash
#
# Update snap packages

readonly PATH_TO_SCRIPT="$(dirname "$(readlink "${0}")")"

# import utility functions
. "${PATH_TO_SCRIPT}"/../../../utils/utils.sh

echo 'Update snap packages'
# ask for super user
utils::ask_sudo
# update snap packages
sudo snap refresh
# Done
echo 'Update finished!'