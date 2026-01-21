$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "         WinDeploy Yukleyicisi         " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Yonetici izni gerekli..." -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command irm 'https://windeploy.vercel.app/launcher.ps1' | iex"
    exit
}

Write-Host "Yonetici modu aktif" -ForegroundColor Green
Write-Host ""

try {
    Write-Host "Indiriliyor..." -ForegroundColor Cyan
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    $script = irm "https://windeploy.vercel.app/WinDeploy.ps1" -ErrorAction Stop
    Write-Host "Indir tamamlandi" -ForegroundColor Green
    Write-Host ""
    
    Invoke-Expression $script
    
} catch {
    Write-Host "Hata: $_" -ForegroundColor Red
    exit 1
}