## Go Command Line Tool 命令行工具

### Go 内置

#### env 环境变量

Go 使用的所有环境变量

```bash
# 查看
go env
# 修改
go env -w GOPROXY=https://goproxy.io
go env -w GO111MODULE=on
```

#### build 编译

```bash
# 编译指定环境
env GOOS=linux GOPATH=amd64 go build
# 指定输出位置
go build -o ch1/echo1 ch1/echo1/main.go
```

#### install 安装

编译并安装，与 build 的区别是编译后会将输出文件打包成库放在`$GOBIN`或
`$GOPATH/bin`或`$HOME/go/bin`下（如果`$GOBIN`没有设置则选择`$GOPATH/bin`，
如果`$GOPATH`也没有则选择`$HOME/go/bin`）

```bash
# 在项目目录中执行，表示将当前项目编译后生成的可执行文件安装
go install
```

```bash
# 直接安装某项目的可执行文件
go install github.com/derekparker/delve/cmd/dlv
```

#### get 获取

用于获取 go 的第三方包，通常会默认从 git repo 上 pull 最新的版本
```bash
# 不带 -u 直接获取，带上可以更新
go get -u github.com/go-sql-driver/mysql

# 末位带上 @版本 获取指定版本，此方法也可以用来降级
go get example.com/pkg@v1.2.3

# 仅删除 go.mod 中的依赖，这不会删除 $GOPATH 里的文件
go get example.com/pkg@none

# -d 表示只下载，不做编译的安装
go get -d github.com/go-sql-driver/mysql
```

