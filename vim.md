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
```
let @*=expand('%')
```
复制到剪贴板
```
let @+=expand('%')
```
