#=================================================
#   Author: Sumi(po@ews.ink)
#   Version: 1.1.6.0
#   Updated: 2021-05-20
#   Description: Git Helper Powershell Version
#=================================================

$Script:Version = "1.1.6.0"
$Script:Updated = "2021-05-21"
[String]$Script:ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

#=================================================
# @func Write-Dev
# @param {Object} $Target
# @desc Print debug
#=================================================
function Write-Dev {
  [CmdletBinding()] param (
    [Parameter(Mandatory = $true, Position = 1)] $Breakpoint
  )
  $DebugTips = "[{0}]`n{1}" -F $Breakpoint.GetType(), $Breakpoint
  Write-Host $DebugTips
  exit
}

#=================================================
# @func Write-Log
# @param {String} $Content logger content
# @param {String} $Level logger level
# @desc Print logger
#=================================================
function Write-Log {
  [CmdletBinding()] param (
    [Parameter(Mandatory = $true, Position = 1)] [String]$Content,
    [Parameter(Position = 2)] [String]$Level = "INFO"
  )
  $Current = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  # $Content = $Content.Replace("`n", "`n".PadRight(27, ' '))
  $Level = $Level.ToUpper()
  switch ($Level) {
    # 7.0+ 版本才支持三元运算符
    { "NOTICE|SUCCESS|INFO".Contains($Level) } { $Label = "INFO" }
    { "WARN".Contains($Level) } { $Label = "WARN" }
    { "ERROR".Contains($Level) } { $Label = "ERROR" }
    { "FATAL".Contains($Level) } { $Label = "FATAL" }
    default { $Label = "DEBUG" }
  }
  $Logger = "{0} {1} {2}" -F $Current, "[$($Label)]".PadLeft(7, ' '), $Content
  switch ($Level) {
    { "NOTICE".Contains($Level) } { Write-Host $Logger -ForegroundColor Cyan }
    { "SUCCESS".Contains($Level) } { Write-Host $Logger -ForegroundColor Green }
    { "INFO".Contains($Level) } { Write-Host $Logger -ForegroundColor White }
    { "WARN".Contains($Level) } { Write-Host $Logger -ForegroundColor Yellow }
    { "ERROR".Contains($Level) } { Write-Host $Logger -ForegroundColor DarkRed }
    { "FATAL".Contains($Level) } { Write-Host $Logger -ForegroundColor White -BackgroundColor Red; exit }
    { "DIVIDER".Contains($Level) } { Write-Host "".PadLeft(64, '=') -ForegroundColor Gray }
    default { Write-Host $Logger -ForegroundColor DarkGray }
  }
}

