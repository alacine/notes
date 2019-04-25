## requests 库

安装
```bash
$ pip install requests gunicorn httpbin
```

gunicorn httpbin 使用
```bash
$ gunicorn httpbin:app
```

virtualenv 使用
```bash
$ virtualenv .env
$ source .env/bin/activate
```

内置库 urllib, urllib2, urllib3 (python3中没有urllib2)
1. urllib 和 urllib2 是相互独立的模块
2. requests 库使用了 urllib3(多次请求重复使用一个 socket)

```python3
# 构建请求参数
url = 'http://127.0.0.1:8000/get'
params = urllib.parse.urlencode({'param1': 'hellp', 'param2': 'world'})
# 发送请求
response = urllib.request.urlopen('?'.join([url, '%s']) % params)
# 处理响应
print(response.info())  # headers
print(response.getcode())  # 状态码
for line in response.readlines():  # 响应主体
    printv(line)
```

使用 requests
```python3
url = 'http://127.0.0.1:8000/get'
params = {'param1': 'hello', 'params2': 'world'}
response = requests.get(url, params=params)
print(response.headers)
print(response.status_code)
print(response.reason)
print(response.json)
print(response.text)
```

请求方法(requests.method(url))
* get: 查看资源
* post: 增加资源
* patch: 轻量级地修改资源, 用少量json数据
* put: 修改资源, 力度更大
* delete: 删除资源
* head: 查看响应头
* options: 查看可用请求方法
