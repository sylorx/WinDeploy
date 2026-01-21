# WinDeploy - One-Line PowerShell Installer
# Kullanım: Aşağıdaki komutu PowerShell'de (Yönetici) çalıştırın

$ErrorActionPreference = "Stop"

Write-Host "🚀 WinDeploy başlatılıyor..." -ForegroundColor Cyan
Write-Host ""

# ExecutionPolicy kontrolü ve ayarlama
$currentPolicy = Get-ExecutionPolicy -Scope Process
if ($currentPolicy -in @("Restricted", "AllSigned")) {
    Write-Host "⚙️ ExecutionPolicy ayarlanıyor..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
}

# Yönetici kontrolü
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "📌 Yönetici izni gerekli. PowerShell yeniden başlatılıyor..." -ForegroundColor Yellow
    Write-Host ""
    
    # Yönetici modunda yeniden başlat
    $scriptFile = $MyInvocation.MyCommand.Path
    if (-not $scriptFile) {
        # Eğer pipe ile çalıştırıldıysa, indirdikten sonra çalıştır
        $scriptFile = Join-Path $env:TEMP "windeploy-launcher-temp.ps1"
        $MyInvocation.Line | Out-File -FilePath $scriptFile -Encoding UTF8
    }
    
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptFile`"" `
        -Verb RunAs `
        -Wait
    exit
}

Write-Host "✅ Yönetici modu aktif" -ForegroundColor Green
Write-Host ""

# WinDeploy script dosya yolu
$windeployPath = Join-Path $env:TEMP "WinDeploy.ps1"

# GitHub'dan indir
Write-Host "📥 WinDeploy indiriliyor..." -ForegroundColor Yellow

try {
    # TLS 1.2 güvenliği
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    $uri = "https://raw.githubusercontent.com/sylorx/WinDeploy/main/WinDeploy.ps1"
    
    # Web isteği (proxy uyumlu)
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($uri, $windeployPath)
    
    Write-Host "✅ İndirme tamamlandı" -ForegroundColor Green
    Write-Host ""
    
    # WinDeploy'u çalıştır
    Write-Host "🎯 WinDeploy çalıştırılıyor..." -ForegroundColor Cyan
    Write-Host ""
    
    # ExecutionPolicy bypass ile çalıştır
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
    & $windeployPath
    
} catch {
    Write-Host "❌ Hata oluştu:" -ForegroundColor Red
    Write-Host "   $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Çözüm önerileri:" -ForegroundColor Yellow
    Write-Host "   1. İnternet bağlantınızı kontrol edin"
    Write-Host "   2. PowerShell'i yönetici olarak çalıştırdığınızdan emin olun"
    Write-Host "   3. Windows Defender Firewall ayarlarını kontrol edin"
    Write-Host ""
    
    Write-Host "Devam etmek için Enter tuşuna basın..." -ForegroundColor Gray
    Read-Host
}
