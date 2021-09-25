## Go 进程的启动与初始化

可执行文件在不同系统的规范不同(下文以 Linux 为例)
| Linux | Windows | MacOS  |
|-------|---------|--------|
| ELF   | PE      | Mach-O |

ELF(Executable and Linkable Format)

包含以下内容

* ELF header
* Section header
* Sections

Linux 执行可执行文件的步骤

1. 解析 ELF header
2. 加载文件内容至内存
3. 从 entry point 开始执行代码

以一个简单程序`echo1`为例子
```go
package main

import (
	"fmt"
	"os"
)

func main() {
	var s, sep string
	for i := 0; i < len(os.Args); i++ {
		s += sep + os.Args[i]
		sep = "\n"
	}
	fmt.Println(s)
}
```

生成并查看可执行文件
```bash
go build
readelf -h ./echo1
```

可以得到内容
```
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x45c1a0 <----------------------- 程序入口
  Start of program headers:          64 (bytes into file)
  Start of section headers:          456 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         7
  Size of section headers:           64 (bytes)
  Number of section headers:         23
  Section header string table index: 3
```

通过 objdump 工具可以输出可执行文件的汇编指令
```bash
go tool objdump ./echo1
```

每执行一条指令，PC 寄存器(Program Counter Register)就指向下一条继续执行，CPU
就是靠 PC 寄存器指向的位置执行代码的。

64 位系统的 PC 寄存器是 rip
