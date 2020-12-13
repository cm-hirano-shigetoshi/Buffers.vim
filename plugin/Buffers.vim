scriptencoding utf-8
if exists('g:load_Buffers')
    finish
endif
let g:load_Buffers = 1

let s:save_cpo = &cpo
set cpo&vim

nnoremap <silent> <Tab>b :<C-u>call Buffers#Buffers()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
