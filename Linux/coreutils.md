### cut

* cut [选项] 文件名  
* -f 列号: 提取第几列
* -d 分隔符: 按照指定分隔符分割列(分隔符必须是一个字符)

### printf

C 风格输出

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

### awk

* 基本格式 `awk [options] 'command' file(s)`  
  - `command`: pattern{awk 操作命令} (pattern: 正则或逻辑判断式)
  - `command2`: 扩展: `BEGIN{print "start"}pattern{commands}END{print "end"}`
* awk内置变量1  
  - `$0`: 表示整个当前行
  - `$1`: 表示第一个字段
  - `$2`: 表示第二个字段
* awk内置变量2  
  - `NR`: 每行的记录号(The ordinal number of the current record from the start of input)
  - `NF`: 字段数量变量(The number of fields in the current record)
  - `FILENAME`: 正在处理的文件名
  - `FS`: 输入分割符号
  - `OFS`: 输出分割符号
* awk内置参数: 分隔符  
  - `-F`: field-separator(默认为空格)  
    `awk -F ':' '{print $3}' /etc/passwd`
* 在awk命令的输出中支持print和printf命令  
  - `print`: (*类似python2中的print*)print会在每个输出之后自动加上一个换行符(Linux默认没有print命令)
  - `printf`: (*类似C中的printf*)printf是标准格式输出命令，并不会自动加入换行符，如果需要换行，需要手工加入换行
* awk逻辑判断式  
  - `~`, `!~`: 匹配正则表达式
  - `==`, `!=`, `<`, `>` 判断逻辑表达式
* awk '条件1{动作1}条件2{动作2}' 文件名
  - 条件(Pattern):  
    + 一般使用关系表达式作为条件
    + `x > 10` 判断变量x是否大于10
    + `x >= 10` 大于等于
    + `x <= 10` 小于等于
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
awk -F ':' '$1!~/^m.*/{print $1}' /etc/passwd
awk -F ':' 'BEGIN{print "Line\tCol\tUser"}{print NR"\t"NF"\t"$1}END{print "-----"FILENAME"------"}' /etc/passwd
# 统计netstat -anp状态下为LISTEN和CONNECTED的连接数量
netstat -anp | awk '$6~/CONNECTED|LISTEN/{sum[$6]++}END{for (i in sum) print i,sum[i]}'
# 统计ssh登录失败的ip
cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $2" = "$1;}'
```

### sed (string editor)

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

### sort

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

### wc

* `wc [选项] 文件名`
* 选项:  
  - `-l`: 只统计行数
  - `-w`: 只统计单词数
  - `-m`: 只统计字符数(包含回车符)
