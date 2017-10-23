## learn python from mooc
* 字符串 string

|          操作         |          含义             |
|-----------------------|--------------------------| 
| \<string\>.upper()      | 字符串中字母大写           |
| <string>.lower()      | 字符串中字母小写           |
| <string>.capitalize() | 首字母大写                 |
| <string>.strip()      | 去两边空格及去指定字符      |
| <string>.split()      | 按指定字符分割字符串为数组  |
| <string>.isgigit()    | 判断是否是数字类型,返回True |
| <string>.find()       | 搜索指定字符串             |
| <string>.replace()    | 字符串替换                 |

```python
>>>"python is an excellent language".split()
['python', 'is', 'an', 'excellent', 'language']
>>>
```

* 列表 list

|    序列操作符          |          操作符含义          |
|-----------------------|------------------------------| 
| <seq> + <seq>         | 连接两个序列                  |
| <seq> * <int>         | 对序列进行整数次重复          |
| <seq>[<int>]          | 索引序列中的元素              |
| len(<seq>)            | 序列中元素的个数              |
| <seq>[<int>:<int>]    | 取序列的一个子序列            |
| for <var> in <seq> :  | 对序列进行循环列举            |
| <expr> in <seq>       | 成员检查,判断<expr>是否在序列中|

|          方法         |          含义               |
|-----------------------|-----------------------------| 
| <list>.append(x)       | 将元素x增加到列表的最后      |
| <list>.sort()         | 将列表排序                   |
| <list>.reverse()      | 将列表元素反转               |
| <list>.index()        | 返回第一次出现x的索引值       |
| <list>.insert(i,x)    | 在位置i处插入新元素x          |
| <list>.count(x)       | 返回元素x在列表中的数量       |
| <list>.remove(x)      | 删除列表中第一次出现的元素x    |
| <list>.pop(i)         | 取出列表中位置i的元素,并删除它 |
