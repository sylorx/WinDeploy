# 🎯 WinDeploy - BAŞLAMA KILAVUZU

> ⚡ **TL;DR:** PowerShell'i açın ve şunu yapın:
> ```powershell
> irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
> ```

---

## 🏁 3 Adımda Başla

### ✓ Adım 1: PowerShell Açın (Yönetici)
- **Windows 10/11:** 
  - `Win + X` tuş kombinasyonunu basın
  - "Windows PowerShell (Yönetici)" seçin
  - "Evet" butonuna tıklayın

### ✓ Adım 2: Tek Komut Çalıştırın

**GitHub'dan (Varsayılan):**
```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

**Kendi Domain'inden (Önerilir - Daha Hızlı):**
```powershell
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com"
irm "https://yourdomain.com/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

### ✓ Adım 3: Menüden Seçim Yapın
```
🚀 WinDeploy - Windows Uygulama Yöneticisi

Ana Menü
1. 📦 Uygulama Yönetimi
2. 🔧 Sistem Kontrol Paneli
3. 📊 Sistem Bilgisi
4. 🛠️  Araçlar
5. ⚙️  Ayarlar
0. ❌ Çıkış
```

---

## 📚 Dokümantasyon Haritası

```
👤 Kullanıcı mısınız?
├─ 🚀 Hızlı Başlangıç → QUICKSTART.md
├─ 📖 Detaylı Rehber → README.md
└─ 🆘 Sorun Giderme → docs/TROUBLESHOOTING.md

👨‍💻 Geliştirici misiniz?
├─ 🛠️  Mimari & Kod → docs/DEVELOPMENT.md
├─ 🔧 Kurulum → INSTALL.md
└─ ⚙️  GitHub Setup → GITHUB_SETUP.md
```

---

## 🎮 Populer Görevler

### 1️⃣ Visual Studio Code Yükle
```
Ana Menü → 1 (Uygulama Yönetimi) → 1 (VS Code)
```

### 2️⃣ Geliştirme Araçlarını Yükle
```
Ana Menü → 1 → G (Tümünü İndir) → Y (Evet)
```

### 3️⃣ Uygulamaları Dışa Aktar
```
Ana Menü → 1 → E (Export)
📁 Dosya kaydedilir: C:\Users\[Kullanıcı]\AppData\Roaming\WinDeploy\apps_export.json
```

### 4️⃣ Sistem Bilgisi Göster
```
Ana Menü → 3 (Sistem Bilgisi)
💾 Disk, RAM, OS bilgisi görüntülenir
```

---

## ⚙️ Kurulum Seçenekleri

### Seçenek 1: Web'den (Tavsiye Edilen)
```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
```
✅ En kolay, Chocolatey/WinGet auto-install

### Seçenek 2: Lokal Dosya
```powershell
# 1. WinDeploy.ps1 dosyasını indirin
# 2. PowerShell'i yönetici olarak açın
# 3. Şunu çalıştırın:
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\path\WinDeploy.ps1"
```

### Seçenek 3: Repository'den
```powershell
# 1. Git clone et
git clone https://github.com/sylorx/WinDeploy.git
cd WinDeploy

# 2. Başlat
powershell -NoProfile -ExecutionPolicy Bypass -File "WinDeploy.ps1"

# Veya lokal test betiğini kullan:
.\run-windeploy.ps1
```

---

## 🆘 Hızlı Sorun Çözümü

| Problem | Çözüm |
|---------|-------|
| "Yönetici izni gerekli" | PowerShell'i sağ tıkla > "Yönetici olarak çalıştır" |
| "ExecutionPolicy" hatası | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Script inmiyor | İnternet bağlantısını kontrol et, `ipconfig` çalıştır |
| Paket yöneticisi yüklenmedi | Yeniden dene, Windows Defender Firewall kontrol et |

**Detaylı çözümler:** [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 📦 Neler Yüklenir?

### Paket Yöneticileri (Otomatik)
- ✅ **Chocolatey** - Windows paket yöneticisi
- ✅ **WinGet** - Microsoft official package manager

### Popüler Uygulamalar
- VS Code, Git, Python, Node.js
- Chrome, Firefox
- 7-Zip, VLC, Discord, Docker
- ...ve 10+ daha

---

## 🌍 Web Sitesi & Sosyal

- 🔗 GitHub: https://github.com/sylorx/WinDeploy
- 📖 Dokümantasyon: Repository içinde
- 🐛 Hata Raporu: GitHub Issues
- 💬 Sorular: GitHub Discussions

---

## 🎓 Daha Fazla Bilgi

### Belgeler
1. **README.md** - Kapsamlı rehber (9 KB)
2. **QUICKSTART.md** - Hızlı başlangıç (4 KB)
3. **INSTALL.md** - Teknik kurulum (4 KB)
4. **PROJECT_SUMMARY.md** - Proje özeti (7.6 KB)
5. **docs/TROUBLESHOOTING.md** - Sorun giderme (geliştirilmiş)
6. **docs/DEVELOPMENT.md** - Geliştirici rehberi (geliştirilmiş)

### Örnek Dosyalar
- `examples/apps_example.json` - 20 popüler uygulama örneği

---

## 💡 İpuçları

✅ **İlk çalıştırmada** paket yöneticileri otomatik kurulur
✅ **Uygulamalar kategoriye göre** organize edilmiştir
✅ **Export/Import** ile uygulamaları kolayca aktarabilirsiniz
✅ **Özel uygulamalar** ekleyebilirsiniz
✅ **Sistem bilgisi** menüsünde tüm detayları görebilirsiniz

---

## 🚀 Sırada Ne Var?

### İmmediyet (Hemen)
- [ ] Script'i çalıştır
- [ ] Menüleri keşfet
- [ ] İlk uygulamaları yükle

### Kısa Vadede
- [ ] İhtiyacın olan uygulamaları ekle
- [ ] Uygulamalar listesini export et
- [ ] Arkadaşlarına öner

### Uzun Vadede
- [ ] Yeni özellik taleplerini ilet
- [ ] Hataları bildir
- [ ] Topluluğa katıl

---

## ✨ Başarılar!

```
╔════════════════════════════════════════════════╗
║  WinDeploy'u kullanmaya başladığınız için     ║
║            teşekkürler! 🎉                   ║
║                                               ║
║   Sorularınız olursa GitHub'da sorum yazın   ║
║   İyi çalışmalar! 🚀                         ║
╚════════════════════════════════════════════════╝
```

---

**Başlamak için:**
```powershell
# GitHub'dan
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1

# VEYA Kendi domain'inizden (Daha Hızlı)
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com"
irm "https://yourdomain.com/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

**Daha fazla bilgi:** [README.md](README.md)

**Sorun mu var?** [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

<div align="center">

Made with ❤️ using PowerShell

[🔝 Başa Dön](#-windeploy---başlama-kilavuzu)

</div>
