# WinDeploy - GitHub Yayın Ayarları

## 🚀 GitHub'a Yüklemeden Önce

### 1. Repository'i Oluştur
- GitHub'da yeni bir public repository oluştur
- Adı: `WinDeploy`
- Açıklama: "PowerShell ile yazılmış, Chris Titus'u gibi güzel arayüzlü Windows uygulama yöneticisi"
- Public: ✓
- Initialize with README: ✗ (zaten var)

### 2. Local Setup
```bash
git config --global user.name "Adınız"
git config --global user.email "email@example.com"

cd "c:\Users\asus\Documents\WinDeploy"
git init
git add .
git commit -m "Initial commit: WinDeploy v1.0"
```

### 3. GitHub'a Bağla
```bash
git remote add origin https://github.com/sylorx/WinDeploy.git
git branch -M main
git push -u origin main
```

### 4. GitHub Ayarları
- ✅ Settings > General > Public olarak ayarla
- ✅ Settings > Code and automation > Pages > Disable (opsiyonel)
- ✅ Settings > Security > Require status checks before merging (recommended)

---

## 📝 README.md GitHub Versiyonu

GitHub'daki README.md otomatik olarak projenin ana sayfasında görüntülenecektir.

### Badge'ler Eklemek (Opsiyonel)
```markdown
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-7.0+-blue.svg)](https://github.com/PowerShell/PowerShell)
```

---

## 🌐 Web'den Erişim

Kullanıcılar şu komutla WinDeploy'u çalıştırabilecekler:

```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
```

### Kısa Link (Opsiyonel)
Eğer kısa link istersen:
- https://christitus.com/ benzeri bir service kullan (bit.ly, short.link, vb.)
- Örnek: https://bit.ly/windeploy

---

## 📦 Release Oluşturma

### v1.0.0 Release Notları
```
# WinDeploy v1.0.0 - İlk Sürüm

## ✨ Yeni Özellikler
- Güzel arayüzlü PowerShell GUI
- Chocolatey & WinGet otomatik kurulumu
- Import/Export uygulama listesi
- 20+ önceden yapılandırılmış uygulama
- Sistem bilgisi paneli
- One-liner kurulum desteği

## 📋 Desteklenen Uygulamalar
- Geliştirme: VS Code, Git, Python, Node.js, Docker, .NET, Visual Studio
- Tarayıcılar: Chrome, Firefox
- Araçlar: 7-Zip, WinSCP, Notepad++, vb.
- Multimedya: VLC, HandBrake

## 📚 Belgeler
- README.md - Kapsamlı rehber
- QUICKSTART.md - Hızlı başlangıç
- docs/TROUBLESHOOTING.md - Sorun giderme
- docs/DEVELOPMENT.md - Geliştirici rehberi

## 🔗 Linkler
- One-liner: `irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex`
- GitHub: https://github.com/sylorx/WinDeploy

## 📝 Lisans
MIT Lisansı altında yayınlanmıştır.
```

---

## 🔄 Gelecek Sürümler (v1.1, v2.0, vb.)

### v1.1 (Gelecek)
- Sistem optimizasyon menüsü
- Daha fazla uygulama
- Bug fixes

### v2.0 (Planlanıyor)
- Grafik arayüz (WinForms)
- Plugin sistemi
- Web dashboard

---

## 💻 CI/CD Pipeline

GitHub Actions otomatik olarak:
1. ✅ PowerShell syntax kontrol
2. ✅ PSScriptAnalyzer analizi
3. ✅ Güvenlik kontrolü

---

## 🎯 Sosyal Medya & Promosyon

### Yazılı İçerik
```
🚀 WinDeploy kullanıma açıldı!

Güzel arayüzlü PowerShell uygulaması - Chris Titus'u gibi 👌

✨ Özellikler:
- One-liner kurulum
- Chocolatey & WinGet otomasyonu
- Import/Export desteği
- 20+ uygulama kütüphanesi

💻 Başlamak:
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex

📖 Belgeleri oku: https://github.com/sylorx/WinDeploy

#PowerShell #Windows #OpenSource #Automation
```

---

## 🔗 Faydalı Kaynaklar

- GitHub Markdown: https://guides.github.com/features/mastering-markdown/
- GitHub Actions: https://docs.github.com/en/actions
- Semantic Versioning: https://semver.org/
- Keep a Changelog: https://keepachangelog.com/

---

## ✅ Kontrol Listesi

- [ ] GitHub repository oluştur
- [ ] Tüm dosyaları git'e ekle
- [ ] İlk commit yap
- [ ] GitHub'a push et
- [ ] README doğru gösteriliyor mu kontrol et
- [ ] launcher.ps1 raw URL'den erişilebilir mi kontrol et
- [ ] v1.0.0 release oluştur
- [ ] Release notlarını yaz
- [ ] Sosyal medyada duyur

---

**Tüm hazırlıklar tamamlandı! GitHub'a yüklemek için hazır! 🎉**
