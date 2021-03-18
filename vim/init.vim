set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

Plug 'OmniSharp/omnisharp-vim'

" Mappings, code-actions available flag and statusline integration
Plug 'nickspoons/vim-sharpenup'

" Linting/error highlighting
Plug 'dense-analysis/ale'

Plug 'mhinz/vim-startify'

" Vim FZF integration, used as OmniSharp selector
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Or build from source code by using yarn: https://yarnpkg.com
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install -frozen-lockfile'}

" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'

Plug 'preservim/nerdtree'
"Plug 'kien/ctrlp.vim'

Plug 'tpope/vim-surround'
Plug 'aserebryakov/vim-todo-lists'


" Colorscheme
Plug 'gruvbox-community/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/sonokai'

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'


call plug#end()

autocmd VimEnter *
	    \   if !argc()
	    \ |   Startify
	    \ |   NERDTree
	    \ |   wincmd w
	    \ | endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:asyncomplete_auto_popup = 1

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-z> :NERDTree<CR>

set shiftwidth=4
set number

let g:lightline = {
   \ 'colorscheme': 'one dark',
   \ }


if has('termguicolors')
set termguicolors
endif

let g:sonokai_style = 'andromeda'
let g:sonokai_transparent_background = 0
let g:airline_theme = 'sonokai'
let g:lightline = {'colorscheme' : 'sonokai'}
colorscheme sonokai
let g:lightline.colorscheme = 'sonokai'

noremap <A-h>  :-tabmove<cr>
noremap <A-l> :+tabmove<cr>
autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

language en_US
set mouse=a

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winhl': 'Normal:NormalFloat'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0, 0, 0, 0],
  \ 'border': [1]
  \}
endif
\}

cd C:\Users\batuh\Desktop\Do_not_fall\Assets\Scripts
