nnoremap <leader>fm :Neoformat<CR>
nnoremap <localleader>= :Neoformat<CR>

" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

let g:neoformat_enabled_python = ['autopep8', 'yapf', 'docformatter']

let g:neoformat_enabled_cpp = ['clangformat', 'uncrustify', 'astyle']
