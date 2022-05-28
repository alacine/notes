## 并发编程

### 常见并发 bug

死锁

进入 pprof 页面查看

* RWR 死锁
```go
package main

import (
	"fmt"
	"log"
	"net/http"
	_ "net/http/pprof"
	"sync"
)

var a = sync.RWMutex{}

func x() {
	a.RLock()
	defer a.RUnlock()
	y()
	fmt.Println("222")
}

func y() {
	a.Lock()
	defer a.Unlock()
	fmt.Println("111")
}

func main() {
	//OrChannel()
	go x()
	log.Fatalln(http.ListenAndServe(":9000", nil))
}
```

* 循环等待死锁
```go
func x() {
    a.Lock()
    b.Lock()
}

func y() {
    b.Lock()
    a.Lock()
}
```

channel 关闭 panic
> channel closing principle https://go101.org/article/channel-closing.html

### 并发编程常用模式

#### 合并 channels

#### 任一 channel 返回，全部 channel 返回

#### 并发同时保存

```go
type 
```
