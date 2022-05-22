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

remove_softlinks() {
    # remove all softlinks
    for script in $(find ./scripts -name "*.sh"); do
        sudo rm /usr/local/bin/$(basename $script .sh)
    done
}

echo "removing all soft links..."
execute_command "remove_softlinks"
echo "soft links removed!"
