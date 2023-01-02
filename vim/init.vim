"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"source ~/.vimrc

language en_US

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

Plug 'OmniSharp/omnisharp-vim'

" Mappings, code-actions available flag and statusline integration
Plug 'nickspoons/vim-sharpenup'

" Linting/error highlighting
Plug 'dense-analysis/ale'
Plug 'jhlgns/naysayer88.vim'

Plug 'mhinz/vim-startify'

" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'matze/vim-move'

Plug 'davidosomething/vim-colors-meh' " do the same for mac

" Vim FZF integration, used as OmniSharp selector
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'pbrisbin/vim-colors-off'
Plug 'w0ng/vim-hybrid'

Plug 'tomlion/vim-solidity'
Plug 'TovarishFin/vim-solidity'

Plug 'nvim-lua/plenary.nvim'


Plug 'preservim/nerdtree'

Plug 'tpope/vim-surround'
Plug 'aserebryakov/vim-todo-lists'

Plug 'preservim/nerdcommenter'
Plug 'rust-lang/rust.vim'

" Colorscheme
Plug 'gruvbox-community/gruvbox'
Plug 'shaunsingh/nord.nvim'
Plug 'sainnhe/sonokai'
Plug 'ulwlu/elly.vim'
Plug 'dracula/vim', { 'as': 'dracula' }

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'
Plug 'fxn/vim-monochrome'
Plug 'sainnhe/everforest'
Plug 'vim-scripts/SingleCompile'

nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

let g:asyncrun_open = 6
set laststatus=0

let g:neovide_cursor_animation_length=0.05
let g:neovide_cursor_trail_length=0.01

call plug#end()

autocmd Filetype c nmap <buffer> <F9> :SCCompileAF -lz <CR>
autocmd Filetype c nmap <buffer> <F10> :SCCompileRunAF -lz <CR>

autocmd VimEnter *
	    \   if !argc()
	    \ |   Startify
	    \ |   NERDTree
	    \ |   wincmd w
	    \ | endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:asyncomplete_auto_popup=0

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-z> :NERDTree<CR>

autocmd FileType cs nmap <silent> <buffer> sd <Plug>(omnisharp_documentation)
autocmd FileType cs nmap <silent> <buffer> gr <Plug>(omnisharp_rename)
autocmd FileType cs nmap <silent> <buffer> fu <Plug>(omnisharp_find_usages)
autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)

noremap <A-h>  :-tabmove<cr>
noremap <A-l> :+tabmove<cr>

set shiftwidth=4
set noexpandtab
set tabstop=4
set number
set relativenumber

"let g:lightline = {
"   \ 'colorscheme': 'gruvbox',
"   \ }


if has('termguicolors')
set termguicolors
endif

colorscheme gruvbox
"hi Normal guibg=NONE ctermbg=NONE
let g:OmniSharp_popup = 1

noremap <A-h> :-tabmove<cr>  
noremap <A-l> :+tabmove<cr>   

set mouse=a

if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

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
