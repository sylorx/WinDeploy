#region Başlangıç ve Lisans
<#
.SYNOPSIS
    WinDeploy - Windows Uygulama Yöneticisi
.DESCRIPTION
    Güzel arayüzlü PowerShell uygulaması. Windows uygulamalarını yönetmek, 
    indirmek ve konfigüre etmek için tasarlanmıştır.
.AUTHOR
    WinDeploy Team
.VERSION
    1.0.0
#>

# Yönetici kontrolü
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "⚠️ Bu program yönetici izniyle çalıştırılmalıdır!" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

#endregion

#region Global Değişkenler
$Global:AppData = @{
    Title = "WinDeploy v1.0"
    Color = @{
        Primary = "Cyan"
        Success = "Green"
        Warning = "Yellow"
        Error = "Red"
        Info = "Blue"
    }
    PackageManagers = @{
        Chocolatey = @{
            Installed = $false
            Command = "choco"
            InstallScript = "https://community.chocolatey.org/install.ps1"
        }
        WinGet = @{
            Installed = $false
            Command = "winget"
            AppxName = "Microsoft.DesktopAppInstaller"
        }
    }
    Applications = @()
    ConfigPath = "$env:APPDATA\WinDeploy"
}
#endregion

#region Yardımcı Fonksiyonlar
function Show-Banner {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor $Global:AppData.Color.Primary
    Write-Host "║                                                            ║" -ForegroundColor $Global:AppData.Color.Primary
    Write-Host "║          🚀 WinDeploy - Windows Uygulama Yöneticisi 🚀     ║" -ForegroundColor $Global:AppData.Color.Primary
    Write-Host "║                        Version 1.0                         ║" -ForegroundColor $Global:AppData.Color.Primary
    Write-Host "║                                                            ║" -ForegroundColor $Global:AppData.Color.Primary
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor $Global:AppData.Color.Primary
    Write-Host ""
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-CommandExists {
    param([string]$Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}
#endregion

#region Paket Yöneticisi Fonksiyonları
function Check-PackageManagers {
    Write-ColorOutput "`n📦 Paket Yöneticileri Kontrol Ediliyor..." $Global:AppData.Color.Info
    
    # Chocolatey Kontrolü
    if (Test-CommandExists "choco") {
        $Global:AppData.PackageManagers.Chocolatey.Installed = $true
        Write-ColorOutput "  ✓ Chocolatey Yüklü" $Global:AppData.Color.Success
    } else {
        Write-ColorOutput "  ✗ Chocolatey Yüklü Değil" $Global:AppData.Color.Warning
    }
    
    # WinGet Kontrolü
    if (Test-CommandExists "winget") {
        $Global:AppData.PackageManagers.WinGet.Installed = $true
        Write-ColorOutput "  ✓ WinGet Yüklü" $Global:AppData.Color.Success
    } else {
        Write-ColorOutput "  ✗ WinGet Yüklü Değil" $Global:AppData.Color.Warning
    }
}

function Install-Chocolatey {
    Write-ColorOutput "`n📥 Chocolatey Yükleniyor..." $Global:AppData.Color.Info
    
    try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.ServicePointManager).ServicePointManager = [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (iwr -UseBasicParsing "https://community.chocolatey.org/install.ps1").Content)
        
        Write-ColorOutput "✓ Chocolatey başarıyla yüklendi!" $Global:AppData.Color.Success
        $Global:AppData.PackageManagers.Chocolatey.Installed = $true
        return $true
    } catch {
        Write-ColorOutput "✗ Chocolatey yükleme başarısız: $_" $Global:AppData.Color.Error
        return $false
    }
}

function Install-WinGet {
    Write-ColorOutput "`n📥 WinGet Yükleniyor..." $Global:AppData.Color.Info
    
    try {
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
        Write-ColorOutput "✓ WinGet başarıyla yüklendi!" $Global:AppData.Color.Success
        $Global:AppData.PackageManagers.WinGet.Installed = $true
        return $true
    } catch {
        Write-ColorOutput "✗ WinGet yükleme başarısız: $_" $Global:AppData.Color.Error
        return $false
    }
}

