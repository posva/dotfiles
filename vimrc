" vimrc
" Eduardo San Martin Morote
" http://posva.net

" General options {

  " Editing  & encoding {
    set nu " Show number lines

    au BufReadPost * call CheckRo()
    set encoding=utf-8
    "
    " Can delete previously edited text
    set backspace=indent,eol,start

    set langmenu=en_US.UTF-8 " sets the language of the menu (gvim)
    language en_US.UTF-8  " sets the language of the messages / ui (vim)

    " "Give me some space" said the cursor
    set scrolloff=15

  " }

  " Indentation {

    set expandtab " uses spaces by default
    set shiftwidth=2
    set softtabstop=2
    set ignorecase " Do case in sensitive matching with
    set smartcase " be sensitive when there's a capital letter

    set smartindent " smart code indentation

    set smarttab " smart tabs

  " }

  " make command should do make
  set makeprg=make

  " Backup dir to keep your working dir clean
  set backup
  set backupdir=~/.vim/backup
  set dir=~/.vim/backup

  " Be polite!
  set confirm

  "show parial pattern matches in real time
  set incsearch
  " I like highlighted search pattern
  set hlsearch
  "display folders ( sympathie with the devil )
  "set foldcolumn=1

  " Disable ex mode
  map Q <Nop>


  " Key Remapping {

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Use , instead of \
    let mapleader = ','

    " Disable arrow keys
    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>

    " Stop acting dumb when pasting
    nnoremap <F2> :set invpaste paste?<CR>
    set pastetoggle=<F2>
    set showmode

  " }

    " Folding {
    set foldmethod=syntax
    noremap <F9> <C-O>za
    nnoremap <F9> za
    onoremap <F9> <C-C>za
    vnoremap <F9> zf
    set foldlevelstart=1
    " }

" }

" Specific config for files {
autocmd BufRead,BufNewFile *.c,*.h setlocal shiftwidth=8 softtabstop=8 ft=c
autocmd BufRead,BufNewFile *.md setlocal syntax=markdown filetype=markdown
autocmd BufRead,BufNewFile *.java setlocal shiftwidth=4 softtabstop=4
autocmd BufRead,BufNewFile *.cpp,*.hpp,*.js,*.php setlocal shiftwidth=4 softtabstop=4
autocmd BufRead,BufNewFile *.html,*.css, setlocal shiftwidth=2 softtabstop=2
autocmd FileType make     set noexpandtab shiftwidth=8
autocmd BufRead,BufNewFile .gitconfig setlocal shiftwidth=8 softtabstop=8
autocmd FileType asm call AsmSyntax()
function AsmSyntax()
    syntax match asmComment "\/\*\_.\{-}\*\/" "\/\/.*"
    syntax match asmComment "\/\/.*"
endfunction
" }

" Init options for vundle {
  set nocompatible
  filetype off

  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
" }

" Vundle and main plugins {
  Bundle 'gmarik/vundle'
  Bundle "MarcWeber/vim-addon-mw-utils"
  Bundle "tomtom/tlib_vim"

  " For vundle to work
  filetype plugin indent on " required!
  syntax on " syntax highlighting

" }

" Mines {
  Bundle 'posva/Rndm'
  Bundle 'vim-scripts/Mines'
" }


let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML

" Colorschemes {
  Bundle 'croaker/mustang-vim'
  Bundle 'fmoralesc/vim-vitamins'
  Bundle 'flazz/vim-colorschemes'
  "Bundle 'altercation/vim-colors-solarized'
  "Bundle 'spf13/vim-colors'

  " Nice theme are  monokai, mustang, vitamins, 256-..., peaksea,
  " ir_black, xoria256

  let themes = ['monokai', 'mustang', 'vitamins', '256-grayvim', '256-jungle', 'peaksea', 'xoria256', 'ir_black']

  execute 'colorscheme '.themes[localtime() % len(themes)]
  unlet themes

" }

" Align text with tabular {
  Bundle 'godlygeek/tabular'
  nmap <leader>a& :Tabularize /&<CR>
  vmap <leader>a& :Tabularize /&<CR>
  nmap <leader>a= :Tabularize /=<CR>
  vmap <leader>a= :Tabularize /=<CR>
  nmap <leader>a: :Tabularize /:<CR>
  vmap <leader>a: :Tabularize /:<CR>
  nmap <leader>a:: :Tabularize /:\zs<CR>
  vmap <leader>a:: :Tabularize /:\zs<CR>
  nmap <leader>a, :Tabularize /,<CR>
  vmap <leader>a, :Tabularize /,<CR>
  nmap <leader>a,, :Tabularize /,\zs<CR>
  vmap <leader>a,, :Tabularize /,\zs<CR>
  nmap <leader>a<Bar> :Tabularize /<Bar><CR>
  vmap <leader>a<Bar> :Tabularize /<Bar><CR>
