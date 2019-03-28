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

Python 之禅(The Zen of Python):
* Tim Peters(Python 核心开发者之一)编写的关于Python编程的准则
* import this
* 编程拿不准的时候可以参考

Python3 改进:
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

Python3 新增:
* `yield from`链接子生成器
* asyncio 内置库, async/await 原生协程支持异步编程
* 新的内置库 `enum`, `mock`, `asyncio`, `ipaddress`, `concurrent.futures`

Python2/3工具(兼容2/3的工具)
* six 模块
* 2to3 等工具转换代码
* __future__

Python函数
* 参数传递
    - 共享传参(既不是传递值也不是引用)
    - Call by Object(Call by Object Reference or Call by Sharing)
    - Call by sharing(共享传参) 函数形参获得实参中各个引用的副本
* (不)可变对象
    - 不可变: bool, int, float, tuple, str, frozenset
    - 可变: list, set, dict
* 可变参数
    - 默认参数只计算一次

Python `*args`, `**kwargs`
* 用来处理可变参数
* `*args` 被打包成 tuple
* `**kwargs` 被打包成 dict

Python 异常

Python 使用异常处理错误(有些语言使用错误码)
* 所有异常继承于 BaseException
* 系统相关的异常 SystemExit/KeyboardInterrupt/GeneratorExit
* Exception

什么时候需要捕获异常? 看Python内置的异常类型
* 网络请求(超时、连接错误等)
* 资源访问(权限问题、资源不存在)
* 代码逻辑(越界访问、KeyError等)

```python
try:
    # func      # 可能会抛出异常的代码
except (Exception1, Exception2) as e: # 可以捕获多个异常并处理
    # 异常处理的代码
else:
    # pass      # 异常没有发生的时候代码逻辑
finally:
    pass        # 无论异常有没有发生都会执行的代码，一般处理资源的关闭和释放
```

如何自定义自己的异常? 为什么需要定义自己的异常?
* 继承Exception实现自定义异常(为什么不是BaseException)
* 给异常加上一些附加信息
* 处理一些业务相关的特定异常(raise MyException)

```python
class MyException(Exception):
    pass

try:
    raise MyException('my exception')
except Exception as e:
    print(e)
```

Python 性能分析与优化，GIL常考

什么是Cpython GIL(GIL, Global Interpreter Lock)
* Cpython 解释器的内存管理并不是线程安全的
* 保护多线程情况下对 Python 对象的访问
* Cpython 室友简单的锁机制避免多个线程同时执行字节码

GIL 影响(限制了程序的多核执行)
* 同一个时间只能有一个线程执行字节码
* CPU 密集程序难以利用多核优势
* IO 期间会释放 GIL, 对IO密集程序影响不大

如何规避 GIL 影响(区分 CPU 和 IO 密集程序)
* CPU 密集可以使用多进程+进程池
* IO密集使用多进程/协程
* cython 扩展 (把python程序转化成c)

为什么有了 GIL 还有关注线程安全(Python 中什么操作才是原子的? 一步到位执行完)
* 一个操作如果是一个字节码指令可以完成就是原子的
* 原子的是可以保证线程安全的
* 使用 dis 操作来分析字节码

如何剖析程序性能(使用各种profile工具(内置或第三方))
* 二八定律，大部分时间耗时在少量代码上
* 内置的 profile/cprofile 等工具
* 使用 pyflame(uber 开源) 的火焰图工具

服务端性能优化措施(Web应用一般语言不会成为瓶颈)
* 数据结构与算法优化
* 数据库: 索引优化, 慢查询消除, 批量操作减少IO, NoSQL
* 网络IO: 批量操作, pipeline操作减少IO
* 缓存: 使用内存数据库 redis/memcached
* 异步: asyncio, celery
* 并发: gevent/多线程

Python 生成器和协程

Generator
* 生成器就是可以生成值的函数
* 当一个函数里有了 yield 关键字就成了生成器
* 生成器可以挂起执行并且保持当前执行的状态
```python
def simple_gen():
    yield 'hello'
    yield 'world'

gen = simple_gen()
print(type(gen)) # 'generator' object
print(next(gen)) # 'hello'
print(next(gen)) # 'world'
```

