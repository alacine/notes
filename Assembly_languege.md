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
其中 PORT 为端口号，端口号范围为00\~FFH时，可以使用长格式指令。所谓长格式指令是指其机器指令长度为 2 个字节（端口号占 1 个字节）。\
**短格式**：IN AL, DX(字节)\
&emsp;&emsp;&emsp;&emsp;IN AX, DX(字)\
操作：AL <- ((DX))\
&emsp;&emsp;&emsp;AX <- ((DX))\
其中 PORT 为端口号，端口号范围为00\~FFH时，必须使用短格式指令。短格式指令长度为一个字节，因为端口号存放在 DX 寄存器中。

* OUT 输出\
把累加器的数据输出到端口 PORT 或由 DX 指向的端口。与输入指令相同，根据端口号的长度，分为长格式和短格式两种形式。\
**长格式**：OUT PORT, AL(字节)\
&emsp;&emsp;&emsp;&emsp;OUT PORT, AX(字节)\
操作：(DX) <- AL\
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

## 算数运算指令

### 类型扩展指令

* CBW 字节扩展成字 (convert byte to word)
* CWD 字扩展成双字 (convert word to double word)

这两条指令的格式相同，只有操作码部分，无操作数部分。操作数默认为累加器，无需在指令中给出。当执行 CBW 时，默认将 AL 寄存器的内容扩展到 AX 寄存器中，扩展方法为符号扩展，即如果 AL 的最高为是 1（负数），则 CBW 指令扩展时使 AH=FFH，如果 AL 的最高为为 0 （正数），则 CBW 指令扩展时使 AH=00H。当执行 CWD 时，默认将 AX 寄存器的内容扩展到（DX, AX）中，其中 DX 存放双字中的低位。如果 AX 的最高位为 1（负数），则 CWD 指令扩展时使 DX=FFFFH，如果 AX 的最高位为 0（正数），则 CWD 指令扩展时使 DX=0000H。

### 加法指令

* ADD (add) 加法\
ADD DST, SRC\
(DST) <- (DST) + (SRC)

ADD 指令将源操作数与目的操作数相加，结果存入目的操作数中。特别需要注意，加法指令执行后会影响标志寄存器中的 CF 和 OF 标志位。
*无符号数发生溢出时，CF 标志位置 1；有符号数发生溢出时，OF 标志位置 1。*

* ADC (add with carry) 带进位加法\
ADD DST, SRC\
(DST) <- (DST) + (SRC) + CF\
上式中的 CF 为运算前 CF 标志位的值。

* INC (increment) 加一\
INC OPR\
(OPR) <- (OPR) + 1\
该指令不影响 CF 标志位

### 减法指令

*减法运算的标志位情况与加法类似，CF 标志位指明无符号数的溢出，OF 标志位指明有符号数溢出*

* SUB (subtract) 减法\
SUB DST, SRC\
(DST) <- (DST) - (SRC)

* SBB (subtract with borrow) 带借位减法\
SBB DST, SRC\
(DST) <- (DST) - (SRC) -CF

* DEC (decrement) 减一\
DEC OPR\
(OPR) <- (OPR) - 1\
该指令不会影响 CF 标志位

* NEG (negate) 求补\
NEG OPR\
(OPR) <- -(OPR)

* CMP (compare) 比较\
CMP OPR1, OPR2
(OPR1) - (OPR2)

### 除法指令

* DIV (unsigned divide) 无符号数除法\
DIV SRC\
操作：\
SRC 为字节时，(AL) <- (AX)/(SRC) 的商，(AH) <- (AX)/(SRC) 的余数。\
SRC 为字时，(AX) <- (DX, AX)/(SRC) 的商，(DX) <- (DX, AX)/(SRC) 的余数。\
*该指令将参与运算的数据默认为无符号数，则商和余数都是无符号数*

* IDIV (signed divide) 有符号数除法\
指令格式和无符号数除法相同，用来作有符号数除法。最终商的符号应是两个操作数的异或，而余数的符号和被除数符号一致。

在除法指令里，目的操作数必须是累加器 AX 和 DX，不必写在指令中。被除数长度应为除数长的的两倍，余数放在目的操作数的高位，商放在目的操作数的低位。其中 SRC 不能是立即数。\
当除数是字节类型时，除法指令要求商为 8 位。此时如果被除数的高 8 位绝对值 >= 除数的绝对值，则商会产生溢出。\
当除数是字类型时，除法指令要求商为 16 位。此时如果被除数的高 16 位绝对值 >= 除数的绝对值，则商会产生溢出。\
除法溢出会使程序退出，回到操作系统。必须在做除法前对溢出做出判断。

### BCD 码的十进制调整指令

* DAA (Decimal Adjust for Addition) 加法的十进制调整指令
DAA\
操作：\
加法指令中，以 AL 为目的操作数，当加法运算结束后，使用本指令可以把 AL 中的和调整为正确的 BCD 码格式。即：
1. 如果 AL 低 4 位 > 9，或 AF = 1，则 AL = AL + 6;
2. 如果 AL 高 4 位 > 9，或 CF = 1，则 AL = AL + 60H, CF = 1。

例如 AL = 28(BCD), BL = 65H = 65(BCD)。
```
ADD AL, BL   ; AL = 28H + 65H = 8DH
DAA          ; AL = AL + 6H = 8DH + 6H = 93H = 93(BCD)
```
AL 和 BL 中都是用 BCD 码表示的十进制数，含义分别是 28 和 65，ADD 指令作二进制加法后得到 8DH，不是 BCD 码，DAA 指令作用后，把和调整为 93H，但它表示的是十进制数 93 的 BCD 码。

再例如 AX = 88H = 88(BCD), BX = 89H = 89(BCD)。
```
ADD AL, BL   ; AL = 88H + 89H = 11H, AF = 1, CF = 1
DAA          ; AL = AL + 66H = 11H + 66H = 77H = 77(BCD), CF = 1
ADC AH, 0    ; AX = 177H = 177(BCD)
```
第一条加法指令中的低四位产生了向高四位的进位，这使得辅助进位 AF 置 1，高四位加产生的进位使得 CF 置 1，因此使用 DAA 指令后，根据 AF 的值需要加 6H，根据 CF 的值需要加 60H，因此将 AL 的内容加上 66H，把和调整为 77H，CF=1，最后 ADC 指令使 AX 中得到177H，即十进制数 177 的 BCD 码。

* DAS (Decimal Adjust for Subtraction) 减法的十进制调整指令
DAS
减法结束后使用，类似 DAA。即：
1. 如果 AL 低 4 位 > 9，或 AF = 1，则 AL = AL - 6, AF = 1;
2. 如果 AL 高 4 位 > 9，或 CF = 1，则 AL = AL - 60H, CF = 1。

例如 AL = 93H = 93(BCD), BL = 65H = 65(BCD)。
```
SUB AL, BL   ; AL = 93H -65H =2EH
DAS          ; AL = AL -6H = 2EH - 6H =28H = 28(BCD)
```

## 逻辑与位移指令
