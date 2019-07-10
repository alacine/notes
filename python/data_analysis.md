## 数据分析
* numpy
* scipy: 科学计算方法(矩阵分析、信号分析、数理分析)
* matplotlib: 丰富的可视化套件
* pandas: 基础数据分析套件
* scikit-learn: 数据分析建模库
* keras: 人工神经网络

### numpy
- 创建 array
```python
>>> import numpy as np
>>> a = np.array([1,2,3,4,5,6,7,8])
>>> print(a.shape)
(8,)
>>> a.reshape((4,2))
array([[1, 2],
       [3, 4],
       [5, 6],
       [7, 8]])
>>> a.reshape((2,-1))
array([[1, 2, 3, 4],
       [5, 6, 7, 8]])
>>> a = np.zeros((2,3))
>>> a
array([[0., 0., 0.],
       [0., 0., 0.]])
>>> a = np.ones((4,2))
>>> a
array([[1., 1.],
       [1., 1.],
       [1., 1.],
       [1., 1.]])
>>> a = np.full((3,3), 3)
>>> a
array([[3, 3, 3],
       [3, 3, 3],
       [3, 3, 3]])
>>> a = np.eye(4)
>>> a
array([[1., 0., 0., 0.],
       [0., 1., 0., 0.],
       [0., 0., 1., 0.],
       [0., 0., 0., 1.]])
>>> a = np.random.random((3,4))
>>> a
array([[0.48642543, 0.58216311, 0.21069667, 0.66663334],
       [0.38634989, 0.01190326, 0.32851522, 0.98804907],
       [0.12070248, 0.18891006, 0.94914811, 0.89072739]])
```

- 索引
```python3
>>> a = np.array([[1,2,3,4]
                  [5,6,7,8],
                  [9,10,11,12]])
>>> a[1, -2]
7
>>> a[-2:, 1:3]
array([[ 6,  7],
       [10, 11]])
>>> a[np.arange(3), 1] += 10
array([[ 1, 12,  3,  4],
       [ 5, 16,  7,  8],
       [ 9, 20, 11, 12]])

>>> a[[0,1,2], [1,1,1]] += 10
array([[ 1, 22,  3,  4],
       [ 5, 26,  7,  8],
       [ 9, 30, 11, 12]])
>>> result_index = a > 10
>>> result_index
array([[False,  True, False, False],
       [False,  True, False, False],
       [False,  True,  True,  True]])
>>> a[result_index]
array([22, 26, 30, 11, 12])
>>> a[a>10]
array([22, 26, 30, 11, 12])
```

- 数据类型
```python
>>> a = np.array([1.9, 2.3])
>>> a.dtype
dtype('float64')
>>> a = np.array([1.9, 2.3], dtype=np.dtype('int64'))
>>> a
array([1, 2])
```

- 运算和常用函数
```python
# 运算
a + b  == np.add(a, b)
a - b  == np.subtract(a, b)
a * b  == np.multiply(a, b)  # 不是矩阵乘法
a / b  == np.divide(a, b)
a // b
np.sqrt(a)
a.dot(b) == np.dot(a, b)  # 矩阵乘法

# 函数
np.sum(a)  # 所有元素的和
np.sum(a, axis=0)  # 每一列的和
np.sum(a, axis=1)  # 每一行的和

np.mean(a)  # 所有元素的平均值
np.mean(a, axis=0)  # 每一列的平均值
np.mean(a, axis=1)  # 每一行的平均值

np.random.uniform(1, 100)  # 产生范围内的随机小数
np.tile(a, (2,3))  # 把 a 作为单个元素生成一个 2*3 的 array
a.argsort(axis=0)  # 每一列(默认是 axis=1, 即行排序)排序, 返回编号

a.T  == np.transpose  # 矩阵转置
np.linalg.inv(a)  # 矩阵的逆
np.linalg.det(a)  # 矩阵的行列式
np.linalg.eig(a)  # 矩阵的特征值

# 解方程
a = np.array([[1,2],[3,4]])
y = np.array([[5.], [7.]])
np.linalg.solve(a, y)
```

- 广播
```python
a = np.array([[1,2,3],
              [4,5,6],
              [7,8,9]])
b = np.array([10, 20, 30])

# 计算 a 的每一行加上 b
# 方法 1: 循环
# 方法 2:
a + np.tile(b, (3,1))
# 方法 3: 广播
a + b
# 广播会在缺失维度和数值为 1 的维度上进行
```

### matplotlib

绘图库, 用于实现数据可视化

### pandas

数据分析库

1. Series & DataFrame (基本数据结构)

* DataFrame: 由行和列组成的表格
* Series: DataFrame 中的每一列被称为 Series, 同时 Series 可以不属于任何一个 DataFrame

2. Basic & Select & Set (基本操作)

* 从文件读取  
`read_table()`使用` `作为默认分割符号, `read_csv()`使用`,`作为默认分割符号(`read_table()`从 0.24.0 开始已经弃用, 使用`read_csv(sep='\t')`代替)

```
movies = pd.read_csv('imdb_1000.csv')
ufo = pandas.read_csv('ufo.csv')
# 读取第 1 和 5 列
ufo = pandas.read_csv('ufo.csv', usecols=[0, 4])
# 读取指定列
ufo = pandas.read_csv('ufo.csv', usecols=['City', 'State'])
# 读取 4 行
ufo = pandas.read_csv('ufo.csv', nrow=4)
```
* 访问  
一般情况下, Series 的两种访问方式均可, 即`ufo.City`和`ufo['City']`, 但是三种情况下只允许第二种访问方式:
    - 列名中包含空格
    - 列名与内置属性冲突
    - 在 DataFrame 中创建一个新的列

* 列重命名  
```python
ufo.rename(
    colomns={
        'Color Reported': 'Color_Reported',
        'Shape Reported': 'Shape_Reported'
    }
    inplace=True # 执行此操作
)
```

* 移除列  
```python
# 移除指定列
ufo.drop('Colors Reported', axis=1, inplace=True)
ufo.drop(['City', 'State'], axis=1, inplace=True)
# 移除指定行(依据行号)
ufo.drop(labels=[0, 1, 2], axis=0, inplace=True)
```

* 过滤  
```python
# 单一条件
movies[movies.duration >= 200]
# 多条件(注意这里的操作符写法, 括号不可省略)
movies[(movies.duration >= 200) & (movies.genre == 'Drama')]
movies.genre.isin(['Crime', 'Drama', 'Action'])
```

* 排序  
```python
# ascending 默认是 True; 表示升序; 不改变 moives; 只显示排序列
movies.duration.sort_values(ascending=False)
# 同上, 显示所有列
movies.sort_values('title')
# 设置多个排序标准
movies.sort_values(['content_rating', 'duration'])

```

* axis 使用  
`axis=0`(操作 row), `axis=1`(操作 column)

* 字符串方法(文档中搜索`string handling`)  
```python
orders.item_name.str.upper()
# 包含指定字符串
orders.item_name.str.contains('Chicken')
orders[orders.item_name.str.contains('Chicken')]
# 替换
orders.choice_description.str.replace('[', '').str.replace(']', '')
# 正则
orders.choice_description.str.replace('[\[\]]', '')
```

* 其他一些技巧
    - 选取指定类型的数据
    - 迭代 Series 和 DataFrame

3. Missing Data Processing (丢失值处理)
4. Merge & Reshape (数据融合和形状定义)
5. Time Series & Graph & Files (时间序列和图形绘制, 文件操作)
