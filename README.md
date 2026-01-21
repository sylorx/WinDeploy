# 🚀 WinDeploy - Windows Uygulama Yöneticisi

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-7.0+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Platform-Windows%2010%2B-lightgrey.svg)](https://www.microsoft.com/windows)

**Chris Titus'un WinUtil'i gibi güzel arayüzlü, PowerShell ile yazılmış Windows uygulama yöneticisi**

[Özellikler](#özellikler) • [Hızlı Başlangıç](#hızlı-başlangıç) • [Kurulum](#kurulum) • [Kullanım](#kullanım)

</div>

---

## 📋 Hakkında

WinDeploy, modern Windows bilgisayarlarında uygulamaları kolay bir şekilde yönetmek, indirmek ve konfigüre etmek için tasarlanmış, güzel arayüzlü bir PowerShell uygulamasıdır.

### Neden WinDeploy?
- ✅ **Tek komutla kurulum** - Basit bir PowerShell one-liner
- ✅ **Otomatik paket yöneticisi kurulumu** - Chocolatey ve WinGet otomatik yükleme
- ✅ **Import/Export desteği** - Uygulama listelerinizi dosyaya aktarıp yeniden kullanın
- ✅ **Güzel kullanıcı arayüzü** - Renkli, kolay kullanılır terminal arayüzü
- ✅ **Geniş uygulama kataloğu** - Önceden yapılandırılmış popüler uygulamalar
- ✅ **Özel uygulama desteği** - Kendi uygulamalarınızı ekleyin
- ✅ **Sistem bilgisi** - Bilgisayarınızın detaylı sistem bilgilerini görüntüleyin

---

## ⚡ Hızlı Başlangıç

### Yöntem 1: Tek Komutla (Tavsiye Edilen - Düzeltilmiş)

PowerShell'i **Yönetici olarak** açıp bu komutu çalıştırın:

```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

#### 🌐 Kendi Domain'inden İndirme (Önerilir)

Eğer kendi domain'iniz varsa (daha hızlı ve güvenilir):

```powershell
# Environment variable ile domain belirtme
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com"
irm "https://yourdomain.com/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

Veya inline:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "$env:WINDEPLOY_DOMAIN='https://yourdomain.com'; irm 'https://yourdomain.com/launcher.ps1' -OutFile $env:TEMP\launcher.ps1; & $env:TEMP\launcher.ps1"
```

> **Not:** GitHub'dan indirmek istiyorsanız repository'yi fork edebilir, kendi sunucunuzda barındırabilirsiniz, veya domain'iniz varsa oraya upload edebilirsiniz. Launcher otomatik olarak domain başarısız olursa GitHub'a fallback yapar.

### Yöntem 2: Lokal Dosya

1. [WinDeploy.ps1](./WinDeploy.ps1) dosyasını indirin
2. PowerShell'i **Yönetici olarak** açın
3. Şu komutu çalıştırın:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\yolu\belirtin\WinDeploy.ps1"
```

---

## 🎯 Özellikler

### 📦 Paket Yöneticileri
- **Chocolatey** - Windows paket yöneticisi
- **WinGet** - Microsoft'un resmi paket yöneticisi
- Otomatik yükleme ve konfigürasyon

### 💾 Uygulama Yönetimi
Yerleşik popüler uygulamalar:
- **Geliştirme:** Visual Studio Code, Git, Python, Node.js
- **Araçlar:** 7-Zip, WinRAR
- **Tarayıcılar:** Google Chrome, Mozilla Firefox
- **Multimedya:** VLC Media Player
- ... ve daha fazlası

### 📁 Import/Export
Uygulama listelerinizi:
- 📤 Dışa aktarın (Export) - JSON formatında
- 📥 İçe aktarın (Import) - Kaydedilmiş listeleri yükleyin
- 🔄 Paylaşın - Arkadaşlarınızla konfigürasyonlarınızı paylaşın

### 🛠️ Sistem Araçları
- 💻 Sistem bilgisi görüntüleme
- 📊 Disk ve RAM kullanımı
- 🔧 Sistem kontrol paneli (gelecek versiyonlar)

---

## 📦 Kurulum

### Gereksinimler
- Windows 10 veya daha yenisi
- PowerShell 5.1 (veya PowerShell 7+)
- **Yönetici izni** (Gerekli!)
- İnternet bağlantısı

### Adım Adım Kurulum

1. **PowerShell'i Yönetici olarak açın**
   - Windows menüsünde "PowerShell" yazın
   - "Windows PowerShell" üzerine sağ tıklayın
   - "Yönetici olarak çalıştır" seçeneğini tıklayın

2. **WinDeploy'u çalıştırın**
   ```powershell
   irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
   ```

3. **İlk çalıştırmada paket yöneticilerini kurun**
   - Chromoliy ve WinGet otomatik olarak kurulacaktır
   - Kurulum tamamlandıktan sonra menüye döneceksiniz

---

## 📖 Kullanım Rehberi

### Ana Menü
```
╔════════════════════════════════════════════════════════════╗
║          🚀 WinDeploy - Windows Uygulama Yöneticisi 🚀     ║
║                        Version 1.0                         ║
╚════════════════════════════════════════════════════════════╝

Ana Menü
════════════════════════════════════════════════════════════
  1. 📦 Uygulama Yönetimi
  2. 🔧 Sistem Kontrol Paneli
  3. 📊 Sistem Bilgisi
  4. 🛠️ Araçlar
  5. ⚙️ Ayarlar
  0. ❌ Çıkış
```

### Uygulama Yönetimi

1. Ana menüden **1** seçin
2. Uygulamaları kategoriye göre görüntüleyin
3. Seçenekler:
   - **Numara girin** - Tek uygulama yükle
   - **I** - Uygulama listesi içe aktarın
   - **E** - Uygulama listesi dışa aktarın
   - **Y** - Yeni uygulama ekleyin
   - **G** - Tümünü yükleyin
   - **M** - Ana menüye dönün

### Import/Export Örneği

#### Dışa Aktarma (Export)
```powershell
# Tüm uygulamalarınızı kaydedin
1 → E → Dosya oluşturulacak: C:\Users\[Kullanıcı]\AppData\Roaming\WinDeploy\apps_export.json
```

#### İçe Aktarma (Import)
```powershell
# Farklı bir bilgisayarda veya yeni kurulumdan sonra
1 → I → Dosya yolunu girin: C:\Users\[Kullanıcı]\AppData\Roaming\WinDeploy\apps_export.json
# Uygulamalar yüklenecektir!
```

### Özel Uygulama Ekleme

1. Uygulama menüsünde **Y** seçin
2. Sorulara cevap verin:
   - **Uygulama Adı:** Visual Studio
   - **Paket Adı:** VisualStudio (WinGet/Chocolatey paket adı)
   - **Kategori:** Geliştirme
   - **Paket Yöneticisi:** winget

---

## 🛠️ İleri Kullanım

### Konfigürasyon Dosyaları

WinDeploy ayarları şurada saklanır:
```
C:\Users\[Kullanıcı]\AppData\Roaming\WinDeploy\
├── apps.json              # Uygulama veritabanı
└── apps_export.json       # Dışa aktarılmış listeler
```

### Paket Yöneticileri

**Chocolatey:** https://chocolatey.org/
```powershell
# Manual yükleme
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**WinGet:** https://github.com/microsoft/winget-cli
```powershell
# Windows 11'de önceden yüklü gelir
winget --version
```

### Script'i Kustomize Etme

1. [WinDeploy.ps1](./WinDeploy.ps1) dosyasını indirin ve düzenleyin
2. `Initialize-DefaultApps` fonksiyonunda uygulamaları ekleyin/kaldırın
3. Renkları veya menü seçeneklerini değiştirin
4. Lokal olarak çalıştırın

---

## 🐛 Sorun Giderme

### Problem: "Yönetici izni gerekli" hatası
**Çözüm:** PowerShell'i yönetici olarak açın
- Windows menüsünde "PowerShell" yazın
- Sağ tıklayın ve "Yönetici olarak çalıştır" seçin

### Problem: "Execution Policy" hatası
**Çözüm:** İlk çalışmada bunu çalıştırın
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Problem: Script inmiyor
**Çözüm:** Bağlantıyı kontrol edin
```powershell
# TLS 1.2 zorunlu
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

### Problem: Paket yöneticileri yüklenmiyor
**Çözüm:** İnternet bağlantınızı kontrol edin ve yeniden deneyin
```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
```

---

## 📊 Sistem Bilgisi

WinDeploy aşağıdaki bilgileri gösterir:
- 💻 Bilgisayar adı
- 🖥️ İşletim sistemi
- 📊 OS versiyonu ve mimarisi
- 💾 Disk kullanımı (Kullanılan / Toplam / Boş)
- 🧠 RAM miktarı

---

## 🔄 Gelecek Özellikler (Roadmap)

- [ ] Grafik arayüz (GUI)
- [ ] Sistem optimizasyon araçları
- [ ] Windows Update yönetimi
- [ ] Sürücü yönetimi
- [ ] Sistem temizleme
- [ ] Başlangıç programları yönetimi
- [ ] Network ayarları
- [ ] Firewall yönetimi

---

## 📝 Lisans

Bu proje MIT Lisansı altında yayınlanmıştır. Detaylar için [LICENSE](./LICENSE) dosyasına bakın.

---

## 🤝 Katkıda Bulunun

WinDeploy'u geliştirmemize yardımcı olun!

1. Repository'yi fork edin
2. Feature branch'i oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişiklikleri commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'e push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

---

## 🙏 İlham Kaynakları

- [Chris Titus WinUtil](https://github.com/ChrisTitusTech/winutil) - Tasarım ve konsept ilhamı
- [Chocolatey](https://chocolatey.org/) - Paket yönetimi
- [WinGet](https://github.com/microsoft/winget-cli) - Windows paket yöneticisi

---

## 📞 İletişim & Destek

- 🐛 Hata raporu için: [Issues](../../issues)
- 💡 Öneriler için: [Discussions](../../discussions)
- 📧 Email: support@windeploy.local

---

## ⭐ Beğendiyseniz

WinDeploy'u faydalı buldum? Bir ⭐ koyarak destek olabilirsiniz!

---

<div align="center">

**Made with ❤️ using PowerShell**

[Başa Dön](#-windeploy---windows-uygulama-yöneticisi)

</div>