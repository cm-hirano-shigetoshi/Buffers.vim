scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:fzfyml = "fzfyml3 run"
let s:yaml = expand('<sfile>:p:h') . "/Buffers.yml"
let s:temp = tempname()

function! Buffers#Buffers()
    function! Operation(lines)
        if a:lines[0] == 'select'
            for num in split(a:lines[1], ' ')
                execute("b " . num)
            endfor
        elseif a:lines[0] == 'quit'
            execute("bd " . a:lines[1])
        elseif a:lines[0] == 'diff'
            if len(split(a:lines[1], ',')) == 1
                execute("vertical diffsplit " . a:lines[1])
            else
                let sp = split(a:lines[1], ',')
                execute("b " . sp[0][1:])
                for num in sp[1:]
                    execute("vertical diffsplit " . num)
                endfor
            endif
        endif
    endfunction

    let ls = execute('ls')
    let s:tmpfile = tempname()
    if has('nvim')
        function! OnFzfExit(job_id, data, event)
            bd!
            let lines = readfile(s:tmpfile)
            if len(lines) == 2
                call Operation(lines)
            endif
            redraw!
        endfunction
        call delete(s:tmpfile)
        enew
        setlocal statusline=fzf
        setlocal nonumber
        call termopen("echo '" . ls . "' | sed 1d | " . s:fzfyml . " " . s:yaml . " > " . s:tmpfile, {'on_exit': 'OnFzfExit'})
        startinsert
    else
        let out = system("tput cnorm > /dev/tty; echo '" . ls . "' | sed 1d | " . s:fzfyml . " " . s:yaml . " 2>/dev/tty")
        let lines = split(out, '\n')
        if len(lines) == 2
            call Operation(lines)
        endif
        redraw!
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

