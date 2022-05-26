#!/bin/bash
#
# Define a set of utility functions

#######################################
# Show an error
# Globals:
#   None
# Arguments:
#   $*: messages to display
# Outputs:
#   Writes error to stderr
# Returns:
#   None
# Sources:
#   https://google.github.io/styleguide/shellguide.html#stdout-vs-stderr
#######################################
utils::err() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')]: $*" >&2
}

#######################################
# Execute a command while displaying a loader
# Globals:
#   None
# Arguments:
#   $1: command to execute
#   $2: command explanation
# Outputs:
#   Writes loader and command explanation to stdout
# Returns:
#   None
#######################################
utils::exec_cmd() {
  # check if a command is provided
  if [[ -z "${1}" ]]; then
    utils::err 'function exec_cmd(): No command provided'
    exit 1
  fi
  # execute the command in background
  ${1} > /dev/null & 
  # display loader while command is running
  local pid=$!
  local i=1
  local sp='/-\|'
  trap 'kill ${pid} 2 > /dev/null' EXIT
  while kill -0 ${pid} 2> /dev/null; do
    echo -ne "\r${sp:i++%${#sp}:1} ${2}"
    sleep 0.1
  done
  echo -ne "\r\033[0;32mDONE\033[0m ${2}\n"
  trap - EXIT
}
