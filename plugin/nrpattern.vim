nnoremap <Plug>PatternIncrement :<C-U>call <SID>PatternIncrement(v:count1)<CR>
nnoremap <Plug>PatternDecrement :<C-U>call <SID>PatternDecrement(v:count1)<CR>

nmap <C-a> <Plug>PatternIncrement
nmap <C-x> <Plug>PatternDecrement

function! s:PatternIncrement(increment)
  call luaeval('require"nrpattern".increment(_A)', a:increment)
  silent! call repeat#set("\<Plug>PatternIncrement", a:increment)
endfunction

function! s:PatternDecrement(decrement)
  call luaeval('require"nrpattern".increment(-1 * _A)', a:decrement)
  silent! call repeat#set("\<Plug>PatternDecrement", a:decrement)
endfunction
