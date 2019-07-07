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
2. Basic & Select & Set (基本操作)
3. Missing Data Processing (丢失值处理)
4. Merge & Reshape (数据融合和形状定义)
5. Time Series & Graph & Files (时间序列和图形绘制, 文件操作)
