call plug#begin('~/.config/nvim/plugged')
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'tjdevries/lsp_extensions.nvim'
" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'
" Wal theme loading
Plug 'dylanaraps/wal.vim'
" Better substitution
Plug 'tpope/vim-abolish'
call plug#end()

let mapleader = "\<Space>"


" Use system colorscheme provided by wal
colorscheme wal

syntax enable
filetype plugin indent on

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion and diagnostics
-- when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
-- Commented for now
nvim_lsp.rust_analyzer.setup({ 
    on_attach=on_attach,
    settings = {
        assist = {
            importGranularity = "module",
            importPrefix = "by_self",
        },
        cargo = {
            loadOutDirsFromCheck = true
        },
        procMacro = {
            enable = true
        },
    }
})
-- pyls
nvim_lsp.pyls.setup{}

-- typescript
nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}
local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}

EOF

" Trigger completion with <Tab>
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Code navigation shortcuts
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <c+]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
inoremap <silent> <c+k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gT    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> rn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Visualize diagnostics
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Don't show diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>PrevDiagnosticCycle<cr>
nnoremap <silent> g] <cmd>NextDiagnosticCycle<cr>

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }



" Scroll using the mouse
set mouse=a " In every mode

set nocompatible

set background=dark
set nocp

set hidden
set history=100

set backspace=2
set autoindent
set cindent

set expandtab
set tabstop=4
set shiftwidth=4
set smarttab

" Wrap on words
" set wrap
set nowrap
set formatoptions=l
set lbr

" Disable continuation of comments
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

"set ruler
set number
set relativenumber

" Indentation

" Highlight on search
set hlsearch
" Cancel highlighting of search term with escape
nnoremap <silent> <Enter> :nohlsearch<Bar>:echo<CR>

" Move back and forth between files
nnoremap <Leader><Leader> :e#<CR>

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
set pastetoggle=<F1>

" Show a list of open files and allow easy navigation
nnoremap <F5> :buffers<CR>:buffer<Space>

" Copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>u "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
