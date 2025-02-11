" Vim filetype plugin
" Language:     UCL (Universal Configuration Language)
" Maintainer:   Oscar Wallberg <oscar.wallberg@outlook.com>
" Upstream:     https://github.com/owallb/vim-ucl
" Last Change:  2025-02-11

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal comments=s1:/*,mb:*,ex:*/,:#
setlocal commentstring=#\ %s
setlocal formatoptions=tcqjro

let b:undo_ftplugin = "setl fo< com< cms<"
