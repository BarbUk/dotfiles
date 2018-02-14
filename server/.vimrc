set nocompatible            " be iMproved, required
filetype off                " required

filetype plugin indent on   " required

set updatetime=250
set laststatus=2

" Options diverses
set nobackup
set swapfile
set hidden               " hides buffer
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set noerrorbells         " don't beep
" change the mapleader from \ to ,
let mapleader=","
" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Affichage
set ruler               " Position du fichier tjs affichée
set showmode            " Montre le mode actuel
set number              " Afficher les numéros de ligne
syntax on               " Coloration syntaxique
set paste
set wrap                " Pas de wordwrap
set showmatch           " Donne parenthèse correspondante
set showcmd             " Donne commande incomplète
set shiftround          " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch           " set show matching parenthesis
set ignorecase          " ignore case when searching
set smartcase           " ignore case if search pattern is all lowercase,
set smarttab            " insert tabs on the start of a line
set hlsearch            " Surligne les résultats de recherche
set incsearch           " Recherche incrémentale
set expandtab           " Utilise  plutot que
set softtabstop=4       " Largeur de tab
set sta                 " Smart tabs
set shiftwidth=4        " Largeur d'indentation
set ru                  " Position dans le fichier donnée
set hlg=en              " Langue de l'aide : english
set mousemodel=popup    " Affiche un popup au clic droit
set showtabline=2       " Affiche tout le temps la ligne des tabs
set numberwidth=5       " Nombre de colonnes que prend les numéros de lignes
set pastetoggle=<F2>    " pour eviter de faire de la cascade
set ffs=unix,dos
cmap hex %!xxd
" Options du GUI
set ul=100              " Niveaux d'annulation
set mouse=v             " Utiliser la sourie que en mode visuel

" trailing white space
match ErrorMsg '\s\+$'

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
nnoremap <silent> <Leader>rts :call TrimWhiteSpace()<CR>

" Navigation entre les buffers
map <C-right> <ESC>:bn<CR>
map <C-left> <ESC>:bp<CR>

imap sdf <ESC>
" To save, ctrl-s.
map <c-s> <Esc>:w<CR>a
map <C-s> <ESC>:w<CR>
imap <C-s> <ESC>:w<CR>a
" Options pour affichage

" Pour avoir tous les buffers en tabs (mauvais pour :help et autres windows)
"au BufAdd,BufNewFile,BufRead * nested tab sball
nmap <silent> ,/ :nohlsearch<CR>
" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest
" Limit popup menu height
set pumheight=15


" Options de complétion générale
set completeopt=menu,longest " Options de completion

" Wildmenu (pour faire un petit menu sympa quand on tape une commande VIM)
set wildmenu
set wildmode=longest:full

" reprendre à la dernière ligne
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" soa serial
:nnoremap <F8> /\<\d\{10}\><CR>ce<C-r>=strftime("%Y%m%d00")<CR><Esc>:echo @"<CR>

nnoremap rm :call delete(expand('%')) \| bdelete! <CR>
nnoremap <leader>wd :write\|bdelete <CR>
nnoremap <leader>x :bdelete<cr>

" use - as a switch key
let g:switch_mapping = "-"

nnoremap ;; m`A;<Esc>``
nnoremap ,, m`A,<Esc>``
nnoremap ## m`I#<Esc>``
nnoremap <leader>' di'
nnoremap <leader>" di"
nnoremap <Leader>q" ciw""<Esc>P
nnoremap <Leader>q' ciw''<Esc>P
nnoremap <Leader>qd daW"=substitute(@@,"'\\\|\"","","g")<CR>P

