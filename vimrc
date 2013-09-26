
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
autocmd BufRead,BufNewFile *.md setlocal syntax=markdown filetype=markdown
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

colorscheme molokai
"set background=dark

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
"Bundle ' ervandew/supertab'

" Syntactic plugin for compilation errors
" REMEMBER TO CREATE THE FILE .ycm_extra_config.py
Bundle 'scrooloose/syntastic'


" git addtitions and deletions
Bundle 'airblade/vim-gitgutter'
let g:gitgutter_realtime = 0

" Java IDE
"Bundle 'vim-scripts/Vim-JDE'
Bundle 'vim-scripts/javacomplete'

" NERD Tree
Bundle 'scrooloose/nerdtree'
"Open NerdTree with Ctrl+N
map <C-N> :NERDTreeToggle<CR>
" Autoclose vim when only NerdTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open Nerdtree when nothing is opened
autocmd vimenter * if !argc() | NERDTree | endif

" Snippets!
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "garbas/vim-snipmate"
Bundle 'honza/vim-snippets'

" Markdown
Bundle 'plasticboy/vim-markdown'

" Utility commands
command Spaces %s/ \+$//g
map <F5> I// <ESC>
map <F4> O/*  */<ESC>hhi

iab _TIME        <C-R>=strftime("%X")<CR>
iab _DATE        <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
iab _DATES       <C-R>=strftime("%b %d %Y")<CR>
" ISO 8601 format
iab _DATEN       <C-R>=strftime("%F")<CR>
iab _DATEL       <C-R>=strftime("%a %b %d %Z %Y")<CR>
iab _EPOCH       <C-R>=strftime("%s")<CR>

ab #d #define
ab #i #include <.h><Esc>hhi<C-R>=DC()<CR>
ab #b /*********************************************
ab #e *********************************************/
ab #l /*------------------------------------------*/

"common typing mistakes
ab teh the
ab fro for

" LATEX
command Accent %s/é/\\'{e}/ge | %s/è/\\`{e}/ge | %s/ê/\\^{e}/ge | %s/ë/\\"{e}/ge | %s/à/\\`{a}/ge | %s/â/\\^{a}/ge | %s/î/\\^{i}/ge | %s/ï/\\"{i}/ge | %s/ö/\\"{o}/ge | %s/ô/\\^{o}/ge | %s/ù/\\`{u}/ge | %s/û/\\^{u}/ge | %s/ü/\\"{u}/ge | %s/ç/\\c{c}/ge

command Pdf execute 'Accent' | w | execute '!latex % && dvipdf %:r.dvi && okular %:r.pdf &'
command Latex execute 'Accent' | w | execute '!latex % && dvipdf %:r.dvi'  

" FUNCTIONS
fun DC()
    let c=nr2char(getchar())|return c=~'\s'?'':c
endfun

func D2H(nr)
    let n = a:nr
    let r = ""
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunc 
