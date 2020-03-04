## 常用命令

* `build`: compile packeages and dependencies
    - 编译 go 文件，跨平台编译: `env GOOS=linux GOPATH=amd64 go build`
* `install`: compile and install packeages and dependencies
    - 编译，与 build 最大的区别是编译后会将输出文件打包成库放在 pkg 下
* `get`: download and install packages and dependencies
    - 用于获取 go 的第三方包，通常会默认从 git repo 上 pull 最新的版本
    - 常用如: `go get -u github.com/go-sql-driver/mysql` (其中`-u`也可以用于更新)
* `fmt`: gofmt(reformat) packages sources
    - 统一代码风格和排版
* `test`: test packages
    - 运行当前包目录下的 tests
    - 常用命令如`go test`或`go test -v`
    - Go 的 test 一般以 XXX_test.go 为文件名，XXX 的部分一般为 XXX_test.go 所要测试的代码文件名(不要求必须这样做)
    - 函数名必须为`TestXXX`形式
    - 如果在 XXX_test.go 中写了 `func TestMain(m *testing.M)`，必须在其中写`m.run()`才能使得其他 Test 函数正常执行
    - `benchmark` (`go test -bench=.`, 同样受到`TestMain`限制)
        + 函数形式`Benchmark`开头
        + benchmark 的 case 一般会跑 b.N(`func BenchmarkXXX(b *testing.B)`) 次，而且每次执行都会如此，在执行过程中会根据实际 case 的执行时间是否稳定会增加 b.N 的次数以达到稳态

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

二维数组排序
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
    {1, 2},
}

sort.Sort(w)
sort.Sort(sort.Reverse(w)) // 逆序

// 第二种
w := [][]int{
    {1, 2, 3, 4},
    {4, 5, 3, 3},
    {3, 4, 5, 2},
    {1, 2},
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
