[练习: 错误](https://tour.go-zh.org/methods/20)

其中
> **注意**: 在 `Error` 方法内调用 `fmt.Sprint(e)` 会让程序陷入死循环。可以通过先转换 `e` 来避免这个问题：`fmt.Sprint(float64(e))`。这是为什么呢？

```go
func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %v", e)
}
```
这种写法会出现错误
```
runtime: goroutine stack exceeds 1000000000-byte limit
fatal error: stack overflow

runtime stack:
...
```

原因: 当`e`变量实现了`Error()`的接口函数成为了`error`类型, 那么在`fmt.Sprintf(e)`时就会调用`e.Error()`来输出错误的字符串信息, 相当于
```
func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %v", e.Error())
}
```
从而造成无限递归

正确写法
```go
func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %v", float64(e))
}
```
