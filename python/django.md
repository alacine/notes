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


### Templates

HTML 文件, 使用了 Django 模板语言(Django Template Language, DTL)  
可以使用第三方模板(如 Jinjia2)
> 如要使用第三方模板, 修改`settings.py`中`TEMPLATES['BACKEND']`的值

#### 创建一个 Template

步骤
1. 在应用的根目录下创建名叫 templates 的目录
2. 在该目录下创建 HTML 文件
3. 在`views.py`中返回`render()`

DTL 初步使用
* `render()`函数中支持一个 dict 类型参数
* 该字典是后台传递到模板的参数, **键为参数名**
* 在模板中使用`{{参数名}}`来直接使用

Django 查找 Template
* Django 按照 `INSTALLED_APPS`中的添加顺序查找 Templates
* 不同应用下 Templates 目录中的同名 html 文件会造成冲突
> 解决冲突的方法:  
> 在应用的 Templates 目录下创建以应用名为名称的目录, 将 html 文件放入创建的目录下

### Models

通常, 一个 Model 对应数据库的一张数据表  
Django 中 Models 以类的形式表现  
它包含了一些基本字段以及数据的一些行为

* ORM  
对象关系映射(Object Relation Mapping)  
实现了对象和数据库之间的映射  
隐藏了数据访问的细节, 不需要编写 SQL 语句

#### 创建一个 Models

步骤
1. 在应用根目录下创建`models.py`, 并引入`models`模块
2. 创建类, 继承 `models.Model`, 该类即是一张数据表
3. 在类中创建字段  
字段即类里面的属性(变量), `attr = models.CharField(max_length=64)`

生成数据表  
步骤
```python
python manage.py makemigrations [app_name]  # (名称默认是应用名称)
python manage.py migrate
```

查看
1. Django 会自动在`app/migrations/`目录下生成移植文件
2. 执行`python manage.py sqlmigrate 应用名 文件id`查看 SQL 语句
3. 默认 sqlite3 的数据库在项目根目录下 `db.sqlite3`

页面呈现数据  
后台步骤
1. `views.yp`中`import models`
2. `article = models.Article.objects.get(pk=1)`
3. `render(request, page, {'article': article})`

前端步骤  
模板可直接使用对象以及对象的`.`操作, `{{article.title}}`

### Admin

Admin 是 Django 自带的一个功能强大的自动化数据管理界面  
被授权的用户可直接在 Admin 中管理数据库  
Django 提供了许多针对 Admin 的定制功能

创建用户
```python
python manage.py createsuperuser  # 创建超级用户
```

Admin 入口  
`localhost:8000/admin/`

界面语言  
修改`settings.py`中`LANGUAGE_CODE = 'zh-Hans'`

配置应用  
在应用下`admin.py`中引入自身的`.models`模块(或里面的模型类)  
编辑`admin.py`: `admin.site.register(models.Article)`

修改数据默认显示名称  
步骤  
1. 在`Article`类下添加一个方法
2. 根据 Python 版本选择`__str__(self)`或`__unicode__(self)`, `return self.title`

### blog

模板 for 循环  
```
{% for thing in things %}
html
{% endfor %}
```

超链接  
目标地址  
href 后面是目标地址, template 中可以用`{%url 'app_name:url_name' param%}`, 其中`app_name`和`url_name`都在 url 中配置