基于生成器的协程(Python3之前没有原生协程, 只有基于生成器的协程)
* pep 341(Coroutines via Enhanced Generators) 增强生成起的功能
* 生成器可以通过yiedld暂停执行和产出数据
* 同时支持send()向生成器发送数据和throw()想生成器抛出异常
```python
# Generator Based Coroutine 示例
def coro():
    hello = yield 'hello'
    yield hello

c = coro()
# 输出'hello', 这里调用 next 产出第一个值 'hello', 之后函数暂停
print(next(c))
# 再次调用 send 发送值, 此时 hello 变量复制为'world', 然后 yield 产出 hello 变量的值'world'
print(c.send('world'))
# 之后协程结束, 后续再 send 值会抛出异常 StopIteration
```

协程的注意点
* 协程需要使用 send(None) 或者 next(coroutine) 来【预激】(prime)才能启动
* 有yield处协程或暂停执行
* 单独的yield value会产出值给调用方
* 可以通过 coroutine.send(value) 来给协程发送值, 发送的值会赋值给 yield 表达式左边的变量 value = yield
* 协程执行完成后(没有遇到下一个yield语句)会抛出StopIteration

协程装饰器(避免每次都要用 send 预激它)
```python
from functools import wraps
def coroutine(func): # 这样就不用每次都用 send(None) 启动了
    # 装饰器: 向前执行到第一个 yield 表达式, 预激 func
    @wraps(func)
    def primer(*args, **kwargs):
        gen = func(*args, **kwargs)
        next(gen)
        return gen
    return primer
```

Python3 原生协程(3.5引入async/await支持原生协程)
```python
import asyncio
import datetime
import random

async def display_date(num, loop):
    end_time = loop.time() + 50.0
    while True:
        print('Loop: {} Time: {}'.format(num, datatime.datatime.now()))
        if (loop.time() + 1.0) >= end_time:
            break
        await asyncio.sleep(random.randint(0, 5))

loop = asyncio.get_event_loop()
asynico.ensure_future(display_date(1, loop))
asynico.ensure_future(display_date(2, loop))
loop.run_forever()
```

单元测试(Unit Testing)
* 针对程序模块进行正确性检验
* 一个函数, 一个类进行验证
* 自底向上保证程序正确性
* 为什么要写
    - 保证代码逻辑的正确性(甚至有些采用测试驱动开发(TDD))
    - 单测影响设计, 易测的代码往往是高内聚低耦合的
    - 回归测试, 防止改一处整个服务不可用
* 相关库
    - nose/pytest 较为常用
    - mock 模块用来模拟替换网络请求等
    - coverage 统计测试覆盖率

Python 深拷贝与浅拷贝
* 什么是深拷贝? 什么是浅拷贝?
* Python 中如何实现深拷贝?
* 思考: Python 中如何正确初始化一个二维数组?

Python 常用内置数据结构和算法

| 数据结构/算法 | 语言内置                  | 内置库                                            |
|---------------|---------------------------|---------------------------------------------------|
| 线性结构      | list/tuple                | array(数组, 不常用)/collectinos.namedtuple         |
| 链式结构      |                           | collections.dequeue(双端队列)                     |
| 字典结构      | dict                      | collections.Counter(计数器)/OrderedDict(有序字典) |
| 集合结构      | set/frozenset(不可变集合) |                                                   |
| 排序算法      | sorted                    |                                                   |
| 二分算法      |                           | bisect模块                                        |
| 堆算法        |                           | heapq模块                                         |
| 缓存算法      |                           | functools.lru_cache(Least Recent Used, python3)   |

collections 模块提供了一些内置数据结构的扩展

| 名称         | 功能                        |
|--------------|-----------------------------|
| namedtuple() | 用名称访问tuple中的元素     |
| deque        | 双端队列                    |
| Counter      | 计数器                      |
| OrderedDict  | 安装key的添加顺序排序的dict |
| defaultdict  | 为dict做值的初始化          |

