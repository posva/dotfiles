
set nu " Show number lines

" Default indentation
set expandtab
set shiftwidth=2
set softtabstop=2

set encoding=utf-8
set fileencoding=utf-8

"Can delete old text
set backspace=indent,eol,start

set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)
language en_US.UTF-8                 " sets the language of the messages / ui (vim)

set ignorecase  " Do case in sensitive matching with
set smartcase   " be sensitive when there's a capital letter

set smartindent   " smart code indentation

set smarttab      " smart tabs
" gg=G pour reindenter tout un fichier.

" Specific config for files
autocmd BufRead,BufNewFile *.c,*.h setlocal shiftwidth=8 softtabstop=8
autocmd BufRead,BufNewFile *.md setlocal syntax=markdown
autocmd BufRead,BufNewFile *.cpp,*.hpp,*.js,*.php setlocal shiftwidth=4 softtabstop=4
autocmd BufRead,BufNewFile *.html,*.css, setlocal shiftwidth=2 softtabstop=2
autocmd FileType make     set noexpandtab shiftwidth=8
autocmd BufRead,BufNewFile .gitconfig setlocal shiftwidth=8 softtabstop=8
autocmd FileType asm call AsmSyntax()
function AsmSyntax()
    syntax match asmComment "\/\*\_.\{-}\*\/" "\/\/.*"
    syntax match asmComment "\/\/.*"
endfunction

" Backup dir to keep your working dir clean
set backupdir=~/.vim/backup
set dir=~/.vim/backup

"5 lignes au dessus et en dessous pour les recherches
set scrolloff=5

"vim reste polit quand il quitte
set confirm

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
<<<<<<< HEAD
Bundle "daylerees/colour-schemes", { "rtp": "vim-themes/" }
Bundle 'sickill/vim-monokai'
Bundle 'airblade/vim-gitgutter'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'ervandew/supertab'
Bundle 'bling/vim-airline'
" YCM have already this ^
"
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'Rip-Rip/clang_complete'
" YCM have this too ^. It need to be installed then desactivated here and it
" works without errors
" Java
"Bundle 'vim-scripts/Vim-JDE'
=======
>>>>>>> master

filetype plugin indent on     " required!
syntax on         " syntax highlighting

" Folding
set foldmethod=syntax
noremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf
"set foldlevelstart=1

let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML

" Airline
let g:airline_left_sep = ''
set laststatus=2
let g:airline_right_sep = ''
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#whitespace#checks = [ 'indent' ]

colorscheme molokai
"set background=dark

<<<<<<< HEAD
"let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_auto_colors = 0
"hi IndentGuidesOdd ctermbg=234
"hi IndentGuidesEven ctermbg=235

=======
" Airline iformation about the file in bottom line
Bundle 'bling/vim-airline'
let g:airline_left_sep = ''
set laststatus=2
let g:airline_right_sep = ''
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#whitespace#checks = [ 'indent' ]
>>>>>>> master

"show parial pattern matches in real time
set incsearch
" I like highlighted search pattern
set hlsearch
"display folders ( sympathie with the devil )
"set foldcolumn=1


" Indent guide plugin
Bundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd ctermbg=234
hi IndentGuidesEven ctermbg=235

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>
map <F3> o\begin{equation*}<ESC>o\begin{split}<ESC>o\end{split}<ESC>o\end{equation*}<ESC>kO

" fill rest of line with characters
function! FillLine( str, l )
  " set tw to the desired total length
  "let tw = 80
  " strip trailing spaces first
  .s/[[:space:]]*$//
  " calculate total number of 'str's to insert
  let reps = (a:l - col("$")) / len(a:str)
  " insert them, if there's room, removing
  " trailing spaces (though forcing
  " there to be one)
  if reps > 0
    .s/$/\=(repeat(a:str, reps))/
  endif
endfunction

