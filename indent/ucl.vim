" Vim indent file
" Language:     UCL (Universal Configuration Language)
" Maintainer:   Oscar Wallberg <oscar.wallberg@outlook.com>
" Upstream:     https://github.com/owallb/vim-ucl
" Last Change:  2025-02-12

" Only load this indent file when no other was loaded
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetUCLIndent(v:lnum)
setlocal indentkeys=0{,0},0],!^F,o,O

let b:undo_indent = "setl inde< indk<"

" Only define the function once
if exists("*GetUCLIndent")
    finish
endif

let s:cblock_start_pat = '^\s*/\*'
let s:cblock_end_pat = '^\s*\*/'
let s:hdoc_start_pat = '<<\u\+\s*$'
let s:hdoc_end_pat = '^\u\+\s*$'
let s:container_end_pat = '^\s*[}\]][,;]\?\s*$'
let s:container_start_pat = '[{[]\s*$'

function! s:IsInCommentBlock(lnum)
    let l:start = searchpair(s:cblock_start_pat, '', s:cblock_end_pat, 'bnW')
    let l:end = searchpair(s:cblock_start_pat, '', s:cblock_end_pat, 'nW')
    return start > 0 && (end == 0 || a:lnum <= end)
endfunction

function! s:IsInHereDoc(lnum)
    let l:start = searchpair(s:hdoc_start_pat, '', s:hdoc_end_pat, 'bnW')
    let l:end = searchpair(s:hdoc_start_pat, '', s:hdoc_end_pat, 'nW')
    return start > 0 && (end == 0 || a:lnum <= end)
endfunction

function! GetUCLIndent(lnum)
    let l:prevlnum = prevnonblank(a:lnum - 1)
    if prevlnum == 0
        return 0
    endif

    let l:line = getline(a:lnum)
    let l:prevline = getline(prevlnum)

    if s:IsInCommentBlock(a:lnum)
        return cindent(a:lnum)
    endif

    if prevline =~ s:cblock_end_pat
        let l:commentstart = search(s:cblock_start_pat, 'bnW')
        if commentstart > 0
            return indent(commentstart)
        endif
    endif

    let l:ind = indent(prevlnum)

    if s:IsInHereDoc(a:lnum)
        return -1
    endif

    if line =~ s:hdoc_end_pat
        return 0
    endif

    if prevline =~ s:hdoc_end_pat
        let l:hdocstart = search(s:hdoc_start_pat, 'bnW')
        if hdocstart > 0
            return indent(hdocstart)
        endif
    endif

    if line =~ s:container_end_pat
        return ind - shiftwidth()
    endif

    if prevline =~ s:container_start_pat
        return ind + shiftwidth()
    endif

    return ind
endfunction
