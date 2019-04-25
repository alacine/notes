## Python 文件存储

* txt
```python
with open('a.txt', 'a', encoding='utf-8') as file_a:
    file_a.write('\n' + '====' + 'adf')
```

* Json (注意: Json 文本中的 key 和字符串 value 必须使用双引号)
    - `json.loads(str)`: 将 Json 文本字符串转为 Json 对象
    - `json.dumps(str, indent=None, separators=None)`: 将 Json 对象转为文本字符串
    - `dict[key]` 和 `dict.get(key)` 区别: 当 key 不存在时, `get()` 返回 `None`, 而中括号报错, 因此, 建议使用 `get()` 方法  
```python
import json

with open('/etc/shadowsocks/example.json', 'r') as ss_config:
    a = ss_config.read()
    data = json.loads(a)
    print(data)

# 中文字符问题
with open('a.json', 'w', encoding='utf-8') as ss_copy:
    ss_copy.write(json.dumps(data, indent=4, ensure_ascii=False))
```

* csv(Comma-Separated Values, 逗号分割值或字符分割值)
    - 写入:  
```python
import csv

with open('a.csv', 'w') as csvfile:
    csvfile_writer = csv.writer(csvfile, delimiter=',') # delimiter 指定分隔符, 默认为','
    csvfile_writer.writerow(['a', 'b', 'c'])
    csvfile_writer.writerow([232, 32, 'fda123'])
    csvfile_writer.writerows([[232, 32, 'fda123'], ['a', 'b', 'c']])

# 字典的写入方式
with open('b.csv', 'w') as csvfile: 
    colname = ['id', 'name', 'age'] 
    csvfile_write = csv.DictWriter(csvfile, fieldnames=colname) 
    csvfile_write.writeheader() 
    csvfile_write.writerow({'id': '10001', 'name': 'Mike', 'age': 20}) 
    csvfile_write.writerow({'id': 1002, 'age': 21, 'name': 'Bob'})
```

    - 读取:  
```python
import csv

# 1. 直接使用 csv 库读取
with open('data.csv', 'r', encoding='utf-8') as csvfile:
    csvfile_read = csv.reader(csvfile)
    for row in reader():
    print(row)

# 2. 利用 pandas 读取
import pands as pd

data = pd.read_csv('data.csv')
print(data)
```
