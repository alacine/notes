## Django 学习


### 安装

pip 安装
```bash
pip install django
```

源码安装
```bash
git clone ...
python setup.py install
```

### 创建项目

```bash
django-admin startproject myblog
```
在当前目录下建立一个 myblog 文件夹, 并且初始化一个项目

项目目录结构
```
manage.py
myblog/
    |-- __init__.py
    |-- settings.py
    |-- urls.py
    |-- wsig.py
```

* `manage.py`: 与项目进行交互的命令行工具集的入口, 项目管理器
    - `python manage.py`: 来查看所有命令
    - `python manage.py runserver [port]`: 启动项目, 默认端口8000

* `myblog/`: 项目的一个容器, 包含项目最基本的一些配置, 目录名称不建议修改
* `myblog/wsig.py`: Python Web Server Gateway Interface(Python 服务器网关接口), Python 应用与 Web 服务器之间的接口
* `myblog/urls.py`: URL 配置文件, django 项目中搜有地址(页面)都需要我们去配置其 URL
* `myblog/settings.py`: 项目的总配置文件, 里面包含了数据库, Web 应用, 时间等各种配置
* `myblog/__init__.py`: Python 中声明模块的文件, 内容默认为空

### 创建应用

创建应用 blog
```bash
python manage.py startapp blog
```

应用目录结构
```
migrations/
    |-- __init__.py
__init__.py
admin.py
apps.py
models.py
tests.py
views.py
```

* `migrations/`: 数据移植(迁移)模块, 内容自动生成
* `admin.py`: 该应用的后台管理系统配置
* `apps.py`: 该应用的一些配置, Django-1.9 以后自动生成
* `models.py`: 数据模块, 使用 ORM 框架
* `tests.py`: 自动化测试模块, Django 提供了自动化测试功能, 在这里编写测试脚本
* `views.py`: 执行响应的代码所在模块, 代码逻辑处理的主要地点, 项目中大部分代码均在这里编写

### 创建第一个页面(响应)

1. 编辑 blog.views  
每个响应对应一个函数, 函数必须返回一个响应  
函数必须存在一个参数, 一般约定为 request  
每一个响应(函数)对应一个 URL

2. 编辑 urls.py  
每个 URL 都以 url 的形式写出来  
url 函数放在urlpatterns 列表中  
url 函数三个参数: URL(正则), 对应方法, 名称
> django2.0 开始 `path()` 语法不再使用正则表达式, `re_path()`才是正则表达式, `url()` 是`re_path()`的别名

3. 第二种 URL 配置  
包含其他 URL  
在根`urls.py`中引入`include`  
在应用的目录下创建`urls.py`文件, 格式与根`urls.py`相同

**注意事项**
1. 根`urls.py`针对 APP 配置的 URL 名称, 是该 APP 所有 URL 的总路径
2. 配置 URL 时注意正则表达式皆为符号`$`和`/`
