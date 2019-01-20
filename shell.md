## shell 变量
变量叠加
```bash
x=123
x="$x"456
x=${x}789
# 最后x的值为"123456789"
```

```bash
set # 查看当前所有变量
set -u # 设定此选项，调用未声明变量时会报错(默认没有提示)
unset x # 删除变量名

env # 查看环境变量
```

设置环境变量
```bash
export x=1 #
y=1
export y # 
```

`$PS1`提示符变量
* \d: 显示日期，格式为"星期 月 日"
* \H: 显示完整主机名
* \t: 显示24小时制时间，格式为"HH:MM:SS"
* \A: 显示24小时制时间，格式为"HH:MM"
* \u: 显示显示当前用户名
* \w: 显示显示当前所在目录的完整名称
* \W: 显示当前所在目录的最后一个目录
* \$: 显示提示符，如果是root用户会显示提示符为"#"，如果是普通用户会显示提示符为"$"

`$PS2`换行后的提示符变量

`locale` # 查询当前语系
* `-a`: 查看支持的所有语系
* LANG: 定义系统主语系的变量
* LC_ALL: 定义整体语系的变量

位置参数变量

|位置参数变量| 作用 |
|:----------:|:----:|
|     $n     |n为数字，$0代表命令本身，$1-$9代表第一到第九个参数，十个以上的参数需要用大括号包含，如${10}|
|     $*     |这个变量代表命令行中所有的参数，$*把所有的参数看成一个整体|
|     $@     |同上，不过$@把每个参数区分对待|
|     $#     |这个变量代表命令行中所有参数的个数|


与定义变量

|与定义变量|作用|
|:--------:|----|
|    $?    |最后一次执行的命令的返回状态。如果这个变量的值为0，证明上一个命令正确执行；如果这个变量的值为非0(具体是哪个数，由命令自己来决定)，则证明上一个命令执行不正确了。|
|    $$    |当前进程的进程号(PID)|
|    $!    |后台运行的最后一个进程的进程号(PID)|

样例脚本:
```bash
#!/bin/bash

for i in 1 2 3 4
do
    echo $i
done

for i in "$*"
do
    echo $i
done

for i in "$@"
do
    echo $i
done
```

接收键盘输入  
`read` 选项 变量名
* 选项:
* `-p "提示信息"` 在等待read输入时，输出提示信息
* `-t` 秒数: read 命令会一直等待用户输入，使用此选项可以指定等待时间
* `-n` 字符数: read 命令只接受指定的字符数，就会执行
* `-s` 隐藏输入的数据，使用与机密信息的输入

样例脚本:
```bash
#!/bin/bash

read -p "please input your name: " -t 30 name
echo $name

read -p "please input you password: " -s password
echo -e "\n"
echo $password

read -p "please input your sex [M/F]: " -n 1 sex
echo -e "\n"
echo $sex
```

## shell 运算符

`declare` 声明变量类型  
`declare [+/-]选项 变量名`
* `-`: 给变量设定类型属性
* `+`: 取消变量类型属性
* `-a`: 将变量声明数组型
* `-i`: 将变量声明为整数型
* `-x`: 将变量声明为环境变量(与`export`的作用相似，但其实`export`就是`declare`命令的作用)
* `-r`: 将变量声明为只读变量(只读属性会让变量不能修改不能删除，甚至不能取消只读属性)
* `-p`: 显示指定变量的被声明的类型(后面不跟变量名则显示所有的变量的属性)
```bash
aa=11
bb=22
# 数值计算方法1
declare -i cc=$aa+$bb
# 数值计算方法2
dd=$(expr $aa + $bb) # 加号两侧必须有空格
# 数值计算方法3
ee=$(($aa+$bb)) # 可以有空格，也可以不加
ff=$[$aa+$bb] # 可以有空格


# 定义数组
moive[0]=zp
movie[1]=tp
declare -a movie[2]=live
# 查看数组
echo ${movie}
echo ${movie[2]}
echo ${movie[*]}
```

