# Build a clean CurseForge release zip for CraftSage.
# Output: dist/CraftSage-<version>.zip
# Usage: .\build-release.ps1

$ErrorActionPreference = "Stop"

$root    = $PSScriptRoot
$tocFile = Join-Path $root "CraftSage.toc"

# Read version from TOC
$version = (Select-String -Path $tocFile -Pattern "^## Version:\s*(.+)").Matches[0].Groups[1].Value.Trim()
if (-not $version) { Write-Error "Could not read version from CraftSage.toc"; exit 1 }

$distDir  = Join-Path $root "dist"
$stagingDir = Join-Path $distDir "CraftSage"
$zipPath  = Join-Path $distDir "CraftSage-$version.zip"

# Clean staging
if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item -ItemType Directory -Path $stagingDir | Out-Null

# Files and folders to include (everything except dev/meta files)
$include = @("CraftSage.toc", "Core.lua", "UI", "Data", "Libs", "Locale") + `
           (Get-ChildItem $root -Filter "*.tga" | Select-Object -ExpandProperty Name)

foreach ($item in $include) {
  $src = Join-Path $root $item
  if (-not (Test-Path $src)) { Write-Warning "Skipping missing: $item"; continue }
  $dst = Join-Path $stagingDir $item
  Copy-Item -Path $src -Destination $dst -Recurse -Force
}

# Remove any stray debug/dev artefacts that might have slipped in
$prunePatterns = @("*.bak", "*.orig", "Thumbs.db", ".DS_Store")
foreach ($pat in $prunePatterns) {
  Get-ChildItem $stagingDir -Recurse -Filter $pat | Remove-Item -Force
}

# Build zip (overwrite if exists)
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $stagingDir -DestinationPath $zipPath

# Clean staging dir
Remove-Item $stagingDir -Recurse -Force

Write-Host ""
Write-Host "Release built: $zipPath"
Write-Host "Version: $version"
Write-Host "Size: $([math]::Round((Get-Item $zipPath).Length / 1KB, 1)) KB"
