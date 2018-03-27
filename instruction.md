# 汇编指令集
## 数据传送指令
### 通用数据传送指令

|     指令                     | 作用    |
|-----------------------------|---------|
| MOV (move)                  |  传送   |
| PUSH (push onto the stack)  |  进栈   |
| POP (pop from the stack)    |  出栈   |
| XCHG (exchange)             |  交换   |


#### MOV 
    格式: MOV DST, SRC
    操作: (DST) <- (SRC) , 将源操作数传送到目的操作数
* 双操作数的长度必须一致, 即必须同时为8位或16位
* 目的操作数与源操作数不能同时为错初期, 不允许在两个存储单元之间传送数据
* 目的操作数不能为 CS 或 IP, 因为 CS:IP 指向的是当前要执行的指令所在位置
* 目的操作数不可以是立即数
```sh
MOV AH, 89          ;十进制数
MOV AX, 2016H       ;十六进制数, 后面加 H
MOV AX, 0ABCDH      ;十六进制数, 因非数字 (0-9) 开头, 前面加 0
MOV AL, 10001011B   ;二进制数,后面加 B
MOV AL, 'A'         ;字符 'A' 的 ASCII 码是 41H, 相当于立即数
```

#### PUSH
#### POP
#### XCHG


### 累加器传送指令
#### IN
#### OUT
#### XLAT

### 地址传送指令
#### LEA
#### LDS
#### LES

### 标志寄存器传送指令
#### LAHF
#### SAHF
#### PUSHF
#### POPF

## 算数运算指令

### 类型扩展指令
#### CBW
#### CWD

### 加法指令
#### ADD
#### ADC
#### INC

### 减法指令
#### SUB
#### SBB
#### DEC
#### NEG
#### CMP

### 乘法指令
#### MUL
#### IMUL

### 除法指令
#### DIV
#### SRC

### BCD码的十进制调整指令
#### DAA
#### DAS

## 逻辑与位移指令

### 逻辑指令
#### AND
#### OR
#### NOT
#### XOR
#### TEST

### 移位指令
#### SHL
#### SAL
#### SHR
#### SAR
#### ROL
#### ROR
#### RCL
#### RCR

## 串操作指令