变量测试  

|变量置换方式|变量y没有设置|变量y为空|变量y设置值                   |
|:----------:|:-----------:|:-------:|:----------------------------:|
|x=${y-新值} |x=新值       |x为空    |x=$y                          |
|x=${y:-新值}|x=新值       |x=新值   |x=$y                          |
|x=${y+新值} |x为空        |x=新值   |x=新值                        |
|x=${y:+新值}|x为空        |x为空    |x=新值                        |
|x=${y=新值} |x=新值，y=新值|x为空，y不变|x=$y，y不变               |
|x=${y:=新值}|x=新值，y=新值|x=新值，y=新值|x=$y，y不变             |
|x=${y?新值} |新值输出到标准错误输出(就是屏幕)|x为空|x=$y           |
|x=${y:?新值}|新值输出到标准错误输出|新值新值输出到标准错误输出|x=$y|

## 环境变量配置文件

`source 配置文件值` 或  `. 配置文件值` 

### 简介

```bash
/etc/profile # 历史命令条数
/etc/profile.d/*.sh
~/.bashrc # 别名
~/.bash_profile
/etc/bashrc # 修改命令提示符
```
环境变量加载路径，正常输入用户名密码时:  
![normal.png](./normal_login.png)
从su用户切换到当前用户时：
![switch_to_login](./switch_to_login.png)
**图片中的`/etc/sysconfig/i18n`是原先的语系配置文件，现在是语系的配置文件是`/etc/locale.conf`**

### 功能

`/etc/profile`的作用:
* USER变量
* LONGAME变量
* MAIL变量
* PATH变量
* HOSTNAME变量
* HISTSIZE变量
* umask变量
* 调用`/etc/profile.d/*.sh`文件

### 其他配置文件

本地终端登录信息: `/etc/issue`

|转义符|作用                            |
|:----:|--------------------------------|
|  \d  |显示当前系统日期                |
|  \s  |显示操作系统名称                |
|  \l  |显示登录的终端号，这个比较常用  |
|  \m  |显示硬件体系结构，如i386、i686等|
|  \n  |显示主机名                      |
|  \o  |显示域名                        |
|  \r  |显示内核版本                    |
|  \t  |显示当前系统时间                |
|  \u  |显示当前登录用户的序列号        |

远程终端欢迎信息: `/etc/issue.net`
* 转义符在`/etc/issue.net`文件中不能使用
* 是否显示此欢迎信息，由ssh的配置文件`/etc/ssh/sshd_config`决定，加入`Banner /etc/issue.net`行才能显示(记得重启SSH服务)

登录后欢迎信息: `/etc/motd`
* 不管是本地登录，还是远程登录，都可以提示此欢迎信息

## shell 正则表达式

### 正则表达式

主要用于字符串的模式分割、匹配、查找及替换操作。

基础正则表达式

|元字符     |作用|
|:---------:|----|
|   *       |前一个字符匹配0次或任意多次|
|   .       |匹配除了换行符外任意一个字符|
|   ^       |匹配行首，例如:^hello会匹配以hello开头的行|
|   $       |匹配行尾，例如:hello&会匹配以hello结尾的行|
| \[\]      |匹配中括号中指定的任意一个字符，只匹配一个字符，例如:\[aeiou\]匹配任意一个元音字符，\[0-9\]匹配任意数字，\[a-z\]\[0-9\]匹配任意小写字母和一位数字|
| \[^\]     |匹配除中括号的字符以外的任意一个字符。例如:\[^0-9\]匹配任意一位非数字字符|
|  \\       |转义符。用于取消特殊符号的含义|
|\\\{n\\\}  |表示其前面的字符恰好出现n次|
|\\\{n,\\\} |表示其前面的字符出现不小于n次。例如:\\\[0-9\\\]\\\{4\\\}匹配4位数字|
|\\\{n,m\\\}|表示前面的字符至少出现n次，最多出现m次。例如\\\[a-z\\\]\\\{6,8\\\}匹配6到8位的小写字母。|

