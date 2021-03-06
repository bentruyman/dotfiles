let vim_plug_path = expand('~/.local/share/nvim/site/autoload/plug.vim')
if !filereadable(vim_plug_path)
  echo 'Installing vim-plug for the first time...'
  execute 'silent !curl -fLo '.fnameescape(vim_plug_path).' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source '.fnameescape(vim_plug_path)
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map leader to <Space>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Make Vim more useful
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'corntrace/bufexplorer'
Plug 'easymotion/vim-easymotion'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-easy-align'
Plug 'ntpeters/vim-better-whitespace'
Plug 'prettier/vim-prettier'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'shime/vim-livedown'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'w0ng/vim-hybrid'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

" Install plugins if this is the first run
if !isdirectory(expand(g:plug_home))
  PlugInstall --sync
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set clipboard to system
set clipboard=unnamed

" Draw a vertical ruler at column 80
set colorcolumn=81

" Configure autocomplete window
set completeopt=longest,menuone,preview
set complete=.,w
set omnifunc=LanguageClient#complete
set completefunc=LanguageClient#complete

" Highlight current line
set cursorline

" Use taller vertical split separator character (reduces visible gaps)
set fillchars+=vert:│

" Hide buffers instead of closing them
set hidden

" Adds - as a word separator
set iskeyword-=-

" Don't redraw while executing macros
set lazyredraw

" Highlight unwanted whitespace
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_

" Show whitespace
set list

" Disables annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show line numbers
set number

" Minimum of 5 lines above and below cursor must be visible
set scrolloff=5

" Don't show short message when starting Vim
set shortmess=atI

" Show matching brackets
set showmatch

" Allow for both case sensitive and insensitive searching based on the pattern
set ignorecase
set smartcase

" Open split below and to the right
set splitbelow
set splitright

" Optimize for fast terminals
set ttyfast

" Enables autocomplete menu
set wildmode=longest:full

" Wrap long lines
set wrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set background color to dark
set background=dark

" Set color scheme
colorscheme onedark

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Highlight lines longer than 100 characters
autocmd BufRead,InsertEnter,InsertLeave * 2match OverLength /\%100v.*/
highlight OverLength ctermbg=red guibg=#5f0000 guifg=#cc6666

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files, Backups, and Undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't add empty newlines at the end of files
set noeol

" Ignore certain files
set wildignore+=
      \.git,
      \*/coverage/*,
      \*/dist/*,
      \*/node_modules/*,
      \*/tmp/*
      \*/vendor/*

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File-specific
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Spellcheck markdown
autocmd FileType markdown setlocal spell spelllang=en_us

" Autoremove trailing spaces when saving the buffer
autocmd FileType css,html,javascript,markdown
      \ autocmd BufWritePre <buffer> :%s/\s\+$//e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces
set expandtab

" Use 2 characters per indent
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Disable maximum text width
set textwidth=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Treat long lines as break lines
noremap j gj
noremap k gk

" Easier split navigation
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle paste mode on and off
noremap <leader>pp :setlocal paste!<cr>

" Fast saving
nnoremap <leader>w :w!<cr>

" Fast quitting
nnoremap <leader>q :q<cr>

" Fast save + quit
nnoremap <leader>wq :wqa!<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ale
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \'*': ['remove_trailing_lines', 'trim_whitespace'],
      \'javascript': ['eslint'],
      \'typescript': ['eslint'],
      \}
let g:ale_linters = {
      \'javascript': ['eslint'],
      \'typescript': ['eslint'],
      \}

" Defx
noremap <F1> :Defx<CR>

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer> q :bd<CR>
endfunction

" Denite
noremap <C-p> :Denite file/rec<CR>

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
nnoremap <silent> <C-p> :<C-u>Denite
      \ `finddir('.git', ';') != '' ? 'file/rec/git' : 'file/rec'`<CR>

" Language Server

let g:LanguageClient_serverCommands = {
    \ 'dockerfile': ['docker-langserver --stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'yaml': ['yaml-language-server'],
    \ }

" NERDTree

let NERDTreeIgnore=[
      \'^coverage$',
      \'^dist$',
      \'^node_modules$',
      \'^tmp$',
      \'^vendor$'
      \]
let NERDTreeHijackNetrw = 0
noremap <silent> <LocalLeader>nt :NERDTreeToggle<CR>
noremap <silent> <LocalLeader>nr :NERDTree<CR>
noremap <silent> <LocalLeader>nf :NERDTreeFind<CR>

" TComment
noremap <silent> <LocalLeader>cc :TComment<CR>
