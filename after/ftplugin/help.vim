let s:save_cpo = &cpoptions
let b:undo_ftplugin = 'setlocal spell<'
let &cpoptions = s:save_cpo
set cpoptions&vim
setlocal nospell
setlocal nohidden
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

nnoremap <buffer> q :helpclose<CR>
