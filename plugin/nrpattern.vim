nnoremap <silent> <Plug>(PatternIncrement) :<C-u>call <SID>PatternIncrement(v:count1)<CR>
nnoremap <silent> <Plug>(PatternDecrement) :<C-u>call <SID>PatternDecrement(v:count1)<CR>

vnoremap <silent> <Plug>(PatternRangeIncrement) :<C-u>call <SID>PatternIncrementRange(v:count1, "false")<CR>
vnoremap <silent> <Plug>(PatternRangeDecrement) :<C-u>call <SID>PatternDecrementRange(v:count1, "false")<CR>
nnoremap <silent> <Plug>(PatternRangeIncrement) :<C-u>call <SID>PatternIncrementRange(v:count1, "true")<CR>
nnoremap <silent> <Plug>(PatternRangeDecrement) :<C-u>call <SID>PatternDecrementRange(v:count1, "true")<CR>

vnoremap <silent> <Plug>(PatternMultIncrement) :<C-u>call <SID>PatternMultIncrement(v:count1, "false")<CR>
vnoremap <silent> <Plug>(PatternMultDecrement) :<C-u>call <SID>PatternMultDecrement(v:count1, "false")<CR>
nnoremap <silent> <Plug>(PatternMultIncrement) :<C-u>call <SID>PatternMultIncrement(v:count1, "true")<CR>
nnoremap <silent> <Plug>(PatternMultDecrement) :<C-u>call <SID>PatternMultDecrement(v:count1, "true")<CR>

if !exists('g:nrpattern_no_mapping')
  echom "Loading maps"
  nmap <C-a> <Plug>(PatternIncrement)
  nmap <C-x> <Plug>(PatternDecrement)
  vmap <C-a> <Plug>(PatternRangeIncrement)
  vmap <C-x> <Plug>(PatternRangeDecrement)
  vmap g<C-a> <Plug>(PatternMultIncrement)
  vmap g<C-x> <Plug>(PatternMultDecrement)
endif

function! s:PatternIncrement(increment)
  call luaeval('require"nrpattern".increment(_A)', a:increment)
  silent! call repeat#set("\<Plug>(PatternIncrement)", a:increment)
endfunction

function! s:PatternDecrement(decrement)
  call luaeval('require"nrpattern".increment(-1 * _A)', a:decrement)
  silent! call repeat#set("\<Plug>(PatternDecrement)", a:decrement)
endfunction

function! s:PatternIncrementRange(increment, repeat)
  call luaeval('require"nrpattern".increment_range(_A, false, ' . a:repeat . ')', a:increment)
  silent! call repeat#set("\<Plug>(PatternRangeIncrement)")
endfunction

function! s:PatternDecrementRange(decrement, repeat)
  call luaeval('require"nrpattern".increment_range(-1 * _A, false, ' . a:repeat . ')', a:decrement)
  silent! call repeat#set("\<Plug>(PatternRangeDecrement)", a:decrement)
endfunction

function! s:PatternMultIncrement(increment, repeat)
  call luaeval('require"nrpattern".increment_range(_A, true , ' . a:repeat . ')', a:increment)
  silent! call repeat#set("\<Plug>(PatternMultIncrement)", a:increment)
endfunction

function! s:PatternMultDecrement(decrement)
  call luaeval('require"nrpattern".increment_range(-1 * _A, true, ' . a:repeat . ')', a:decrement)
  silent! call repeat#set("\<Plug>(PatternMultDecrement)", a:decrement)
endfunction
