# WinDeploy - Sorun Giderme Rehberi

## 🔍 Yaygın Sorunlar ve Çözümleri

---

## 1. ❌ "Yönetici izni gerekli" Hatası

### Semptom
```
⚠️ Bu program yönetici izniyle çalıştırılmalıdır!
```

### Çözüm
**Windows 10/11:**
1. Windows menüsüne tıklayın
2. "PowerShell" yazın
3. "Windows PowerShell" üzerine sağ tıklayın
4. "Yönetici olarak çalıştır" seçin
5. "Evet" butonuna tıklayın

**Alternatif Yöntem:**
```powershell
# Komut satırı başlama görevini oluşturun
schtasks /create /tn WinDeploy /tr "powershell -NoProfile -ExecutionPolicy Bypass -File C:\yol\WinDeploy.ps1" /sc once /st 00:00
schtasks /run /tn WinDeploy
```

---

## 2. ❌ "ExecutionPolicy" Hatası

### Semptom
```
+ CategoryInfo          : SecurityError: (:) [], PSSecurityException
+ FullyQualifiedErrorId : UnauthorizedAccess
```

### Çözüm
**PowerShell'i yönetici olarak açıp şu komutu çalıştırın:**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

**Açıklamalar:**
- `RemoteSigned` - İmzalanmış scriptlere izin verir
- `CurrentUser` - Sadece bu kullanıcı için geçerlidir
- `-Force` - Onay sorunu görmezden gelir

---

## 3. ❌ Script İndirilemiyor

### Semptom
```
Invoke-WebRequest: A connection attempt failed
```

### Çözüm Adımları

#### Adım 1: TLS Sürümünü Kontrol Edin
```powershell
[Net.ServicePointManager]::SecurityProtocol
```

#### Adım 2: TLS 1.2'yi Etkinleştirin
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

#### Adım 3: İnternet Bağlantısını Kontrol Edin
```powershell
Test-NetConnection -ComputerName github.com -Port 443
```

#### Adım 4: Proxy Kontrol Edin
Eğer kurumsal ağdaysanız:
```powershell
# Proxy ayarını kontrol et
$proxy = [System.Net.WebRequest]::DefaultWebProxy
$proxy.GetProxy([System.Uri]"https://github.com")
```

#### Adım 5: DNS Kontrol Edin
```powershell
nslookup github.com
```

### Alternatif: Lokal Dosya Yöntemi
1. WinDeploy.ps1 dosyasını indirin
2. PowerShell'i açın
3. Şu komutu çalıştırın:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\yolu\belirtin\WinDeploy.ps1"
```

---

## 4. ❌ Chocolatey Kurulumunda Hata

### Semptom
```
Error downloading content from https://...
```

### Çözüm

#### Yöntem 1: Manuel Kurulum
```powershell
# PowerShell'i yönetici olarak açıp:
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

$ProgressPreference = 'SilentlyContinue'
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Doğrulama
choco --version
```

#### Yöntem 2: Proxy Ayarı
```powershell
# Eğer kurumsal ağdaysanız
choco config set proxy https://[proxy-sunucusu]:[port]
```

---

## 5. ❌ WinGet Kurulumunda Hata

### Semptom
```
The AppX file path is invalid...
```

### Çözüm

#### Yöntem 1: Microsoft Store'dan Kur
1. Windows 11'de App Installer önceden yüklüdür
2. Eğer yüklü değilse: Microsoft Store > "App Installer" ara > Yükle

#### Yöntem 2: WinGet CLI'dan Kur
```powershell
# Yönetici PowerShell:
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
```

#### Yöntem 3: GitHub'dan İndir
```powershell
# En son sürümü GitHub'dan indirin
# https://github.com/microsoft/winget-cli/releases
# .msixbundle dosyasını yükleyin
```

---

## 6. ❌ Uygulama Kurulumunda Hata

### Semptom
```
Package not found
```

### Çözüm

#### Paket Adını Kontrol Edin
```powershell
# Chocolatey paketi ara
choco search [uygulama-adı]

