""" Basic Behavior
set wildmenu                    " visual autocomplete for command menu
set wildmode=longest:list,full  " https://stackoverflow.com/a/21977418/1397061
set lazyredraw                  " redraw screen only when we need to
set showmatch                   " Show matching brackets when text indicator is over them
set mat=2                       " How many tenths of a second to blink when matching brackets
" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""" Vim Appearance
colorscheme monokai-phoenix     " put colorscheme files in ~/.vim/colors/
syntax enable                   " use filetype-based syntax highlighting
set number                      " Numering lines

"""" Tab settings
set tabstop=4                   " width that a <TAB> character displays as
set expandtab                   " convert <TAB> key-presses to spaces
set shiftwidth=4                " number of spaces to use for each step of (auto)indent
set softtabstop=4               " backspace after pressing <TAB> will remove up to this many spaces
set smarttab                    " Be smart when using tabs

"""" Search settings
set incsearch                   " search as characters are entered
set hlsearch                    " highlight matches
set ignorecase                  " Do case insensitive matching
set smartcase                   " Do smart case matching
set magic                       " For regular expressions turn magic on