扩展正则 `?`, `()`

### 字符截取命令

1. `cut`字段提取命令  
* cut [选项] 文件名  
* -f 列号: 提取第几列
* -d 分隔符: 按照指定分隔符分割列(分隔符必须是一个字符)

2. `printf`命令  
* printf '输出类型输出格式' 输出内容
* 输出类型:  
  - `%ns`: 输出字符串。n是数字指代输出几个字符
  - `%ni`: 输出整数。n是数字指代输出几个数字
  - `%m.nf`: 输出浮点数。m和n是数字，指代输出的整数位数和小数位数，如`%8.2f`代表共输出8位数，其中2位是小数，6位是整数
* 输出格式:  
  - `\a`: 输出警告声音
  - `\b`: 输出退格键，也就是Backspace键
  - `\f`: 清除屏幕
  - `\n`: 换行
  - `\r`: 回车，也就是Enter键
  - `\t`: 水平输出退格键，也就是Tab键
  - `\v`: 垂直输出退格键，也就是Tab键

3. `awk`命令  
* 基本格式 `awk [options] 'command' file(s)`  
  - `command`: pattern{awk 操作命令} (pattern: 正则或逻辑判断式)
* awk内置变量1  
  - `$0`: 表示整个当前行
  - `$1`: 表示第一个字段
  - `$2`: 表示第二个字段
* awk内置变量2  
  - `NR`: 每行的记录号(The ordinal number of the current record from the start of input)
  - `NF`: 字段数量变量(The number of fields in the current record)
  - `FILENAME`: 正在处理的文件名
* awk内置参数: 分隔符  
  - `-F`: field-separator(默认为空格)  
    `awk -F ':' '{print $3}' /etc/passwd`
* 在awk命令的输出中支持print和printf命令  
  - `print`: (*类似python2中的print*)print会在每个输出之后自动加上一个换行符(Linux默认没有print命令)
  - `printf`: (*类似C中的printf*)printf是标准格式输出命令，并不会自动加入换行符，如果需要换行，需要手工加入换行
* awk '条件1{动作1}条件2{动作2}' 文件名
  - 条件(Pattern):  
    + 一般使用关系表达式作为条件
    + x > 10 判断变量x是否大于10
    + x >= 10 大于等于
    + x <= 10 小于等于
  - 动作(Action):  
    + 格式化输出
    + 流程控制语句
* 下面是几个使用样例:  
```bash
awk '{printf $2 "\t" $4 "\n"}' student.txt # 把student.txt中的第二个和第四个字段(列)按照格式输出(文件名传给$0。其中printf可换成print，这时不用写"\n")
df -h | awk '{print $1 "\t" $3}'
awk 'BEGIN{print "test"}{printf $2 "\t" $4 "\n"}' student.txt
awk 'END{print "test"}{printf $2 "\t" $4 "\n"}' student.txt
cat /etc/passwd | grep /bin/bash | awk 'BEGIN{FS=":"}{print $1 "\t" $3}' # 可以对比不加'BEGIN'
# FS 内置变量，用来标称分隔符是什么
awk -F ':' '{printf("Line:%3s Col:%s User:%s\n", NR, NF, $1)}' /etc/passwd
awk -F ':' '{if ($3 > 100) print "Line : "NR, "User: "$1}' /etc/passwd
```

4. `sed`命令(字符替换)  
sed 是一种几乎包括在所有UNIX平台的(包括Linux)的轻量级编辑器。sed重要是用来将数据进行选取、替换、删除、新增的命令  
* sed [选项] '[动作]' 文件名
* 选项:  
  - `-n`: 一般sed命令会把所有数据都输出到屏幕，如果加入次选择则只会把经过sed命令处理的行输出到屏幕
  - `-e`: 允许对输入数据应用多条sed命令编辑
  - `-i`: 用sed的修改结果直接修改读取数据的文件，而不是由屏幕输出
