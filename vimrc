" General {{{

set nocompatible

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Do unix-style tab-completion of filenames
set wildmode=longest,list

" MacOS requires this in order to not be insane
set backspace=indent,eol,start

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
if ! exists("mapleader")
  let mapleader = ","
endif

if ! exists("g:mapleader")
  let g:mapleader = ","
endif

" Leader key timeout
set tm=2000

" Allow the normal use of "," by pressing it twice
noremap ,, ,

" Use par for prettier line formatting
"set formatprg=par
"let $PARINIT = 'rTbgqR B=.,?_A_a Q=_s>|'

" Kill the damned Ex mode.
nnoremap Q <nop>
" Kill non-useful quits.
nnoremap ZZ <nop>


" Make <c-h> work like <c-h> again (this is a problem with libterm)
if has('nvim')
  nnoremap <BS> <C-w>h
endif

" }}}

" Plugins {{{
 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/vim/plugged')

" tags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*"]

" Colourscheme
Plug 'vim-scripts/wombat256.vim'

" Syntaces
Plug 'posva/vim-vue'
Plug 'udalov/kotlin-vim'

" Support bundles
"Plug 'jgdavey/tslime.vim'
"Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'ervandew/supertab'
"Plug 'benekastah/neomake'
"Plug 'moll/vim-bbye'
"Plug 'nathanaelkane/vim-indent-guides'
"Plug 'vim-scripts/gitignore'

" Bars, panels, and files
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
"Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'

" Text manipulation
"Plug 'vim-scripts/Align'
"Plug 'simnalamburt/vim-mundo'
"Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
"Plug 'michaeljsmith/vim-indent-object'
"Plug 'easymotion/vim-easymotion'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'jeetsukumaran/vim-indentwise'

" Linters
Plug 'w0rp/ale'

" Haskell type inspection
Plug 'hdevtools/hdevtools', {'for': 'haskell'}

" Fuzzy-find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Haskell
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'JonnyRa/vim-himposter'
"Plug 'parsonsmatt/intero-neovim'  " stopped using this
"Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
"Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
"Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
"Plug 'mpickering/hlint-refactor-vim', { 'for': 'haskell' }

" Relative/absolute line numbers
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Passively highlight occurences of word under cursor
Plug 'RRethy/vim-illuminate'
" Don't delay before highlighting (time in milliseconds)
let g:Illuminate_delay = 0
hi illuminatedWord cterm=underline gui=underline

call plug#end()

" }}}

" {{{ vim-sneak

let g:sneak#label = 1
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S

" }}}

" vim-himporter {{{

let g:himporterCreateMappings = 1

" }}}

" Relative line numbering {{{

:set number relativenumber

" }}}

" Haskell type information {{{

" Using vim-hdevtools

"setup shortcuts. these are only set in haskell buffers
autocmd FileType haskell nnoremap <buffer> <Leader>ht :HdevtoolsType<CR>
"need execute here as for some reason HdevtoolsClear is trying to read '|' as an argument
"dun't work: autocmd FileType haskell nnoremap <buffer> <Leader>hc :execute ":HdevtoolsClear"<bar>:ClearSearchHighlight<CR>
autocmd FileType haskell nnoremap <buffer> <Leader>hi :HdevtoolsInfo<CR>

" }}}


" Fuzzy Find {{{

nnoremap <C-t> :Tags<cr>
nnoremap <C-_> :execute "Tags ".expand('<cword>')<cr>

" }}}

" Asynchronous linting engine {{{

"fast syntax checking
"this disables some linters that don't work
let g:ale_linters = {
\   'haskell': ['stack-ghc', 'hlint', 'hdevtools', 'hfmt' ],
\    'cs': []
\}
let g:ale_haskell_stack_build_options = '--fast --work-dir .stack-work-ale --test --no-run-tests'
nmap <silent> <A-PageUp> <Plug>(ale_previous_wrap)
nmap <silent> <A-PageDown> <Plug>(ale_next_wrap)
nnoremap <A-Enter> :ALEDetail <cr>

" }}}

" Filetypes {{{

augroup vue
  au!

  " Julius is javascript, basically.
  autocmd BufNewFile,BufRead *.julius set syntax=javascript
augroup END

" }}}

" Fast-tag stuff {{{