function Ensure-PackageManagers {
    Check-PackageManagers
    
    if (-not $Global:AppData.PackageManagers.Chocolatey.Installed -or -not $Global:AppData.PackageManagers.WinGet.Installed) {
        Write-ColorOutput "`n⚠️ Bazı paket yöneticileri yüklü değil. Yüklemek istiyorsanız devam edin." $Global:AppData.Color.Warning
        $response = Read-Host "Yüklemeyi başlatmak için 'Y' yazın (Y/N)"
        
        if ($response -eq 'Y' -or $response -eq 'y') {
            if (-not $Global:AppData.PackageManagers.Chocolatey.Installed) {
                Install-Chocolatey
            }
            if (-not $Global:AppData.PackageManagers.WinGet.Installed) {
                Install-WinGet
            }
        }
    }
}
#endregion

#region Uygulama Yönetimi
function Initialize-ConfigPath {
    if (-not (Test-Path $Global:AppData.ConfigPath)) {
        New-Item -ItemType Directory -Path $Global:AppData.ConfigPath -Force | Out-Null
        Write-ColorOutput "✓ Konfigürasyon dizini oluşturuldu." $Global:AppData.Color.Success
    }
}

function Load-AppDatabase {
    $dbPath = Join-Path $Global:AppData.ConfigPath "apps.json"
    
    if (Test-Path $dbPath) {
        try {
            $Global:AppData.Applications = Get-Content $dbPath -Raw | ConvertFrom-Json
            Write-ColorOutput "✓ Uygulama veritabanı yüklendi." $Global:AppData.Color.Success
        } catch {
            Write-ColorOutput "✗ Veritabanı yükleme hatası: $_" $Global:AppData.Color.Error
            $Global:AppData.Applications = @()
        }
    } else {
        Initialize-DefaultApps
        Save-AppDatabase
    }
}

function Initialize-DefaultApps {
    $Global:AppData.Applications = @(
        @{
            Id = "vscode"
            Name = "Visual Studio Code"
            Description = "Kod editörü"
            Package = "VisualStudioCode"
            Category = "Geliştirme"
            Manager = "winget"
        },
        @{
            Id = "7zip"
            Name = "7-Zip"
            Description = "Sıkıştırma aracı"
            Package = "7zip"
            Category = "Araçlar"
            Manager = "chocolatey"
        },
        @{
            Id = "git"
            Name = "Git"
            Description = "Versiyon kontrol sistemi"
            Package = "git"
            Category = "Geliştirme"
            Manager = "chocolatey"
        },
        @{
            Id = "python"
            Name = "Python"
            Description = "Python programlama dili"
            Package = "python"
            Category = "Geliştirme"
            Manager = "winget"
        },
        @{
            Id = "nodejs"
            Name = "Node.js"
            Description = "JavaScript runtime"
            Package = "nodejs"
            Category = "Geliştirme"
            Manager = "chocolatey"
        },
        @{
            Id = "googlechrome"
            Name = "Google Chrome"
            Description = "Web tarayıcısı"
            Package = "google-chrome"
            Category = "Tarayıcı"
            Manager = "chocolatey"
        },
        @{
            Id = "firefox"
            Name = "Mozilla Firefox"
            Description = "Web tarayıcısı"
            Package = "firefox"
            Category = "Tarayıcı"
            Manager = "chocolatey"
        },
        @{
            Id = "vlc"
            Name = "VLC Media Player"
            Description = "Multimedya oynatıcısı"
            Package = "vlc"
            Category = "Multimedya"
            Manager = "chocolatey"
        }
    )
}

function Save-AppDatabase {
    $dbPath = Join-Path $Global:AppData.ConfigPath "apps.json"
    $Global:AppData.Applications | ConvertTo-Json | Set-Content $dbPath
    Write-ColorOutput "✓ Veritabanı kaydedildi." $Global:AppData.Color.Success
}