#=================================================
# @func Read-Config
# @param {String} $ScriptPath
# @desc Read config from local .env file
#=================================================
function Read-Config {
  [CmdletBinding()] param (
    [Parameter(Mandatory = $true, Position = 1)] [String]$ScriptPath
  )
  # Write-Log "Reading config file(.env) ..." DEBUG
  $ConfigPath = "{0}\.env" -F $ScriptPath
  if (Test-Path $ConfigPath) {
    $SettingList = Get-Content $ConfigPath # -Encoding UTF8
    $Script:Config = $SettingList | ForEach-Object {
      $item = "$($_)".Split('=')
      "{0}={1}" -F $item[0], $item[1].Replace("\", "/").Replace("./", "/")
    } | ConvertFrom-StringData
  }
  else {
    Write-Log ".env file not exists!" WARN
    @"
COMMAND_SAVE=save
COMMAND_DIST=dist
BRANCH_MAIN=main
AUTO_DELETE=
DEBUG=false
"@ | Out-File $ConfigPath
    $Script:Config = @{
      COMMAND_SAVE = "save"
      COMMAND_DIST = "dist"
      BRANCH_MAIN  = "main"    # 老仓库是master 后来Github搞政治正确废除了"奴隶制" Code Lives Matter!
      AUTO_DELETE  = ""        # 需要删除的文件夹写在这里即可 比如 /public/
      DEBUG        = "false"
    }
    Write-Log "Generated .env file success. Use default setting." NOTICE
  }
}

#=================================================
# @func Initialize-Workspace
# @param {String} $Root project root path
# @param {String} $DeletePath auto delete path
# @return {Boolean} success
# @desc Initialize workspace before execute $Script:CommandBlock
#=================================================
function Initialize-Workspace {
  [CmdletBinding()] param (
    [Parameter(Mandatory = $true, Position = 1)] [String]$Root,
    [Parameter(Position = 2)] [String]$DeletePath
  )
  if (-not (Test-Path "$($Root)/.git")) {
    Write-Log "Workspace is NOT a git project!" FATAL
    return $false
  }
  Set-Location $Root
  Write-Log "Workspace: $($Root)" SUCCESS
  $Script:Branch = $(git rev-parse --abbrev-ref HEAD)
  Write-Log "Branch: $($Script:Branch) ($(git rev-parse --short HEAD))"

  if (-not [String]::IsNullOrEmpty($DeletePath)) {
    $will_delete = $Root + "\" + $DeletePath.Trim("/")
    if ((Test-Path $will_delete) -and (-not $Root.Contains($will_delete))) {
      if ("$($Script:Config.DEBUG)".CompareTo("true") -ne -1) {
        $DebugTips = "Try to delete:`nRemove-Item `"{0}`" -Recurse" -F $will_delete
        Write-Log $DebugTips DEBUG
      }
      else {
        Remove-Item "$will_delete" -Recurse
      }
    }
  }
  return $true
}

#=================================================
# @func Invoke-Command
# @param {String} $CommandString commands
# @param {Switch} $DebugMode debug mod
# @desc Execute commands
#=================================================
function Invoke-Command {
  [CmdletBinding()] param (
    [Parameter(Mandatory = $true)] [String]$CommandString,
    [String]$DebugMode = "false"
  )
  if ($DebugMode.CompareTo("true") -ne -1) {
    $DebugTips = "Try to exec command:`n" + $CommandString
    Write-Log $DebugTips DEBUG
  }
  else {
    $command = [scriptblock]::Create($CommandString)
    Trap { Write-Log "Trap Error: $($_.Exception.Message)" ERROR; Continue }
    & $command
  }
}

#=================================================
# @func Main
# @desc Main workflow
#=================================================
function Invoke-Main {
  [CmdletBinding()] param (
    [Parameter(Mandatory = $true)] $Temp
  )
  Write-Log "Script Version $($Version)    Updated @$($Updated)" NOTICE

  $Script:Root = $Script:ScriptPath | Split-Path
  Read-Config $Script:ScriptPath
  Initialize-Workspace $Script:Root -DeletePath $Script:Config.AUTO_DELETE | Out-Null

  $curtime = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
  if ([String]::IsNullOrEmpty($Temp[0])) {
    $commit_message = ""
    $Script:CommandBlock = @"
git add .
git status
"@
  }
  else {
    if ($Temp.Count -eq 1) {
      $commit_message = "Updated @$($curtime)"
    }
    else {
      $extraMsg = [String]$Temp[1]
      for ($i = 2; $i -lt $Temp.Count; $i++) {
        $extraMsg += " $($Temp[$i])"
      }
      $commit_message = "$($extraMsg.Trim())"
    }

    $Script:DoSave = @"
git switch $($Script:Branch)
git add .
git status
git commit -m `"$($commit_message)`"
git push -u origin $($Script:Branch)
git push gitee $($Script:Branch)
"@

    $Script:DoDist = @"
git switch $($Script:Config.BRANCH_MAIN)
git merge $($Script:Branch) -m "$($commit_message)"
git push -u origin $($Script:Config.BRANCH_MAIN)
git push gitee $($Script:Config.BRANCH_MAIN)
git switch $($Script:Branch)
"@

    if ("$($Script:Config.COMMAND_SAVE)".Contains("$($Temp[0])")) {
      $Script:CommandBlock = $Script:DoSave
    }
    elseif ("$($Script:Config.COMMAND_DIST)".Contains("$($Temp[0])")) {
      $Script:CommandBlock = $Script:DoDist
    }
    elseif ("update".Contains("$($Temp[0])")) {
      $Script:CommandBlock = @"
git submodule update --rebase --remote
git add .
"@
    }
    else {
      $Script:CommandBlock = @"
git add .
git status
"@
    }
  }

  Invoke-Command $Script:CommandBlock $Script:Config.DEBUG
}
