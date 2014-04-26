# Intro

ex-tags is a Vim plugin which improves the usage of Vim's `:ts` function. It
will list tags by file path and allow you move cursor to select it.

ex-tags is also a part of [exVim](https://github.com/exvim/main) project

## Requirements

- Vim 6.0 or higher.
- [exvim/ex-utility](https://github.com/exvim/ex-utility) 
- [ctags](http://ctags.sourceforge.net/)

## Installation

### Install ex-utility

ex-tags is written based on [exvim/ex-utility](https://github.com/exvim/ex-utility). This 
is the basic library of ex-vim-plugins. Follow the readme file in ex-utility to install it first.

### Install ctags

ex-tags used [ctags](http://ctags.sourceforge.net/) to generate tags. 
You can install ctags for different platform:

**Mac**

    ## use Homebrew
    brew install ctags

**Linux**

    ## use pat-get
    apt-get install ctags

    ## use yum
    yum install ctags

    ## or compile ctags from source

**Windows**

download it from [ctags page](http://ctags.sourceforge.net/)

### Install ex-tags

ex-tags follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-tags'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-tags

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-tags'

[Download zip file](https://github.com/exvim/ex-tags/archive/master.zip):

    cd ~/.vim
    unzip ex-tags-master.zip
    copy all of the files into your ~/.vim directory

## Usage

Enter your project, use `ctags` command create your tags:

```bash
ctags -R .
```

For more details about using `ctags`, read [ctags manual](http://ctags.sourceforge.net/ctags.html).

You will see a tags file generated under your directory. 

Start your Vim and try to search a tag by `:TS your-tag`. A search window will 
open and the search results of `your-tag` will be listed in it. 

You can jump to the search result by hit the `Enter` on the listed lines. 

More details, check `:help extags`.
