" variables {{{1
let s:title = "-Tags-" 
let s:confirm_at = -1

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press <F1> for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short
" }}}

" functions {{{1
" extags#bind_mappings {{{2
function extags#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" extags#register_hotkey {{{2
function extags#register_hotkey( priority, key, action, desc )
    call ex#keymap#register( s:keymap, a:priority, a:key, a:action, a:desc )
endfunction

" extags#toggle_help {{{2
" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function extags#toggle_help()
    if !g:ex_tags_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" extags#open_window {{{2

function extags#init_buffer()
    set filetype=extags
    au! BufWinLeave <buffer> call <SID>on_close()

    if line('$') <= 1 && g:ex_tags_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
    endif
endfunction

function s:on_close()
    let s:zoom_in = 0
    let s:help_open = 0

    " go back to edit buffer
    call ex#window#goto_edit_window()
    call ex#hl#clear_target()
endfunction

function extags#open_window()
    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_tags_winsize,
                    \ g:ex_tags_winpos,
                    \ 1,
                    \ 1,
                    \ function('extags#init_buffer')
                    \ )
        if s:confirm_at != -1
            call ex#hl#confirm_line(s:confirm_at)
        endif
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" extags#toggle_window {{{2
function extags#toggle_window()
    let result = extags#close_window()
    if result == 0
        call extags#open_window()
    endif
endfunction

" extags#close_window {{{2
function extags#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" extags#toggle_zoom {{{2
function extags#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_tags_winpos, g:ex_tags_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_tags_winpos, g:ex_tags_winsize )
        endif
    endif
endfunction

" extags#confirm_select {{{2
" modifier: '' or 'shift'
function extags#confirm_select(modifier)
    " TODO
    " " check if the line is valid file line
    " let line = getline('.') 

    " " get filename 
    " let filename = line

    " " NOTE: GSF,GSFW only provide filepath information, so we don't need special process.
    " let idx = stridx(line, ':') 
    " if idx > 0 
    "     let filename = strpart(line, 0, idx) "DISABLE: escape(strpart(line, 0, idx), ' ') 
    " endif 

    " " check if file exists
    " if findfile(filename) == '' 
    "     call ex#warning( filename . ' not found!' ) 
    "     return
    " endif 

    " " confirm the selection
    " let s:confirm_at = line('.')
    " call ex#hl#confirm_line(s:confirm_at)

    " " goto edit window
    " call ex#window#goto_edit_window()

    " " open the file
    " if bufnr('%') != bufnr(filename) 
    "     exe ' silent e ' . escape(filename,' ') 
    " endif 

    " if idx > 0 
    "     " get line number 
    "     let line = strpart(line, idx+1) 
    "     let idx = stridx(line, ":") 
    "     let linenr  = eval(strpart(line, 0, idx)) 
    "     exec ' call cursor(linenr, 1)' 

    "     " jump to the pattern if the code have been modified 
    "     let pattern = strpart(line, idx+2) 
    "     let pattern = '\V' . substitute( pattern, '\', '\\\', "g" ) 
    "     if search(pattern, 'cw') == 0 
    "         call ex#warning('Line pattern not found: ' . pattern)
    "     endif 
    " endif 

    " " go back to global search window 
    " exe 'normal! zz'
    " call ex#hl#target_line(line('.'))
    " call ex#window#goto_plugin_window()
endfunction

" extags#select {{{2

function s:convert_filename(filename)
    return fnamemodify( a:filename, ':t' ) . ' (' . fnamemodify( a:filename, ':h' ) . ')'    
endfunction

function s:put_taglist( tag, tag_list )
    " if empty tag_list, put the error result
    if empty(a:tag_list)
        silent put = 'Error: tag not found ==> ' . a:tag
        silent put = ''
        return
    endif

    " Init variable
    let idx = 1
    let pre_tag_name = a:tag_list[0].name
    let pre_file_name = a:tag_list[0].filename
    " put different file name at first
    silent put = pre_tag_name
    silent put = s:convert_filename(pre_file_name)
    " put search result
    for tag_info in a:tag_list
        if tag_info.name !=# pre_tag_name
            silent put = ''
            silent put = tag_info.name
            silent put = s:convert_filename(tag_info.filename)
        elseif tag_info.filename !=# pre_file_name
            silent put = s:convert_filename(tag_info.filename)
        endif
        " put search patterns
        let quick_view = ''
        if tag_info.cmd =~# '^\/\^' 
            let quick_view = strpart( tag_info.cmd, 2, strlen(tag_info.cmd)-4 )
            let quick_view = strpart( quick_view, match(quick_view, '\S') )
        elseif tag_info.cmd =~# '^\d\+'
            try
                let file_list = readfile( fnamemodify(tag_info.filename,":p") )
                let line_num = eval(tag_info.cmd) - 1 
                let quick_view = file_list[line_num]
                let quick_view = strpart( quick_view, match(quick_view, '\S') )
            catch /^Vim\%((\a\+)\)\=:E/
                let quick_view = "ERROR: can't get the preview from file!"
            endtry
        endif
        " this will change the \/\/ to //
        let quick_view = substitute( quick_view, '\\/', '/', "g" )
        silent put = '        ' . idx . ': ' . quick_view
        let idx += 1
        let pre_tag_name = tag_info.name
        let pre_file_name = tag_info.filename
    endfor
endfunction

function extags#select( tag )
    " strip white space.
    let in_tag = substitute (a:tag, '\s\+', '', 'g')
    if match(in_tag, '^\(\t\|\s\)') != -1
        return
    endif

    " get taglist
    " NOTE: we use \s\* which allowed the tag have white space at the end.
    "       this is useful for lua. In current version of cTags(5.8), it
    "       will parse the lua function with space if you define the function
    "       as: functon foobar () instead of functoin foobar(). 
    if g:ex_tags_ignore_case && (match(in_tag, '\u') == -1)
        let in_tag = substitute( in_tag, '\', '\\\', "g" )
        echomsg 'parsing ' . in_tag . '...(ignore case)'
        let tag_list = taglist('\V\^'.in_tag.'\s\*\$')
    else
        let in_tag = substitute( in_tag, '\', '\\\', "g" )
        echomsg 'parsing ' . in_tag . '...(no ignore case)'
        let tag_list = taglist('\V\^\C'.in_tag.'\s\*\$')
    endif

    " open the global search window
    call extags#open_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_tags_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 0
    endif

    "
    call s:put_taglist ( a:tag, tag_list )

    " " put the result
    " silent exec 'normal ' . start_line . 'g'
    " let header = '---------- ' . a:pattern . ' ----------'
    " let start_line += 1
    " let text = header . "\n" . result
    " silent put =text
    " let end_line = line('$')

    " " init search state
    " silent normal gg
    " let linenr = search(header,'w')
    " silent call cursor(linenr,1)
    " silent normal zz
endfunction

" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
