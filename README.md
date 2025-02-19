# vim-ucl

Vim support for UCL (Universal Configuration Language) files, including syntax highlighting and indentation.

## Installation

### Using vim-plug

```vim
Plug 'owallb/vim-ucl'
```

### Using lazy.nvim

```lua
{
  'owallb/vim-ucl',
}
```

### Manual Installation

Copy the contents of this repository into your ~/.vim directory (or %USERPROFILE%\vimfiles on Windows).

## File Type Detection

By default, this plugin will be activated for files with the `.ucl` extension. If you use UCL files with different extensions, you have several options:

### Via vimrc

Add this to your vimrc:
```vim
autocmd BufNewFile,BufRead *.conf setfiletype ucl
```

### Via modeline

Add one of these lines near the start or end of your UCL file:
```
# vim: ft=ucl
```
or
```
/* vim: set ft=ucl: */
```

## Configuration

The plugin has one configuration option:

```vim
" Disable syntax folding (enabled by default)
let g:ucl_fold = 0
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [UCL documentation](https://rspamd.com/doc/configuration/ucl.html)
- [libucl](https://github.com/vstakhov/libucl)

