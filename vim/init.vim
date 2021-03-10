set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

 let s:using_snippets = 1

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

 " Use release branch (recommend)
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 
 " Or build from source code by using yarn: https://yarnpkg.com
 Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install -frozen-lockfile'}

 " Autocompletion
 Plug 'prabirshrestha/asyncomplete.vim'

 Plug 'preservim/nerdtree'
 Plug 'kien/ctrlp.vim'

 Plug 'tpope/vim-surround'
 Plug 'majutsushi/tagbar' "f8
 Plug 'irrationalistic/vim-tasks'
 "n - new task below
 "N - new task above
 "d - toggle current task complete
 "x - toggle current task cancelled
 "a - send completed tasks to the archive
 "Run :help Tasks to view the full documentation.
 
 "Plug 'codota/tabnine-vim'
 
 
 " Colorscheme
 Plug 'gruvbox-community/gruvbox'

 " Statusline
 Plug 'itchyny/lightline.vim'

 Plug 'shinchu/lightline-gruvbox.vim'
 Plug 'maximbaz/lightline-ale'

 " Snippet support
 if s:using_snippets
   Plug 'sirver/ultisnips'
   endif

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

 function! s:check_back_space() abort
	     let col = col('.') - 1
	         return !col || getline('.')[col - 1]  =~ '\s'
	 endfunction

	 inoremap <silent><expr> <TAB>
	   \ pumvisible() ? "\<C-n>" :
	   \ <SID>check_back_space() ? "\<TAB>" :
	   \ asyncomplete#force_refresh()
	 inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

 nnoremap <leader>n :NERDTreeFocus<CR>
 cd C:\Users\batuh\Desktop\Crazy_shop\Assets\Scripts
 nnoremap <C-n> :NERDTree<CR>

 set shiftwidth=4
 set number

 let g:lightline = {
       \ 'colorscheme': 'one dark',
       \ }

 

 colorscheme gruvbox
   " }}}

