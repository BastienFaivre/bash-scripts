#!/bin/bash
#
# Update snap packages

echo -e 'Update snap packages\n'
# ask for super user
sudo -v
# update snap packages
sudo snap refresh
echo 'Update finished!'