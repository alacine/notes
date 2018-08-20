变量叠加
```shell
x=123
x="$x"456
x=${x}789
# 最后x的值为"123456789"
```

```shell
set # 查看当前所有变量
set -u # 设定此选项，调用未声明变量时会报错(默认没有提示)
unset x # 删除变量名
```

设置环境变量
```shell
export x=1 #
y=1
export y # 
```





