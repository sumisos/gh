# Git Helper

## Install
```bash
$ git submodule add https://github.com/sumisos/gh.git
```

## Update
```bash
$ $ git submodule update --rebase --remote
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

## TODO
- [ ] Support config file to customize script  
- [ ] Refactor shell version to support Linux  
