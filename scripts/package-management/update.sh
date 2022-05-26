#!/bin/bash

# import exec-cmd function
. ./scripts/utils/exec-cmd.sh

echo "Update all packages"
# ask for super user
sudo -v
# iterate on all package managers and update
for manager in $(find $(dirname $(readlink $0)) -mindepth 1 -type d); do
    exec_cmd "$(basename $manager)-update" "Update $(basename $manager) packages"
done

echo "Update finished!"
