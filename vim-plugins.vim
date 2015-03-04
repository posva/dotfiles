" Init options for vundle {
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" }

" Vundle and main plugins {
Plugin 'gmarik/Vundle.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
" }

" Editing & Utils {
Plugin 'tpope/vim-repeat'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tomtom/tcomment_vim'
" }

" Mines {
"Plugin 'posva/Rndm'
"Plugin 'vim-scripts/Mines'
" }

" Colorschemes/Themes {
Plugin 'croaker/mustang-vim'
Plugin 'fmoralesc/vim-vitamins'
Plugin 'flazz/vim-colorschemes'
Plugin 'chriskempson/tomorrow-theme'
"Plugin 'altercation/vim-colors-solarized'
"Plugin 'spf13/vim-colors'
" }

" Align text with tabular {
Plugin 'godlygeek/tabular'
" }

" Sessions are good {
Plugin 'vim-scripts/sessionman.vim'
" }

" Airline iformation about the file at bottom {
Plugin 'bling/vim-airline'
" }

" Javascript {
Plugin 'elzr/vim-json'
"Plugin 'groenewege/vim-less'
Plugin 'pangloss/vim-javascript' " indentation and syntax support
Plugin 'briancollins/vim-jst' " indenting and highlighting jst/ejs
Plugin 'kchmck/vim-coffee-script'
Plugin 'mtscout6/vim-cjsx'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'einars/js-beautify'
" }

" HTML {
Plugin 'mattn/emmet-vim'
"Plugin 'amirh/HTML-AutoCloseTag'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'tpope/vim-haml'
" }

" PHP {
"Plugin 'spf13/PIV'
"Plugin 'arnaud-lb/vim-php-namespace'
" }

" Scala {
Plugin 'derekwyatt/vim-scala'
" }

" Autoclose brackets, etc Press <C-c> for new line {
"Plugin 'spf13/vim-autoclose'
" }

" Autocompletion {
if has("lua") && v:version >= 740
  Plugin 'Shougo/neocomplete.vim'
  Plugin 'Shougo/neosnippet'
  Plugin 'Shougo/neosnippet-snippets'
  Plugin 'honza/vim-snippets'
endif
" }

" TagBar (ctags, jsctags, etc) {
if v:version >= 702
  Plugin 'majutsushi/tagbar'
endif
" }

" Indent guide plugin {
if exists('*matchadd')
  Plugin 'nathanaelkane/vim-indent-guides'
endif
" }

" Syntastic plugin for compilation errors {
Plugin 'scrooloose/syntastic'
" }

" git  {
Plugin 'airblade/vim-gitgutter'
" }

" Java IDE {
"Plugin 'vim-scripts/Vim-JDE'
"Plugin 'vim-scripts/javacomplete'
" }

" NERD Tree {
Plugin 'scrooloose/nerdtree'
" }

" NERD commenter {
Plugin 'scrooloose/nerdcommenter'
" }

" Markdown {
Plugin 'plasticboy/vim-markdown'
" }

" SQL {
Plugin 'vim-scripts/dbext.vim'
" }

" Surrounding, just awesome {
Plugin 'tpope/vim-surround'
" }

" Cool surronding character coloring
Plugin 'kien/rainbow_parentheses.vim'

" Ctrl-P ST like {
Plugin 'kien/ctrlp.vim'
" }

" numbers: better line numbers {
if v:version >= 730
  Plugin 'myusuf3/numbers.vim'
endif
"}

" A plugin for automatically restoring file's cursor position and folding
Plugin 'vim-scripts/restore_view.vim'

" Autocompletion {
Plugin 'Valloric/YouCompleteMe'
" }

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on


