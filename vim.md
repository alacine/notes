## VIM 操作

global 操作

删除空白行
```vimscript
g/^$/d
"global/^$/delete
```

删除空白行以及仅包含不可见空白符号的行(可通过`set list`来查看这些字符)
```vimscript
g/^\s*$/d
```

删除多个连续的空白行，只保留一个空行
```vimscript
g/^\_$\n^$/d
```

获取当前文件的路径，复制到 X 主选择区
```vim
let @*=expand('%')
```
复制到剪贴板
```vim
let @+=expand('%')
```

匹配单词边界(不是`\b`)
```vim
" 单词左边界
:\<
" 单词右边界
:\>
```

关闭除当前 buffer 之外的所有 buffer
```
:%bd|e#
```

手动加载插件

vim-plug，用 vim-go 的时候设置了
```vim
Plug 'fatih/vim-go', { 'for': ['go'] ,'do': ':GoInstallBinaries' }
"let g:go_fmt_command = 'goimports'
```
仅在打开 go 文件时启用插件。这样有个问题，第一个打开的 go 文件不能有 vim-go 提
供的更多语法高亮的功能。vim 启动的时候还没有加载 vim-go，当打开 go 文件时，开始
加载 vim-go，此时文件当然没有 vim-go 提供的高亮，需要手动触发一下才可以，有这么
几种方法。
```vim
" 可行
:e
" 不可行
:w
" 可行
:call plug#load('vim-go')
```

`go_fmt_command`会使得文件保存时会导致`coc`的检查丢失，
因此把它注释掉了（如果不注释掉可以手动保存一次文件即可获得高亮）。

