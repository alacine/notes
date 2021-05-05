## HTTP

在做下载文件功能时候遇到这么个问题：

当请求中为类似`http://127.0.0.1:8000/xxx/exportFile`时，实际的文件我在代码中设置
了下载时的默认文件名称为`a.txt`，但是使用 postman 的 send and download 和
`curl -O -J` 这两种方式来下载文件时，没法正确地拿到文件名称，但是通过 chrome 或 
firefox 访问，弹出另存为的窗口时却可以正常获取到文件名。

于是使用`curl -v`的方式查看具体的请求报文和相应报文，相应头中是有文件名称的，但是
却没有拿到
```
Content-Dispostion: attachment;filename*=utf-8'zh_cn'a.txt
```

查了 MDN 的[文档](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition)
还有一种格式是下面这样的，用`nc -l 12345`的方式模拟试了一下这种格式的可以被 postman 和 curl 识别。
```
Content-Dispostion: attachment;filename="a.txt"
```

