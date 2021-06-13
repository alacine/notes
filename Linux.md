## 环境变量

| 变量                                    | 作用 | 说明                              |
|-----------------------------------------|------|-----------------------------------|
| `TZ`                                    | 时区 | 例如`Asia/Shanghai`, `US/Eastern` |
| `HTTP_PROXY`,`HTTPS_PROXY`, `ALL_PROXY` | 代理 |                                   |

## 进程相关

获取某个进程的路径
```
readlink -f /proc/PID/exe
```
获取进程的当前工作路径
```
pwdx PID
```
获取进程使用的环境变量
```
cat /proc/PID/environ
```
或者用`strings`(一些字符在`cat`不能正常输出, 这里用`strings`可以输出换行)
```
strings /proc/PID/environ
```

