if has("autocmd")
  autocmd FileType ruby call SetupTestrunner()
endif

function! SetupTestrunner()
  let name = expand('%:t')
  if match(name, '_test') > -1
    nnoremap <buffer> Q :wa <bar> :!ruby %<CR>
  else
    nnoremap <buffer> Q :execute ':wa <bar> :!ruby' rake#buffer().related()<CR>
  endif
endfunction
