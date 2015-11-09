" vimrc
" Eduardo San Martin Morote
" http://posva.net
" foldmethod=maker foldmarker={,}

" Plugin loading {
  source ~/dotfiles/vim-plugins.vim
" }

" General options {

  " Theme {

    " Nice theme are mustang, vitamins, 256-..., peaksea,
    " ir_black, xoria256

    let themes = ['solarized', 'mustang', 'vitamins', '256-grayvim', '256-jungle', 'peaksea', 'xoria256', 'ir_black', 'Tomorrow-Night-Bright']

    set background=dark
    colorscheme solarized
    "execute 'colorscheme '.themes[localtime() % len(themes)]
    unlet themes

  " }


  " Editing  & encoding {
    set nu " Show number lines
    set cursorline

    syntax on " syntax highlight

    au BufReadPost * call CheckRo()
    set encoding=utf-8

    " Can delete previously edited text
    set backspace=indent,eol,start

    set langmenu=en_US.UTF-8 " sets the language of the menu (gvim)
    "language en_US.UTF-8  " sets the language of the messages / ui (vim)

    " "Give me some space" said the cursor
    set scrolloff=15

    set mouse=a " mouse is so usefull if well used

    " Gotta go fast
    set ttyfast
    set lazyredraw

    set list
    set listchars=tab:›\ ,trail:●,extends:#,nbsp:.

    " relative line numbers
    autocmd BufLeave * set norelativenumber
    autocmd BufLeave * set number
    autocmd BufEnter * set relativenumber
    autocmd InsertEnter * set norelativenumber
    autocmd InsertEnter * set number
    autocmd InsertLeave * set relativenumber

    " makes * and # work on visual mode too.
    function! s:VSetSearch(cmdtype)
      let temp = @s
      norm! gv"sy
      let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
      let @s = temp
    endfunction

    xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
    xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

    " recursively vimgrep for word under cursor or selection if you hit leader-star
    nmap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
    vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>

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

  " tmux fix (background color erase)
  set t_ut=

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
    let javaScript_fold=1         " JavaScript
    let perl_fold=1               " Perl
    let php_folding=1             " PHP
    let r_syntax_folding=1        " R
    let ruby_fold=1               " Ruby
    let sh_fold_enabled=1         " sh
    let vimsyn_folding='af'       " Vim script
    let xml_syntax_folding=1      " XML
    " }

" }

" Specific config for files {
  autocmd BufRead,BufNewFile *.c,*.h setlocal shiftwidth=8 softtabstop=8 ft=c
  autocmd BufRead,BufNewFile *.md setlocal syntax=markdown filetype=markdown
  autocmd BufRead,BufNewFile *.java setlocal shiftwidth=4 softtabstop=4
  autocmd BufRead,BufNewFile *.cpp,*.hpp,*.js,*.php setlocal shiftwidth=4 softtabstop=4
  autocmd BufRead,BufNewFile *.html,*.css,*.js setlocal shiftwidth=2 softtabstop=2
  autocmd BufNewFile,BufReadPost *.styl set filetype=stylus

  autocmd FileType make     set noexpandtab shiftwidth=8
  autocmd BufRead,BufNewFile .gitconfig setlocal shiftwidth=8 softtabstop=8
  autocmd FileType asm call AsmSyntax()
  function AsmSyntax()
      syntax match asmComment "\/\*\_.\{-}\*\/" "\/\/.*"
      syntax match asmComment "\/\/.*"
  endfunction
" }

" Tabular {
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

" sessionman {
  set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
  nmap <leader>sl :SessionList<CR>
  nmap <leader>ss :SessionSave<CR>
  nmap <leader>sc :SessionClose<CR>
" }

" JSON {
  nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
" }

" js-doc {
  let g:jsdoc_allow_input_prompt=1
  let g:jsdoc_default_mapping=0
" }

" lightline.vim {
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'readonly': 'LightLineReadonly',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
        return strlen(_) ? ' '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp,*.js,*.coffee call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

set noshowmode
" }

" HTML {
  autocmd BufRead,BufNewFile *.html,*.css, setlocal shiftwidth=2 softtabstop=2
  " Make it so AutoCloseTag works for xml and xhtml files as well
  au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
  "TODO
  nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" Autocompletion {
if has("lua") && v:version >= 740
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
  if v:version >= 702
    nmap <F8> :TagbarToggle<CR>
  endif
" }

" Indent guide plugin {
  if exists('*matchadd')
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    hi IndentGuidesOdd ctermbg=0
    hi IndentGuidesEven ctermbg=8
  endif
" }

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

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
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'ervandew/supertab'
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_register_as_syntastic_checker = 0
" Disable preview scratch
set completeopt=menu,menuone

" Syntastic plugin for compilation errors {
"let g:syntastic_java_javac_classpath="src\nlib/gui.jar\n/usr/share/java/junit4.jar\n/Applications/eclipse/plugins/org.junit_4.11.0.v201303080030/junit.jar\n/usr/local/eclipse-3.2.6/plugins/org.junit_4.8.1.v4_8_1_v20100427-1100/junit.jar"
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_include_dirs = [ 'src', '../src', '../include', 'include' ]
let g:syntastic_c_include_dirs = [ 'src', '../src', '../include', 'include' ]
let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -O2 -std=c++11'
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
" }

" python3 Syntax {
let g:syntastic_python_checkers = ['python', 'python3']
let g:syntastic_python_python_exec = 'python3'
" }

" gitgutter {
" prevent  running after every modification
let g:gitgutter_realtime = 0
" }

" NERD Tree {
"Open NerdTree with Ctrl+H
nmap <C-H> :NERDTreeToggle<CR>
" Autoclose vim when only NerdTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open Nerdtree when nothing is opened
" autocmd vimenter * if !argc() | NERDTree | endif
" }

" NERD commenter {
map <F5> <leader>c<space>
" }

" SQL dbext.vim {
if (filereadable("~/dotfiles/db.vim"))
  source ~/dotfiles/db.vim
endif
" }

" jsbeautify {
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
" }

" Rainbow parantheses {
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" }

"Ctrl-P {
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

" Utility commands {
command Spaces %s/\s\+$\|\t\+$//g
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

" common typing mistakes
ab teh the
ab fro for

" Some remapping
imap hh <ESC>
" }

" LATEX {

command Pdf w | execute '!latex % && dvipdf %:r.dvi && okular %:r.pdf &'
command Latex w | execute '!latex % && dvipdf %:r.dvi'
" }

" FUNCTIONS {

  function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
    let ft=toupper(a:filetype)
    let group='textGroup'.ft
    if exists('b:current_syntax')
      let s:current_syntax=b:current_syntax
      " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
      " do nothing if b:current_syntax is defined.
      unlet b:current_syntax
    endif
    execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
    try
      execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
      let b:current_syntax=s:current_syntax
    else
      unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.ft.'
    \ matchgroup='.a:textSnipHl.'
    \ start="'.a:start.'" end="'.a:end.'"
    \ contains=@'.group
  endfunction

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

" Local config file {
if filereadable(".vim-local.vim")
  source .vim-local.vim
endif
" }