* 动作:  
  - `a`: 追加，在当前行后添加一行或多行
  - `c`: 行替换，用c后面的字符串替换原数据行
  - `i`: 插入，在当前行前插入一行或多行
  - `d`: 删除，删除指定行
  - `p`: 打印，输出指定行
  - `s`: 字串替换，用一个字符串替换另外一个字符串。格式为"行范围s/旧字串/新字串/g"(与vim类似)
  - `n`: 下一行
  - `r`: 复制指定文件插入到匹配行
  - `w`: 复制匹配行拷贝指定文件里
  - `q`: 退出sed
* 行定位:  
  - 定位一行: `x`, `/pattern/`
  - 定位几行: `x,y`, `patern/,x`, `/pattern1/,/pattern2/`, `x,y!`
  - 定位间隔几行: `first~step`
* 元字符:  
  - `\w`: 数字和字母组成的单词
  - `\W`: 非单词
  - `\u`: 首字符大写
  - `\U`: 大写
  - `\l`: 首字符小写
  - `\L`: 小写
  - `\1`: 前面第一个括号中的内容, `\2`、`\3`以此类推

以下是使用样例
```bash
sed -n '2p' ex # 打印ex中的第二行
sed '2d' ex # 删除第二行后输出，但不改变文件
sed '2,4d' ex # 删除第二行到第四行后输出
sed '2a abcdefg' ex # 在第二行后加一行abcdefg后输出
sed '2i abcdefg' ex # 在第二行前加一行abcdefg后输出
sed '2c abcdefg' ex # 把第二行替换为abcdefg后输出
sed '4s/abc/def/g' ex # 把第四行的abc替换为def后输出
sed -i '4s/abc/def/g' ex # 把第四行的abc替换为def不输出，并把改动写入文件
sed -e 's/a/b/g;s/c/d/g' ex # 执行把a换成b和把c换成d
sed -n '{n;p}' ex # 打印奇数行
sed -n '{p;n}' ex # 打印偶数行

# & 符号表示前面的部分
sed 's/^[a-z_-]\+/&  /' /etc/passwd # 把passwd文件中用户名后面加上空格
sed 's/^[a-z_-]\+/\U&/' /etc/passwd # 把passwd文件中用户名转换为大写,`\L`为小写
sed 's/^[a-z_-]\+/\u&/' /etc/passwd # 把passwd文件中用户名首字符转换为大写,`\l`为小写

# 提取前三列
sed 's/^\([a-z_-]\+\):x:\([0-9]\+\):\([0-9]\+\):.*$/USER:\1 UID:\2 GID:\3/' /etc/passwd

# 获取网卡wlo1的ip
ifconfig wlo1 | sed -n '/inet /p' | sed 's/inet \([0-9.]\+\).*/\1/'

# 读入123.txt中的内容，放到abc.txt的第一行后面(并不改变文件的内容)
sed '1r 123.txt' abc.txt
# 把123.txt的第一行拷贝到abc.txt中(修改文件*注意是修改不是追加，abc中原来的内容会被清除*)
sed '1w abc.txt' 123.txt
```

### 字符处理命令

排序命令`sort`
* `sort [选项] 文件名`
* 选项:  
  - `-f`: 忽略大小写
  - `-n`: 以数值型进行排序，默认使用字符串型排序
  - `-r`: 反向排序
  - `-t`: 指定分隔符，默认分隔符是制表符
  - `-k n[,m]`: 按照指定的字段范围排序。从n字段开始，m字段结束(默认到行尾)

```bash
sort -t ":" -k 3,3 /etc/passwd # 指定分隔符是':'，用第三字段开头，第三字段结尾排序
sort -n -t ":" -k 3,3 /etc/passwd 
```

统计命令`wc`
* `wc [选项] 文件名`
* 选项:  
  - `-l`: 只统计行数
  - `-w`: 只统计单词数
  - `-m`: 只统计字符数(包含回车符)


## 流程控制

### 条件判断式

按照文件类型进行判断