" }

" Sessions are good {
  Bundle 'vim-scripts/sessionman.vim'
  set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
  nmap <leader>sl :SessionList<CR>
  nmap <leader>ss :SessionSave<CR>
  nmap <leader>sc :SessionClose<CR>
" }

" JSON {
  nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
" }

" Airline iformation about the file in bottom line {
  Bundle 'bling/vim-airline'
  let g:airline_left_sep = ''
  set laststatus=2
  let g:airline_right_sep = ''
  let g:airline_detect_modified = 1
  let g:airline_detect_paste = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#branch#empty_message = ''
  let g:airline#extensions#whitespace#checks = [ 'indent' ]
" }

" shell within vim {
  " Do make after installing this plugin
  if version >= 700
    Bundle 'Shougo/vimproc.vim'
    Bundle 'Shougo/vimshell.vim'
    nmap <leader>s :VimShell<CR>
  endif
" }

" Javascript {
  Bundle 'elzr/vim-json'
  Bundle 'groenewege/vim-less'
  Bundle 'pangloss/vim-javascript'
  Bundle 'briancollins/vim-jst'
  Bundle 'kchmck/vim-coffee-script'
" }

" HTML {
  Bundle 'amirh/HTML-AutoCloseTag'
  Bundle 'hail2u/vim-css3-syntax'
  Bundle 'tpope/vim-haml'

  autocmd BufRead,BufNewFile *.html,*.css, setlocal shiftwidth=2 softtabstop=2
  " Make it so AutoCloseTag works for xml and xhtml files as well
  au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
  nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" PHP {
  Bundle 'spf13/PIV'
  Bundle 'arnaud-lb/vim-php-namespace'
  let g:DisableAutoPHPFolding = 0
  let g:PIVAutoClose = 0
" }

" Insert missing }])"' etc. Press <C-c> for new line
Bundle 'Raimondi/delimitMate'
imap <C-c> <CR><Esc>O

" Autocompletion {
if !has("lua")
  Bundle 'Shougo/neocomplete.vim'
  " Config {
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1

    " SuperTab like snippets behavior.
    imap <silent><expr><TAB> neosnippet#expandable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
          \ "\<C-e>" : "\<TAB>")
    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
          \ 'default' : '',
          \ 'vimshell' : $HOME.'/.vimshell_hist',
          \ 'scheme' : $HOME.'/.gosh_completions'
          \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    inoremap <expr><C-g> neocomplete#undo_completion()
    inoremap <expr><C-l> neocomplete#complete_common_string()
    inoremap <expr><CR> neocomplete#complete_common_string()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

    " <CR>: close popup
    " <s-CR>: close popup and save indent.
    inoremap <expr><s-CR> pumvisible() ? neocomplete#close_popup()"\<CR>" : "\<CR>"
    inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y> neocomplete#close_popup()
  " }

  if version >= 700
    Bundle 'Shougo/neosnippet'
    Bundle 'Shougo/neosnippet-snippets'
    Bundle 'honza/vim-snippets'
  endif

else
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
endif
" }

" TagBar {
  if version >= 702
    Bundle 'majutsushi/tagbar'
  endif
" }

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

" Omni completion  when you don't have neocompl {
"  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" }

" Prevent YCM conflict
"imap <C-J> <esc>a<Plug>snipMateNextOrTrigger
"smap <C-J> <Plug>snipMateNextOrTrigger
"let g:ycm_key_list_select_completion = []

" C/C++ completion with YCM
" This plugin include these plugins:
" clang_complete
" AutoComplPop
" Supertab
" neocomplcache
" REMEMBER TO COMPILE THIS PLUGIN!
" cd ~/.vim/bundle/YouCompleteMe
" ./install.sh --clang-completer
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'ervandew/supertab'
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_register_as_syntastic_checker = 0
" Disable preview scratch
set completeopt=menu,menuone

