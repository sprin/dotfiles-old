set nocompatible	" Use Vim defaults instead of 100% vi compatibility
filetype off " required a vundle!
" see https://github.com/gmarik/vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" My Bundles here:
"
" original repos on github
" cd ~/.vim/bundle/Command-T/ruby/command-t/; ruby extconf.rb; make
Bundle 'wincent/Command-T'
Bundle 'mitechie/pyflakes-pathogen' 
Bundle 'chrisbra/csv.vim'

filetype on
filetype plugin on
filetype plugin indent on " required!
"End vundle

" Command-T config
let g:CommandTMaxFiles=1000000

" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set backspace=2		" more powerful backspacing
set ai                  " auto indenting
set history=100         " keep 100 lines of history
set ruler               " show the cursor position
syntax on               " syntax highlighting
set hlsearch            " highlight the last searched term

set expandtab
set shiftwidth=2
set tabstop=2

autocmd FileType python
  \ setlocal shiftwidth=4 |
  \ setlocal tabstop=4
autocmd FileType html
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2
autocmd FileType javascript
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2


filetype plugin on

" Show line numbers
set number

" Allow paste from clipboard
set paste

" Set colorscheme
colorscheme zenburn
" let g:zenburn_high_Contrast=1
" colors zenburn

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

" Set 80 char margin
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Function to replace spaces with underbars temporarily - bound to F3
set hls
let g:HLSpace = 1
let g:HLColorScheme = g:colors_name
function! ToggleSpaceUnderscoring()
    if g:HLSpace
        highlight Search cterm=underline gui=underline ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
        let @/ = " "
    else
        highlight clear
        silent colorscheme "".g:HLColorScheme
        let @/ = ""
    endif
    let g:HLSpace = !g:HLSpace
endfunction

nmap <silent> <F3> <Esc>:call ToggleSpaceUnderscoring()<CR>

if has("gui_running")
  if has("gui_macvim")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
  endif
  set guifont=Monospace\ 13
  highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

