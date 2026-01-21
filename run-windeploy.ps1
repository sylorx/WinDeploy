#!/usr/bin/env pwsh
<#
.SYNOPSIS
    WinDeploy Başlangıç Betiği - Lokal Test İçin

.DESCRIPTION
    Bu script, WinDeploy'u lokal olarak test etmek için tasarlanmıştır.
    Execution Policy'yi otomatik ayarlar ve programı çalıştırır.

.USAGE
    PowerShell'i açın ve şu komutu çalıştırın:
    .\run-windeploy.ps1

.NOTES
    Yönetici izni gereklidir!
#>

# Renkler
$colors = @{
    Info = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
}

function Write-ColorMessage {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Banner
Clear-Host
Write-ColorMessage "`n╔════════════════════════════════════════════════════════════╗" $colors.Info
Write-ColorMessage "║         🚀 WinDeploy - Başlangıç Betiği 🚀                ║" $colors.Info
Write-ColorMessage "║                  Lokal Test Sürümü                        ║" $colors.Info
Write-ColorMessage "╚════════════════════════════════════════════════════════════╝`n" $colors.Info

# Yönetici Kontrolü
Write-ColorMessage "1️⃣ Yönetici İzni Kontrol Ediliyor..." $colors.Info
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-ColorMessage "❌ Bu script yönetici izni ile çalıştırılmalıdır!" $colors.Error
    Write-ColorMessage "PowerShell'i sağ tıkla > 'Yönetici olarak çalıştır' seçin" $colors.Warning
    Start-Sleep -Seconds 3
    exit 1
}
Write-ColorMessage "✅ Yönetici izni kontrolü başarılı`n" $colors.Success

# Execution Policy
Write-ColorMessage "2️⃣ Execution Policy Ayarlanıyor..." $colors.Info
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force -ErrorAction Stop
    Write-ColorMessage "✅ Execution Policy ayarlandı`n" $colors.Success
} catch {
    Write-ColorMessage "⚠️ Execution Policy ayarlanamadı: $_" $colors.Warning
}

# WinDeploy Script Kontrol
Write-ColorMessage "3️⃣ WinDeploy Script Kontrol Ediliyor..." $colors.Info
$scriptPath = Join-Path $PSScriptRoot "WinDeploy.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-ColorMessage "❌ WinDeploy.ps1 bulunamadı!" $colors.Error
    Write-ColorMessage "Lütfen WinDeploy.ps1 dosyasının aynı dizinde olduğundan emin olun." $colors.Warning
    Start-Sleep -Seconds 3
    exit 1
}
Write-ColorMessage "✅ WinDeploy.ps1 bulundu`n" $colors.Success

# WinDeploy'u Çalıştır
Write-ColorMessage "4️⃣ WinDeploy Başlatılıyor...`n" $colors.Info
Write-ColorMessage "════════════════════════════════════════════════════════════`n" $colors.Info

try {
    & $scriptPath
} catch {
    Write-ColorMessage "`n❌ Hata: $_" $colors.Error
    Start-Sleep -Seconds 3
    exit 1
}
