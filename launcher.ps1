[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Write-Host " WinDeploy başlatılıyor..." -ForegroundColor Cyan

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "  Yönetici izni gerekli..." -ForegroundColor Yellow
    $scriptFile = "C:\Users\asus\Documents\WinDeploy\launcher.ps1"
    Start-Process powershell -Verb RunAs -ArgumentList @("-NoProfile", "-ExecutionPolicy Bypass", "-File", $scriptFile)
    exit
}

$domain = $env:WINDEPLOY_DOMAIN
if (-not $domain) {
    $domain = "https://raw.githubusercontent.com/sylorx/WinDeploy/main"
}

Write-Host " Kaynak: $domain" -ForegroundColor Gray

$windeployPath = Join-Path $env:TEMP "WinDeploy.ps1"

Write-Host " WinDeploy indiriliyor..." -ForegroundColor Yellow

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    $webClient = New-Object System.Net.WebClient
    $webClient.Encoding = [System.Text.Encoding]::UTF8
    $uri = "$domain/WinDeploy.ps1"
    
    $webClient.DownloadFile($uri, $windeployPath)
    Write-Host " İndirme tamamlandı" -ForegroundColor Green
    
    & $windeployPath
    
} catch {
    Write-Host " Hata: $_" -ForegroundColor Red
    exit 1
}