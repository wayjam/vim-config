let s:save_cpo = &cpoptions
set cpoptions&vim
let b:undo_ftplugin = 'setlocal spell<'
setlocal nospell
setlocal nohidden
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

nnoremap <buffer> q :helpclose<CR>

let &cpoptions = s:save_cpo