```python
import collections
# namedtuple
Point = collections.namedtuple('Point', 'x, y')
p = Point(1, 2)
print(p.x, p.y)
print(p[0], p[1])
# deque
de = collections.deque()
de.append(1)
de.appendleft(0)
de.pop()
de.popleft()
# Counter
c = collections.Counter()
c = collections.Counter('abcab')
print(c)
print(c['a'])
print(c.most_common()) # 从大到小
# OrderedDict
od = collectinos.OrderedDict()
od['c'] = 'c'
od['a'] = 'a'
od['b'] = 'b'
print(list(od.keys())) # ['c', 'a', 'b']
# defaultdict
dd = collections.defaultdit(int)
print(dd['a'])
dd['b'] += 1
print(dd)
```

dict 底层结构(哈希表)
* 为了支持快速查找使用了哈希表作为底层结构
* 哈希表平均查找时间复杂度O(1)
* CPython 解释器使用二次探查解决哈希冲突问题(哈希表的冲突解决和扩容)
    - 链接法: 元素 key 冲突之后使用一个链表填充相同的 key 的元素
    - 开放寻址法: 冲突之后根据一种方式(二次探查)寻找下一个可用的槽
    - CPython 解释器使用的就是二次探查

list/tuple
* 都是线性结构, 支持下表访问
* list 是可变对象, tuple 不可变(引用不可变)
* list 没法作为字典的 key, tuple 可以(可变对象不可hash)

LRUCache
* 缓存剔除策略, 当缓存空间不够用的时候需要一种方式剔除key
* 常见的有LRU, LFU等
* LRU通过使用一个循环双端队列不断把最新访问的key放到表头实现
    - 利用 Python 内置的 dict + collections.OrderedDict 实现
    - dict 用来当做 k/v 键值对的缓存
    - OrderedDict 用来实现更新最近访问的 key

组合与继承(优先使用组合而非继承)
* 组合是使用其他的类实例作为自己的一个属性(Has-a 关系)
* 子类继承父类的属性和方法(Is a 关系)
* 优先使用组合保持代码简单

类变量和实例变量
* 类变量由所有实例共享
* 实例变量由实例单独享有，不同实例之间不影响
* 当我们需要在一个类的不同实例之间共享变量的时候使用类变量

classmethod/staticmethod
* 都可以通过 Class.method() 的方式使用
* classmethod 第一个参数是 cls, 可以引用类变量
* staticmethod 使用起来和普通函数一样, 只不过放在类里去组织

元类(Meta Class)是创建类的类
* 元类允许我们控制类的生成, 比如修改类的属性等
* 使用 type 来定义元类
* 元类最常见的一个使用场景就是 ORM 框架
* `__new__` 生成实例, `__init__` 初始化
```python
class LowercaseMeta(type):
    """ 修改类的属性名称为小写的元类 """
    def __new__(mcs, name, bases, attrs):
        lower_attrs = {}
        for k, v in attrs.items():
            if not k.startswitth('__'): # 排除magic method
                lower_attrs[k.lower()] = v
            else:
                lower_attrs[k] = v
        return type.__new__(mcs, name, bases, lower_attrs)

class LowercaseClass(metaclass=LowercaseMeta):
    BAR = True

    def HELLO(self):
        print('hello')

print(dir(LowercaseClass)) # 你会发现 "BAR" 和 "HELLO" 都变成了小写
```

Decorator(装饰器)
* Python 中一切皆对象, 函数也可以当做参数传递
* 装饰器是接受函数作为参数, 添加功能后返回一个新函数的函数(类)
* Python 中通过@使用装饰器
```python
import time
def log_time(func): # 接受一个函数作为参数
    def _log(*args, **kwargs):
        beg = time.time()
        res = func(*args, **kwargs)
        print('{} ues time: {}'.format(func.__name__, time.time()-beg))
        return res 
    return _log


class LogTime:
    def __init__(self, use_int=False):
        self.use_int = use_int

    def __call__(self, func):
        def _log(*args, **kwargs):
            beg = time.time()
            res = func(*args, **kwargs)
            if self.use_int:
                print('{} use time: {}'.format(func.__name__, int(time.time()-beg)))
            else:
                print('{} use time: {}'.format(func.__name__, time.time()-beg))
            return res 
        return _log


@log_time # 装饰器语法糖
def mysleep():
    time.sleep(1)

@LogTime(True)
def yoursleep():
    time.sleep(2)

# newsleep = log_time(mysleep)
mysleep()
yoursleep()
```

