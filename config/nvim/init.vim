""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map leader to <Space>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Make Vim more useful
set nocompatible

" Set path to Python executables
let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }
Plug 'corntrace/bufexplorer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'dir': '~/.config/nvim/plugged/tern_for_vim', 'do': 'npm install' }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'w0ng/vim-hybrid'
Plug 'wannesm/wmgraphviz.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

" Install plugins if this is the first run
if !isdirectory(expand(g:plug_home))
  PlugInstall
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

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:UltiSnipsExpandTrigger="<C-j>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set background color to dark
set background=dark

" Set colorscheme
colorscheme hybrid

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Highlight lines longer than 100 characters
autocmd BufRead,InsertEnter,InsertLeave * 2match OverLength /\%100v.*/
highlight OverLength ctermbg=red guibg=#5f0000 guifg=#cc6666

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=#5f0000 guifg=#cc6666

" Autocomplete menu colors
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files, Backups, and Undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
endif

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

" Enter command-line mode easier
nmap ; :

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

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]

let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" EasyAlign
nmap ga <Plug>(EasyAlign)

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

" One
let g:one_allow_italics = 1

" TComment
noremap <silent> <LocalLeader>cc :TComment<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Trim trailing whitespace
function! Trim()
  %s/\s*$//
  ''
endfunction
command! -nargs=0 Trim :call Trim()
nnoremap <silent> <Leader>cw :Trim<CR>

" Search & Replace functions (uses vim-over):
function! VisualFindAndReplace()
  :OverCommandLine%s/
endfunction
function! VisualFindAndReplaceWithSelection() range
  :'<,'>OverCommandLine s/
endfunction
nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>
