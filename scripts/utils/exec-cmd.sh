#!/bin/bash

#######################################
# Execute a command while displaying a loader
# Arguments:
#   $1: command to execute
#   $2: command explanation
#######################################
exec_cmd() {
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
    trap "kill $pid 2 > /dev/null" EXIT
    while kill -0 $pid 2> /dev/null; do
        # display spinner
        echo -ne "\r${sp:i++%${#sp}:1} $2"
        sleep 0.1
    done
    echo -ne "\r\033[0;32mDONE\033[0m $2\n"
    trap - EXIT
}