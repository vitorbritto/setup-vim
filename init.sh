#!/bin/bash

#
# Program: init.sh
# Author: Vitor Britto
#
# Description:
# Install VIM and setup for use
#

# Declaring variables
FILE="~/.vimrc"
DIR="~/.vim"

# Scaffolding
echo -e " → Installing VIM"
echo -e "-------------------------------------------------"
echo -e " → This could take awhile. Relax and enjoy... =] "
echo -e "-------------------------------------------------"

if [ -d "$DIR" ] then;
    rm -rf ~/.vim
fi

if [ -f "$FILE" ] then;
    rm ~/.vimrc
fi

git clone --recursive http://github.com/vitorbritto/setup-vim.git $DIR
ln -s ~/.vim/vimrc $FILE
rm -rf ~/.vim/init.sh
clear

# All done!
echo -e " ✔ All done!"
