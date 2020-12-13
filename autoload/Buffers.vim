scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:fzfyml = "fzfyml3 run"
let s:yaml = expand('<sfile>:p:h') . "/Buffers.yml"
let s:temp = tempname()

function! Buffers#Buffers()
    if has('nvim')
        let ls = execute('ls')
        let s:tmpfile = tempname()
        function! OnFzfExit(job_id, data, event)
            bd!
            let lines = readfile(s:tmpfile)
            if len(lines) > 0
                execute("b" . lines[0])
                redraw!
            endif
        endfunction
        call delete(s:tmpfile)
        enew
        setlocal statusline=fzf
        setlocal nonumber
        call termopen("echo '" . ls . "' | sed 1d | " . s:fzfyml . " " . s:yaml . " > " . s:tmpfile, {'on_exit': 'OnFzfExit'})
        startinsert
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

