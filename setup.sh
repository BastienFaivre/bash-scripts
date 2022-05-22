#!/bin/bash

execute_command() {
    # check if a command is provided
    if [ -z "$1" ]; then
        echo "Execute: No command provided"
        exit 1
    fi
    # execute the command in background
    $1 > /dev/null & 
    # display loader
    pid=$!
    i=1
    sp="/-\|"
    echo -n ' '
    trap "kill $pid 2 > /dev/null" EXIT
    while kill -0 $pid 2> /dev/null; do
        # display spinner
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.1
    done
    printf "\b"
    trap - EXIT
}

install_prerequisites() {
    sudo apt-get -y install < ./requirements.txt
}

give_permission() {
    sudo find ./scripts -name "*.sh" -exec chmod +x {} \;
}

create_softlinks() {
    sudo find ./scripts -name "*.sh" -exec cp {} /usr/local/bin/ \;
    # removing file extension from scripts
    for script in /usr/local/bin/*.sh; do
        sudo mv $script /usr/local/bin/$(basename $script .sh)
    done
}

echo -e "bash-scripts setup\n"
# ask for super user
echo "Password required..."
sudo echo -e "Password given!\n"
# install prerequisites
echo "Installing prerequisites..."
execute_command "install_prerequisites"
echo -e "Prerequisites installed!\n"
# Give execute permissions to the scripts
echo "Giving execution permission to scripts..."
execute_command "give_permission"
echo -e "Permission given!\n"
# Copy scripts to /usr/local/bin which is usually already in the PATH
echo "Creating soft links in /usr/local/bin..."
execute_command "create_softlinks"
echo -e "Soft links created!\n"
# Done
echo "Setup finished!"
