# WinDeploy — Windows Uygulama Yöneticisi

## 📁 Proje Yapısı

```
WinDeploy/
│
├── 📄 README.md                      # Ana dokümantasyon
├── 📄 vercel.json                    # Vercel deployment config
│
├── 📂 scripts/                       # PowerShell uygulaması
│   ├── WinDeploy.ps1                # Ana GUI uygulaması
│   └── launcher.ps1                 # Bootstrap/launcher script
│
├── 📂 website/                       # Website kaynak dosyaları
│   ├── index.html                   # Ana sayfa (HTML)
│   └── style.css                    # Stil (CSS)
│
├── 📂 public/                        # Vercel deploy dosyaları (deployment root)
│   ├── index.html                   # Landing page (Vercel root)
│   ├── style.css                    # Landing page stili
│   ├── WinDeploy.ps1                # Deployment için kopyalanmış
│   ├── launcher.ps1                 # Deployment için kopyalanmış
│   └── 📂 website/                  # Website deployment klasörü
│       ├── index.html               # Website (isteğe bağlı)
│       └── style.css                # Website stili (isteğe bağlı)
│
├── 📂 docs/                         # Ek dokümantasyon
├── 📂 examples/                     # Örnek JSON konfigürasyonları
└── 📂 .github/                      # GitHub actions ve konfigürasyonları
```

## 🚀 Hızlı Başlangıç

### Yerel Çalıştırma (Geliştirme)

```powershell
# Admin PowerShell aç, sonra:
cd C:\Users\asus\Documents\WinDeploy\scripts
.\WinDeploy.ps1
```

### Vercel Üzerinden (Üretim)

```powershell
irm "https://windeploy.vercel.app/launcher.ps1" | iex
```

## 📋 Dosya Rolleri

| Dosya | Lokasyon | Rol |
|-------|----------|-----|
| **WinDeploy.ps1** | `scripts/` | PowerShell GUI uygulaması, 50+ uygulama yükleme |
| **launcher.ps1** | `scripts/` | Bootstrap script (yönetici, paket yönetici kurulu mu kontrol) |
| **index.html** | `website/`, `public/` | Landing page + proje bilgisi |
| **style.css** | `website/`, `public/` | Dark tema stili |
| **vercel.json** | Root | Vercel deployment konfigürasyonu |

## 🔧 Geliştirme Akışı

1. **PowerShell dosyalarını düzenle** → `scripts/` klasöründe çalıştır
2. **Website dosyalarını güncelle** → `website/` klasöründe sakla
3. **Test et** → Lokal olarak çalıştır
4. **Commit et** → Git'e push et
5. **Deploy et** → Vercel otomatik olarak `public/` klasöründen deploy eder

## ✨ Özellikler

- ✅ 50+ uygulamadan seçim
- ✅ WinGet + Chocolatey desteği
- ✅ Arka planda sessiz kurulum
- ✅ İçe/dışa aktarma (JSON)
- ✅ Detaylı günlükleme
- ✅ Modern dark tema website

## 📊 Kategoriler

- 🌐 **Tarayıcılar** (Chrome, Firefox, Brave, Edge, Vivaldi, Tor, Chromium)
- 🎵 **Multimedia** (Spotify, VLC, OBS, Audacity, GIMP, HandBrake, foobar2000)
- 💻 **Geliştirme** (VSCode, Git, Python, Node.js, Docker, Postman, JetBrains, Sublime, IntelliJ, Visual Studio)
- 🛠️ **Sistem** (PowerToys, 7-Zip, Notepad++, VirtualBox, Sysinternals, CPU-Z)
- 💬 **İletişim** (Discord, Slack, Zoom, Microsoft Teams)
- 📝 **Office** (LibreOffice, OnlyOffice)
- 🔒 **Güvenlik** (Malwarebytes, Bitwarden, KeePass)
- 🎮 **Oyunlar** (Steam, Epic Games, GOG Galaxy)

## 📖 Kullanım

1. Admin PowerShell açın
2. Komutu çalıştırın (Vercel)
3. GUI açılacak
4. Uygulamaları seçin
5. "İndir ve Yukle" tıklayın
6. Arka planda kurulum yapılır
7. Log dosyasında sonuçları kontrol edin

## 📝 Günlük Dosyası

Lokasyon: `%APPDATA%\WinDeploy\WinDeploy_YYYY-MM-DD.log`

Örnek:
```
[2026-01-25 14:30:00] === WinDeploy v5.5 Basladi ===
[2026-01-25 14:30:00] WinGet tespit edildi
[2026-01-25 14:30:02] Chocolatey tespit edildi
[2026-01-25 14:30:05] GUI Basariyla Olusturuldu
[2026-01-25 14:30:15] === YUKLEME BASLANDI ===
[2026-01-25 14:30:15] Paket Yoneticisi: WinGet
[2026-01-25 14:30:15] Uygulama Sayisi: 3
[2026-01-25 14:30:15] UYGULAMA: Google Chrome | Paket: Google.Chrome
[2026-01-25 14:30:15]   Komut: winget install Google.Chrome -e --silent...
[2026-01-25 14:30:20]   SONUC: BASARILI (ExitCode: 0)
```

## 🔗 Linkler

- **Website**: [windeploy.vercel.app](https://windeploy.vercel.app)
- **GitHub**: [github.com/sylorx/WinDeploy](https://github.com/sylorx/WinDeploy)
- **Launcher**: `irm "https://windeploy.vercel.app/launcher.ps1" | iex`

## 📦 Paket Yöneticileri

### WinGet (Microsoft)
- Modern, hızlı
- Windows 11+ varsayılan, diğer sürümlere yüklenebilir
- Komut: `winget install [PackageId] -e --silent --accept-package-agreements`

### Chocolatey (Topluluk)
- Geniş paket havuzu
- Tüm Windows sürümlerine uyumlu
- Komut: `choco install [PackageName] -y --no-progress`

**Fallback**: WinGet başarısız olursa Chocolatey otomatik olarak denenir.

## 🐛 Sorun Giderme

### Program açılmıyor
- Admin PowerShell kullanıyor musunuz?
- `%APPDATA%\WinDeploy\` klasöründe log dosyasını kontrol edin

### Uygulama yüklenmiyor
- Paket adı doğru mu?
- İnternet bağlantısı var mı?
- WinGet/Chocolatey kurulu mu?
- Log dosyasında hata mesajını kontrol edin

### Kategoriler çalışmıyor
- GUI açıldıktan sonra kategori başlığına tıklayın
- `[-]` = açık, `[+]` = kapalı

## 📜 Lisans

MIT License — Özgürce kullanın, değiştirin, paylaşın.

---

**v5.5** — Düzenli dosya yapısı, güzel website, 50+ uygulama, WinGet+Chocolatey, sessiz kurulum.
