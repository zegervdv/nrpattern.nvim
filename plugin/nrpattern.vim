" nnoremap <C-a> :<C-u>call <SID>PatternIncrement(v:count1)<CR>
nnoremap <Plug>PatternIncrement :<C-U>call <SID>PatternIncrement(v:count1)<CR>
nmap <C-a> <Plug>PatternIncrement

function! s:PatternIncrement(increment)
  call luaeval('require"nrpattern".increment(_A)', a:increment)
  silent! call repeat#set("\<Plug>PatternIncrement", a:increment)
endfunction