<<<<<<< HEAD
" ===================================================================
" " ASCII Table - | decimal value - name/char |
" "
" " |000 nul|001 soh|002 stx|003 etx|004 eot|005
" enq|006 ack|007 bel|
" " |008 bs |009 ht |010 nl |011 vt |012 np |013 cr
" |014 so |015 si |
" " |016 dle|017 dc1|018 dc2|019 dc3|020 dc4|021
" nak|022 syn|023 etb|
" " |024 can|025 em |026 sub|027 esc|028 fs |029 gs
" |030 rs |031 us |
" " |032 sp |033  ! |034  " |035  # |036  $ |037  %
" |038  & |039  ' |
" " |040  ( |041  ) |042  * |043  + |044  , |045  -
" |046  . |047  / |
" " |048  0 |049  1 |050  2 |051  3 |052  4 |053  5
" |054  6 |055  7 |
" " |056  8 |057  9 |058  : |059  ; |060  < |061  =
" |062  > |063  ? |
" " |064  @ |065  A |066  B |067  C |068  D |069  E
" |070  F |071  G |
" " |072  H |073  I |074  J |075  K |076  L |077  M
" |078  N |079  O |
" " |080  P |081  Q |082  R |083  S |084  T |085  U
" |086  V |087  W |
" " |088  X |089  Y |090  Z |091  [ |092  \ |093  ]
" |094  ^ |095  _ |
" " |096  ` |097  a |098  b |099  c |100  d |101  e
" |102  f |103  g |
" " |104  h |105  i |106  j |107  k |108  l |109  m
" |110  n |111  o |
" " |112  p |113  q |114  r |115  s |116  t |117  u
" |118  v |119  w |
" " |120  x |121  y |122  z |123  { |124  | |125  }
" |126  ~ |127 del|
" "
" "
" ===================================================================
" " ASCII Table - | hex value - name/char |
" "
" " | 00 nul| 01 soh| 02 stx| 03 etx| 04 eot| 05 enq|
" 06 ack| 07 bel|
" " | 08 bs | 09 ht | 0a nl | 0b vt | 0c np | 0d cr |
" 0e so | 0f si |
" " | 10 dle| 11 dc1| 12 dc2| 13 dc3| 14 dc4| 15 nak|
" 16 syn| 17 etb|
" " | 18 can| 19 em | 1a sub| 1b esc| 1c fs | 1d gs |
" 1e rs | 1f us |
" " | 20 sp | 21  ! | 22  " | 23  # | 24  $ | 25  % |
" 26  & | 27  ' |
" " | 28  ( | 29  ) | 2a  * | 2b  + | 2c  , | 2d  - |
" 2e  . | 2f  / |
" " | 30  0 | 31  1 | 32  2 | 33  3 | 34  4 | 35  5 |
" 36  6 | 37  7 |
" " | 38  8 | 39  9 | 3a  : | 3b  ; | 3c  < | 3d  = |
" 3e  > | 3f  ? |
" " | 40  @ | 41  A | 42  B | 43  C | 44  D | 45  E |
" 46  F | 47  G |
" " | 48  H | 49  I | 4a  J | 4b  K | 4c  L | 4d  M |
" 4e  N | 4f  O |
" " | 50  P | 51  Q | 52  R | 53  S | 54  T | 55  U |
" 56  V | 57  W |
" " | 58  X | 59  Y | 5a  Z | 5b  [ | 5c  \ | 5d  ] |
" 5e  ^ | 5f  _ |
" " | 60  ` | 61  a | 62  b | 63  c | 64  d | 65  e |
" 66  f | 67  g |
" " | 68  h | 69  i | 6a  j | 6b  k | 6c  l | 6d  m |
" 6e  n | 6f  o |
" " | 70  p | 71  q | 72  r | 73  s | 74  t | 75  u |
" 76  v | 77  w |
" " | 78  x | 79  y | 7a  z | 7b  { | 7c  | | 7d  } |
" 7e  ~ | 7f del|
" "
" ===================================================================
"
" vim:set ts=2 tw=80:
=======
" C/C++ completion with YCM
" This plugin include these plugins:
" clang_complete
" AutoComplPop
" Supertab
" neocomplcache
" REMEMBER TO COMPILE THIS PLUGIN!
" cd ~/.vim/bundle/YouCompleteMe
" ./install.sh --clang-completer
Bundle 'Valloric/YouCompleteMe'

" Syntactic plugin for compilation errors
" REMEMBER TO CREATE THE FILE .ycm_extra_config.py
Bundle 'scrooloose/syntastic'


" git addtitions and deletions
Bundle 'airblade/vim-gitgutter'

" Java IDE
Bundle 'vim-scripts/Vim-JDE'

" NERD Tree
Bundle 'scrooloose/nerdtree'
"Open NerdTree with Ctrl+N
map <C-N> :NERDTreeToggle<CR>
" Autoclose vim when only NerdTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open Nerdtree when nothing is opened
autocmd vimenter * if !argc() | NERDTree | endif

" Don't use arrows!
nnoremap   <Up>     <NOP>
nnoremap   <Down>   <NOP>
nnoremap   <Left>   <NOP>
nnoremap   <Right>  <NOP>
>>>>>>> master
