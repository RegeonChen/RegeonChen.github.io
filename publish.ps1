param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath
)

$ErrorActionPreference = "Stop"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

$BlogRoot = "D:\MyBlog"
$PostsDir = "$BlogRoot\content\posts"

if (-not (Test-Path $SourcePath)) {
    Write-Host "ERROR: Source file not found: $SourcePath"
    exit 1
}

if ($SourcePath -notmatch '\.md$') {
    Write-Host "ERROR: Only .md files are supported"
    exit 1
}

$FileName = Split-Path $SourcePath -Leaf
$DestPath = "$PostsDir\$FileName"

Write-Host "Source: $SourcePath"
Write-Host "Dest  : $DestPath"

Copy-Item $SourcePath $DestPath -Force
Write-Host "Copied OK"

Set-Location $BlogRoot

$Title = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
Write-Host "Title: $Title"

git add "content/posts/$FileName"
git commit -m "post: $Title"
git push

Write-Host "Done!"
Write-Host "Site: https://regeonchen.github.io/"
