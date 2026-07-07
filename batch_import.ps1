param(
    [string]$SourceDir,
    [string]$PostsDir,
    [string]$Today
)

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

$files = Get-ChildItem $SourceDir -Filter "*期末复习*.md" -Recurse

foreach ($file in $files) {
    $destFile = Join-Path $PostsDir $file.Name

    if ($file.Name -eq "期末复习 - 典型进程内存布局.md") {
        Write-Host "SKIP (already done): $($file.Name)"
        continue
    }

    Write-Host "Processing: $($file.Name)"

    $firstLine = Get-Content $file.FullName -First 1
    $title = $firstLine -replace '^#+\s*', ''
    if (-not $title) {
        $title = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    }
    $title = $title.Trim().Trim('"').Trim("'")

    $frontMatter = @"
---
title: "$title"
date: $Today
draft: false
tags: ["CSAPP", "操作系统"]
categories: ["课程笔记"]
---

"@

    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $newContent = $frontMatter + $content
    [System.IO.File]::WriteAllText($destFile, $newContent, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  OK: $title"
}

Set-Location $PostsDir\..
git add content/posts/

Write-Host ""
Write-Host "Files staged. Ready to commit."
