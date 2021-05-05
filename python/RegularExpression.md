## 正则表达式 (regular expression)

Regex 风格
* POSIX(Portable Operating System Interface) 规范，定义正则表达式的两个标准： BRE(基本 re)和 ERE(扩展 re)
* PCRE(Perl Compatible Regular Expressions) 现在的变成语言中的正则表达式，大部分都属于这个分支

练习网站 [RegexOne](https://regexone.com/)

| 字符               | 匹配                                   |
|--------------------|----------------------------------------|
| `.`                | 匹配任意字符                           |
| `[abc]`            | 匹配字符集                             |
| `\d` / `\D`        | 匹配数字/非数字                        |
| `\s` / `\S`        | 匹配空白/非空白                        |
| `\w` / `\W`        | 匹配单词字符\[a-zA-Z0-9\]/非单词字符   |
| `\b` / `\B`        | 匹配单词边界/非单词边界                |
| `*`                | 匹配前一个字符0次或者无限次            |
| `+`                | 匹配前一个字符1次或者无限次            |
| `?`                | 匹配前一个字符0次或者1次               |
| `{m}` / `{m,n}`    | 匹配前一个字符m次或者m到n次            |
| `*?` / `+?` / `??` | 匹配模式变为非贪婪\(尽可能少匹配字符\) |


python re 模块常用函数

```python
import re

# 全字符串查找
re.search()
# 从字符串开头查找
re.match()
# 字符串完全匹配
re.fullmatch()
# 查找出所有匹配的子字符串
re.findall()
# 同上返回一个迭代器
re.finditer()

# 替换
re.sub()
# 多返回一个替换的次数
re.subn()

# 分割
re.spilit()
```
不写例子了，还是直接看文档更好

转译字符

不使用 raw string
```python
import re

s = 'abc\def'
result = re.search('(\w+)\\\\(\w+)', s)
```

使用 raw string
```python
import re

s = 'abc\def'  # 或 s = 'abc\def'
result = re.search(r'(\w+)\\(\w+)', s)
```
