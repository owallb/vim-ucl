" Vim indent file
" Language:     UCL (Universal Configuration Language)
" Maintainer:   Oscar Wallberg <oscar.wallberg@outlook.com>
" Upstream:     https://github.com/owallb/vim-ucl
" Last Change:  2025-02-19

" Only load this indent file when no other was loaded
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetUCLIndent()
setlocal indentkeys=0{,0},0],!^F,o,O

let b:undo_indent = "setl inde< indk<"

" Only define the function once
if exists("*GetUCLIndent")
    finish
endif

let s:cblock_start_pat = '^\s*/\*'
let s:cblock_end_pat = '^\s*\*/'
let s:container_start_pat = '[{[]\s*$'
let s:brace_end_pat = '^\s*\}'
let s:bracket_end_pat = '^\s*\]'

function! s:GetCurSyn()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

function! s:IsComment()
    return s:GetCurSyn() =~? 'comment'
endfunction

function! s:IsString()
    return s:GetCurSyn() =~? 'string'
endfunction

function! s:IsCommentOrString()
    return s:IsComment() || s:IsString()
endfunction

function! s:IsInHereDoc()
    return synIDattr(synID(
                \ prevnonblank(v:lnum), 1, 0), 'name') =~ 'uclHereDocString'
endfunction

function! s:IsHereDocEnd()
    return synIDattr(synID(v:lnum, 1, 0), 'name') =~ 'uclHereDocDelimiterEnd'
endfunction

function! s:IsInCommentBlock()
    let match = searchpair(s:cblock_start_pat, '', s:cblock_end_pat . '\zs',
                \ 'bnW', 's:IsString()')
    return match > 0
endfunction

function! s:CommentIndent()
    let cblock_start_lnum = s:PrevCodeLine()
    let ind = indent(cblock_start_lnum)

    if getline(v:lnum) =~ '^\s*\*'
        return ind + 1
    endif

    return ind
endfunction

function! s:PrevCodeLine()
    let lnum = prevnonblank(v:lnum - 1)

    while lnum > 0
        if synIDattr(synID(lnum, 1, 0), 'name') =~ 'uclHereDoc\|uclCommentBlock'
            let lnum -= 1
        else
            break
        endif

        let lnum = prevnonblank(lnum)
    endwhile

    return lnum
endfunction

function! GetUCLIndent()
    if s:IsInHereDoc() || s:IsHereDocEnd()
        return -1
    endif

    if s:IsInCommentBlock()
        return s:CommentIndent()
    endif

    let line = getline(v:lnum)

    if line =~ s:brace_end_pat
        let match = searchpair('{', '', '}\zs', 'bnW', 's:IsCommentOrString()')
        if match > 0
            return indent(match)
        else
            return -1
        endif
    endif

    if line =~ s:bracket_end_pat
        let match = searchpair(
                    \ '\[', '', '\]\zs', 'bnW', 's:IsCommentOrString()')
        if match > 0
            return indent(match)
        else
            return -1
        endif
    endif

    let prevlnum = s:PrevCodeLine()
    if prevlnum == 0
        return 0
    endif

    let ind = indent(prevlnum)
    let prevline = getline(prevlnum)

    if prevline =~ s:container_start_pat
        return ind + shiftwidth()
    endif

    return ind
endfunction
