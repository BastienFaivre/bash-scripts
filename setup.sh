#!/bin/bash

# import exec-cmd function
. ./scripts/utils/exec-cmd.sh

install_prerequisites() {
    sudo apt-get -y install < ./requirements/apt.txt
}

give_permission() {
    sudo find . -name "*.sh" -exec chmod a+x {} \;
}

create_softlinks() {
    # create softlinks without file extension
    for script in $(find ./scripts -name "*.sh"); do
        sudo ln -s $(realpath $script) /usr/local/bin/$(basename $script .sh)
    done
}

echo "bash-scripts setup"
# ask for super user
sudo -v
# # gives permission to exec-cmd script
# sudo chmod a+x ./scripts/utils/exec-cmd.sh
# install prerequisites
exec_cmd "install_prerequisites" "Install prerequisites"
# Give execute permissions to the scripts
exec_cmd "give_permission" "Give permission to scripts"
# Create softlinks to /usr/local/bin which is usually already in the PATH
exec_cmd "create_softlinks" "Create soft links in /usr/local/bin"
# Done
echo "Setup finished!"
