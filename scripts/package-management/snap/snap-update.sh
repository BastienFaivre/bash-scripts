#!/bin/bash

echo -e "Update snap packages\n"
# ask for super user
echo "Password required..."
sudo echo -e "Password given!\n"
# update snap packages
sudo snap refresh
echo "Update finished!"