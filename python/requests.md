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
$ virtualenv .env --python=python3
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
print(response.reason)  # 状态码信息
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

带参数的请求
1. URL Parameters: URL 参数
    * https://www.baidu.com/s?wd=abc
    * params: requests.get(url, params={'key1':'value1'})
2. 表单参数提交
    * Content-Type: application/x-www-form-urlencoded
    * 内容: key1=value1&key2=value2
    * requests.post(url, data={'key1':'value1', 'key2': 'value2'})
3. json 参数提交
    * Content-Type: application/json
    * 内容: '{"key1":"value1", "key2":"value2"}'
    * requests.post(url, json={"key1":"value1", "key2":"value2"})

异常处理(`requests.exceptions`)
```python3
try:
    response = requests.get(url, timeout=10)
    # response = requests.get(url, timeout=(3, 7))
    response.raise_for_status()
except exceptions.Timeout as e:
    print(e)
except exceptions.HTTPError as e:
    print(e)
else:
    print(response.text)
    print(response.status_code)
```

自定义请求
```python
s = requests.Session()
headers = {'User-Agent': 'fake-agent'}
req = requests.Request('GET', url, auth=user, headers=headers)
prepped = req.prepare()
print(prepped.body)
print(prepped.headers)
resp = s.send(prepped, timeout=5)  # 这里才是发送
print(resp.status_code)
print(resp.request.headers)
print(resp.text)
```

相应基本 api(response 对象)
* status_code: 状态码
* reason: 状态码信息
* headers: 信息头部
* url: 消息来源
* history: 
* elapsed: 请求耗时


[什么是回调函数](https://www.zhihu.com/question/19801131/answer/27459821)

认证方式
* 基本认证  
```python
user = ('username': 'password')
response = requests.get(url, auth=user)
```

* OAuth 认证  
```python
# 写法1
headers = {'Authorization': 'token xxxxxxxxxx'}
response = requests.get(url, headers=headers)
# 写法2
from requests.auth import AuthBase

class GithubAuth(AuthBase):

    def __init__(self, token):
        self.token = token

    def __call__(self, r):
        r.headers['Authorizion'] = ' '.join(['toke', self.token])
        return r

auth = GithubAuth('xxxxxxxxxxxxxxxxxx')
response = requests.get(url, auth=auth)
```

![OAuth](./oauth.png)

Proxy 代理
1. 终端代理
```bash
export HTTP_PROXY="socks5://127.0.0.1:1080"
export HTTPS_PROXY="socks5://127.0.0.1:1080"
export ALL_PROXY="socks5://127.0.0.1:1080"
```

2. proxies 参数
> 这里有点问题, 实际使用时有报错, 先放着, 用前一种方法
```python
import requests

proxies = {
    'http': 'socks5://127.0.0.1',
    'https': 'socks5://127.0.0.1',
    # 'http': 'socks5://user:pass@127.0.0.1',
    # 'https': 'http://user:pass@127.0.0.1',
}

requests.get(url, proxies=proxies)
```
