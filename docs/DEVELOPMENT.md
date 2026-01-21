# WinDeploy - Geliştirici Rehberi

## 🛠️ Geliştirme Ortamını Kurun

### Gereksinimler
- PowerShell 5.1 veya 7+
- Git
- VS Code (Tavsiye Edilen)

### VS Code Uzantıları (Tavsiye Edilen)
```
- PowerShell (ms-vscode.powershell)
- JSON (redhat.vscode-yaml)
- Markdown All in One (yzhang.markdown-all-in-one)
```

---

## 📁 Proje Yapısı

```
WinDeploy/
│
├── WinDeploy.ps1              # Ana program
├── launcher.ps1                # Web installer script
├── README.md                   # Kullanıcı belgesi
├── QUICKSTART.md               # Hızlı başlangıç
├── INSTALL.md                  # Kurulum talimatları
├── LICENSE                     # MIT Lisansı
├── .gitignore                  # Git ayarları
│
└── docs/
    ├── TROUBLESHOOTING.md      # Sorun giderme
    ├── DEVELOPMENT.md          # Bu dosya
    ├── ARCHITECTURE.md         # Mimari (gelecek)
    └── API.md                  # API Referans (gelecek)
```

---

## 🏗️ Program Mimarisi

### Ana Bileşenler

```
┌─────────────────────────────────────┐
│         WinDeploy Ana Program       │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────────────────────┐   │
│  │    Main Menu (Show-MainMenu) │   │
│  └──────────────────────────────┘   │
│           ↓   ↓   ↓   ↓   ↓         │
│  ┌────┴───┴───┴───┴───┴─────────┐  │
│  │ App Mgmt │ System │ Tools │... │  │
│  └────┬─────────────────────────┘  │
│       │                             │
│  ┌────┴──────────────────────────┐  │
│  │  Package Manager Mgmt         │  │
│  │  • Chocolatey                 │  │
│  │  • WinGet                     │  │
│  └────────────────────────────────┘  │
│                                     │
│  ┌────────────────────────────────┐  │
│  │  Data Management              │  │
│  │  • JSON Veritabanı            │  │
│  │  • Import/Export              │  │
│  └────────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### Fonksiyon Grupları

1. **Başlangıç & Setup**
   - `Show-Banner` - Banner göster
   - `Test-Administrator` - Yönetici kontrolü
   - `Initialize-ConfigPath` - Config klasörü oluştur

2. **Paket Yönetimi**
   - `Check-PackageManagers` - PM durumu kontrol et
   - `Install-Chocolatey` - Chocolatey yükle
   - `Install-WinGet` - WinGet yükle
   - `Ensure-PackageManagers` - PM'ları sağla

3. **Uygulama Yönetimi**
   - `Load-AppDatabase` - Veritabanını yükle
   - `Initialize-DefaultApps` - Varsayılan uygulamaları yükle
   - `Save-AppDatabase` - Veritabanını kaydet
   - `Show-AppMenu` - Uygulama menüsünü göster

4. **Installation**
   - `Install-SingleApp` - Tek uygulama yükle
   - `Install-AllApps` - Tümünü yükle

5. **Data Operations**
   - `Export-AppList` - Dışa aktar
   - `Import-AppList` - İçe aktar
   - `Add-CustomApp` - Özel uygulama ekle

6. **UI/Display**
   - `Show-MainMenu` - Ana menü
   - `Write-ColorOutput` - Renkli çıktı
   - `Show-SystemInfo` - Sistem bilgisi

---

## 📝 Kod Standardları

### Naming Convention
```powershell
# Fonksiyonlar - PascalCase
function Initialize-ConfigPath { }
function Test-Administrator { }

# Değişkenler - camelCase veya CONSTANT_CASE
$configPath = "..."
$Global:AppData = @{ }

# Parametreler - PascalCase
param(
    [string]$Message,
    [bool]$Force = $false
)
```

### Bölüm Organizasyonu
```powershell
#region Kısa Açıklama
# Fonksiyonlar ve değişkenler

#endregion
```

### Yorum Stili
```powershell
# Tek satır yorum

<#
.SYNOPSIS
    Kısa açıklama

.DESCRIPTION
    Detaylı açıklama

.PARAMETER ParamName
    Parametre açıklaması

.EXAMPLE
    PS> Örnek Kullanım
#>
```

---

## 🔀 Git İş Akışı

### Feature Branch Oluşturma
```powershell
git checkout -b feature/yeni-ozellik
```

### Commit Mesajları
```
[TYPE] Kısa açıklama (maksimum 50 karakter)

