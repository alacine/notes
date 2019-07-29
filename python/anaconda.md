## anaconda 使用

安装 anaconda 后添加 conda 到`PATH`
```
PATH=$PATH:/opt/anaconda/bin
```

创建 anaconda 环境下的虚拟环境
```
conda create -n env_py2 anaconda python=2.7
```

进入 anaconda 环境
```
conda activate
```

选择 anaconda 中的虚拟环境
```
conda activate env_py
```

退出 anaconda 中的虚拟环境, 或退出 anaconda 环境
```
conda decactivate
```