|测试选项|作用                                              |
|:------:|--------------------------------------------------|
| -b 文件|判断该文件是否存在，并且是否为块设备文件(是为真)  |
| -c 文件|判断该文件是否存在，并且是否为字符设备文件(是为真)|
| -d 文件|判断该文件是否存在，并且是否为目录文件(是为真)    |
| -e 文件|判断该文件是否存在，存在为真                      |
| -f 文件|判断该文件是否存在，并且是否为普通文件(是为真)    |
| -L 文件|判断该文件是否存在，并且是否为符号链接文件(是为真)|
| -p 文件|判断该文件是否存在，并且是否为管道文件(是为真)    |
| -s 文件|判断该文件是否存在，并且是否为非空(是为真)        |
| -S 文件|判断该文件是否存在，并且是否为套接字文件(是为真)  |

两种判断格式
* `test -e /root/install.log`
* `[ -e /root/install.log ]` (注意中括号边上有空格)
* 这两条命令没有输出，可以使用`echo $?`来查看是否正确执行，为0正确执行，为1错误执行

按照文件权限进行判断

|测试选项|作用                                                  |
|:------:|------------------------------------------------------|
| -r 文件|判断该文件是否存在，并且是否该文件具有读权限(有为真)  |
| -w 文件|判断该文件是否存在，并且是否该文件具有写权限(有为真)  |
| -x 文件|判断该文件是否存在，并且是否该文件具有执行权限(有为真)|
| -u 文件|判断该文件是否存在，并且是否该文件具有SUID权限(有为真)|
| -g 文件|判断该文件是否存在，并且是否该文件具有SGID权限(有为真)|
| -k 文件|判断该文件是否存在，并且是否该文件具有SBit权限(有为真)|

两个文件之间比较

|     测试选项    |作用|
|:---------------:|----|
| 文件1 -nt 文件2 |判断文件1的修改时间是否比文件2新(新为真)|
| 文件1 -ot 文件2 |判断文件1的修改时间是否比文件2旧(旧为真)|
| 文件1 -ef 文件2 |判断文件文件1是否和文件2的Inode号一致，可以理解为两个文件是否为同一个文件。这个判断用于判断硬链接是很好的办法|

两个整数之间比较

|     测试选项    |作用                                    |
|:---------------:|----------------------------------------|
| 整数1 -eq 整数2 |判断整数1是否和整数2相等(相等为真)      |
| 整数1 -ne 整数2 |判断整数1是否和整数2不相等(不相等真)    |
| 整数1 -gt 整数2 |判断整数1是否大于整数2(大于为真)        |
| 整数1 -lt 整数2 |判断整数1是否小于整数2(小于为真)        |
| 整数1 -ge 整数2 |判断整数1是否大于等于整数2(大于等于为真)|
| 整数1 -le 整数2 |判断整数1是否小于等于整数2(小于等于为真)|

字符串判断

|     测试选项    |作用                                    |
|:---------------:|----------------------------------------|
| -z 字符串       |判断字符串是否为空(空为真)              |
| -n 字符串       |判断字符串是否为非空(非空为真)          |
| 字串1 == 字串2  |判断字串1是否和字串2相等(相等为真)      |
| 字串1 != 字串2  |判断字串1是否和字串2不相等(不相等真)    |

多重条件判断

|     测试选项    |作用  |
|:---------------:|------|
| 判断1 -a 判断2  |逻辑与|
| 判断1 -o 判断2  |逻辑或|
|      !判断2     |逻辑非|



### if语句

单分支
```bash
if [ 条件判断式 ]; then
    ...
fi
# 或
if [ 条件判断式 ]
    then
    ...
fi
```

双分支
```bash
if [ 条件判断式 ]
    then 
        ...
    else
        ...
fi

# 判断apache是否启动
#!/bin/bash

test=$(ps aux | grep httpd | grep -v grep)
# 截取http进程，并把结果赋予变量test
if [ -n "$test" ]
    then
        echo "$(date) httpd is ok!" >> /tmp/autostart-acc.log
    else
        # /etc/rc.d/init.d/httpd start &> /dev/null
        service network restart
        echo "$(date) restart httpd!!" >> /tmp/autostart-err.log
fi
```

