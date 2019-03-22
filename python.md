python 动态强类型语言  
动态: 数据类型在运行期确定; 静态: 数据类型在编译期确定  
强类型: 不会发生隐式转换(如不允许这样的操作:`1+'1'`)

特点:
* 胶水语言, 轮子多, 应用广泛
* 语言灵活, 生产力高
* 性能问题、代码维护问题、python2/3兼容问题

鸭子类型: 
> 当一只鸟看起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子。
* 关注对象的行为，而不是类型
* 比如`file`, `StringIO`, `socket`对象都支持read/write方法(file like object)
* 再比如定义了`__iter__`魔术方法的对象可以用for迭代

monkey patch:
* monkey patch 就是运行时替换
* 比如`gevent`库需要修改内置的`socket`
* `from gevent import monkey; monkey.patch_socket()`

自省(Introspection):
* 运行时判断一个对象类型的能力
* Python一切皆对象, 用`type`, `id`, `isinstance`获取对象类型信息
* Inspect 模块提供了更多获取层叠的信息的函数

列表和字典推倒:
* 比如`[i for i in range(10) if i % 2 == 0]`
* 一种快速生成list/dict/set的方式。用来代替map/filter等
* `(i for i in range(10) if i % 2 == 0)` 返回生成器

Python之禅(The Zen of Python):
* Tim Peters(Python 核心开发者之一)编写的关于Python编程的准则
* import this
* 编程拿不准的时候可以参考

Python3改进:
* `print`成为函数, 在2中是关键字
* 编码(2中默认是字节); Python3不再有Unicode对象, 默认str就是unicode
* 除法, Python3除号返回浮点数
* 类型注解(type hint), 帮助IDE实现类型检查  
```python
def hello(name: str) -> str:
    return 'hello ' + name
```
* 优化的`super()`方便直接调用父类函数
* 高级解包操作, `a, b, *c = range(10)`, `a, b, *_ = range(10) # 丢弃后面的`
* Keyword only arguments 限定关键字参数(传入参数的同时要指明参数名)
* Chained exceprions Python3 重新抛出异常不会丢失栈信息
* 一切返回迭代器`range`, `zip`, `map`, `dict.values`, etc. are all iterators
* 生成的pyc文件统一放到`__pycache__`
* 一些内置库的修改, `urllib`, `selector`等
* 性能优化

Python3新增:
* `yield from`链接子生成器
* asyncio 内置库, async/await 原生协程支持异步编程
* 新的内置库 `enum`, `mock`, `asyncio`, `ipaddress`, `concurrent.futures`

Python2/3工具(兼容2/3的工具)
* six 模块
* 2to3 等工具转换代码
* __future__


## learn python from mooc
* 字符串 string

| 操作                    | 含义                        |
|-------------------------|-----------------------------|
| \<string\>.upper()      | 字符串中字母大写            |
| \<string\>.lower()      | 字符串中字母小写            |
| \<string\>.capitalize() | 首字母大写                  |
| \<string\>.strip()      | 去两边空格及去指定字符      |
| \<string\>.split()      | 按指定字符分割字符串为数组  |
| \<string\>.isgigit()    | 判断是否是数字类型,返回True |
| \<string\>.find()       | 搜索指定字符串              |
| \<string\>.replace()    | 字符串替换                  |

```python
>>>"python is an excellent language".split()
['python', 'is', 'an', 'excellent', 'language']
>>>
```

* 列表 list

| 序列操作符                 | 操作符含义                      |
|----------------------------|---------------------------------|
| \<seq\> + \<seq\>          | 连接两个序列                    |
| \<seq\> * \<int\>          | 对序列进行整数次重复            |
| \<seq>\[\<int\>\]          | 索引序列中的元素                |
| len(\<seq\>)               | 序列中元素的个数                |
| \<seq\>\[\<int\>:\<int\>\] | 取序列的一个子序列              |
| for \<var\> in \<seq\> :   | 对序列进行循环列举              |
| \<expr\> in \<seq\>        | 成员检查,判断<expr>是否在序列中 |

