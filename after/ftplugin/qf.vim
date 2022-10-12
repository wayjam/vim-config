let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin = 'setl fo< com< rnu< nu< bl<'

setlocal winminheight=1 winheight=3
setlocal nowrap
setlocal norelativenumber number
setlocal linebreak
setlocal nolist
setlocal nobuflisted

" https://vi.stackexchange.com/questions/8534/make-cnext-and-cprevious-loop-back-to-the-begining
function! s:cycle(action, fallback) abort
  try
    execute a:action
  catch
    execute a:fallback
  finally
    normal! zz
  endtry
endfunction

nnoremap <silent> ]q :<c-u>call <SID>cycle('cnext', 'cfirst')<CR>
nnoremap <silent> [q :<c-u>call <SID>cycle('cprev', 'clast')<CR>

" Location
nnoremap <silent> ]l :<c-u>call <SID>cycle('lnext', 'lfirst')<CR>
nnoremap <silent> [l :<c-u>call <SID>cycle('lprev', 'llast')<CR>

nnoremap <silent> <buffer> q :cclose<bar>:lclose<CR>
nnoremap <buffer> <CR> <CR>

let &cpoptions = s:save_cpo
