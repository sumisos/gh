#=================================================
#   Author: Sumi(po@ews.ink)
#   Version: 1.1.3.1
#   Updated: 2021-05-19
#   Description: Git Helper Powershell Version
#=================================================

$Script:Version = "1.1.3.1"
$Script:Updated = "2021-05-19"

[String]$Script:Root = Split-Path -Parent $MyInvocation.MyCommand.Definition | Split-Path
$Script:SaveCommand = "save"
$Script:DistCommand = "dist"
$Script:AutoDelete = ""  # 需要删除的文件夹写在这里即可 比如 /public/
$Script:MainBranch = "main"  # 老仓库是master 后来Github搞政治正确废除了"奴隶制" Code Lives Matter!!
$Script:EditBranch = "writing"

#=================================================
# @func Write-Log
# @param {String} $Content logger content
# @param {String} $Level logger level
# @desc Print logger
#=================================================
function Write-Log {
  [CmdletBinding()] Param (
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
  $Logger = "{0} {1} {2}" -f $Current, "[$($Label)]".PadLeft(7, ' '), $Content
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
# @func Initialize-Workspace
# @param {String} $Root project root path
# @param {String} $DeletePath auto delete path
# @return {Boolean} success
# @desc Initialize workspace before execute $Script:CommandBlock
#=================================================
function Initialize-Workspace {
  [CmdletBinding()] Param (
    [Parameter(Mandatory = $true, Position = 1)] [String] $Root,
    [Parameter(Position = 2)] [String] $DeletePath
  )
  if (-not (Test-Path "$($Root)/.git")) {
    Write-Log "当前工作目录不是 Git 项目" fatal
    return $false
  }
  Set-Location $Root
  if (-not [String]::IsNullOrEmpty($DeletePath)) {
    $will_delete = $Root + "\" + $DeletePath.Trim("\/")  # 未处理 ./ 格式
    if ((Test-Path $will_delete) -and (-not $Root.Contains($will_delete))) {
      Remove-Item $will_delete -Recurse
    }
  }
  Write-Log "当前脚本版本 v$($Version) Updated @$($Updated)" notice
  Write-Log "当前工作目录 $($Root)" success
  return $true
}

#=================================================
# @func Invoke-Command
# @param {String} $CommandString commands
# @param {Switch} $enableDebug debug mod
# @desc Execute commands
#=================================================
function Invoke-Command {
  [CmdletBinding()] Param (
    [Parameter(Mandatory = $true)] [String] $CommandString,
    [Switch] $enableDebug
  )
  if ($enableDebug) {
    $debugInfo = "Try to exec this command:`n" + $CommandString
    Write-Log $debugInfo debug
  }
  else {
    $command = [scriptblock]::Create($CommandString)
    Trap { Write-Log "Trap Error: $($_.Exception.Message)" error; Continue }
    & $command
  }
}

$curtime = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
if ([String]::IsNullOrEmpty($args[0])) {
  $commit_message = ""
  $Script:CommandBlock = @"
git add .
git status
"@
}
else {
  if ($args.Count -eq 1) {
    $commit_message = "Updated @$($curtime)"
  }
  else {
    $extraMsg = [String]$args[1]
    for ($i = 2; $i -lt $args.Count; $i++) {
      $extraMsg += " $($args[$i])"
    }
    $commit_message = "$($extraMsg.Trim())"
  }

  $Script:DoSave = @"
git switch $($Script:EditBranch)
git add .
git status
git commit -m `"$($commit_message)`"
git push -u origin $($Script:EditBranch)
git push gitee $($Script:EditBranch)
"@

  $Script:DoDist = @"
git switch $($Script:MainBranch)
git merge $($Script:EditBranch) -m "$($commit_message)"
git push -u origin $($Script:MainBranch)
git push gitee $($Script:MainBranch)
git switch $($Script:EditBranch)
"@

  if ($Script:SaveCommand.contains("$($args[0])")) {
    $Script:CommandBlock = $Script:DoSave
  }
  elseif ($Script:DistCommand.contains("$($args[0])")) {
    $Script:CommandBlock = $Script:DoDist
  }
  else {
    $Script:CommandBlock = @"
git add .
git status
"@
  }
}

# Trap { Write-Log "Trap Error: $($_.Exception.Message)" error; Continue }
if (Initialize-Workspace $Script:Root -DeletePath $Script:AutoDelete) {
  Invoke-Command $Script:CommandBlock # -enableDebug
}
