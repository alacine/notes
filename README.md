## GIT
### GIT的结构和状态

* GIT的三层结构

 | English                     |   说明   |
 |-----------------------------|----------|
 | working directory           |工作区    |
 | staging index               |暂存区    |
 | git directory(Repository)   |版本库    |

* git中文件的四种状态

 | English       |说明                                             |
 |---------------|-------------------------------------------------|
 | Untracked     |未被追踪的                                        |
 | Modified      |表示工作区修改了某个文件但是还没有添加到暂存区       |
 | Staged        |表示工作区修改的文件添加到暂存区但还没有提交到版本库  |
 | Committed     |表示数据被安全的储存在本地库中                      |


### GIT基本命令

*  初始化git仓库
```sh
git init
```

*  将文件添加到暂存区
```sh
git add filename  //添加单个文件
git add .         //添加当前目录下所有文件
```

*  将暂存区内的文件提交到版本库
```sh
git commit -m 'description'
git commit -am 'description'   //跳过add命令直接提交Untracked
```

*  查看项目文件状态
```sh
git status
```

*  查看提交日志
```sh
git log
```

*  配置
```sh
git config
git config --global user.name name
git config --global user.email email
git config --list
地址~/.gitconfig
```

* GIT撤销操作
```sh
git commit --amend         //撤销上一次提交 并将暂存区的文件重新提交
git checkout -- filename   //拉取暂存区的文件并将其替换工作区的文件
git reset HEAD -- filename //拉去最近一次提交的版本库中的文件到暂存区(不影响工作区)
```

