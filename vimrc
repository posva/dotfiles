" vimrc
" Eduardo San Martin Morote
" Based on https://github.com/spf13/spf13-vim
" It's like a copy but reordered and with some modifications
" http://posva.net
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker

" Environment {

    " Basics {
        set nocompatible        " Must be first line
        if !(has('win16') || has('win32') || has('win64'))
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Setup Bundle Support {
        " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype on
        filetype off
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }

" }

" Bundles {
  " Deps {
    Bundle 'gmarik/vundle'
    Bundle 'MarcWeber/vim-addon-mw-utils'
    Bundle 'tomtom/tlib_vim'
    if executable('ag')
      Bundle 'mileszs/ack.vim'
      let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
    elseif executable('ack-grep')
      let g:ackprg="ack-grep -H --nocolor --nogroup --column"
      Bundle 'mileszs/ack.vim'
    elseif executable('ack')
      Bundle 'mileszs/ack.vim'
    endif
  "}

  " General {
    Bundle 'scrooloose/nerdtree'
    Bundle 'tpope/vim-surround'
    Bundle 'spf13/vim-autoclose'
    Bundle 'kien/ctrlp.vim'
    Bundle 'terryma/vim-multiple-cursors'
    Bundle 'vim-scripts/sessionman.vim'
    " Matching (
    Bundle 'tsaleh/vim-matchit'
    Bundle 'bling/vim-airline'
    Bundle 'bling/vim-bufferline'
    " Better motions
    Bundle 'Lokaltog/vim-easymotion'
    " Make gvim-only colorschemes work transparently in terminal vim
    Bundle 'godlygeek/csapprox'
    " See undo as a tree
    Bundle 'mbbill/undotree'
    Bundle 'myusuf3/numbers.vim'
    Bundle 'nathanaelkane/vim-indent-guides'
    " A plugin for automatically restoring file's cursor position and folding
    Bundle 'vim-scripts/restore_view.vim'
    " Better gitgutter
    Bundle 'mhinz/vim-signify'
    " easy search, substitute and abbreviate
    Bundle 'tpope/vim-abolish.git'
    "substitute preview
    Bundle 'osyo-manga/vim-over'
    Bundle 'justinmk/vim-sneak'
  " }

  " General Programming {
  " Syntax check
    Bundle 'scrooloose/syntastic'
    " Git
    Bundle 'tpope/vim-fugitive'
    " For the web
    Bundle 'mattn/webapi-vim'
    " Gists
    Bundle 'mattn/gist-vim'
    " Commenter
    Bundle 'scrooloose/nerdcommenter'
    " Align text
    Bundle 'godlygeek/tabular'
    if executable('ctags')
      " Show tags in a split
      Bundle 'majutsushi/tagbar'
    endif
  " }

  " Snippets & Autocomplete {
    Bundle 'Shougo/neocomplete.vim.git'
    Bundle 'Shougo/neosnippet'
    Bundle 'honza/vim-snippets'
  " }

  " Colorschemes {
    Bundle 'croaker/mustang-vim'
    Bundle 'fmoralesc/vim-vitamins'
    Bundle 'flazz/vim-colorschemes'
    Bundle 'altercation/vim-colors-solarized'
    Bundle 'spf13/vim-colors'
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
  " }

  " PHP {
    Bundle 'spf13/PIV'
    Bundle 'arnaud-lb/vim-php-namespace'
  " }

  " Java {
    Bundle 'derekwyatt/vim-scala'
    Bundle 'derekwyatt/vim-sbt'
  " }

  " Misc {
    Bundle 'plasticboy/vim-markdown'
    Bundle 'spf13/vim-preview'
    Bundle 'tpope/vim-cucumber'
    Bundle 'quentindecock/vim-cucumber-align-pipes'
    Bundle 'Puppet-Syntax-Highlighting'
  " }

  " SQL {
    Bundle 'vim-scripts/dbext.vim'
  " }

" Rainbow parantheses {
  Bundle 'kien/rainbow_parentheses.vim'
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
  " }

" }

