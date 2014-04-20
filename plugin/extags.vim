" default configuration {{{1
if !exists('g:ex_tags_winsize')
    let g:ex_tags_winsize = 20
endif

if !exists('g:ex_tags_winsize_zoom')
    let g:ex_tags_winsize_zoom = 40
endif

" bottom or top
if !exists('g:ex_tags_winpos')
    let g:ex_tags_winpos = 'bottom'
endif

if !exists('g:ex_tags_enable_help')
    let g:ex_tags_enable_help = 1
endif

"}}}

" commands {{{1
" command! -n=1 -complete=customlist,ex#compl_by_symbol TSelect call extags#select('<args>', '-s')
command! EXTagsCWord call extags#select(expand('<cword>'), '-s')

command! EXTagsToggle call extags#toggle_window()
command! EXTagsOpen call extags#open_window()
command! EXTagsClose call extags#close_window()
"}}}

" default key mappings {{{1
call extags#register_hotkey( 1  , '<F1>'            , ":call extags#toggle_help()<CR>"           , 'Toggle help.' )
call extags#register_hotkey( 2  , '<ESC>'           , ":EXTagsClose<CR>"                         , 'Close window.' )
call extags#register_hotkey( 3  , '<Space>'         , ":call extags#toggle_zoom()<CR>"           , 'Zoom in/out project window.' )
call extags#register_hotkey( 4  , '<CR>'            , ":call extags#confirm_select('')<CR>"      , 'Go to the select result.' )
call extags#register_hotkey( 5  , '<2-LeftMouse>'   , ":call extags#confirm_select('')<CR>"      , 'Go to the select result.' )
call extags#register_hotkey( 6  , '<S-CR>'          , ":call extags#confirm_select('shift')<CR>" , 'Go to the select result in split window.' )
call extags#register_hotkey( 7  , '<S-2-LeftMouse>' , ":call extags#confirm_select('shift')<CR>" , 'Go to the select result in split window.' )
"}}}

call ex#register_plugin( 'extags', { 'actions': ['autoclose'] } )

" vim:ts=4:sw=4:sts=4 et fdm=marker:
