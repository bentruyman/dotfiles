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
Plug 'alampros/vim-styled-jsx'
Plug 'alvan/vim-closetag'
Plug 'kyazdani42/nvim-web-devicons' | Plug 'akinsho/bufferline.nvim'
Plug 'APZelos/blamer.nvim'
Plug 'corntrace/bufexplorer'
Plug 'easymotion/vim-easymotion'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-easy-align'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'navarasu/onedark.nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yuezk/vim-js'

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

" Give more space for displaying messages
set cmdheight=2

" Highlight current line
set cursorline

" Hide buffers instead of closing them
set hidden

" Adds - as a word separator
set iskeyword-=-

" Don't redraw while executing macros
set lazyredraw

" Show whitespace
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¬,precedes:«,extends:»
set list

" Enable mouse control
set mouse=a

" Disables annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show line numbers
set number

" Don't show short message when starting Vim
set shortmess=actI

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

" Lower update time to increase perceived performance
set updatetime=300

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

" Don't use backups
set nobackup
set nowritebackup

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

" Fast closing buffers
nnoremap <leader>q :bd<cr>

" Fast quitting
nnoremap <leader>x :x<cr>
nnoremap <leader>wq :wqa!<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Blamer
let g:blamer_enabled = 1
let g:blamer_delay = 300

" BufferLine
lua << EOF
require("bufferline").setup{}
EOF
nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>]b :BufferLineCyclePrev<CR>
nnoremap <silent><leader>1 :BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 :BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 :BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 :BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 :BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 :BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 :BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 :BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 :BufferLineGoToBuffer 9<CR>

" CoC
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <TAB> to skip through suggestions
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add :Format command
command! -nargs=0 Format :call CocAction('format')
"
" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Format selected code
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Rename symbols
map <F3> <Plug>(coc-rename)

" Show available CoC commands
map <F5> :CocList commands<CR>

" FZF
noremap <C-p> :FZF<CR>
set rtp+=/opt/homebrew/opt/fzf

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif

" NERDTree
let NERDTreeIgnore=[
      \'^coverage$',
      \'^dist$',
      \'^node_modules$',
      \'^tmp$',
      \'^vendor$'
      \]
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1 " Hide 'Press ? for help'
let NERDTreeHijackNetrw = 1
let g:NERDTreeWinPos = "right"
noremap <silent> <LocalLeader>nt :NERDTreeToggle<CR>
noremap <silent> <LocalLeader>nr :NERDTree<CR>
noremap <silent> <LocalLeader>nf :NERDTreeFind<CR>

" Prettier
noremap <leader>P :Prettier<cr>


" TComment
noremap <silent> <LocalLeader>cc :TComment<CR>
