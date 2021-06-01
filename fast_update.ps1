$CommandBlock = @"
git add .
git status
git commit -m `"perf: rapid iteration @$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))`"
git push -u origin
git push gitee
"@

# Write-Host $CommandBlock
$Commander = [ScriptBlock]::Create($CommandBlock)
& $Commander
