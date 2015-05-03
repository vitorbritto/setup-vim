#!/bin/bash

#
# Program: add.sh
# Author: Vitor Britto
#
# Description:
# Add a New Plugin as Submodule
#

# Declaring variables
REPOSITORY_PATH="$1"
REPOSITORY_NAME="$2"
DIR="bundle/{$REPOSITORY_NAME}"

# Scaffolding
echo -e " → Installing Plugin"
echo -e "-------------------------------------------------"
echo -e " → This could take awhile. Relax and enjoy... =] "
echo -e "-------------------------------------------------"

cd ~/.vim
git submodule add "$REPOSITORY_PATH" "$DIR"
git submodule init && git submodule update

# All done!
echo -e " ✔ All done!"