" Syntastic plugin for compilation errors
" REMEMBER TO CREATE THE FILE .ycm_extra_config.py
Bundle 'scrooloose/syntastic'
let g:syntastic_java_javac_classpath="src\nlib/gui.jar\n/usr/share/java/junit4.jar\n/Applications/eclipse/plugins/org.junit_4.11.0.v201303080030/junit.jar\n/usr/local/eclipse-3.2.6/plugins/org.junit_4.8.1.v4_8_1_v20100427-1100/junit.jar"
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_include_dirs = [ 'src', '../src', '../include', 'include' ]
let g:syntastic_c_include_dirs = [ 'src', '../src', '../include', 'include' ]
let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -O2 -std=c++11'
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1

" git addtitions and deletions
Bundle 'airblade/vim-gitgutter'
let g:gitgutter_realtime = 0

" Java IDE
"Bundle 'vim-scripts/Vim-JDE'
Bundle 'vim-scripts/javacomplete'

" Bash within vim
Bundle 'basepi/vim-conque'

" NERD Tree
Bundle 'scrooloose/nerdtree'
"Open NerdTree with Ctrl+N
map <C-N> :NERDTreeToggle<CR>
" Autoclose vim when only NerdTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open Nerdtree when nothing is opened
" autocmd vimenter * if !argc() | NERDTree | endif

" NERD commenter
Bundle 'scrooloose/nerdcommenter'
map <F5> <leader>c<space>

" Markdown
Bundle 'plasticboy/vim-markdown'

" SQL
Bundle 'vim-scripts/dbext.vim'

" Surrounding, just awesome
Bundle 'tpope/vim-surround'

" Rainbow parantheses
Bundle 'kien/rainbow_parentheses.vim'
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"Ctrl-P open fast files {
  Bundle 'kien/ctrlp.vim'
  let g:ctrlp_working_path_mode = 'ra'
  nnoremap <silent> <D-t> :CtrlP<CR>
  nnoremap <silent> <D-r> :CtrlPMRU<CR>
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

  " On Windows use "dir" as fallback command.
  if has('win32') || has('win64')
    let g:ctrlp_user_command = {
          \ 'types': {
          \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
          \ 2: ['.hg', 'hg --cwd %s locate -I .'],
          \ },
          \ 'fallback': 'dir %s /-n /b /s /a-d'
          \ }
  else
    let g:ctrlp_user_command = {
          \ 'types': {
          \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
          \ 2: ['.hg', 'hg --cwd %s locate -I .'],
          \ },
          \ 'fallback': 'find %s -type f'
          \ }
  endif
"}

" TODO neocomplcache

" numbers: better line numbers {
Bundle 'myusuf3/numbers.vim'
"}

" A plugin for automatically restoring file's cursor position and folding
Bundle 'vim-scripts/restore_view.vim'

" Utility commands {
command Spaces %s/ \+$//g
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
" }

" LATEX {
command Accent %s/é/\\'{e}/ge | %s/è/\\`{e}/ge | %s/ê/\\^{e}/ge | %s/ë/\\"{e}/ge | %s/à/\\`{a}/ge | %s/â/\\^{a}/ge | %s/î/\\^{i}/ge | %s/ï/\\"{i}/ge | %s/ö/\\"{o}/ge | %s/ô/\\^{o}/ge | %s/ù/\\`{u}/ge | %s/û/\\^{u}/ge | %s/ü/\\"{u}/ge | %s/ç/\\c{c}/ge

command Pdf execute 'Accent' | w | execute '!latex % && dvipdf %:r.dvi && okular %:r.pdf &'
command Latex execute 'Accent' | w | execute '!latex % && dvipdf %:r.dvi'
" }

" FUNCTIONS {

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

  function CheckRo()
    if ! (&readonly)
      set fileencoding=utf-8
    endif
  endfunction

  " Returns true if paste mode is enabled
  function! HasPaste()
    if &paste
      return 'PASTE MODE  '
    end
    return ''
  endfunction

  " Automatically create the directories we need
  function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
          \ 'backup': 'backupdir',
          \ 'views': 'viewdir',
          \ 'swap': 'directory' }

    if has('persistent_undo')
      let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
      let directory = common_dir . dirname . '/'
      if exists("*mkdir")
        if !isdirectory(directory)
          call mkdir(directory)
        endif
      endif
      if !isdirectory(directory)
        echo "Warning: Unable to create backup directory: " . directory
        echo "Try: mkdir -p " . directory
      else
        let directory = substitute(directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . directory
      endif
    endfor
  endfunction
  call InitializeDirectories()

  " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " Restore cursor to file position in previous editing session
  " To disable this, add the following to your .vimrc.before.local file:
  "   let g:spf13_no_restore_cursor = 1
  function! ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction

  augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
  augroup END

" }