另外，不要用`go get`来做安装操作，根据[这篇文档](https://docs.studygolang.com/doc/go-get-install-deprecation)，
从 Go 1.17 开始，`go get`、`go install`将做语义上的区分，之后`get`将不会做 build 
包的操作，只用来添加、更新、删除 go.mod 中的依赖，且`get`的 flag `-d`将会默认
启用。

#### clean 删除

删除编译出来的文件

```bash
# 不管是什么参数都可以先用 -n 看看会具体删除哪些东西，不会真的执行删除操作
go clean -n

# -i 会删除 go install 的文件，-x 会打印出实际删除了哪些东西
go clean -i -x

# 删除整个 $GOPATH/pkg/mod
go clean -modcache

# 删除 cache
go clean -cache
```

我目前没有看到有单独删除某一个包的方法，似乎只能手动删除`rm -rf $GOPATH/pkg/mod/xxx`，
不过会提示缺少权限

#### test 测试

测试的函数名称必须为`Test`开头
```bash
# 执行测试，-v 会输出详细，没有 -v，测试的 log 不会打印，但 fmt.Printf(Println)有输出
go test -v

# 执行某个 test 文件，记得要带上 xxx_test.go 中用的源码文件
go test ./xxx_test.go ./xxx.go
# 即使有多个也要全部带上
go test ./xxx_test.go ./xxx.go ./a.go ./b.go ...
# 支持 *
go test ./xxx*

# 执行具体某个测试函数，但是要注意这是正则匹配，也就是说 axxx、xxxa
# 这些都会执行，如果要区分记得写完整正则
go test -run "xxx"
go test -run "^xxx$"

# 生成测试覆盖率报告
go test -coverprofile c.out
go tool cover -html=c.out

# cpu 性能分析，-bench 不可少，否则生成的内容少很多
go test -cpuprofile cpu.prof -bench=.
# 在浏览器中查看结果，或生成 png 图片
go tool pprof -web cpu.prof
go tool pprof -png cpu.prof

# 内存性能分析，-bench 不可少，否则生成的内容少很多
go test -memprofile mem.prof -bench=.
go tool pprof -web mem.prof

# goroutine 阻塞分析
go test -blockprofile block.prof -bench=.
```

性能测试函数名称必须为`Benchmark`开头
```bash
go test -bench=.

# 指定具体函数，并且给出内存分配情况
go test -bench=BenchmarkXXX -benchmem
```

另外，如果在 XXX_test.go 中写了`func TestMain(m *testing.M)`，
必须在其中写`m.run()`才能使得其他 Test 函数正常执行

#### list

展示包信息

```bash
# 当前目录包信息
go list
# 指定依赖的包信息，输出为 json 格式
go list -json github.com/example

# 指定输出格式，这里的格式语法和 text/template 中模板的语法一致
go list -f '{{.ImportPath}} -> {{join .Imports " "}}' compress/...
```

最后一个命令的输出结果
```
compress/bzip2 -> bufio io sort
compress/flate -> bufio fmt io math math/bits sort strconv sync
compress/gzip -> bufio compress/flate encoding/binary errors fmt hash/crc32 io time
compress/lzw -> bufio errors fmt io
compress/zlib -> bufio compress/flate encoding/binary errors fmt hash hash/adler32 io
```


#### mod

确保 GO111MODULE 是启用的
```bash
go env -w GO111MODULE=on
```

```bash
# 下载依赖的 module 到本地 cache (默认是`$GOPATH/pkg/mod`)
go mod download

# 编辑 go.mod 文件，-replace 依赖替换
go mod edit -replace example.com/xxx=../xxx

# 打印模块依赖图
go mod graph

# 初始化当前文件夹为一个模块，创建`go.mod`文件
go mod init example.com/xxx

# 增加缺少的 module，删除无用的 module
go mod tidy

# 将依赖复制到 vendor 下
go mod vendor

# 校验依赖
go mod verify

# 解释为什么需要依赖
go mod why
```

### Go Tool

#### trace

在代码中加入 trace，并且把错误信息输出到标准错误输出（和标准输出区分开来）
```go
package main

import (
	"fmt"
	"os"
	"runtime/trace"
	"sync"
)

func main() {
    // ==== trace ====
	trace.Start(os.Stderr)
	defer trace.Stop()
    // ===============

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		fmt.Println("hello")
		wg.Done()
	}()

	go func() {
		fmt.Println("world")
		wg.Done()
	}()

	wg.Wait()
}
```

然后把 trace 信息保留下来
```bash
go run main.go 2> trace.out
go tool trace ./trace.out
```
此时会打开浏览器，会有可视化的分析

#### compile 编译

```go
package main

func main() {
	var a = "hello"
	var b = []byte(a)
	println(b)
}
```

比如上面这份代码，想要知道如何找到 string -> []byte 的实现

```bash
go tool compile -S main.go | grep "main.go:5"
```

输出
```
        0x0014 00020 (./main.go:5)      LEAQ    ""..autotmp_2+40(SP), AX
        0x0019 00025 (./main.go:5)      LEAQ    go.string."hello"(SB), BX
        0x0020 00032 (./main.go:5)      MOVL    $5, CX
        0x0025 00037 (./main.go:5)      PCDATA  $1, $0
        0x0025 00037 (./main.go:5)      CALL    runtime.stringtoslicebyte(SB)
```

这样可以知道用的是 runtime 中的 stringtoslicebyte()，然后再去 runtime 里面搜索
就可以了。

同样可以用这样的方法来找 make 的实现

#### objdump 反汇编

```bash
# 将可执行二进制文件 binary 反汇编
go tool objdump binary
```

用前面 compile 的例子
```bash
go build main.go && go tool objdump ./main | grep -E "main.go:5"
```

#### vet 静态检查

```bash
go vet main.go
go vet ./...
```

### 其它

#### errcheck

检查函数返回的 err 是否被检查

```bash
errcheck ./...
```

#### revive

golint 代替

```bash
revive ./...
```

#### golangci-lint

```bash
golangci-lint run
```

#### goplantuml

goplantuml 用生成 go 项目的结构，plantuml 用来生成图片
```bash
goplantuml . > a.puml
plantuml a.puml
```
