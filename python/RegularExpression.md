## 正则表达式 (regular expression)

| 字符          | 匹配                                   |
|---------------|----------------------------------------|
| \.            | 匹配任意字符                           |
| \[...\]       | 匹配字符集                             |
| \\d / \\D     | 匹配数字/非数字                        |
| \\s / \\S     | 匹配空白/非空白                        |
| \\w / \\W     | 匹配单词字符\[a-zA-Z0-9\]/非单词字符   |
| \\b / \\B     | 匹配单词边界/非单词边界                |
| \*            | 匹配前一个字符0次或者无限次            |
| \+            | 匹配前一个字符1次或者无限次            |
| ?             | 匹配前一个字符0次或者1次               |
| \{m\}/\{m,n\} | 匹配前一个字符m次或者m到n次            |
| \*?/\+?/??    | 匹配模式变为非贪婪\(尽可能少匹配字符\) |