# WinGet paketi ara
winget search [uygulama-adı]
```

#### Doğru Paket Adını Bulun
- **Chocolatey:** https://community.chocolatey.org/packages
- **WinGet:** https://github.com/microsoft/winget-pkgs

#### Paketi Manuel Yükle
```powershell
# Chocolatey ile
choco install [doğru-paket-adı] -y

# WinGet ile
winget install [doğru-paket-adı] -e -h
```

---

## 7. ❌ Import/Export Dosyası Açılamıyor

### Semptom
```
Cannot convert the JSON object to type System.Object[]
```

### Çözüm

#### JSON Dosyasını Kontrol Edin
```powershell
# Dosyayı düz metinle açın
notepad "C:\Users\[Kullanıcı]\AppData\Roaming\WinDeploy\apps_export.json"
```

#### Geçerliliği Kontrol Edin
```powershell
$json = Get-Content "apps_export.json" -Raw | ConvertFrom-Json
$json | Format-List
```

#### Dosyayı Düzeltme
- Çift tırnak (`"`) işaretini kontrol edin
- Virgülleri kontrol edin
- Geçersiz karakterleri kaldırın

---

## 8. ⚠️ Yavaş Kurulum

### Semptom
Uygulama kurulumu çok uzun sürüyor

### Çözüm

#### Ağ Bağlantısını Kontrol Edin
```powershell
# İnternet hızını test et
Test-NetConnection -ComputerName google.com -CommonTCPPort HTTPS
```

#### Disk Alanını Kontrol Edin
```powershell
# C sürücüsünün durumunu kontrol et
Get-PSDrive C
```

#### Antivirus'u Kontrol Edin
- Kurumsal antivirus engelleme yapıyor olabilir
- BT departmanına başvurun

---

## 9. ❌ Config Klasörü Oluştulamıyor

### Semptom
```
Access to the path is denied
```

### Çözüm
```powershell
# AppData klasörünün izinlerini kontrol et
$path = "$env:APPDATA\WinDeploy"
icacls $path

# Gerekirse manual oluştur
New-Item -ItemType Directory -Path $path -Force
```

---

## 10. 🔄 Tam Kaldırma

Eğer tamamen yeniden başlamak istiyorsanız:

```powershell
# 1. WinDeploy klasörünü sil
Remove-Item "$env:APPDATA\WinDeploy" -Recurse -Force

# 2. Chocolatey'i kaldır (opsiyonel)
choco uninstall chocolatey -y

# 3. WinGet'i kaldır (opsiyonel - Windows 11 için)
Get-AppxPackage *Microsoft.DesktopAppInstaller* | Remove-AppxPackage

# 4. PowerShell Execution Policy'i sıfırla
Set-ExecutionPolicy -ExecutionPolicy Default -Scope CurrentUser -Force
```

---

## 🛠️ Gelişmiş Hata Ayıklama

### PowerShell Debug Modu
```powershell
# Debug modu etkinleştir
Set-PSDebug -Trace 1

# WinDeploy'u çalıştır
.\WinDeploy.ps1

# Debug modunu kapat
Set-PSDebug -Trace 0
```

### Detaylı Log Tutma
```powershell
# Tüm çıktıyı dosyaya kaydet
.\WinDeploy.ps1 | Tee-Object -FilePath "C:\windeploy-debug.log"
```

### İşlem Yöneticisinde Takip
```powershell
# PowerShell işlemini izle
Get-Process powershell | Format-List

# Bellek kullanımı
Get-Process powershell | Select-Object Name, WorkingSet, Handles
```

---

## 📞 Daha Fazla Yardım

- **GitHub Issues:** https://github.com/sylorx/WinDeploy/issues
- **PowerShell Docs:** https://learn.microsoft.com/powershell
- **Chocolatey Docs:** https://docs.chocolatey.org
- **WinGet Docs:** https://github.com/microsoft/winget-cli/blob/master/doc/index.md

---

**Sorununuzu çözemediyseniz, lütfen GitHub'da bir issue açın!** 🆘
