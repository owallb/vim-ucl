" Vim syntax file
" Language:     UCL (Universal Configuration Language)
" Maintainer:   Oscar Wallberg <oscar.wallberg@outlook.com>
" Upstream:     https://github.com/owallb/vim-ucl
" Last Change:  2025-02-13

if exists("b:current_syntax")
  finish
endif

" Scalars
syn match uclEscape contained "\\."
syn keyword uclBoolean true false yes no contained
syn keyword uclNull null contained
syn match uclNumber "\<\d\+\>" contained
syn match uclFloat "\<\d\+\.\d\+\>" contained
syn match uclHex "\<0x[0-9a-fA-F]\+\>" contained
syn region uclString start=/"/ skip=/\\\\\|\\"/ end=/"/ contained contains=uclEscape
syn region uclString start=/'/ skip=/\\\\\|\\'/ end=/'/ contained contains=uclEscape
syn region uclHereDocString start=/<<\z([a-z0-9A-Z]\+\)/ end=/^\z1/ fold contained contains=uclEscape

" Nested structures
syn region uclBlock start="{" end="}" fold transparent contained
syn region uclList start="\[" end="\]" fold transparent contained

" Grouping
syn cluster uclValues contains=uclBoolean,uclNull,uclNumber,uclFloat,uclHex,uclString,uclHereDocString,uclBlock,uclList

" Comments
syn match uclComment "#.*$" contains=@Spell
syn region uclMultilineComment start="/\*" end="\*/" fold contains=uclMultilineComment,@Spell

" Structure and list syntax
syn match uclKey "^\s*[a-zA-Z0-9_-]\+\>" nextgroup=uclKeyOperator,@uclValues skipwhite
syn match uclKeyOperator "[=:]" contained nextgroup=@uclValues skipwhite

" UCL specific
syn match uclVariable "\${[^}]*}"
syn match uclMacro "@[a-zA-Z0-9_-]\+"
syn match uclInclude "^@include\>"

" Variable references
syn match uclRef "\$[a-zA-Z0-9_.-]\+"

" Define highlighting
hi def link uclBoolean Boolean
hi def link uclNull Constant
hi def link uclNumber Number
hi def link uclFloat Float
hi def link uclHex Number
hi def link uclString String
hi def link uclHereDocString uclString
hi def link uclEscape Special
hi def link uclComment Comment
hi def link uclMultilineComment Comment
hi def link uclVariable Identifier
hi def link uclMacro PreProc
hi def link uclInclude Include
hi def link uclKey Identifier
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
