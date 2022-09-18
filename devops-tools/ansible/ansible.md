## Ansible

样例

> 这里用到的 demo 来自 vm/ 中自动创建的 fedora

```baash
ansible demo -a "ls"
```

用户切换
```bash
ansible demo -a "whoami"
ansible demo -a "whoami" --become --become-user root
```

配置文件(默认位置先查看 man page)
```bash
ansible -i hosts demo -a "ls"
```
