## socket 编程例子

### 简单的聊天例子

* 服务端
```python
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('localhost', 8000))

while True:
    data = input()
    client.send(data.encode('utf8'))
    data = client.recv(1024)
    print(data.decode('utf8'))

# client.close()
```

* 客户端
```python
import socket
import threading

# AF_INET: ipv4, AF_INET5: ipv6; SOCK_STREAM: tcp, SOCK_DGRAM: udp
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('0.0.0.0', 8000))
server.listen()

def handle_sock(sock, addr, bufsize=1024):
    while True:
        data = sock.recv(bufsize)
        print(data.decode('utf8'))
        re_data = input()
        sock.send(re_data.encode('utf8'))

while True:
    sock, addr = server.accept()
    # 用线程接收处理新的连接
    client_thread = threading.Thread(target=handle_sock, args=(sock, addr))
    client_thread.start()
    # 获取从客户端获取到的数据
    # 一次获取 1k 的数据
    # data = sock.recv(1024)
    # print(data.decode('utf8'))
    # data = input()
    # sock.send(data.encode('utf8'))

# server.close()
# sock.close()
```

### 使用 socket 模拟 http 请求
```python
import socket
from urllib.parse import urlparse

def get_url(url):
    url = urlparse(url)
    host = url.netloc
    path = url.path
    if not path:
        path = '/'
    # 建立 socket 连接
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect((host, 80))
    client.send('GET {} HTTP/1.1\r\nHost: {}\r\nConnection:close\r\n\r\n'.format(path, host).encode('utf8'))
    data = bytes()
    while True:
        d = client.recv(1024)
        if not d:
            break
        data += d
    data = data.decode('utf8')
    print(data.split('\r\n\r\n')[1])
    client.close()

if __name__ == '__main__':
    get_url('http://www.baidu.com')
```
