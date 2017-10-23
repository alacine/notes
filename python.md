## learn python from mooc
* 字符串 string

|          操作           |          含义             |
|-------------------------|--------------------------| 
| \<string\>.upper()      | 字符串中字母大写           |
| \<string\>.lower()      | 字符串中字母小写           |
| \<string\>.capitalize() | 首字母大写                 |
| \<string\>.strip()      | 去两边空格及去指定字符      |
| \<string\>.split()      | 按指定字符分割字符串为数组  |
| \<string\>.isgigit()    | 判断是否是数字类型,返回True |
| \<string\>.find()       | 搜索指定字符串             |
| \<string\>.replace()    | 字符串替换                 |

```python
>>>"python is an excellent language".split()
['python', 'is', 'an', 'excellent', 'language']
>>>
```

* 列表 list

|    序列操作符              |          操作符含义          |
|---------------------------|------------------------------| 
| \<seq\> + \<seq\>         | 连接两个序列                  |
| \<seq\> * \<int\>         | 对序列进行整数次重复          |
| \<seq>\[\<int\>\]         | 索引序列中的元素              |
| len(\<seq\>)              | 序列中元素的个数              |
| \<seq\>\[\<int\>:\<int\>\]| 取序列的一个子序列            |
| for \<var\> in \<seq\> :  | 对序列进行循环列举            |
| \<expr\> in \<seq\>       | 成员检查,判断<expr>是否在序列中|

|          方法            |          含义               |
|-------------------------|-----------------------------| 
| \<list\>.append(x)      | 将元素x增加到列表的最后      |
| \<list\>.sort()         | 将列表排序                   |
| \<list\>.reverse()      | 将列表元素反转               |
| \<list\>.index()        | 返回第一次出现x的索引值       |
| \<list\>.insert(i,x)    | 在位置i处插入新元素x          |
| \<list\>.count(x)       | 返回元素x在列表中的数量       |
| \<list\>.remove(x)      | 删除列表中第一次出现的元素x    |
| \<list\>.pop(i)         | 取出列表中位置i的元素,并删除它 |

* 数学库 math

|    函数    |       含义        |
|------------|------------------| 
| pi         | 圆周率(15位)      |
| e          | 自然对数(15位)    |
| ceil(x)    | 对x向上取整       |
| floor(x)   | 对x向下取整       |
| exp(x)     | e的x次幂          |
| degrees(x) | 将弧度转换为角度   |
| radians(x) | 将角度转换为弧度   |
 
* 随机库 random

|         函数       |              含义              |
|--------------------|-------------------------------| 
| seed()             | 给随机数一个种子,默认为系统时钟  |
| random()           | 生成一个\[0,1.0\]之间的随机小数  |
| uniform(a,b)       | 生成一个a到b之间的随机小数       |
| randint(a,b)       | 生成一个a到b之间的随机整数       |
| randrange(a,b,c)   | 随机生成一个从a开始到b以c递增的数 |
| choice(\<list\>)   | 从列表中随机返回一个元素         |
| shuffle(\<list\>)  | 将列表中随机返回一个元素         |
| sample(\<list\>,k) | 从指定列表随机获取k个元素        |

