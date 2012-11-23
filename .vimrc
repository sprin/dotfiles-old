" sprin's vimrc

" a few preliminaries to allow vundle to load.
" see https://github.com/gmarik/vundle
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" PLUGINS MANAGED BY VUNDLE
"
" original repos on github
" Vundle is a plugin manager. It is the only plugin that needs to be
" manually downloaded, and it will take care of the rest. Go to:
" https://github.com/gmarik/vundle
Bundle 'gmarik/vundle'
" Command-T will allow you to search quickly for files. Must be compiled:
" cd ~/.vim/bundle/Command-T/ruby/command-t/; ruby extconf.rb; make
Bundle 'wincent/Command-T'
" pyflakes does some inline-linting of Python, and will highlight errors.
Bundle 'mitechie/pyflakes-pathogen' 
" csv.vim has a number of nice features for displaying column-separated data.
Bundle 'chrisbra/csv.vim'
" vim-puppet offers syntax highlighting for puppet manifests.
Bundle 'rodjek/vim-puppet'
" Tabular enables easy text-alignment in tables.
Bundle 'godlygeek/tabular'
" vim-notes is as close to Notational Velocity as it gets in vim.
Bundle 'xolox/vim-notes'
" vim-indent-guides will visually display indent levels.
Bundle 'nathanaelkane/vim-indent-guides'
" Surround makes quoting, bracketing, and parenthesizing fast.
Bundle 'tpope/vim-surround'
" Conque is a is a terminal emulator which uses a Vim buffer to display 
" the program output. The vim-scripts version is broken, using a fork.
Bundle 'scottmcginness/Conque-Shell'

" vim-scripts
" grep.vim brings a whole slew of grep variations. Favorite is :GrepBuffer
" when an entire project is loaded in memory.
Bundle 'grep.vim'
" scratch buffers
Bundle 'scratch'
" VimClojure is syntax, indenting, completion, and Clojure server, like SLIME.
Bundle 'VimClojure'
" rest.vim is syntax for ReStructuredText.
Bundle 'rest.vim'
" RST-Tables creates and reformats tables in ReStructuredText.
Bundle 'RST-Tables-CJK'


" BASIC VIM CONFIGURATION
"
" Turn on standard filetype detection and indentation.
filetype on
filetype plugin on
filetype plugin indent on

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set backspace=2		" more powerful backspacing
set ai                  " auto indenting
set history=100         " keep 100 lines of history
set ruler               " show the cursor position
syntax on               " syntax highlighting
set hlsearch            " highlight the last searched term

" Set a minimum number of lines around the cursor (scroll offset)
set so=5

" Show line numbers
set number

" Allow paste from clipboard
set paste

" Code folding settings
set foldenable
set foldmethod=indent
set foldlevel=99999

" Enable hidden buffers
set hidden

" Disable modelines
set modelines=0		" CVE-2007-2438

" Ignore tmp files and pyc
set wildignore=*~,*.tmp,*.pyc

" Tab settings
set noexpandtab
set shiftwidth=2
set tabstop=2

" Disable beeping
set noeb vb t_vb=


" ADVANCED VIM CONFIGURATION
"
" Set colorscheme
colorscheme zenburn
" let g:zenburn_high_Contrast=1
" colors zenburn

" syntax detection based on file ext
au BufNewFile,BufRead *.rst set filetype=rest | set noexpandtab | 
\ set softtabstop=4  | set tabstop=4 | set shiftwidth=4 
" Subtle horizontal highlighting of current line.
set cursorline
hi clear CursorLine 
hi CursorLine guibg=#4D4D4D
hi clear CursorColumn 
hi link CursorColumn CursorLine 

" Set 80 char margin
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
" Display nice blue line at column `colorcolumn` (80)
highlight ColorColumn guibg=DarkSlateGray

" Strip trailing whitespace on save
autocmd FileType python autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd FileType python
  \ setlocal shiftwidth=4 |
  \ setlocal tabstop=4
autocmd FileType html
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2
autocmd FileType javascript
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif

" Highlight all instances of word under cursor
:autocmd CursorMoved *
\ exe printf('match IncSearch /\V\<%s\>/', 
\ escape(expand('<cword>'), '/\'))


" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup


" Highlight SQL in triple quotes
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

au FileType python call TextEnableCodeSnip('pgsql', "'''", "'''", 'SpecialComment')


" KEY REMAPPINGS
"
" Reserve arrow keys for some future use.
:noremap <Left> <nop>
:noremap <Right> <nop>
:noremap <Up> <nop>
:noremap <Down> <nop>
:noremap! <Left> <nop>
:noremap! <Right> <nop>
:noremap! <Up> <nop>
:noremap! <Down> <nop>

" Ctrl-k/j deletes blank line below/above, and Alt-k/j inserts.
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent>˚ :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent>∆ :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Remap command-mode keys for bash-style movement
" move to bol
cnoremap <C-A> <Home>
" move right
cnoremap <C-F> <Right>
" move left
cnoremap <C-B> <Left>
" move one WORD left
cnoremap ∫ <C-Left>
" move one WORD right
cnoremap ƒ <C-Right>


" PLUGIN SETTINGS
" Command-T config
let g:CommandTMaxFiles=1000000

" Scratch config
let scratch_show_command='hide buffer'


" indent-guides plugin settings
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1


" MACVIM SETTINGS
"
" fullscreen
if has("gui_running")
  if has("gui_macvim")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
  endif
  set guifont=Monospace\ 13
  highlight SpellBad term=underline gui=undercurl guisp=Orange
endif


" PLUGIN COMMAND ALIASES
"
" Alias :Sc to open scratch buffer
command! -bar -nargs=0 Sc call scratch#open()
" Alias :Vsc to open scratch buffer in vertical split
command! -bar -nargs=0 Vsc exe "rightbelow vsplit" | call scratch#open()
" Alias :Tsplit to Vsplit and CommandT
command Tsplit rightbelow vsplit | CommandT