Daha detaylı açıklama (isteğe bağlı)
```

**TYPE'lar:**
- `feat:` Yeni özellik
- `fix:` Hata düzeltmesi
- `docs:` Belge güncelleme
- `refactor:` Kod yeniden yapılandırması
- `test:` Test ekleme/değiştirme
- `chore:` Diğer değişiklikler

### Örnek Commit
```
feat: Yeni sistem optimizasyon menüsü ekle

- Windows başlangıcı hızlandırma
- Disk temizleme
- RAM optimizasyonu
- Firewall konfigürasyonu

Closes #12
```

---

## 🧪 Test Etme

### Manuel Test Checklist

#### Başlangıç
- [ ] Yönetici olmayan kullanıcı ile test et
- [ ] Yönetici olarak çalıştır
- [ ] PowerShell 5.1'de test et
- [ ] PowerShell 7+ da test et

#### Menü Navigasyonu
- [ ] Tüm menü seçeneklerini test et
- [ ] Geçersiz girişleri test et
- [ ] ESC/Q ile çıkma test et

#### Paket Yönetimi
- [ ] Chocolatey yükleme test et
- [ ] WinGet yükleme test et
- [ ] Paket kurulumu test et

#### Data Operations
- [ ] Export/Import test et
- [ ] JSON geçerliliğini kontrol et
- [ ] Özel uygulama ekleme test et

### Test Script'i Oluşturma
```powershell
# test.ps1
param(
    [string]$TestSuite = "all"
)

$tests = @{
    Admin = { Test-Administrator }
    Menu = { Show-MainMenu }
    PackageManager = { Check-PackageManagers }
}

foreach ($test in $tests.Keys) {
    Write-Host "Test: $test" -ForegroundColor Yellow
    & $tests[$test]
}
```

---

## 📚 Yeni Özellik Ekleme

### Örnek: Yeni Menü Seçeneği Ekleme

1. **Fonksiyon Oluştur**
```powershell
function Show-NewFeature {
    Write-ColorOutput "`n🆕 Yeni Özellik" $Global:AppData.Color.Primary
    # Kod buraya gelecek
}
```

2. **Ana Menüye Ekle**
```powershell
function Show-MainMenu {
    # ... mevcut kod ...
    Write-Host "  6. 🆕 Yeni Özellik"
    # ... seçim kodu ...
    "6" { Show-NewFeature }
}
```

3. **Test Et**
```powershell
Show-NewFeature
```

4. **Dokümantasyon Güncelle**
- README.md
- QUICKSTART.md

---

## 🚀 Deploy Etme

### GitHub'a Push Etme
```powershell
git add .
git commit -m "Yeni özellik: xyz"
git push origin feature/xyz
```

### Pull Request Oluşturma
1. GitHub'da "New Pull Request" tıkla
2. Base: `main`, Compare: `feature/xyz`
3. Başlık ve açıklama doldur
4. Ekibin onayını bekle

### Release Oluşturma
```powershell
git tag -a v1.0.0 -m "Version 1.0.0"
git push origin v1.0.0
```

---

## 🔍 Debugging İpuçları

### PowerShell ISE Kullanma
```powershell
# VS Code'da test et
code .\WinDeploy.ps1

# F5 ile başlat
# Breakpoint ayarla (tıkla)
# Adım adım ilerle (F10)
```

### Debug Modu
```powershell
$DebugPreference = "Continue"
.\WinDeploy.ps1 -Debug
```

### Verbose Modu
```powershell
.\WinDeploy.ps1 -Verbose
```

---

## 📊 Performans Optimizasyonu

### Profil Oluşturma
```powershell
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# Test edilecek kod

$sw.Stop()
Write-Host "Süre: $($sw.ElapsedMilliseconds)ms"
```

### Yaygın Sorunlar
- Döngülerde `Write-Host` kullanmak yavaştır
- Çok fazla API çağrısı
- Büyük JSON dosyaları

---

## 📚 Kaynaklar

### PowerShell Dokumanları
- https://learn.microsoft.com/powershell/
- https://docs.microsoft.com/powershell/module/microsoft.powershell.core/

### Best Practices
- https://github.com/PoshCode/PowerShellPracticeAndStyle
- https://www.powershellgallery.com/

### Paket Yöneticileri
- https://chocolatey.org/docs
- https://github.com/microsoft/winget-cli/tree/master/doc

---

## ✅ Pre-Release Checklist

- [ ] Tüm fonksiyonlar test edildi
- [ ] Kodu review et
- [ ] Belgeleri güncelle
- [ ] Version numarasını güncelle
- [ ] CHANGELOG oluştur
- [ ] Release notes yaz
- [ ] Tag oluştur ve push et

---

**Kontribüsyon için teşekkürler! 🙏**
