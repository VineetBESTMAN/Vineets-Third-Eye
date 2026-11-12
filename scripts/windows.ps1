param(
    [ValidateSet('Install', 'Dev', 'Doctor', 'Build', 'Test', 'Track', 'Smoke', 'Check')]
    [string]$Action = 'Dev'
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Set-Location -LiteralPath $root
$version = '24.22.3'
$toolsDir = Join-Path $root '.tools'
$runtime = Join-Path $toolsDir "node-v$version-win-x64"
$sharedRuntime = Join-Path (Split-Path $root -Parent) ".tools\node-v$version-win-x64"
if (Test-Path (Join-Path $sharedRuntime 'node.exe')) { $runtime = $sharedRuntime }
if (-not (Test-Path (Join-Path $runtime 'node.exe'))) {
    if ($Action -ne 'Install') { throw 'Run setup-windows.cmd first to install the portable runtime.' }
    New-Item -ItemType Directory -Force $toolsDir | Out-Null
    $archiveName = "node-v$version-win-x64.zip"
    $archive = Join-Path $toolsDir $archiveName
    $base = "https://nodejs.org/dist/v$version"
    Invoke-WebRequest "$base/$archiveName" -OutFile $archive -UseBasicParsing
    $manifest = (Invoke-WebRequest "$base/SHASUMS256.txt" -UseBasicParsing).Content
    $line = ($manifest -split "`n") | Where-Object { $_.Trim().EndsWith(" $archiveName") }
    if (-not $line) { throw 'Node checksum entry missing.' }
    $expected = ($line.Trim() -split '\s+')[0]
    if ((Get-FileHash $archive -Algorithm SHA256).Hash -ne $expected) { throw 'Node checksum mismatch.' }
    Expand-Archive -LiteralPath $archive -DestinationPath $toolsDir -Force
}
$env:PATH = "$runtime;$env:PATH"
$env:PUPPETEER_CACHE_DIR = Join-Path (Split-Path $runtime -Parent) 'puppeteer'
$env:npm_config_cache = Join-Path (Split-Path $runtime -Parent) 'npm-cache'
# Native watchers can throw EBUSY when Windows briefly locks a newly copied asset.
$env:CHOKIDAR_USEPOLLING = 'true'
$env:CHOKIDAR_INTERVAL = '1000'
$npm = Join-Path $runtime 'npm.cmd'
function Invoke-Npm {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$NpmArgs)
    & $npm @NpmArgs
    if ($LASTEXITCODE -ne 0) { throw "npm $NpmArgs failed (exit $LASTEXITCODE)." }
}
switch ($Action) {
    'Install' { Invoke-Npm -NpmArgs @('ci'); Invoke-Npm -NpmArgs @('run', 'doctor') }
    'Dev' { Invoke-Npm -NpmArgs @('run', 'dev', '--', '--host', 'localhost', '--port', '4173', '--strictPort') }
    'Doctor' { Invoke-Npm -NpmArgs @('run', 'doctor') }
    'Build' { Invoke-Npm -NpmArgs @('run', 'build') }
    'Test' { Invoke-Npm -NpmArgs @('test') }
    'Track' { Invoke-Npm -NpmArgs @('run', 'test:track', '--', '--offline-imagery') }
    'Smoke' {
        & (Join-Path $runtime 'node.exe') scripts/smoke-local.mjs
        if ($LASTEXITCODE -ne 0) { throw 'Browser smoke check failed.' }
    }
    'Check' {
        Invoke-Npm -NpmArgs @('run', 'doctor')
        Invoke-Npm -NpmArgs @('run', 'format:check')
        Invoke-Npm -NpmArgs @('run', 'check:boundaries')
        Invoke-Npm -NpmArgs @('test')
        Invoke-Npm -NpmArgs @('run', 'build')
    }
}
