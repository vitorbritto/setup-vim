# VIM Setup

My personal VIM Configuration.


## Requirements

Vim 7.3 or better _(Tested on Mac OS )_

**Introduction to Vim:** http://blog.interlinked.org/tutorials/vim_tutorial.html

- [Homebrew](http://github.com/mxcl/homebrew) - `ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"`
- [MacVim](http://code.google.com/p/macvim/) - `brew install macvim`
- [Homesick](http://github.com/technicalpickles/homesick) - `gem install homesick`
- [discount](http://www.pell.portland.or.us/~orc/Code/discount/) - `brew install discount `
- [ctags](http://ctags.sourceforge.net/) - `brew install ctags `

[MacVim](http://code.google.com/p/macvim/) is not a requirement as the majority of the files work in most \*nix environments including Terminal. It's recommended to use [Homebrew's](http://github.com/mxcl/homebrew) package of [MacVim](http://code.google.com/p/macvim/), as it compiles MacVim and Vim at 64 bit with Ruby, Python, Perl, installs the command line link `mvim`, plus a bunch of other goodness. [Homesick](http://github.com/technicalpickles/homesick) is required for easy management of dot files with the repository. The [discount](http://www.pell.portland.or.us/~orc/Code/discount/) executable is recommended for converting markdown files to html for previewing. The [ctags](http://ctags.sourceforge.net/) executable is helpful for taglist (jumping between files) and omni completion.


## Installing

To install the files and default configuration run the following:

**Quick Install**

    $ bash -c "$(curl -fsSL raw.github.com/vitorbritto/setup-vim/master/init.sh)"

**Normal Install**

    # Backup for your existing VIM configuration
    $ mv ~/.vim ~/.vim_bkp && mv ~/.vimrc ~/.vimrc_bkp && mv ~/.gvimrc ~/.gvimrc_bkp

    # Installation
    $ git clone --recursive http://github.com/vitorbritto/setup-vim.git .vim
    $ ln -s ~/.vim/vimrc ~/.vimrc
    $ ln -s ~/.vim/gvimrc ~/.gvimrc
    $ rm -rf ~/.vim/init.sh


## Plugins

Plug-ins are managed using pathogen. All submodule plug-ins are stored in the `bundle` directory.

### Adding New Plug-Ins As Submodules

New plug-ins need to be added to the `bundle` directory and should be treated as submodules. To add a new one run:

    $ git submodule add <repository> ~/.vim/bundle/<plugin-name>
    $ git submodule init
    $ git submodule update

### Update Plugins (Upgrading all bundled plugins)

To pull upstream changes for all of the submodules run the following:

    $ cd ~/.vim
    $ git submodule foreach git pull origin master

### Sync Setup (Installing Vim environment on another machine)

To sync this environment on another machine run the following:

    $ cd ~
    $ git clone http://github.com/vitorbritto/setup-vim.git ~/.vim
    $ ln -s ~/.vim/vimrc ~/.vimrc
    $ cd ~/.vim
    $ git submodule init
    $ git submodule update

### Removing Submodules

   - Delete the relevant line from the `.gitmodules` file
   - Delete the relevant section from `.git/config`
   - Run `git rm --cached path_to_submodule` (**no trailing slash!!**)
   - Remove the directory from `bundle`
   - Remove any descriptions from the `README.md` file

### Default Plug-Ins

- [vim-airline](https://github.com/bling/vim-airline)
- [bufkill.vim](https://github.com/vim-scripts/bufkill.vim.git)
- [camelcasemotion](https://github.com/vim-scripts/camelcasemotion.git)
- [colorsel.vim](https://github.com/vim-scripts/colorsel.vim.git)
- [Gundo](https://github.com/vim-scripts/Gundo.git)
- [HTML-AutoCloseTag](https://github.com/vim-scripts/HTML-AutoCloseTag.git)
- [IndexedSearch](https://github.com/vim-scripts/IndexedSearch.git)
- [Specky](https://github.com/vim-scripts/Specky.git)
- [tabular](https://github.com/godlygeek/tabular.git)
- [TailMinusF](https://github.com/vim-scripts/TailMinusF.git)
- [vim-ragtag](https://github.com/tpope/vim-ragtag.git)
- [vim-repeat](https://github.com/tpope/vim-repeat.git)
- [vim-surround](https://github.com/tpope/vim-surround.git)
- [delimitMate](https://github.com/Raimondi/delimitMate.git)
- [vim-rake](https://github.com/tpope/vim-rake.git)
- [vim-bundler](https://github.com/tpope/vim-bundler.git)
- [emmet-vim](https://github.com/mattn/emmet-vim.git)
- [browser-refresh.vim](https://github.com/mkitt/browser-refresh.vim/blob/master/doc/browser-refresh.txt)
- [gist-vim](https://github.com/mattn/gist-vim)
- [jade.vim](https://github.com/vim-scripts/jade.vim)
- [json.vim](https://github.com/vim-scripts/JSON.vim)
- [markdown-preview.vim](https://github.com/mkitt/markdown-preview.vim/blob/master/doc/markdown-preview.txt)
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter/blob/master/doc/NERD_commenter.txt)
- [nerdtree](https://github.com/scrooloose/nerdtree/blob/master/doc/NERD_tree.txt)
- [rvm.vim](https://github.com/csexton/rvm.vim)
- [snipmate.vim](https://github.com/msanders/snipmate.vim/blob/master/doc/snipMate.txt)
- [statusline](https://github.com/factorylabs/vimfiles/blob/master/home/.vim/bundle_storage/statusline/doc/statusline.txt)
- [supertab](https://github.com/ervandew/supertab/blob/master/doc/supertab.txt)
- [syntastic](https://github.com/scrooloose/syntastic/blob/master/doc/syntastic.txt)
- [taglist.vim](https://github.com/vim-scripts/taglist.vim/blob/master/doc/taglist.txt)
- [vim-coffee-script](https://github.com/kchmck/vim-coffee-script)
- [vim-cucumber](https://github.com/tpope/vim-cucumber)
- [vim-fugitive](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt)
- [vim-haml](https://github.com/tpope/vim-haml)
- [vim-javascript](https://github.com/pangloss/vim-javascript)
- [vim-markdown](https://github.com/tpope/vim-markdown)
- [vim-rails](https://github.com/tpope/vim-rails/blob/master/doc/rails.txt)
- [vim-ruby](https://github.com/vim-ruby/vim-ruby/tree/master/doc)
- [vim-stylus](https://github.com/wavded/vim-stylus)
- [vim-unimpaired](https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt)


## Helpful Stuff

- `:help key-notation`
- http://github.com/krisleech/vimfiles/wiki
- http://walking-without-crutches.heroku.com/image/images/vi-vim-cheat-sheet.png
- http://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118
- http://stevelosh.com/blog/2010/09/coming-home-to-vim/#important-vimrc-lines
- http://vimcasts.org/


## Acknowledgments

- http://tpo.pe/
- https://github.com/carlhuda/janus
- https://github.com/rson/vimfiles/blob/master/plugins.vim
- https://github.com/codegram/vimfiles
- https://www.destroyallsoftware.com/file-navigation-in-vim.html
- https://github.com/alexreisner/dotfiles/blob/master/.vimrc
- http://items.sjbach.com/319/configuring-vim-right
- https://github.com/sickill/dotfiles/blob/master/.vimrc


## License

[MIT License](http://vitorbritto.mit-license.org/) © Vitor Britto
