"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"source ~/.vimrc

language en_US

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

Plug 'OmniSharp/omnisharp-vim'

" Mappings, code-actions available flag and statusline integration
Plug 'nickspoons/vim-sharpenup'
Plug 'sainttttt/flesh-and-blood'

" Linting/error highlighting
Plug 'dense-analysis/ale'

Plug 'mhinz/vim-startify'
Plug 'preservim/nerdtree'
" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'matze/vim-move'

Plug 'davidosomething/vim-colors-meh' " do the same for mac
Plug 'ishan9299/nvim-solarized-lua'

" Vim FZF integration, used as OmniSharp selector
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'pbrisbin/vim-colors-off'
Plug 'w0ng/vim-hybrid'

Plug 'sharkdp/fd'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'tpope/vim-surround'
Plug 'aserebryakov/vim-todo-lists'

Plug 'preservim/nerdcommenter'
Plug 'rust-lang/rust.vim'

" Colorscheme
Plug 'gruvbox-community/gruvbox'
Plug 'savq/melange-nvim'
Plug 'shaunsingh/nord.nvim'

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
       	"\   if !argc()
       	"\ |   Startify
       	"\ |   NERDTree
       	"\ |   wincmd w
       	"\ | endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:asyncomplete_auto_popup=0

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-z> :NERDTree<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

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

let g:lightline = {
   \ 'colorscheme': 'gruvbox',
   \ }


if has('termguicolors')
set termguicolors
endif

colorscheme melange
let g:OmniSharp_popup = 1
let g:asyncomplete_auto_completeopt=1
let g:asyncomplete_auto_popup=1

" hi Normal guibg=NONE ctermbg=NONE

noremap <A-h> :-tabmove<cr>  
noremap <A-l> :+tabmove<cr>   

set mouse=a

if has('patch-8.1.1880')
 "set completeopt=longest,menuone,popuphidden
 "" Highlight the completion documentation popup background/foreground the same as
 "" the completion menu itself, for better readability with highlighted
 "" documentation.
 "set completepopup=highlight:Pmenu,border:off
else
 "set completeopt=longest,menuone,preview
 "" Set desired preview window height for viewing documentation.
 "set previewheight=5
endif

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
 "let g:OmniSharp_popup_options = {
 "\ 'winhl': 'Normal:NormalFloat'
 "\}
else
 "let g:OmniSharp_popup_options = {
 "\ 'highlight': 'Normal',
 "\ 'padding': [0, 0, 0, 0],
 "\ 'border': [1]
 "\}
endif
