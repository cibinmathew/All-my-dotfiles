set number
set cursorline

noremap q :q<cr>
" next/prev buffer
noremap e <C-w><C-w>
noremap <C-k> :bp<CR>
noremap <C-l> :bn<CR>
noremap gl G
noremap <leader>f :Ranger<CR>

noremap b :CtrlP<CR>

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


noremap r :! C:/cygwin64/bin/python3.6m.exe C:/cygwin64/bin/ranger --selectfile=%:p<CR>
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

" Initialize plugin system
call plug#end()
" use :PlugInstall from vim to install one time"

set title
" set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
set titlestring=vim:\ %{expand(\"%:p:h\")}/%t



set showcmd




















 