" Encoding & language {
    function CheckRo()
      if ! (&readonly)
        set fileencoding=utf-8
      endif
    endfunction

    au BufReadPost * call CheckRo()
    set encoding=utf-8
    scriptencoding utf-8

    set langmenu=en_US.UTF-8 " sets the language of the menu (gvim)
    language en_US.UTF-8  " sets the language of the messages / ui (vim)

" }

" General {

    set background=dark         " Assume a dark background
    if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

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

    " Setting up the directories {
        set backup                  " Backups are nice ...
        " if has('persistent_undo')
        "     set undofile                " So is persistent undo ...
        "     set undolevels=1000         " Maximum number of changes that can be undone
        "     set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        " endif

          " Add exclusions to mkview and loadview
          " eg: *.*, svn-commit.tmp
          let g:skipview_files = [
              \ '\[example pattern\]'
              \ ]
    " }

" }

" Vim UI {

    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        color solarized             " Load a colorscheme
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F2>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

  set nu                          " Line numbers on
" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location.
    let mapleader = ','

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select (over written
    " below) modes
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Over write the Visual+Select mode mappings to ensure correct mode is
    " passed to WrapRelativeMotion
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_fastTabs = 1
    if !exists('g:spf13_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
    "   let g:spf13_clear_search_highlight = 1
    if exists('g:spf13_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }

" Config for specific files types {

  autocmd BufRead,BufNewFile *.c,*.h setlocal shiftwidth=4 tabstop=4 softtabstop=4 ft=c noexpandtab
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

  autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" }

" Misc {
  set makeprg=make " make command

  set confirm " Vim is polite

  map Q <Nop> " No exmode

  " <Ctrl-l> redraws the screen and removes any search highlighting.
  nnoremap <silent> <C-l> :nohl<CR><C-l>

  noremap <F9> <C-O>za
  nnoremap <F9> za
  onoremap <F9> <C-C>za
  vnoremap <F9> zf

  command Spaces %s/ \+$//g " Use :Spaces to remove trailing spaces
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

  " LATEX {
    command Accent %s/é/\\'{e}/ge | %s/è/\\`{e}/ge | %s/ê/\\^{e}/ge | %s/ë/\\"{e}/ge | %s/à/\\`{a}/ge | %s/â/\\^{a}/ge | %s/î/\\^{i}/ge | %s/ï/\\"{i}/ge | %s/ö/\\"{o}/ge | %s/ô/\\^{o}/ge | %s/ù/\\`{u}/ge | %s/û/\\^{u}/ge | %s/ü/\\"{u}/ge | %s/ç/\\c{c}/ge

    command Pdf execute 'Accent' | w | execute '!latex % && dvipdf %:r.dvi && okular %:r.pdf &'
    command Latex execute 'Accent' | w | execute '!latex % && dvipdf %:r.dvi'
  " }

  " Automatically open and close the popup menu / preview window
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  set completeopt=menu,preview,longest

" }

" Plugins Config {
  " Airline {
    " set laststatus=2
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    " let g:airline_detect_modified = 1
    " let g:airline_detect_paste = 1
    " let g:airline#extensions#branch#enabled = 1
    " let g:airline#extensions#branch#empty_message = ''
    " let g:airline#extensions#whitespace#checks = [ 'indent' ]
  " }

  " SQL {
    source ~/dotfiles/db.vim
  " }

  " Indent guide plugin {
    let g:indent_guides_enable_on_vim_startut = 1
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#212121 ctermbg=3
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#404040 ctermbg=4
    " hi IndentGuidesOdd ctermbg=234
    " hi IndentGuidesEven ctermbg=235
  " }

  " Snippets! {
    let g:snips_author = 'Eduardo San Martin Morote <i@posva.net>'
    "let g:ycm_key_list_select_completion = []
  " }

  " AutoCloseTag {
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nmap <Leader>ac <Plug>ToggleAutoCloseMappings
  " }

  " PIV {
    let g:DisableAutoPHPFolding = 0
    let g:PIVAutoClose = 0
  " }

  " OmniComplete {
    if has("autocmd") && exists("+omnifunc")
      autocmd Filetype *
            \if &omnifunc == "" |
            \setlocal omnifunc=syntaxcomplete#Complete |
            \endif
    endif

    hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    " Some convenient mappings
    inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

    " Automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menu,preview,longest
  " }

  " Ctags {
    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
      let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
  " }

  " Syntastic {
    let g:syntastic_java_javac_classpath="src\nlib/gui.jar\n/usr/share/java/junit4.jar\n/Applications/eclipse/plugins/org.junit_4.11.0.v201303080030/junit.jar\n/usr/local/eclipse-3.2.6/plugins/org.junit_4.8.1.v4_8_1_v20100427-1100/junit.jar"
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_cpp_include_dirs = [ 'src', '../src', '../include', 'include' ]
    let g:syntastic_c_include_dirs = [ 'src', '../src', '../include', 'include' ]
    let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -O2 -std=c++11'
    let g:syntastic_check_on_open = 1
    let g:syntastic_enable_signs = 1
  " }

  " NERD Tree {
    "Open NerdTree with Ctrl+N
    map <C-N> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
    map <leader>e :NERDTreeFind<CR>

    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    let g:nerdtree_tabs_open_on_gui_startup=0

    let g:NERDShutUp=1
    let b:match_ignorecase = 1
  " }

  " NERD commenter {
    map <F5> <leader>c<space>
  " }

  " Tabularize {
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
  " }

  " Session List {
    set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    nmap <leader>sl :SessionList<CR>
    nmap <leader>ss :SessionSave<CR>
    nmap <leader>sc :SessionClose<CR>
  " }

  " JSON {
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
  " }

  " ctrlp {
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

  " TagBar {
    nnoremap <silent> <leader>tt :TagbarToggle<CR>

    " If using go please install the gotags program using the following
    " go install github.com/jstemmer/gotags
    " And make sure gotags is in your path
    let g:tagbar_type_go = {
          \ 'ctagstype' : 'go',
          \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
          \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
          \ 'r:constructor', 'f:functions' ],
          \ 'sro' : '.',
          \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
          \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
          \ 'ctagsbin'  : 'gotags',
          \ 'ctagsargs' : '-sort -silent'
          \ }
  "}

  " neocomplete {
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

    " Plugin key-mappings {
    " These two lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_neosnippet_expand = 1
    if !exists('g:spf13_no_neosnippet_expand')
      imap <C-k> <Plug>(neosnippet_expand_or_jump)
      smap <C-k> <Plug>(neosnippet_expand_or_jump)
    endif

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

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
      autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

    " Use honza's snippets.
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

    " Enable neosnippet snipmate compatibility mode
    let g:neosnippet#enable_snipmate_compatibility = 1

    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif

    " Disable the neosnippet preview candidate window
    " When enabled, there can be too much visual noise
    " especially when splits are used.
    set completeopt-=preview

  " }

  " UndoTree {
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
  " }

" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if has("gui_gtk2")
            set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
        elseif has("gui_mac")
            set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
        elseif has("gui_win32")
            set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
        if has('gui_macvim')
            set transparency=5      " Make the window slightly transparent
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

  " fill rest of line with characters {
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
  "}

" Initialize directories {
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
  " }

  " fill rest of line with characters {
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
  " }

  " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
      redir => bufoutput
      buffers!
      redir END
      let idx = stridx(bufoutput, "NERD_tree")
      if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
      endif
  endfunction
  " }

  function DC()
      let c=nr2char(getchar())|return c=~'\s'?'':c
  endfunction

  function D2H(nr)
      let n = a:nr
      let r = ""
      while n
          let r = '0123456789ABCDEF'[n % 16] . r
          let n = n / 16
      endwhile
      return r
  endfunction

  " Shell command {
    function! s:RunShellCommand(cmdline)
      botright new

      setlocal buftype=nofile
      setlocal bufhidden=delete
      setlocal nobuflisted
      setlocal noswapfile
      setlocal nowrap
      setlocal filetype=shell
      setlocal syntax=shell

      call setline(1, a:cmdline)
      call setline(2, substitute(a:cmdline, '.', '=', 'g'))
      execute 'silent $read !' . escape(a:cmdline, '%#')
      setlocal nomodifiable
      1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
  " }

" }

" Find merge conflict markers (not folded because it makes it bug
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

