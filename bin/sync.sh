#!/bin/bash

#
# Program: sync.sh
# Author: Vitor Britto
#
# Description:
# Sync Setup (Installing Vim environment on another machine)
#

# Declaring variables
REPOSITORY_PATH="http://github.com/vitorbritto/setup-vim.git"
DIST_FOLDER="$HOME/.vim"

# Scaffolding
echo -e " → Installing Plugin"
echo -e "-------------------------------------------------"
echo -e " → This could take awhile. Relax and enjoy... =] "
echo -e "-------------------------------------------------"

cd ~
git clone "$REPOSITORY_PATH" "$DIST_FOLDER"
ln -s "$DIST_FOLDER"/vimrc ~/.vimrc
cd "$DIST_FOLDER"
git submodule init && git submodule update

# All done!
echo -e " ✔ All done!"