多分支
```bash
if [ 条件判断式1 ]
    then
        ...
elif [ 条件判断式1 ]
    then
        ...
...
else
    ...
fi
```

样例1 简单计算器
```bash
#!/bin/bash
# 字符界面加减乘除计算器

read -t 30 -p "Please input num1: " num1
read -t 30 -p "Please input num2: " num2
read -t 30 -p "Please input a operator: " ope

if [ -n "$num1" -a -n "$num2" -a -n "$ope" ]; then
# 第一层判断，用来判断num1、num2和ope中都有值
    test1=$(echo $num1 | sed 's/[0-9]//g')
    test1=$(echo $num1 | sed 's/[0-9]//g')
    # 定义变量test1和test2的值为$(命令)的结果
    # 后续命令作用是，把变量test1的值替换为空。如果能替换为空，证明num1的值为数字

    if [ -z "$test1" -a -z "$test2" ]; then
        # 第二层判断用来判断num1和num2为数值
        # 如果变量test1和test2的值为空，则证明num1和num2是数字
        # 如果test1和test2是数字，则执行一下命令
        if [ "$ope" == '+' ]; then
            ans=$(($num1 + $num2))
        elif [ "$ope" == '-' ]; then
            ans=$(($num1 - $num2))
        elif [ "$ope" == '*' ]; then
            ans=$(($num1 * $num2))
        elif [ "$ope" == '/' ]; then
            ans=$(($num1 / $num2))
        else
            echo "Please enter a valid symbol"
            exit 10
        fi
    else
        echo "Please enter a valid value"
        exit 11
    fi
else
    echo "input can not be empty"
    exit 12
fi

echo "$num1 $ope $num2 = $ans"
```

样例2 判断输入的是什么文件
```bash
#!/bin/bash
# 判断用户输入的是什么文件

read -p "Please input a filename: " file

if [ -z "$file" ]; then
    echo "Error, Please input a filename"
    exit 1
elif [ ! -e "$file" ]; then
    echo "Your input is not a file!"
    exit 2
elif [ -f "$file" ]; then
    echo "$file is a regulare file!"
elif [ -d "$file" ]; then
    echo "$file is a directory!"
else
    echo "$file is an other file!"
fi
```

### case语句

```bash
case $变量名 in
  "值1")
    ...
    ;;
  "值2")
    ...
    ;;
  ...
  *)
    ...
    ;;
esac
```

### for循环

```bash
for 变量 in value1 value2 value3...
    do
        ...
    done
# 或
for 变量 in value1 value2 value3...; do
    ...
done

# 样例1
#!/bin/bash

s=0
for ((i=1; i<=100; i=i+1)); do
    s=$(($s+$i))
done
echo $s

# 样例2
#!/bin/bash
# 批量添加指定数量的用户
read -p "Please input user name: " -t 30 name
read -p "Please input the number of users: " -t 30 num
read -p "Please input the password of users: " -t 30 pass
if [ ! -z "$name" -a ! -z "$num" -a ! -z "$pass" ]; then
    y=$(echo $num | sed 's/[0-9]//g')
    if [ -z "$y" ]; then
        for ((i=1; i<=$num; i=i+1)); do
            /usr/bin/useradd $name$i &>/dev/null
            echo $pass | /usr/bin/passwd --stdin $name$i &> /dev/null
        done
    fi
fi
```

## while循环和until循环

```bash
#!/bin/bash
i=1
s=0
while [ $i -le 100 ]; do
    s=$(($s+$i))
    i=$(($i+1))
done
echo "The sum is: $s"

#!/bin/bash
i=1
s=0
until [ $i -gt 100 ]; do
    s=$(($s+$i))
    i=$(($i+1))
done
echo "The sum is: $s"
```
