#!/bin/bash

#
# Program: del.sh
# Author: Vitor Britto
#
# Description:
# Remove Plugin
https://github.com/sirver/ultisnips

echo -e "-----------------------------------------------------------------"
echo -e "1. Delete the relevant line from the .gitmodules file"
echo -e "2. Stage the .gitmodules changes git add .gitmodules"
echo -e "3. Delete the relevant section from .git/config"
echo -e "4. Run git rm --cached path_to_submodule (no trailing slash!!)"
echo -e "5. Delete the now untracked submodule files"
echo -e "6. rm -rf path_to_submodule"
echo -e "-----------------------------------------------------------------"