创建模式(常见创建型设计模式)
* 工厂模式(Factory): 解决对象创建问题
    - 解决对象对象的创建和使用
    - 包括工厂方法和抽象工厂
```python
class DogToy:
    def speak(self):
        print("wang wang")

class CatToy:
    def speak(self):
        print("miao miao")

def toy_factory(toy_type):
    if toy_type == 'dog':
        return DogToy()
    elif toy_type == 'cat':
        return CatToy()
```
* 构造模式(Builder): 控制复杂对象的创建
    - 创建和表示分离, 比如你要买电脑, 工厂模式直接给你需要的电脑
    - 但是构造模式允许你自己定义电脑的配置, 组装完成后给你
* 原型模式(Prototype): 通过原型的克隆创建新的实例
    - 可以使用相同的原型, 通过修改部分属性来创建新的实例
    - 用途: 对于一下创建实例开销比较高的地方可以用原型模式
* 单例(Bory/Singleton): 一个类只能创建同一个对象
    - 一个类创建出来的对象都是同一个
    - Python 的模块其实就是单例的, 只会导入一次
    - 使用共享同一个实例的方式来创建单例模式
```python
class Singleton:
    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, '_instance'):
            _instance = super().__new__(cls, *args, **kwargs)
            cls._instance = _instance
        return cls._instance

class MyClass(Singleton):
    pass

c1 = MyClass()
c2 = MyClass()
assert c1 is c2
```
* 对象池模式(Pool): 预先分配同一类型的一组实例
* 惰性计算模式(Lazy Evaluation): 延迟计算(python 和 property)

结构型设计模式
* 装饰器模式(Decorator): 无需子类化扩展对象功能
* 代理模式(Proxy): 把一个对象的操作代理到另一个对象
    - 比如用 deque 实现 Stack/Queue, 把操作代理到 deque
    - 通常使用 has-a 组合关系
* 适配器模式(Adapter): 通过一个间接层适配统一接口
    - 把不同对象的接口是配到同一个接口
    - 想象一个多功能充电头, 可以给不同的电器充电, 充当了适配器
    - 当我们需要给不同的对象统一接口的时候可以使用适配器模式
* 外观模式(Facade): 简化复杂对象的访问问题
* 享元模式(Flyweight): 通过对象服用(池)改善资源利用, 比如连接池
* Model-View-Controller(MVC): 解耦展示逻辑和业务逻辑

行为型设计模式
* 迭代器模式(Iterator): 通过统一的接口迭代对象
    - Python 内置对迭代器模式的支持
    - 比如我们可以用 for 遍历各种 Iterable 的数据类型
    - Python 里可以使用`__next__`和`__iter__`实现迭代器
* 观察者模式(Observer): 对象发生改变的时候, 观察者执行相应动作
    - 发布订阅是一种最常用的实现方式
    - 发布订阅用于解耦逻辑
    - 可以通过回调等方式实现, 当发生事件时, 调用相应的回调函数
* 策略模式(Strategy): 针对不同规模输入使用不同的策略
    - 比如买东西超过10个打八折, 超过20个打七折
    - 对外暴露统一的接口, 内部采用不同的策略计算

函数式编程
* 把电脑的运算视作数学上的函数计算(lambda 演算)
* 高阶函数: map/reduce/filter
    - 推荐列表推导代替map
* 无副作用, 相同的参数调用始终产生同样的结果

Closure(闭包)
* 绑定了外部作用域的变量的函数
* 及时程序离开外部作用域, 如果闭包仍然可见, 绑定变量不会销毁
* 每次运行外部函数都会重新创建闭包

