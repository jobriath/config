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

" Kill the damned Ex mode.
nnoremap Q <nop>
" Kill non-useful quits.
nnoremap ZZ <nop>

" Clear registers
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor


" Make <c-h> work like <c-h> again (this is a problem with libterm)
if has('nvim')
  nnoremap <BS> <C-w>h
endif

" }}}

" Asynchronous linting engine {{{

"fast syntax checking
"this disables some linters that don't work
let g:ale_linters = {
\   'haskell': ['stack-ghc', 'hlint', 'hdevtools', 'hfmt' ],
\}
let g:ale_haskell_stack_build_options = '--fast --work-dir .stack-work-ale --test --no-run-tests'
"nmap <silent> <A-PageUp> <Plug>(ale_previous_wrap)
"nmap <silent> <A-PageDown> <Plug>(ale_next_wrap)
"nnoremap <A-Enter> :ALEDetail <cr>

" }}}


" {{{ vindent
let g:vindent_motion_OO_prev   = '[=' " jump to prev block of same indent.
let g:vindent_motion_OO_next   = ']=' " jump to next block of same indent.
let g:vindent_motion_more_prev = '[+' " jump to prev line with more indent.
let g:vindent_motion_more_next = ']+' " jump to next line with more indent.
let g:vindent_motion_less_prev = '[-' " jump to prev line with less indent.
let g:vindent_motion_less_next = ']-' " jump to next line with less indent.
let g:vindent_motion_diff_prev = '[;' " jump to prev line with different indent.
let g:vindent_motion_diff_next = '];' " jump to next line with different indent.
let g:vindent_motion_XX_ss     = '[p' " jump to start of the current block scope.
let g:vindent_motion_XX_se     = ']p' " jump to end   of the current block scope.
let g:vindent_object_XX_ii     = 'ii' " select current block.
let g:vindent_object_XX_ai     = 'ai' " select current block + one extra line  at beginning.
let g:vindent_object_XX_aI     = 'aI' " select current block + two extra lines at beginning and end.
let g:vindent_jumps            = 1    " make vindent motion count as a |jump-motion| (works with |jumplist|).
" }}}


" Plugins {{{
 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/vim/plugged')

" Tags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*", "dist"]

" Look and feel
Plug 'vim-scripts/wombat256.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'christoomey/vim-tmux-navigator'

" Text manipulation
Plug 'godlygeek/tabular'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-surround'               " ds(  cs[{
Plug 'jessekelighine/vindent.vim'

" Linters
Plug 'dense-analysis/ale'

" Fuzzy-find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Let there be REST consoles
Plug 'diepm/vim-rest-console'

" LSP+autocomplete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'rhysd/vim-lsp-ale'
" install or update LSPs with :LspInstallServer

call plug#end()

" }}}

" vim-himporter {{{

let g:himporterCreateMappings = 1

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

" Fast-tag stuff {{{

" calls a shell script to dump in all the haskell files
augroup tags
"  au BufWritePost *.hs      silent !init-tags %      " Don't do this---messes up under Mac env. Not sure what I'll miss, tbough.
"  au BufWritePost *.hsc     silent !init-tags %
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

" ALE shouldn't shout in red.
hi SpellBad ctermbg=8

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

"nnoremap <leader>rm :call delete(expand('%')) \| bdelete!<CR>

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
let NERDTreeQuitOnOpen = 0

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

" When editing syntax files, call this function to see what syntax category the cursor is over.
function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction
command! GetSyntaxStack call SynStack()
