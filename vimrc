" Vundle
" --------------------

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
Plugin 'scrooloose/nerdcommenter' "To make commenting faster
Plugin 'scrooloose/nerdtree' "File tree
Plugin 'tpope/vim-surround' "Surround texts with tags or quotes
Plugin 'kien/ctrlp.vim' "Fuzzy search (command t is another option)
Plugin 'tpope/vim-repeat' "Repeat plugins like surround
Plugin 'airblade/vim-gitgutter'
Plugin 'mru.vim' " Pulls up a buffer of most recently used files

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" GENERAL
" --------------------

syntax enable                   " enable syntax highlighting
set encoding=utf-8
set autoread                    " Automatically reload when a file is changed outside of Vim
set nobackup                    " Do not automatically backup files
set showcmd                     " display incomplete commands
set history=1000                " Remember 1000 lines of command line history
set number                      " Enable line numbers
set noswapfile
set vb " Turn off beeps
imap jk <ESC> 
"Stop showing search results when you hit enter
nnoremap <CR> :nohlsearch<CR>
set backspace   =indent,eol,start  " Make backspace work as you would expect.

" Undo
" ---------------------
set undofile                    " Save undo's after file closes
set undodir=~/.vim/undo         " where to save undo histories
set undolevels=1000             " How many undos
set undoreload=10000            " number of lines to save for undo

" Leader Mappings
" ---------------------
let mapleader= " "
" ctrl p. Fuzzy finder. This is huge
nmap <leader>p :CtrlP <cr>
nmap <leader>m :MRU
" leader n opens nerdtree by default

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
