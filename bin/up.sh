#!/bin/bash

#
# Program: up.sh
# Author: Vitor Britto
#
# Description:
# Update Plugins
#

# Declaring variables
REPOSITORY_PATH="$1"
REPOSITORY_NAME="$2"
DIR="bundle/{$REPOSITORY_NAME}"

# Scaffolding
echo -e " → Updating Plugins"
echo -e "-------------------------------------------------"
echo -e " → This could take awhile. Relax and enjoy... =] "
echo -e "-------------------------------------------------"

cd ~/.vim
git submodule foreach git pull origin master

# All done!
echo -e " ✔ All done!"
