<h1 align="center">🚀 Git 使用助手 PowerShell 版</h1>

<p  align="center">
    <a href="https://github.com/sumisos/gh" target="_blank"><img src="https://img.shields.io/badge/sumisos-gh-blue?logo=github" alt="Github Repository" /></a>
    <a href="https://github.com/sumisos/gh/blob/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/License-MIT-green" alt="Package License" /></a>
    <a href="https://github.com/sumisos/gh/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/sumisos/gh?label=Version" alt="Release Version" /></a>
</p>

## 安装
```bash
$ git submodule add http://github.com/sumisos/gh.git
```

## 用法
* 初次运行会自动生成配置文件（`.env`）  
* 可以把启动脚本移到上层目录使用（但只支持移出一层）  

```
Your-Project/
 ├── .git/       # Git 仓库信息
 ├── gh/
 │ ├── .env      # 配置文件
 │ ├── core.ps1  # 核心功能实现脚本
 │ ├── ci.ps1    # 启动脚本
 │ └── ...
 └── ...         # 你的项目文件
```

变成：  
```
Your-Project/
 ├── .git/       # Git 仓库信息
 ├── gh/
 │ ├── .env      # 配置文件
 │ ├── core.ps1  # 核心功能实现脚本
 │ ├── ci.ps1    # 启动脚本
 │ └── ...
 └── ci.ps1      # 启动脚本拷贝
 └── ...         # 你的项目文件
```

如此一来，之后所有的 `.\gh\ci.ps1` => `.\ci.ps1`。（而且两种方式都能使用）  

并且以后当版本更新时，也不需要重新拷贝启动脚本，可以继续沿用。  
因为**一般来说**入口文件是不会变动的。  

### 配置文件 `.env`
```
COMMAND_SAVE=save  # save 功能的别名
COMMAND_DIST=dist  # dist 功能的别名
BRANCH_MAIN=main   # 老仓库是master 后来Github搞政治正确废除了"奴隶制"  Code Lives Matter!
AUTO_DELETE=       # **慎用** 自动删除目录 留空为不删除
ENABLE_GITLAB=     # 多仓库名字 需要提前配置好多远程仓库
DEBUG=false        # 开启Debug模式 打印出原本应该运行的命令
```

> 如果参考<a href="https://ews.ink/tech/git-github-gitee" target="_blank">同时使用 Github 以及 Gitee 进行版本管理</a>一文配置**多远程仓库**，`ENABLE_GITLAB` 就应该填 `gitee`。  

### Windows
```powershell
$ .\gh\ci.ps1 <COMMAND> [COMMIT MESSAGE]
```

* `<COMMAND>`： 默认为 `save` 或者 `dist`，可以在配置文件中自行设置  
* `[COMMIT MESSAGE]`： 传递到实际 `commit` 命令的 commit message  

#### 常规
添加工作区的所有变动文件到本地仓库：  
```powershell
$ .\gh\ci.ps1
```

#### 保存
提交当前分支的所有变动，并 push 到远程仓库：  
```powershell
$ .\gh\ci.ps1 save
```

> 默认的 commit message 是 `Updated @yyyy-MM-dd HH：mm：ss` 这样的格式。  

---

可以使用长 commit message，推荐用双引号包裹起来，以免产生歧义：  
```powershell
$ .\gh\ci.ps1 save "fix： It's a very long commit message & Closes #123, #456"
```

---

可以省略引号，只有第一个参数会被识别为命令，剩余的参数会自动归类为一条 commit message。  
但要注意不能有影响 PowerShell 功能的特殊符号（比如 `&` / `|`/ `#` 等）：  
```powershell
$ .\gh\ci.ps1 save commit message without special syntax
```

---

可以使用缩写的命令：  
```powershell
$ .\gh\ci.ps1 sa
```

---

缩写的命令也是可以添加 commit message 的：  
```powershell
$ .\gh\ci.ps1 s init
```

#### 分发
保持处于 `当前分支` 的情况下，将 `当前分支` 合并到 `主分支`，并提交 `主分支`：  

```powershell
$ .\gh\ci.ps1 dist
$ .\gh\ci.ps1 d # 注意d不在关键词save里 否则会优先触发save
```

### Linux
```bash
$ chmod +x ./gh/ci
$ ./gh/ci
```

## 更新
```bash
$ git submodule update --rebase --remote
```

脚本也有自更新功能，Windows 运行：  
```bash
$ .\gh\ci.ps1 update
```

Linux 运行：  
```bash
$ ./gh/ci update
```
