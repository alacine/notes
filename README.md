## GIT
### GIT 结构和状态

* GIT的三层结构

 |          结构               |   说明   |
 |-----------------------------|----------|
 | working directory           |工作区    |
 | staging index               |暂存区    |
 | git directory(Repository)   |版本库    |

* git中文件的四种状态

 |   状态        |                       说明                       |
 |---------------|-------------------------------------------------|
 | Untracked     |未被追踪的                                        |
 | Modified      |表示工作区修改了某个文件但是还没有添加到暂存区       |
 | Staged        |表示工作区修改的文件添加到暂存区但还没有提交到版本库  |
 | Committed     |表示数据被安全的储存在本地库中                      |


### GIT 基本命令

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

* 撤销操作
```sh
git commit --amend         //撤销上一次提交 并将暂存区的文件重新提交
git checkout -- filename   //拉取暂存区的文件并将其替换工作区的文件
git reset HEAD -- filename //拉去最近一次提交的版本库中的文件到暂存区(不影响工作区)
git reset --option 版本号   //--hard 将版本库、暂存区和工作区的文件恢复到相应版本号中的状态
                           //--mixed 将版本库、暂存区的文件恢复到相应版本号中的状态
                           //--soft 将版本库、暂存区的文件恢复到相应版本号中的状态
```

* 文件删除
```sh
git rm -f filename        //删除暂存区和工作区的文件
git rm --cached filename  //仅删除暂存区的文件
```

* 文件重命名
```sh
git mv oldname newname    //将工作区和暂存区的文件一起重命名
```

### Git 分支

* git分支的创建、修改、切换、删除
```sh
git branch                     //查看分支
git branch branchname          //创建分支
git branch -m oldname newname  //修改分支名称
git checkout [-b] branchname   //切换分支
git branch -d branchname       //产出分支
```

* 分支的合并
  HEAD 指针指向当前工作区，在切换分支的时候指向新的分支

* 比较
```sh
git diff              //比较
git diff --staged     //比较暂存区和版本库的文件差异
git diff 版本号 版本号 //比较分之内的两个版本的差异
git diff 分支 分支     //比较两个分支的最新提交版本的差异
```

* 合并
```sh
git merge branchname    //合并分支到 master (合并之前需要先切换到master分支,快速合并和冲突合并)
```

* 储存变更
```sh
git stash                   //暂存工作区到当前分支
git stash list
git stash apply stash@num   //apply 后面不加名字则应用最近一次的储存信息
git stash drop stash@num    //git stash apply 只是运用存储信息,并不删除它，drop 命令可以删除它
```


### GIT 远程仓库

* GitHub 上的仓库
    - 创建仓库
    - clone 仓库到本地
    - 本地 push 到仓库
    - pull 代码到本地
    - ignoring files
    - fork and pull request

* 远程服务器上的仓库
  ```sh
  git init --bare
  git remote add name path
  git remote rm name
  git remote rename oldname newname
  git fetch
  ```
  
* Git ssh 免密登陆

  ```sh
  ssh-keygen             //生成sshkey
  ssh-copy-id user@host  //将本地的公钥复制到远程服务器的 authorized.keys 文件中
  ```
    - 如果发现不是自己的服务器，可以将本地公钥发给服务器管理员添加在 authorized.keys 文件中

* Git 帮助文档的使用
    - git help
    - git help command
    - [官方文档地址](https://git-scm.com/docs)
