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

echo -e "Update all packages\n"
# ask for super user
echo "Password required..."
sudo echo -e "Password given!\n"

# iterate on all package managers and update
for manager in $(find $(dirname $(readlink $0)) -mindepth 1 -type d); do
    echo "Updating $(basename $manager) packages..."
    execute_command "$(basename $manager)-update"
    echo -e "$(basename $manager) packages updated!\n"
done

echo "Update finished!"
