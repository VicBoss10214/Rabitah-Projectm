# Build a self-contained, clickable Rabitah Windows app image.
param(
  [string]$ApiUrl = $env:RABITAH_API_BASE_URL
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ApiUrl)) {
  $ApiUrl = 'https://rabitah-projectm-production.up.railway.app/api/v1'
}

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Frontend = Join-Path $Root 'Rabitah-Frontend'
$Output = Join-Path $Root 'dist'
$Input = Join-Path $env:TEMP ("rabitah-jpackage-" + [guid]::NewGuid().ToString())
$Icon = Join-Path $Frontend 'src\main\resources\com\rabitah\frontend\images\package-icons\rabitah.ico'

try {
  Set-Location $Root
  & mvn -q -pl Rabitah-Frontend -am -DskipTests package
  if ($LASTEXITCODE -ne 0) { throw 'Maven build failed.' }

  New-Item -ItemType Directory -Force -Path $Input | Out-Null
  Copy-Item (Join-Path $Frontend 'target\Rabitah.jar') $Input
  Copy-Item (Join-Path $Frontend 'target\desktop-libs\*.jar') $Input
  New-Item -ItemType Directory -Force -Path $Output | Out-Null
  Remove-Item (Join-Path $Output 'Rabitah') -Recurse -Force -ErrorAction SilentlyContinue

  & jpackage --type app-image --input $Input --name Rabitah --main-jar Rabitah.jar `
    --main-class com.rabitah.frontend.RabitahLauncher --dest $Output --app-version 1.0.0 `
    --vendor Rabitah --description 'Rabitah campus platform' --icon $Icon --java-options "-Drabitah.api=$ApiUrl"
  if ($LASTEXITCODE -ne 0) { throw 'jpackage failed. Install JDK 21, not a JRE.' }
  Write-Host "Built clickable app: $Output\Rabitah\Rabitah.exe"
}
finally {
  Remove-Item $Input -Recurse -Force -ErrorAction SilentlyContinue
}