" calls a shell script to dump in all the haskell files
augroup tags
  au BufWritePost *.hs      silent !init-tags %
  au BufWritePost *.hsc     silent !init-tags %
augroup END

" }}}

" Haskell stuff {{{

" ,t looks up type under cursor
map <silent> <leader>t <Plug>InteroGenericType

" Pretty-printing
command! FormatJson %!python -m json.tool
command! FormatHaskell %!pretty-simple | ansifilter

" }}}

" VIM user interface {{{

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
"set wildmenu
" Tab-complete files up to longest unambiguous prefix
"set wildmode=list:longest,full

" Always show current position
set ruler
set number

" Show trailing whitespace
set list
" But only interesting whitespace
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Height of the command bar
set cmdheight=1

" Configure backspace so it acts as it should act
"set backspace=eol,start,indent
"set whichwrap+=<,>,h,l

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set vb t_vb=

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Force redraw
"map <silent> <leader>r :redraw!<CR>

" Turn mouse mode on
"nnoremap <leader>ma :set mouse=a<cr>

" Turn mouse mode off
"nnoremap <leader>mo :set mouse=<cr>

" Default to mouse mode on
"set mouse=a

" }}}

" Colors and Fonts {{{

try
  colorscheme wombat256mod
catch
endtry

" Adjust signscolumn to match wombat
hi! link SignColumn LineNr

" Use pleasant but very visible search hilighting
hi Search ctermfg=white ctermbg=173 cterm=none guifg=#ffffff guibg=#e5786d gui=none
hi! link Visual Search

" Match wombat colors in nerd tree
hi Directory guifg=#8ac6f2

" Searing red very visible cursor
hi Cursor guibg=red

" Don't blink normal mode cursor
set guicursor=n-v-c:block-Cursor
set guicursor+=n-v-c:blinkon0

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set guitablabel=%M\ %t
endif
set t_Co=256

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Use powerline fonts for airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
" }}}

" Files, backups and undo {{{

" Turn backup off, since most stuff is in Git anyway...
set nobackup
set nowb
set noswapfile

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost vimrc source $MYVIMRC
augroup END

" Open file prompt with current path
nmap <leader>e :e  <C-R>=expand("%:p:h") . '/'<CR>
nmap <leader>E :e! <C-R>=expand("%:p:h") . '/'<CR>
nmap <leader>w :w  <C-R>=expand("%:p:h") . '/'<CR>
nmap <leader>W :w! <C-R>=expand("%:p:h") . '/'<CR>
nmap <leader>r :e  <C-R>=expand("%")<CR><CR>
nmap <leader>R :e! <C-R>=expand("%")<CR><CR>

" Show undo tree
"nmap <silent> <leader>u :MundoToggle<CR>

" Fuzzy find files
nnoremap <silent> <C-p> :FZF<CR>
" }}}

" Text, tab and indent related {{{

" Use spaces instead of tabs
set expandtab

" 1 tab == 2 spaces, unless the file is already
" using tabs, in which case tabs will be inserted.
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" }}}

" Moving around, tabs, windows, buffers {{{

" Return to last edit position when opening files (You want this!)
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END

" }}}

" Status line {{{

" Always show the status line
set laststatus=2

" }}}

" NERDTree {{{

" Close nerdtree after a file is selected
let NERDTreeQuitOnOpen = 1

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! ToggleFindNerd()
  if IsNERDTreeOpen()
    exec ':NERDTreeToggle'
  else
    exec ':NERDTreeFind'
  endif
endfunction

" If nerd tree is closed, find current file, if open, close it
nmap <silent> <leader>f <ESC>:call ToggleFindNerd()<CR>
nmap <silent> <leader>F <ESC>:NERDTreeToggle<CR>

" }}}

" Alignment {{{

"" Stop Align plugin from forcing its mappings on us
"let g:loaded_AlignMapsPlugin=1
"" Align on equal signs
"map <Leader>a= :Align =<CR>
"" Align on commas
"map <Leader>a, :Align ,<CR>
"" Align on pipes
"map <Leader>a<bar> :Align <bar><CR>
"" Prompt for align character
"map <leader>ap :Align
"" }}}

" Completion {{{
set completeopt+=longest

" Use buffer words as default tab completion
let g:SuperTabDefaultCompletionType = '<c-x><c-p>'

" }}}
