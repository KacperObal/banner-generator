param(
  [Parameter(Mandatory = $true)]
  [string]$RepoUrl
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $false

Set-Location $PSScriptRoot

if (-not (Test-Path ".git")) {
  git init
}

$currentBranch = git branch --show-current 2>$null
if (-not $currentBranch) {
  git checkout -b main
} elseif ($currentBranch -ne "main") {
  git branch -M main
}

$existingRemotes = git remote
if ($existingRemotes -contains "origin") {
  git remote set-url origin $RepoUrl
} else {
  git remote add origin $RepoUrl
}

git add index.html editor.html banner.png banner-image-data.js .nojekyll
git commit -m "Publish banner generator" 2>$null

git push -u origin main

Write-Host ""
Write-Host "Gotowe. Teraz w repo na GitHub włącz GitHub Pages:"
Write-Host "Settings -> Pages -> Build and deployment -> Deploy from a branch -> main /(root)"
