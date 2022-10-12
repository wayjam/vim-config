" ===
" Runtime Initialize
" ===

" Disable vim distribution plugins
let g:loaded_gzip = 1
" let g:loaded_matchit = 1
" let g:loaded_matchparen = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:loaded_remote_plugins = 1
let g:loaded_shada_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip      = 1
let g:loaded_zipPlugin = 1
let g:did_load_filetypes = 1 " replaced by filetype.nvim

" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
if &runtimepath !~# g:CONFIG_PATH
  set runtimepath^=g:CONFIG_PATH
  set runtimepath+=g:CONFIG_PATH/after
endif

" Ensure data directories
for s:path in [
      \ g:DATA_PATH,
      \ g:DATA_PATH . '/undo',
      \ g:DATA_PATH . '/backup',
      \ g:DATA_PATH . '/session',
      \ g:CONFIG_PATH . '/spell' ]
  if ! isdirectory(s:path)
    call mkdir(s:path, 'p', 0700)
  endif
endfor

" Try setting up the custom virtualenv created by ./venv.sh
let s:virtualenv = g:DATA_PATH . '/venv/bin/python'
if empty(s:virtualenv) || ! filereadable(s:virtualenv)
  " Fallback to old virtualenv location
  let s:virtualenv = g:DATA_PATH . '/venv/neovim3/bin/python'
endif

" Python interpreter settings
if filereadable(s:virtualenv)
  let g:python3_host_prog = s:virtualenv
endif