function Show-AppMenu {
    while ($true) {
        Clear-Host
        Show-Banner
        Write-ColorOutput "`n📋 Uygulama Yönetimi Menüsü" $Global:AppData.Color.Primary
        Write-ColorOutput "════════════════════════════════════════════════════════════" $Global:AppData.Color.Primary
        
        # Uygulamaları kategoriye göre göster
        $categories = $Global:AppData.Applications | Select-Object -ExpandProperty Category -Unique
        
        $index = 1
        $appMenuItems = @{}
        
        foreach ($category in $categories) {
            Write-ColorOutput "`n🗂️ $category" $Global:AppData.Color.Info
            foreach ($app in $Global:AppData.Applications | Where-Object { $_.Category -eq $category }) {
                $appMenuItems[$index] = $app
                Write-Host "  $index. $($app.Name) - $($app.Description)"
                $index++
            }
        }
        
        Write-ColorOutput "`n════════════════════════════════════════════════════════════" $Global:AppData.Color.Primary
        Write-Host "  I. İçe Aktarma (Import)"
        Write-Host "  E. Dışa Aktarma (Export)"
        Write-Host "  Y. Yeni Uygulama Ekle"
        Write-Host "  G. Tümünü İndir"
        Write-Host "  M. Ana Menüye Dön"
        
        $choice = Read-Host "`n✓ Seçim yapın"
        
        if ($choice -eq 'M' -or $choice -eq 'm') {
            break
        } elseif ($choice -eq 'I' -or $choice -eq 'i') {
            Import-AppList
        } elseif ($choice -eq 'E' -or $choice -eq 'e') {
            Export-AppList
        } elseif ($choice -eq 'Y' -or $choice -eq 'y') {
            Add-CustomApp
        } elseif ($choice -eq 'G' -or $choice -eq 'g') {
            Install-AllApps
        } elseif ($appMenuItems.ContainsKey([int]$choice)) {
            Install-SingleApp $appMenuItems[[int]$choice]
        } else {
            Write-ColorOutput "✗ Geçersiz seçim!" $Global:AppData.Color.Error
            Start-Sleep -Seconds 2
        }
    }
}

function Install-SingleApp {
    param($app)
    
    Write-ColorOutput "`n📥 '$($app.Name)' yükleniyor..." $Global:AppData.Color.Info
    
    try {
        if ($app.Manager -eq "chocolatey" -and $Global:AppData.PackageManagers.Chocolatey.Installed) {
            choco install $app.Package -y
        } elseif ($app.Manager -eq "winget" -and $Global:AppData.PackageManagers.WinGet.Installed) {
            winget install $app.Package -e -h
        } else {
            Write-ColorOutput "✗ Gerekli paket yöneticisi yüklü değil!" $Global:AppData.Color.Error
        }
        
        Write-ColorOutput "✓ Yükleme tamamlandı!" $Global:AppData.Color.Success
    } catch {
        Write-ColorOutput "✗ Yükleme başarısız: $_" $Global:AppData.Color.Error
    }
    
    Read-Host "`nDevam etmek için Enter tuşuna basın"
}

function Install-AllApps {
    $selectedApps = $Global:AppData.Applications
    $count = $selectedApps.Count
    
    Write-ColorOutput "`n⚠️ $count uygulama yüklenecek. Devam etmek istiyor musunuz?" $Global:AppData.Color.Warning
    $response = Read-Host "Y/N"
    
    if ($response -ne 'Y' -and $response -ne 'y') {
        return
    }
    
    foreach ($app in $selectedApps) {
        Install-SingleApp $app
        Start-Sleep -Seconds 1
    }
}

function Export-AppList {
    $exportPath = Join-Path $Global:AppData.ConfigPath "apps_export.json"
    $Global:AppData.Applications | ConvertTo-Json | Set-Content $exportPath
    Write-ColorOutput "✓ Uygulama listesi dışa aktarıldı: $exportPath" $Global:AppData.Color.Success
    Read-Host "Devam etmek için Enter tuşuna basın"
}

function Import-AppList {
    Write-ColorOutput "`n📂 İçe aktarılacak dosyayı seçin..." $Global:AppData.Color.Info
    $importPath = Read-Host "Dosya yolunu girin"
    
    if (Test-Path $importPath) {
        try {
            $importedApps = Get-Content $importPath -Raw | ConvertFrom-Json
            $Global:AppData.Applications = $importedApps
            Save-AppDatabase
            Write-ColorOutput "✓ Uygulama listesi içe aktarıldı!" $Global:AppData.Color.Success
        } catch {
            Write-ColorOutput "✗ İçe aktarma başarısız: $_" $Global:AppData.Color.Error
        }
    } else {
        Write-ColorOutput "✗ Dosya bulunamadı!" $Global:AppData.Color.Error
    }
    
    Read-Host "Devam etmek için Enter tuşuna basın"
}

function Add-CustomApp {
    Write-ColorOutput "`n➕ Yeni Uygulama Ekle" $Global:AppData.Color.Primary
    
    $name = Read-Host "Uygulama Adı"
    $package = Read-Host "Paket Adı (chocolatey/winget için)"
    $category = Read-Host "Kategori"
    $manager = Read-Host "Paket Yöneticisi (chocolatey/winget)"
    
    $newApp = @{
        Id = ($name -replace ' ', '').ToLower()
        Name = $name
        Description = ""
        Package = $package
        Category = $category
        Manager = $manager
    }
    
    $Global:AppData.Applications += $newApp
    Save-AppDatabase
    
    Write-ColorOutput "✓ Uygulama eklendi!" $Global:AppData.Color.Success
    Read-Host "Devam etmek için Enter tuşuna basın"
}
#endregion

