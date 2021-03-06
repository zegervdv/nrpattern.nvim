nnoremap <silent> <Plug>PatternIncrement :<C-U>call <SID>PatternIncrement(v:count1)<CR>
nnoremap <silent> <Plug>PatternDecrement :<C-U>call <SID>PatternDecrement(v:count1)<CR>

vnoremap <silent> <Plug>PatternIncrementRange :call <SID>PatternIncrement(v:count1)<CR>
vnoremap <silent> <Plug>PatternDecrementRange :call <SID>PatternIncrement(v:count1)<CR>

nmap <C-a> <Plug>PatternIncrement
nmap <C-x> <Plug>PatternDecrement
vmap <C-a> <Plug>PatternIncrementRange
vmap <C-x> <Plug>PatternDecrementRange

function! s:PatternIncrement(increment)
  call luaeval('require"nrpattern".increment(_A)', a:increment)
  silent! call repeat#set("\<Plug>PatternIncrement", a:increment)
endfunction

function! s:PatternDecrement(decrement)
  call luaeval('require"nrpattern".increment(-1 * _A)', a:decrement)
  silent! call repeat#set("\<Plug>PatternDecrement", a:decrement)
endfunction
