let mapleader="<Space>"

" vim-easyscape
" use j and k together to exit insert mode
let g:easyscape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 100
cnoremap jk <ESC>
cnoremap kj <ESC>
" inoremap <ESC> <Nop>

execute pathogen#infect()

" Let's not be *too* easy on ourselves
" Will not be useful without pathogen and hardmode installed
let g:HardMode_level = 'wannabe'
let g:HardMode_hardmodeMsg = 'Do not use the arrow keys'
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

set nocompatible
filetype off

" Enable syntax highlighting
" vim syntax folder contains rules
" ex. locate cpp.vim to see rules for c++ highlighting
syntax on
set background=dark

set nocp

set hidden
set history=100

set backspace=2
set autoindent
set cindent

" Set tabs to 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set smarttab

" Wrap on words
set wrap
set formatoptions=l
set lbr

"set ruler
set number

" Colors
"colorscheme molokai

filetype indent on
set nowrap
" Indentation
"set tabstop=2
"set softtabstop=2
"set expandtab

" Highlight on search
set hlsearch
" Cancel highlighting of search term with escape
nnoremap <silent> <Enter> :nohlsearch<Bar>:echo<CR>

" Move back and forth between files
" nnoremap <Leader><Leader> :e#<CR>

" Hilight matching parenthesis
set showmatch

" New file Templates
" Place template fiples in ~/.vim/skeleton
" template.cpp will be the default value upon creating a new .cpp file in vim
" Ignore
let ftToIgnore = ['h', 'hpp']
autocmd BufNewFile * if index(ftToIgnore, &ft) < 0 | silent! 0r ~/.vim/skeleton/template.%:e

" Include guard on c/cpp header files
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! 2o "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
  endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" Python specific formatting
autocmd BufNewFile,BufRead *.py call SetPythonOptions()
function SetPythonOptions()
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  set textwidth=79
  set expandtab
  set autoindent
  set fileformat=unix
endfunction

autocmd BufNewFile,BufRead *.rs call SetRustOptions()
function SetRustOptions()
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  set textwidth=79
  set expandtab
  set autoindent
  set fileformat=unix
endfunction
" Only copy text not line number
"se mouse+=a
set pastetoggle=<F1>
