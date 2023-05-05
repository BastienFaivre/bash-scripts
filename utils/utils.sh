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
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] \033[0;31mERROR:\033[0m $*" >&2
}

#######################################
# Ask for sudo
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes error to stderr if sudo refused
# Returns:
#   None
#######################################
utils::ask_sudo() {
  # Ask for super user
  sudo -v > /dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    utils::err "You need to be root to run this script."
    exit 1
  fi
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
#   1 if the command failed, 0 otherwise
#######################################
utils::exec_cmd() {
  # retrieve arguments
  local cmd="${1}"
  local cmd_explanation="${2}"
  # check if a command is provided
  if [[ -z "${cmd}" ]]; then
    utils::err 'function exec_cmd(): No command provided.'
    exit 1
  fi
  # execute the command in background and redirect output to log file
  ${cmd} > /tmp/log.txt 2> /tmp/log.txt &
  # display loader while command is running
  local pid=$!
  local i=1
  local sp='⣾⣽⣻⢿⡿⣟⣯⣷'
  trap 'kill ${pid} 2 > /dev/null' EXIT
  while kill -0 ${pid} 2> /dev/null; do
    echo -ne "\r${sp:i++%${#sp}:1} ${cmd_explanation}"
    sleep 0.1
  done
  wait ${pid}
  # check is the command succeeded
  if [ "$?" -ne 0 ]; then
    echo -ne "\r\033[0;31mFAIL\033[0m ${cmd_explanation}\n"
    # display log file
    cat /tmp/log.txt
    # remove log file
    rm /tmp/log.txt
    trap - EXIT
    return 1
  else
    echo -ne "\r\033[0;32mDONE\033[0m ${cmd_explanation}\n"
    # remove log file
    rm /tmp/log.txt
    trap - EXIT
    return 0
  fi
}
