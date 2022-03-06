### PYTHONPATH

```bash
python setup.py install --prefix /path/to/dir/site-packages
pip install --prefix
```

在上面这种安装时候指定了 prefix 的情况下，pip list 要列出已经安装的的内容，
则需要设置相应的环境变量

```bash
export PYTHONPATH=/path/to/dir/site-packages
pip list
```
