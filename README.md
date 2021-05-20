<h2 align="center">🚀 Git Helper Scripts Using PowerShell</h2>

<p  align="center">
    <a href="https://github.com/sumisos/gh" target="_blank"><img src="https://img.shields.io/badge/sumisos-gh-blue?logo=github" alt="Github Repository" /></a>
    <a href="https://github.com/sumisos/gh/blob/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/license-MIT-green" alt="Package License" /></a>
    <a href="https://github.com/sumisos/gh/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/sumisos/gh" alt="Release Version" /></a>
</p>

## Install
```bash
$ git submodule add https://github.com/sumisos/gh.git
```

## Usage
### Windows
```powershell
$ .\gh\ci.ps1 <COMMAND> [COMMIT MESSAGE]
```

* `<COMMAND>`: `save` or `dist`  
* `[COMMIT MESSAGE]`: Commit message  

#### Add untracked files to Staged
```powershell
$ .\gh\ci.ps1
```

#### Commit changes & Push to remote @**CURRENT branch**
```powershell
$ .\gh\ci.ps1 save
```

>  Default commit message wil be `Updated @yyyy-MM-dd HH:mm:ss`.  

---

You may save the "save":  
```powershell
$ .\gh\ci.ps1 s
```

---

You may edit your own commit message:  
```powershell
$ .\gh\ci.ps1 sa init
```

---

You may edit a long commit message:  
```powershell
$ .\gh\ci.ps1 save "fix: It's a very long commit message & Closes #123, #456"
```

---

You may save the quotes:  
```powershell
$ .\gh\ci.ps1 save commit message without special syntax
```

#### Push main branch by merge & Keeping in current branch
```powershell
$ .\gh\ci.ps1 dist
$ .\gh\ci.ps1 d # notice "d" not in "save"
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

You may also use in Windows:  
```bash
$ .\gh\ci.ps1 update
```

or in Linux:  
```bash
$ ./gh/ci update
```

## TODO
- [x] Support config file to customize script  
- [ ] Refactor shell version to support Linux  
