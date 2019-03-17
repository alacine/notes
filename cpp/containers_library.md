## C++ 容器

### set

* 定义: set<int> a
* 基本操作:
    - `.insert(value)`: 插入一个值
    - `.erase(value | iterator | first, last)`: 删除一个值(可以传入具体的值或者具体位置或者起始位置和结束位置)
    - `.empty()`: 判断 set 是否为空, 为空返回1, 不为空返回0
    - `.count(value)`: 返回 set 指定元素的个数, 只会是0或1
    - `.begin()`: 返回头 iterator
    - `.end()`: 返回尾部 iterator
    - `.clear()`: 清空 set
    - `.rbegin()` 和 `.rend()`: 配合可以实现逆序遍历
    - ![begin_and_end](./range-rbegin-rend.svg)

