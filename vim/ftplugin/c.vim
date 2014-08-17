let name = 'Eduardo San Martin Morote'
let email = 'i@posva.net'
let web = 'http://posva.net'
map <buffer> <C-E> <ESC>ggO/**<ESC>:call FillLine("*", 81)<CR>A<CR> <C-R>=expand("%:t:r")<CR><ESC>:call FillLine(" ", 80)<CR>A*<CR><C-R>=strftime("%a %b %d %Z %Y")<CR><ESC>:call FillLine(" ", 80)<CR>A*<CR>Copyright <C-R>=name<CR><ESC>:call FillLine(" ", 80)<CR>A*<CR><C-R>=email<CR><ESC>:call FillLine(" ", 80)<CR>A*<CR><C-R>=web<CR><ESC>:call FillLine(" ", 80)<CR>A*<CR><ESC>:call FillLine("*", 80)<CR>A/<CR><ESC>ggO#ifndef __<C-R>=expand("%:t:r")<CR>_H__<ESC>^f gUg_o#define __<C-R>=expand("%:t:r")<CR>_H__<ESC>^f gUg_Go#endif<ESC>kko

