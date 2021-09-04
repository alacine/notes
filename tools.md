## 其他工具

### qrencode

通过二维码分享短文本
```bash
qrencode -t UTF8 hello
echo hello | qrencode -t UTF8
```

### dbeaver

数据库图形化连接工具

### zeal

文档查询

### 乱码问题图
![](img/character_encode_decode_problem.jpg)

### qemu

预计内容较多，单开一页 [qemu.md](./kvm/qemu.md)

### libvirt

预计内容较多，单开一页 [libvirt.md](./kvm/libvirt.md)

### plantuml

goplantuml 用生成 go 项目的结构，plantuml 用来生成图片
```bash
goplantuml . > a.puml
plantuml a.puml
```
