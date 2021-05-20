# Start-Process ".\gh\ci.ps1" -ArgumentList $args
$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
switch ($Root) {
    { Test-Path "$($Root)\core.ps1" } { $CorePath = "$($Root)\core.ps1" }
    { Test-Path "$($Root)\gh\core.ps1" } { $CorePath = "$($Root)\gh\core.ps1" }
    default { "[FATAL] Git Helper core not found!"; exit }
}
. "$($CorePath)"

# Write-Log "Found Worker @ $($CorePath)" debug
Invoke-Main $args
