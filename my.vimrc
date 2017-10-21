" source ~/my.vimrc

":oldfiles


" open each buffer in its own tabpage, add this to your vimrc:
" may freeze also
:au BufAdd,BufNewFile * nested tab sball

" open in less"
nnoremap c :exe ':silent !less %'<CR>

" line numbers; lags
" set number

"enable number and relativenumber at the same time,
:set number relativenumber

" :set nonumber  " turn line numbers off

:set relativenumber
" TIP: Typing 5j will move the cursor five lines down
set cursorline

noremap q :q<cr>
" next/prev buffer
noremap e <C-w><C-w>
noremap <C-k> :bp<CR>
noremap <C-l> :bn<CR>
noremap gl G
noremap <leader>f :Ranger<CR>

noremap b :CtrlPMixed<CR>
noremap <C-x>b :CtrlP<CR>
" Press <c-f> and <c-b> to cycle between modes.

noremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>


noremap <C-l> <C-w>v:ConqueTerm bash<CR>
" open a file"
noremap <F7> :tabe %:p:h<CR>
noremap <F7> <C-w>v<C-w>l<CR>

"noremap ,r :! C:/cygwin64/bin/python3.6m.exe C:/cygwin64/bin/ranger<CR>

"  %:p to get the full path to the current file."
"  :~: Get the file path relative to the home directory (this one didn't work for me for some reason)
"  :.: Get the file path relative to the current directory (% default)
"  :r: File name root. The name of the file without the extension.
"  :e: File's extension.
"  :h: Split on / and return the left half (i.e. if I'm editing a file in a path of /tmp/test.txt and run %:p:h will return /tmp
"  :t: Split on / and return the right half (i.e. if I'm editing a file in a path of /tmp/test.txt and run %:p:t will return text.txt


noremap od :silent !~/my-scripts/open_explorer.sh "$(~/my-scripts/convert_path_to_windows.sh %:p)"<CR>
noremap oe :silent !~/my-scripts/emacs.sh "$(~/my-scripts/convert_path_to_windows.sh %:p)"<CR>
noremap os :silent !~/my-scripts/sublime_text.sh "$(~/my-scripts/convert_path_to_windows.sh %:p)"<CR>
noremap on :silent !~/my-scripts/npp.sh "$(~/my-scripts/convert_path_to_windows.sh %:p)"<CR>
noremap ol :silent !less "$(~/my-scripts/convert_path_to_windows.sh %:p)"<CR>
noremap or :! C:/cygwin64/bin/python3.6m.exe C:/cygwin64/bin/ranger --selectfile=%:p<CR>
" --choosedir=%:p:h"


" C-w s/v split
" C- c/o close current/all except current
" :e filename
" :b filen <TAB>
"


"accelerated motion
:noremap <M-j> 4j
:noremap <M-k> 4k


function RangerExplorer()
    exec "silent !ranger --choosefile=/tmp/vim_ranger_current_file " . expand("%:p:h")
    if filereadable('/tmp/vim_ranger_current_file')
        exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
        call system('rm /tmp/vim_ranger_current_file')
    endif
    redraw!
endfun
map w :call RangerExplorer()<CR>
map <leader>b :CtrlPBuffer
nnoremap ; :
" nnoremap : ;


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'hecal3/vim-leader-guide'
Plug 'junegunn/vim-easy-align'
Plug 'roman/golden-ratio'
Plug 'vim-scripts/ag.vim'
" shell inside vi
Plug 'wkentaro/conque.vim'
Plug 'https://github.com/kien/ctrlp.vim.git'
Plug 'junegunn/fzf.vim'
Plug 'hecal3/vim-leader-guide'
Plug 'francoiscabrol/ranger.vim'


" Initialize plugin system
call plug#end()
" use :PlugInstall from vim to install one time"

set title
" set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
set titlestring=vim:\ %{expand(\"%:p:h\")}/%t

set laststatus=2            " always a status line
set incsearch
set ignorecase
set smartcase
set showcmd
set scrolloff=4 		"offset


:let mapleader = ","

"#"suppose  leader is space
"nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
"vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
autocmd FileType gitcommit  noremap <buffer> <leader> <Plug>leaderguide-buffer
" for fugitive

autocmd BufEnter __Tagbar__  noremap <buffer> <leader> <Plug>leaderguide-buffer
" for tagbar


" http://vim.wikia.com/wiki/Accessing_the_system_clipboard
" Note: in vim 7.3.74 and higher you can set clipboard=unnamedplus to alias unnamed register to the + register, which is the X Window clipboard.
set clipboard=unnamed

colorscheme elflord























source ~/my.guide.vim