* 闭包: 引用了外部自由变量的函数
* 自由变量: 不在当前函数定义的变量
* 特性: 自由变量会和闭包函数同时存在

Python 线程安全
* 一个操作可以在多线程环境中安全使用, 获取正确结果
* 线程安全的操作好比线程是顺序执行而不是并发执行的(i+=1)
* 一般如果涉及到写操作需要考虑如何让多个线程安全访问数据

线程同步的方式(保证线程安全)
* 互斥量(锁): 通过互斥机制防止多个线程同时访问公共资源
* 信号量(Semphare): 控制同一时刻多个线程访问同一个资源的线程数
* 事件(信号): 通过通知的方式保持多个线程同步

进程间通信(Inter-Process Communication, 进程间传递信号或数据)
* 管道/匿名管道/有名管道(pipe)
* 信号(Signal): 比如用户使用 Ctrl+c 产生 SIGINT 程序终止信号
* 消息队列(Message)
* 共享内存(share memory)
* 信号量(Semaphore)
* 套接字(socket): 最常用的方式, web 应用都是这种方式

多线程(threading)
* threading.Thread 类用来创建线程
* start() 方法启动线程
* 可以用 join() 等待线程结束

多进程(multiprocessing)
* Multiprocessing.Process 类实现多进程
* 一般用在 cpu 密集程序里, 避免 GIL 的影响

Python 垃圾回收机制(无需手动回收)
* 引用计数`ref`(sys 模块, `sys.getrefcount(obj)`)为主(缺点: 循环引用无法解决, 两个对象相互引用之后计数无法归零)
    - 计数增加
        + 对象创建 `a=1`
        + 对象被引用 `b=a`
        + 对象作为参数传递 `func(a)`
        + 对象存储在容器中 `l=[a]`
    - 计数减少
        + 显示使用 `del a`
        + 引用指向了别的对象 `b=None`
        + 离开的对的作用域(比如函数执行结束)
        + 从一个容器移除对象或者销毁容器
* 引入标记清除和分代回收解决引用计数的问题
    - 标记清除 ![mark_and_sweep](./mark.png)
    - 分代回收: 对象分三代(创建时是第一代), 每一代达到阈值的时候执行分代回收(gc 模块, `gc.get_threshold`)
* 引用计数为主+标记清除和分代回收为辅

Python 实现 IO 多路复用(Python 封装了操作系统的 IO 多路复用)
* Python 的 IO 多路复用基于操作系统实现(select/poll/epoll)
* Python2 select 模块
* Python3 selectors 模块
    - 事件类型: EVENT_READ(socket 可读), EVENT_WRITE(socket 可写)
    - DefaultSelector: 自动根据平台选取合适的 IO 模型
        + register(fileobj(文件描述符), events, data=None): 监听 socket
        + unregister(fileobj): 取消监听
        + modify(fileobj, events, data=None): 先 unregister, 再重新 register
        + select(timeout=None): returns[(key, events)]
        + close()

Python 并发网络库(Tornado vs Gevent vs Asyncio)
* Tornado 并发网络库和同时也是一个 web 为框架, 提供了基于回调和协程并发逻辑的编写方式
    - 适用于微服务, 实现 Restful 接口
    - 底层基于 Linux 多路复用
    - 可以通过协程或者回调实现异步编程
    - 不过生态不完善, 相应的异步框架比如 ORM 不完善
* Gevent 绿色线程(greenlet) 实现并发, 注意使用时要用猴子补丁修改内置 socket(《Gevent 程序员指南》)
    - 基于轻量级绿色线程(greenlet)实现并发
    - 需要注意 monkey patch, gevent 修改了内置的 socket 改为非阻塞
    - 配合 gunicorn 和 gevent 部署作为 wsgi server
* Asyncio Python3 内置的并发网络库, 基于原生协程
    - Python3 引入到内置库, 协程+时间循环
    - 生态不够完善, 没有大规模生产环境检验
    - 目前应用不够广泛, 基于 Aiohttp 可以实现一些小的服务

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
