## 数据传送指令

### 通用数据传送指令

* MOV 传送\
格式: MOV DST, SRC\
操作: (DST) <- (SRC) , 将源操作数传送到目的操作数
1. 双操作数的长度必须一致, 即必须同时为8位或16位。
2. 目的操作数与源操作数不能同时为存储器, 不允许在两个存储单元之间传送数据。
3. 目的操作数不能为 CS 或 IP, 因为 CS:IP 指向的是当前要执行的指令所在位置。
4. 目的操作数不可以是立即数。
```sh
MOV AH, 89          ;十进制数
MOV AX, 2016H       ;十六进制数, 后面加 H
MOV AX, 0ABCDH      ;十六进制数, 因非数字 (0-9) 开头, 前面加 0
MOV AL, 10001011B   ;二进制数,后面加 B
MOV AL, 'A'         ;字符 'A' 的 ASCII 码是 41H, 相当于立即数
```

* PUSH 进栈\
格式：PUSH SRC\
操作：(SP) <- (SP)-2\
&emsp;&emsp;&emsp;((SP) + 1, (SP)) <- (SRC)\
其中 SRC 表示源操作数。

> 该指令表示将源操作数压入堆栈（目的操作数），目的操作数地址由 SS:SP 指定，指令中无需给出。堆栈是后进先出（Last in First out, LIFO）内存区，SP 总是指向栈顶，即大地址。因此入栈时，先将栈顶指针 SP 减 2 （2 表示2个字节，16 位机器字长），以便指向新的内存地址接受 16 位源操作数，同时指向新的栈顶。堆栈操作以字为单位进行操作。

* POP 出栈\
格式：POP DST\
操作：(DST) <- ((SP)+1, (SP))\
&emsp;&emsp;&emsp;(SP) <- (SP) + 2\
其中 DST 表示目的操作数。

> 将堆栈中操作数弹出到目的操作数，堆栈中源操作数地址由 SS:SP指定，指令中无需给出。源操作数弹出后，SP 加 2，下移一个字，指向新的栈顶。

* XCHG 交换\
格式：XCHG OPR1, OPR2\
操作：(OPR1) <- -> (OPR2)\
&emsp;&emsp;&emsp;其中OPR1, OPR2 位操作数。

> 把两个数交换位置。
> XCHG位双操作数指令，两个操作数均是目的操作数，除了遵循双操作数指令的规定，也不能用立即数寻址。

### 累加器专用传送指令

*说明：输入/输出（I/O）是 CPU 与外设传送数据的接口，单独编址，不属于内存。端口地址范围为0000~FFFFH。这组指令只限于AX，AL（也称累加器）*

* IN 输入\
把端口号 PORT 或由 DX 指向的端口的数据输入到累加器，根据端口号的长度，有长格式和短格式两种形式。\
**长格式**：IN AL, PORT(字节)\
&emsp;&emsp;&emsp;&emsp;IN AX, PORT(字)\
操作：AL <- (PORT)\
&emsp;&emsp;&emsp;AX <- (PORT)\
其中 PORT 为端口号，端口号范围为00\~FFH时，可以使用长格式指令。所谓长格式指令是指其机器指令长度为 2 个字节（端口号占 1 个字节）。
**短格式**：IN AL, DX(字节)\
&emsp;&emsp;&emsp;&emsp;IN AX, DX(字)\
操作：AL <- ((DX))\
&emsp;&emsp;&emsp;AX <- ((DX))\
其中 PORT 为端口号，端口号范围为00\~FFH时，必须使用短格式指令。短格式指令长度为一个字节，因为端口号存放在 DX 寄存器中。

* OUT 输出\
把累加器的数据输出到端口 PORT 或由 DX 指向的端口。与输入指令相同，根据端口号的长度，分为长格式和短格式两种形式。\
**长格式**：OUT PORT, AL(字节)\
&emsp;&emsp;&emsp;&emsp;OUT PORT, AX(字节)\
操作：(DX) <- AL
&emsp;&emsp;&emsp;PORT <- AX\
**短格式**：OUT DX, AL(字节)\
&emsp;&emsp;&emsp;&emsp;OUT DX, AL(字节)\
操作：(DX) <- AL\
&emsp;&emsp;&emsp;(DX) <- AX

* XLAT 换码\
格式：XLAT\
操作：AL <- (BX + AL)\
把 BX+AL 的值作为有效地址，取出其中的一个字节送 AL。

### 地址传送指令

* LEA 有效地址送寄存器\
LEA REG, SRC\
REG <- SRC
> 把源操作数的有效地址 EA 送到指定的寄存器。

* LDS 指针送寄存器和 DS\
LDS REG, (SRC)\
DS <- (SRC + 2)
> 把操作数 SRC 所指向的内存单元中2个字送到指定的寄存器 REG 和 ES。

### 标志寄存器传送指令

* LAHF(Load AH with Flags)  标志送 AH 寄存器
* SAHF(Store AH into Flags) AH 送标志寄存器
* PUSHF(Push Flags)         标志入栈
* POPF(Pop Flags)           标志出栈
*以上4条指令的格式相同，只有操作码部分，操作数为固定默认值，如表2.2所示，且传送类指令（除 SAHF、POPF 外）均不影响标志位*