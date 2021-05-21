<h1 align="center">🚀 Git Helper Scripts Using PowerShell</h1>

<p  align="center">
    <a href="https://github.com/sumisos/gh" target="_blank"><img src="https://img.shields.io/badge/sumisos-gh-blue?logo=github" alt="Github Repository" /></a>
    <a href="https://github.com/sumisos/gh/blob/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/License-MIT-green" alt="Package License" /></a>
    <a href="https://github.com/sumisos/gh/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/sumisos/gh?label=Version" alt="Release Version" /></a>
    <a href="https://github.com/sumisos/gh/blob/main/README.zh-CN.md" target="_blank"><img src="https://img.shields.io/badge/中文-文档-green" alt="Release Version" /></a>
</p>

## Install
```bash
$ git submodule add https://github.com/sumisos/gh.git
```

## Usage
* Configuration file(`.env`) will be generated if not exists  
* It also works if moved `ci.ps1` to parent path  

```
Your-Project/
 ├── .git/       # git repo meta info
 ├── gh/
 │ ├── .env      # config file
 │ ├── core.ps1  # core function
 │ ├── ci.ps1    # starter
 │ └── ...
 └── ...         # your project
```

Become：  
```
Your-Project/
 ├── .git/       # git repo meta info
 ├── gh/
 │ ├── .env      # config file
 │ ├── core.ps1  # core function
 │ ├── ci.ps1    # starter
 │ └── ...
 └── ci.ps1      # starter copy
 └── ...         # your project
```

`.\gh\ci.ps1` / `.\ci.ps1` will be both effective.  

Besides, you can keep it after updated scripts to new version.  
**By and large**, content of the `ci.ps1` file would NOT change.  

### Configuration `.env`
```
COMMAND_SAVE=save  # save func alias
COMMAND_DIST=dist  # dist func alias
BRANCH_MAIN=main   # old repo is master. nice try. CLM!
AUTO_DELETE=       # **CAUTION** auto delete path
ENABLE_GITLAB=     # name of another remote repo
DEBUG=false        # enable debug mode (log command to console instead of exec)
```

### Windows
```powershell
$ .\gh\ci.ps1 <COMMAND> [COMMIT MESSAGE]
```

* `<COMMAND>`: `save` or `dist` (you may edit it in `.env`)  
* `[COMMIT MESSAGE]`: commit message  

#### General
Add untracked files to Staged:  

```powershell
$ .\gh\ci.ps1
```

#### Save
Commit changed files & push to remote @ **CURRENT branch**:  

```powershell
$ .\gh\ci.ps1 save
```

> Default commit message will be like `Updated @yyyy-MM-dd HH:mm:ss`.  

---

You may edit a long commit message (recommend using quotes):  
```powershell
$ .\gh\ci.ps1 save "fix: It's a very long commit message & Closes #123, #456"
```

---

You may save the quotes:  
```powershell
$ .\gh\ci.ps1 save commit message without special syntax
```

---

You may save the "save":  
```powershell
$ .\gh\ci.ps1 s
```

---

It's also support edit commit message:  
```powershell
$ .\gh\ci.ps1 sa init
```

#### Distribute
Push `main` branch by merge current branch with keeping in:  

```powershell
$ .\gh\ci.ps1 dist
$ .\gh\ci.ps1 d # notice "d" not in "save" because save is first
```

### Linux
```bash
$ chmod +x ./gh/ci
$ ./gh/ci
```

## Update
```bash
$ git submodule update --rebase --remote
```

You may also use update command alias in Windows:  
```bash
$ .\gh\ci.ps1 update
```

or in Linux:  
```bash
$ ./gh/ci update
```

## TODO
- [x] Support config file to customize script  
- [x] Default NOT push to Gitee  
- [ ] Refactor shell version to support Linux  
