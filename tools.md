## 其他工具

### qrencode

通过二维码分享短文本
```bash
qrencode -t UTF8 hello
echo hello | qrencode -t UTF8
```

### dbeaver

数据库图形化连接工具

如果出现类似`publickey retrieval not allowed`的问题，记得在连接设置里面把
`驱动属性`里面的`allowPublicKeyRetrieval`改为`TRUE`

### zeal

文档查询

### 乱码问题图
![](img/character_encode_decode_problem.jpg)

### qemu

预计内容较多，单开一页 [qemu.md](./vm/qemu.md)

### libvirt

预计内容较多，单开一页 [libvirt.md](./vm/libvirt.md)

### plantuml

goplantuml 用生成 go 项目的结构，plantuml 用来生成图片
```bash
goplantuml . > a.puml
plantuml a.puml
```
