# WinDeploy One-Liner Installer
# Kullanım: irm "https://example.com/launcher.ps1" | iex
# Veya lokal: powershell -NoProfile -ExecutionPolicy Bypass -Command "(irm 'https://example.com/launcher.ps1') | iex"

Write-Host "WinDeploy Başlatılıyor..." -ForegroundColor Cyan

# Geçici dosya yolu
$TempDir = $env:TEMP
$ScriptPath = Join-Path $TempDir "WinDeploy.ps1"

# GitHub veya özel sunucudan indir
$GitHubRaw = "https://raw.githubusercontent.com/sylorx/WinDeploy/main/WinDeploy.ps1"
$LocalFallback = "https://windeploy.local/WinDeploy.ps1" # Kendi sunucunuz için

try {
    Write-Host "📥 WinDeploy ana script indiriliyor..." -ForegroundColor Yellow
    
    # GitHub'dan indir (TLS 1.2 zorunlu)
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $GitHubRaw -OutFile $ScriptPath -UseBasicParsing
    
    if (Test-Path $ScriptPath) {
        Write-Host "✓ Script indirildi!" -ForegroundColor Green
        Write-Host "🚀 WinDeploy çalıştırılıyor..." -ForegroundColor Cyan
        
        # Yönetici kontrolü
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        
        if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Host ""
            Write-Host "⚠️  WinDeploy yönetici izniyle çalışıyor..." -ForegroundColor Yellow
            
            # Yönetici izniyle yeniden başlat
            Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" -Verb RunAs
        } else {
            # Zaten yönetici, direkt çalıştır
            & $ScriptPath
        }
    } else {
        throw "Script indirilemedi"
    }
} catch {
    Write-Host "❌ Hata: $_" -ForegroundColor Red
    Write-Host "Lütfen bağlantıyı kontrol edin ve yeniden deneyin." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
}
