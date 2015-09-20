" GENERAL
" --------------------

set nocompatible                " choose no compatibility with legacy vi
syntax enable                   " enable syntax highlighting
set encoding=utf-8
set autoread                    " Automatically reload when a file is changed outside of Vim
set nobackup                    " Do not automatically backup files
set showcmd                     " display incomplete commands
set history=1000                " Remember 1000 lines of command line history
set number                      " Enable line numbers

" File Editing
" --------------------
filetype plugin indent on       " load file type plugins + indentation
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
                                " Disable auto-commenting subsequent comment lines

" Whitespace
" --------------------
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

" Searching
" --------------------
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
