"PLUGINS
"--------------------------
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'

Plug 'morhetz/gruvbox'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()
"--------------------------

"GENERAL
set number
set nowrap
set cursorline
set autochdir
set noswapfile
set splitbelow
set splitright
set mouse=

"CONFIGURACIÓN DE TEMAS
set termguicolors
colorscheme gruvbox


"KEYMAPS

"FZF
map <C-n> :Files<cr>

"moverse entre ventanas
map <A-Up> <C-w><Up>
map <A-Down> <C-w><Down>
map <A-Left> <C-w><Left>
map <A-Right> <C-w><Right>

"abrir nueva pestaña
map <C-t> :tabnew<cr>
inoremap <C-t> <C-O>:tabnew<cr>

"tab entre pestañas
map <tab> gt


"COC-TAB
"--------------------------
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
"--------------------------
