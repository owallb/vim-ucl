" Vim syntax file
" Language:     UCL (Universal Configuration Language)
" Maintainer:   Oscar Wallberg <oscar.wallberg@outlook.com>
" Upstream:     https://github.com/owallb/vim-ucl
" Last Change:  2025-02-19

if exists("b:current_syntax")
  finish
endif

" Scalars
syn keyword uclBoolean true false yes no contained
syn keyword uclNull null contained
syn match uclNumber "-\?\<\d\+\>" contained
syn match uclNumber "-\?\<\d\+[kKmMgG]b\?\>" contained
syn match uclNumber "-\?\<\d\+\%(min\|ms\|[sdwy]\)\>" contained
syn match uclFloat "-\?\<\d\+\.\d\+\>" contained
syn match uclFloat "-\?\<\d\+\.\d\+[kKmMgG]b\?\>" contained
syn match uclFloat "-\?\<\d\+\.\d\+\%(min\|ms\|[sdwy]\)\>" contained
syn match uclHex "-\?\<0x[0-9a-fA-F]\+\>" contained
syn match uclHex "-\?\<0x[0-9a-fA-F]\+[kKmMgG]b\?\>" contained
syn match uclHex "-\?\<0x[0-9a-fA-F]\+\%(min\|ms\|[sdwy]\)\>" contained

" Strings
syn match uclEscape contained "\\."
syn region uclString start=/"/ skip=/\\\\\|\\"/ end=/"/ contained contains=uclEscape
syn region uclString start=/'/ skip=/\\\\\|\\'/ end=/'/ contained contains=uclEscape
syn region uclHereDocString 
            \ matchgroup=uclHereDocDelimiterStart
            \ start="<<\z(\u\+\)"
            \ matchgroup=uclHereDocDelimiterEnd
            \ end="^\z1"
            \ fold contained
            \ contains=uclEscape

" Nested structures
syn region uclBlock start="{" end="}" fold transparent contained
syn region uclList start="\[" end="\]" fold transparent contained

" Grouping
syn cluster uclValues
            \ contains=
            \ uclBoolean,
            \ uclNull,
            \ uclNumber,
            \ uclFloat,
            \ uclHex,
            \ uclString,
            \ uclHereDocString,
            \ uclBlock,
            \ uclList

" Comments
syn match uclComment "#.*$" contains=@Spell
syn region uclCommentBlock
            \ start="/\*"
            \ end="\*/"
            \ fold
            \ contains=uclCommentBlock,@Spell

" Structure and list syntax
syn match uclKeys "^\%(\s*[a-zA-Z0-9_-]\+\)\+" nextgroup=uclKeyOperator,@uclValues skipwhite
syn match uclKeyOperator "[=:]" contained nextgroup=@uclValues skipwhite

" Preprocessor
syn match uclVariable "\${[^}]*}"
syn match uclRef "\$[a-zA-Z0-9_.-]\+"
syn match uclMacro "@[a-zA-Z0-9_-]\+"
syn match uclInclude "^@include\>"

" Define highlighting
hi def link uclBoolean Boolean
hi def link uclNull Constant
hi def link uclNumber Number
hi def link uclFloat Float
hi def link uclHex Number
hi def link uclString String
hi def link uclHereDocString uclString
hi def link uclHereDocDelimiter Delimiter
hi def link uclHereDocDelimiterStart uclHereDocDelimiter
hi def link uclHereDocDelimiterEnd uclHereDocDelimiter
hi def link uclEscape Special
hi def link uclComment Comment
hi def link uclCommentBlock Comment
hi def link uclVariable Identifier
hi def link uclMacro PreProc
hi def link uclInclude Include
hi def link uclKeys Identifier
hi def link uclKeyOperator Operator
hi def link uclRef Identifier
hi def link uclBraceError Error
hi def link uclBracketError Error

" Enable folding
if !exists("g:ucl_fold")
    let g:ucl_fold = 1
endif

if g:ucl_fold == 1
    setlocal foldmethod=syntax
endif

let b:current_syntax = "ucl"