#region Ana Menü
function Show-MainMenu {
    while ($true) {
        Clear-Host
        Show-Banner
        
        Write-ColorOutput "`nAna Menü" $Global:AppData.Color.Primary
        Write-ColorOutput "════════════════════════════════════════════════════════════" $Global:AppData.Color.Primary
        Write-Host ""
        Write-Host "  1. 📦 Uygulama Yönetimi"
        Write-Host "  2. 🔧 Sistem Kontrol Paneli"
        Write-Host "  3. 📊 Sistem Bilgisi"
        Write-Host "  4. 🛠️ Araçlar"
        Write-Host "  5. ⚙️ Ayarlar"
        Write-Host "  0. ❌ Çıkış"
        Write-ColorOutput "════════════════════════════════════════════════════════════" $Global:AppData.Color.Primary
        
        $choice = Read-Host "`n✓ Seçim yapın"
        
        switch ($choice) {
            "1" { Show-AppMenu }
            "2" { Show-SystemPanel }
            "3" { Show-SystemInfo }
            "4" { Show-Tools }
            "5" { Show-Settings }
            "0" {
                Write-ColorOutput "`n👋 WinDeploy kapatılıyor..." $Global:AppData.Color.Info
                exit
            }
            default {
                Write-ColorOutput "✗ Geçersiz seçim!" $Global:AppData.Color.Error
                Start-Sleep -Seconds 1
            }
        }
    }
}

function Show-SystemPanel {
    Write-ColorOutput "`n🔧 Sistem Kontrol Paneli (Bu kısım gelecek versiyonlarda eklenecek)" $Global:AppData.Color.Warning
    Read-Host "Devam etmek için Enter tuşuna basın"
}

function Show-SystemInfo {
    Clear-Host
    Show-Banner
    
    Write-ColorOutput "`n💻 Sistem Bilgisi" $Global:AppData.Color.Primary
    Write-ColorOutput "════════════════════════════════════════════════════════════" $Global:AppData.Color.Primary
    
    $sysInfo = Get-ComputerInfo
    
    Write-Host ""
    Write-Host "  💾 Bilgisayar Adı    : $($sysInfo.CsComputerName)"
    Write-Host "  🖥️  OS              : $($sysInfo.OsName)"
    Write-Host "  📈 OS Versiyonu     : $($sysInfo.OsVersion)"
    Write-Host "  🔹 İşletim Sistemi  : $($sysInfo.OsArchitecture)"
    
    $disk = Get-PSDrive C
    $usedSpace = [math]::Round(($disk.Used / 1GB), 2)
    $freeSpace = [math]::Round(($disk.Free / 1GB), 2)
    $totalSpace = [math]::Round((($disk.Used + $disk.Free) / 1GB), 2)
    
    Write-Host "  💾 Disk Kullanımı   : $usedSpace GB / $totalSpace GB (Boş: $freeSpace GB)"
    
    $ram = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $ramGB = [math]::Round(($ram.Sum / 1GB), 2)
    Write-Host "  🧠 RAM              : $ramGB GB"
    
    Write-Host ""
    Read-Host "Devam etmek için Enter tuşuna basın"
}

function Show-Tools {
    Write-ColorOutput "`n🛠️ Araçlar (Bu kısım gelecek versiyonlarda eklenecek)" $Global:AppData.Color.Warning
    Read-Host "Devam etmek için Enter tuşuna basın"
}

function Show-Settings {
    Write-ColorOutput "`n⚙️ Ayarlar (Bu kısım gelecek versiyonlarda eklenecek)" $Global:AppData.Color.Warning
    Read-Host "Devam etmek için Enter tuşuna basın"
}
#endregion

#region Program Başlangıcı
function Start-WinDeploy {
    if (-not (Test-Administrator)) {
        Write-ColorOutput "❌ Bu program yönetici izniyle çalıştırılmalıdır!" $Global:AppData.Color.Error
        exit
    }
    
    Initialize-ConfigPath
    Load-AppDatabase
    Ensure-PackageManagers
    
    Show-MainMenu
}

# Programı başlat
Start-WinDeploy
#endregion