| 方法                 | 含义                           |
|----------------------|--------------------------------|
| \<list\>.append(x)   | 将元素x增加到列表的最后        |
| \<list\>.sort()      | 将列表排序                     |
| \<list\>.reverse()   | 将列表元素反转                 |
| \<list\>.index()     | 返回第一次出现x的索引值        |
| \<list\>.insert(i,x) | 在位置i处插入新元素x           |
| \<list\>.count(x)    | 返回元素x在列表中的数量        |
| \<list\>.remove(x)   | 删除列表中第一次出现的元素x    |
| \<list\>.pop(i)      | 取出列表中位置i的元素,并删除它 |

* 数学库 math

|    函数    |       含义        |
|------------|-------------------| 
| pi         | 圆周率(15位)      |
| e          | 自然对数(15位)    |
| ceil(x)    | 对x向上取整       |
| floor(x)   | 对x向下取整       |
| exp(x)     | e的x次幂          |
| degrees(x) | 将弧度转换为角度  |
| radians(x) | 将角度转换为弧度  |
 
* 随机库 random

|         函数       |              含义                |
|--------------------|----------------------------------| 
| seed()             | 给随机数一个种子,默认为系统时钟  |
| random()           | 生成一个\[0,1.0\]之间的随机小数  |
| uniform(a,b)       | 生成一个a到b之间的随机小数       |
| randint(a,b)       | 生成一个a到b之间的随机整数       |
| randrange(a,b,c)   | 随机生成一个从a开始到b以c递增的数|
| choice(\<list\>)   | 从列表中随机返回一个元素         |
| shuffle(\<list\>)  | 将列表中随机返回一个元素         |
| sample(\<list\>,k) | 从指定列表随机获取k个元素        |

* 高阶函数

1. `map(function_with_one_arg, list)`: 把function作用到list的每一个元素, 不改变原list, 返回一个Iterator  
```python
# 例如求a中每一个元素的平方, 并生成一个新的list
def f(x):
    return x * x
a = [1, 2, 3, 4]
b = map(f, x)
print(list(b))
```

2. `reduce(function_with_two_args, list)`: 把function作用在list上, reduce把结果和list下一个元素做累加计算不改变原list  
```python
# 例如将数字序列[1, 2, 3, 4]变换成整数1234
from functools import reduce
a = [1, 2, 3, 4]
def f(x, y):
    return x * 10 + y
print(reduce(f, a))
```

3. `filter(function_with_one_arg, list)`: 把function作用在list上, 根据返回值是True还是False决定元素保留还是丢弃, 不改变原list  
```python
# 例如去掉一个list中的偶数，仅保留奇数
a = [1, 2 ,3, 4]
def is_odd(x):
    return n % 2 == 1
print(list(filter(is_odd, a)))
```

4. `sorted(list, [key = function_with_one_arg], [reverse = True/False])`: 返回排序之后的list, 不改变原list  
```python
# 例如按照绝对值从大到小排序
a = [1, -2, 3, -4]
sorted(a, key = abs, reverse = True)
```

* 特殊方法(定义在class中)

    - 用于print的__str__
    - 用于len的__len__
    - 用于cmp的__cmp__
    - ...

> 不需要直接调用, python的某些函数或操作符会调用相应的特殊方法
> 有关联的特殊方法都必须实现


*problem raised when trying to import tesserocr*
```
>>> import tesserocr
!strcmp(locale, "C"):Error:Assert failed:in file baseapi.cpp, line 209
[1]    9424 segmentation fault (core dumped)  python
```
*how to fix*
```
import locale
locale.setlocale(locale.LC_ALL, 'C')
import tesserocr
```

* 文件操作
    - `read()`: 一次性读取文件全部内容, 文件太大内存吃不消, 保险起见, 可以反复调用`read(size)`, 每次最多读取 size 个字节的内容;
    - `readline()`: 每次读取一行内容;
    - `readlines()`: 一次读取全部内容并按行返回`list`;
```
# 尽量采用这种方式打开文件, 可以不用调用close()
with open('/path/to/file', 'r', encoding='gbk') as f:
    print(f.read())

for line in readlines():
    print(line.strip()) # 去掉行末的'\n'
```
