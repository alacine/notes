## 问题记录

多个 Go 版本

```bash
go get golang.org/dl/go1.14.12
```

默认装在了`$HOME/sdk/go1.14.12`
```bash
❯ exa -T -L 1 ~/sdk/go1.14.12
/home/ryan/sdk/go1.14.12
├── api
├── AUTHORS
├── bin
├── CONTRIBUTING.md
├── CONTRIBUTORS
├── doc
├── favicon.ico
├── go1.14.12.linux-amd64.tar.gz
├── lib
├── LICENSE
├── misc
├── PATENTS
├── pkg
├── README.md
├── robots.txt
├── SECURITY.md
├── src
├── test
└── VERSION
```

使用时指定版本即可
```bash
go1.14.12 env
```

要区分开依赖记得改`$GOPATH`

------

1. 执行一个特定的 `xxx_test.go` 文件的时候，例如`go test xxx_test.go`，即使`xxx_test.go`和
`xxx.go`中都申明了`package xxx`，却还是找不到`xxx.go`中的方法。

> 运行时需要把 `xxx.go` 也带上，例如`go test xxx.go xxx_test.go`，同理，如果`xxx`
> 包中还有其他的文件如 `xxxa.go` 如果用到了也得带上

------

2. 执行特定的某个 `TestXXX` 函数时，实际执行了多个函数，例如`go test -run TestXXX`
但实际却执行了`TestXXXa`、`TestXXXb`、`TestXXX`、`TestTestXXX`……等

> `-run`flag 会匹配一个正则表达式，改为 `go test -run "^TestXXX$"` 就可以了

1 和 2 参考[回答](https://stackoverflow.com/a/16936314/8461712)

------

3. 导入本地项目作为依赖 [import local module](https://golang.org/doc/tutorial/call-module-code)

假设写好了一个 module: chu，想在 chudemo 中 import，目录结构如下
```
chu
├── chu.go
├── chu_test.go
└── go.mod
chudemo
├── go.mod
└── main.go
```
那么在`chudemo`中
```bash
go mod init chudemo
go mod edit -replace example.com/chu=../chu
go mod tidy
```

------

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


------

结构体排序

```go
type Man struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}
people := []Man{
    {3, "b"},
    {1, "a"},
    {6, "3"},
}
sort.Slice(people, func(i, j int) bool { return people[i].Id < people[j].Id })
```

二维切片排序
```go
// 第一种
type In2 [][]int

func (in2 In2) Len() int {
	return len(in2)
}

func (in2 In2) Less(i, j int) bool {
	for k := 0; k < len(in2[i]); k++ {
		if in2[i][k] < in2[j][k] {
			return true
		} else if in2[i][k] > in2[j][k] {
			return false
		}
	}
	return true
}

func (in2 In2) Swap(i, j int) {
	in2[i], in2[j] = in2[j], in2[i]
}

w := In2{
    {1, 2, 3, 4},
    {4, 5, 3, 3},
    {3, 4, 5, 2},
}

sort.Sort(w)
sort.Sort(sort.Reverse(w)) // 逆序

// 第二种
w := [][]int{
    {1, 2, 3, 4},
    {4, 5, 3, 3},
    {3, 4, 5, 2},
}

sort.Slice(w, func(i, j int) bool {
    for k := 0; k < len(w[i]); k++ {
        if w[i][k] < w[j][k] {
            return true
        } else if w[i][k] > w[j][k] {
            return false
        }
    }
    return true
})
```

如果是对数组排序, 那么必须使用指针, 切片是引用类型, 本身就自带指针指向原来的数组, 而数组在调用方法时是拷贝的
```go
type In2 [3][]int

func (in2 *In2) Len() int {
	return len(in2)
}

func (in2 *In2) Less(i, j int) bool {
	for k := 0; k < len(in2[i]); k++ {
		if in2[i][k] < in2[j][k] {
			return true
		} else if in2[i][k] > in2[j][k] {
			return false
		}
	}
	return true
}

func (in2 *In2) Swap(i, j int) {
	in2[i], in2[j] = in2[j], in2[i]
}

w := In2{
    {1, 2, 3, 4},
    {4, 5, 3, 3},
    {3, 4, 5, 2},
}

sort.Sort(&w)
```
