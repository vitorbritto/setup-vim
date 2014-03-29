#!/bin/bash

#
# Program: init.sh
# Author: Vitor Britto
#
# Description:
# Install VIM and setup for use
#

# Declaring variables
GFILE=".gvimrc"
FILE=".vimrc"
DIR=".vim"

# Scaffolding
echo -e " → Installing VIM"
echo -e "-------------------------------------------------"
echo -e " → This could take awhile. Relax and enjoy... =] "
echo -e "-------------------------------------------------"

if [ -d "$DIR" ]; then
    mv ~/.vim ~/.vim_bkp
fi

if [ -f "$FILE" ]; then
    mv ~/.vimrc ~/.vimrc_bkp
fi

if [ -f "$GFILE" ]; then
    mv ~/.gvimrc ~/.gvimrc_bkp
fi

git clone --recursive http://github.com/vitorbritto/setup-vim.git $DIR
ln -s ~/.vim/vimrc $FILE
rm -rf ~/.vim/init.sh

# All done!
echo -e " ✔ All done!"
