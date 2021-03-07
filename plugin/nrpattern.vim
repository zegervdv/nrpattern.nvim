nnoremap <silent> <Plug>PatternIncrement :<C-U>call <SID>PatternIncrement(v:count1)<CR>
nnoremap <silent> <Plug>PatternDecrement :<C-U>call <SID>PatternDecrement(v:count1)<CR>

vnoremap <silent> <Plug>PatternRangeIncrement :<C-u>call <SID>PatternIncrementRange(v:count1)<CR>
vnoremap <silent> <Plug>PatternRangeDecrement :<C-u>call <SID>PatternDecrementRange(v:count1)<CR>

nmap <C-a> <Plug>PatternIncrement
nmap <C-x> <Plug>PatternDecrement
vmap <C-a> <Plug>PatternRangeIncrement
vmap <C-x> <Plug>PatternRangeDecrement

function! s:PatternIncrement(increment)
  call luaeval('require"nrpattern".increment(_A)', a:increment)
  silent! call repeat#set("\<Plug>PatternIncrement", a:increment)
endfunction

function! s:PatternDecrement(decrement)
  call luaeval('require"nrpattern".increment(-1 * _A)', a:decrement)
  silent! call repeat#set("\<Plug>PatternDecrement", a:decrement)
endfunction

function! s:PatternIncrementRange(increment)
  call luaeval('require"nrpattern".increment_range(_A)', a:increment)
  silent! call repeat#set("\<Plug>PatternRangeIncrement", a:increment)
endfunction

function! s:PatternDecrementRange(decrement)
  call luaeval('require"nrpattern".increment_range(-1 * _A)', a:decrement)
  silent! call repeat#set("\<Plug>PatternRangeDecrement", a:decrement)
endfunction
