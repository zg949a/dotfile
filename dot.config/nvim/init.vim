let mapleader =","

set laststatus=0
syntax on
set t_Co=256

set number
set relativenumber
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
" Display all matching files when we tab complete
set wildmenu

" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'Vundlevim/Vundle.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'https://github.com/junegunn/vim-github-dashboard.git'
Plugin 'SirVer/ultisnips' | Plugin 'honza/vim-snippets'
Plugin 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plugin 'tpope/vim-fireplace', { 'for': 'clojure' }
Plugin 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plugin 'fatih/vim-go', { 'tag': '*' }
Plugin 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'scrooloose/syntastic'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'lervag/vimtex'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'mg979/vim-visual-multi'
Plugin 'taglist.vim'
"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
call vundle#end()

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes) in terminals
set nobackup
set writebackup
"set foldmethod=indent
set foldmethod=marker

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" settings for Vim Airline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
""" Separators can be configured independently for the tabline
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let This_Show_One_File=1

let g:livepreview_previewer = 'evince'
let g:tex_flavor='latex'
autocmd Filetype tex setl updatetime=3
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_compiler_latexmk = {
\ 'executable' : 'latexmk',
\ 'options' : [
\ '-xelatex',
\ '-file-line-error',
\ '-synctex=1',
\ '-interaction=nonstopmode',
\ ],
\}

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif

inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>

