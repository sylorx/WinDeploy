# 🎉 WinDeploy v6.0 Release Notes

## Yeni Sistem Sekmesi ile Tanışın! 🖥️

WinDeploy v6.0 sürümüne hoş geldiniz! Bu sürümde, uygulamalar yönetiminin yanında **sistem yönetimi ve bilgisi** için tamamen yeni bir sekme ekledik.

---

## 📊 Neler Yeni?

### Sistem Bilgisi Sekmesi

Yeni **"Sistem"** sekmesine tıklayıp şunları yapabilirsiniz:

#### 💻 Sistem Bilgilerinizi Görmek
```
Bilgisayar Adı:        DESKTOP-ABC123
İşletim Sistemi:       Windows 11 Pro
OS Versiyonu:          22631.5863 (64-bit)
RAM Miktarı:           32.00 GB
Disk - Toplam:         238.47 GB
Disk - Kullanılan:     120.82 GB
Disk - Boş:            117.65 GB
```

#### 🛠️ 8 Sistem Yönetim Aracına Tek Tuşla Erişim

| Araç | Açıklama | Kullanım |
|------|----------|---------|
| 🚀 Sistem Optimizasyonu | Disk temizleme ayarları | Depolama sensörü, eski dosya temizliği |
| 📥 Windows Güncellemesi | Update ayarları | Güncellemeleri zamanla, otomatik ayarları değiştir |
| ⚡ Tek Tuşla Güncelleme | İçeri güncelleme başlat | Hemen güncelleme yapması gereken durumlarda |
| 🖥️ Sürücü Yönetimi | Cihaz Yöneticisi | Donanım sürücüleri, güncelleme, sorun çözme |
| 🧹 Sistem Temizleme | Disk Temizleme | Geçici dosyalar, çöp, indirilmiş dosyalar |
| ⚙️ Başlangıç Programları | Görev Yöneticisi | Başlangıç hızını artır, gereksiz programları kapat |
| 🌐 Network Ayarları | Ağ Bağlantıları | WiFi, Ethernet, IP, DNS ayarları |
| 🔥 Firewall Yönetimi | Defender Firewall | Güvenlik kuralları, program izinleri |

---

## 🎯 Sistem Sekmesi Özel Özellikleri

### ✅ Otomatik Sistem Bilgisi Alma
- Bilgisayar adı, Windows sürümü, mimarisi otomatik olarak algılanır
- RAM ve disk bilgileri gerçek zamanlı olarak güncellenir
- Sekmeden çıkıp yeniden girdiğinde veriler yenilenir

### ✅ Renkli ve Kolay Kullanılır Arayüz
- Her araç için farklı renkler (yeşil, mavi, mor, turuncu, vs.)
- 2 sütun halinde düzenlenmiş düğmeler
- Başparmakla tıklamak kolay (mobil dostu tasarım)

### ✅ Doğrudan Windows Araçlarına Bağlantı
- Tüm araçlar Windows'un yerel yönetim uygulamalarıdır
- Üçüncü taraf yazılım yüklemeye gerek yoktur
- Güvenli ve resmi kaynaklardan açılır

---

## 🚀 Hızlı Başlangıç

### WinDeploy'u Açın ve...

**1. Sistem Sekmesine Gitmeyin**
```
WinDeploy penceresinde üst kısımda iki sekme görürsünüz:
[Uygulamalar] [Sistem] ← Buraya tıklayın
```

**2. Sistem Bilgilerinizi Görün**
```
Ekranın üst kısmında:
- PC adınız
- Windows sürümü
- RAM ve disk bilgileri
```

**3. Sistem Aracını Açın**
```
İhtiyacınız olan aracın düğmesine tıklayın.
Windows yönetim paneli doğrudan açılacaktır.
Örnek: "Başlangıç Programları" → Görev Yöneticisi açılır
```

---

## 📁 Dosya Yapısı (Yeni)

```
WinDeploy/
├── scripts/
│   ├── WinDeploy.ps1          ← v6.0 (823 satır)
│   │   ├── Tab 1: Uygulamalar (120+ app)
│   │   └── Tab 2: Sistem (System Info & Tools)
│   ├── launcher.ps1
│   └── deploy.ps1
│
├── docs/
│   ├── SYSTEM_TAB_GUIDE.md    ← YENİ! Detaylı rehber
│   ├── CHANGELOG.md           ← YENİ! Sürüm geçmişi
│   ├── README.md              ← Güncellendi
│   ├── STRUCTURE.md           ← Güncellendi
│   ├── QUICKSTART.md          ← Güncellendi
│   └── ...
│
└── ...
```

---

## 💡 Sistem Sekmesinde Ne Yapabilirim?

### Örnek 1: Yavaş Bilgisayar
1. Sistem Bilgisi'nde disk %90+ dolu mu kontrol et
2. "Sistem Temizleme" → gereksiz dosyaları sil
3. "Başlangıç Programları" → gereksiz programları kapat
4. Bilgisayarı yeniden başlat

### Örnek 2: Ağ Bağlantısı Sorunu
1. Sistem Bilgisi'nde RAM ve Disk durumunu kontrol et
2. "Network Ayarları" → bağlantıyı yeniden kur
3. "Firewall Yönetimi" → kuralları kontrol et

### Örnek 3: Windows Güncellemesi
1. "Windows Güncellemesi" → mevcut güncellemeleri gör
2. "Tek Tuşla Güncelleme" → hemen güncelle
3. Sistem Bilgisi'nde yeni versiyonu kontrol et

### Örnek 4: Sürücü Sorunu
1. "Sürücü Yönetimi" → Cihaz Yöneticisi aç
2. Sorulu cihazı bul (ünlem işareti !)
3. Sürücüyü güncelle veya yükle

---

## 🔄 Geçiş Notları (v5.5 → v6.0)

### ✅ Değişmeyen Şeyler
- Tüm 120+ uygulama aynı şekilde çalışır
- Import/Export JSON fonksiyonu aynı
- Paket yönetici seçimi (WinGet/Chocolatey) aynı

### ✨ Yeni Şeyler
- Yeni "Sistem" sekmesi
- Sistem bilgisi görüntüleme
- 8 sistem yönetim aracı

### 📥 Güncelleme
```powershell
# Eski versiyon ile kullandığınız JSON:
export.json dosyasını sakla

# WinDeploy v6.0'ı indir ve çalıştır
irm "https://windeploy.vercel.app/launcher.ps1" | iex

# İçeri aktar (Import)
"Import" → export.json seç → tüm uygulamalar geri gelir
```

---

## 🐛 Bilinen Sorunlar

Şu anda bilinen sorun yoktur. Eğer sorun yaşarsanız:

1. [GitHub Issues](https://github.com/sylorx/WinDeploy/issues) sayfasını ziyaret edin
2. Sorunu açıklayan yeni bir issue oluşturun
3. Log dosyasını ekleyin: `%APPDATA%\WinDeploy\logs\WinDeploy_YYYY-MM-DD.log`

---

## 📚 Daha Fazla Bilgi

### Rehberler
- [Sistem Sekmesi Detaylı Rehberi](docs/SYSTEM_TAB_GUIDE.md) - Tüm araçları anla
- [Hızlı Başlangıç](docs/QUICKSTART.md) - 5 dakikada setup
- [Kurulum Rehberi](docs/INSTALL.md) - Adım adım kurulum
- [Sorun Giderme](docs/TROUBLESHOOTING.md) - Yaygın sorunlar

### Linkler
- **GitHub:** https://github.com/sylorx/WinDeploy
- **Website:** https://windeploy.vercel.app
- **Issues:** https://github.com/sylorx/WinDeploy/issues

---

## 🎁 v6.0'da Eklenenler Özeti

| Kategori | Detay |
|----------|-------|
| **Yeni Sekme** | Sistem Bilgisi ve Yönetimi |
| **Sistem Bilgisi** | 7 adet gerçek zamanlı metrik |
| **Sistem Araçları** | 8 adet yönetim aracı |
| **Kod** | 308 satır yeni kod (+60%) |
| **Dokümantasyon** | 3 yeni rehber dosyası |
| **Sürüm** | v5.5 → v6.0 |
| **Window Boyutu** | 950x750 → 1000x800 |

---

## 🚀 Sonraki Sürüm Planları

**v6.1 (Yakında):**
- Sistem bilgisi yenileme düğmesi
- Uygulama arama/filtreleme
- Sistem benchmark araçları
- Ağ hızı testi

**v7.0 (Gelecek):**
- Windows 11 Fluent tasarım
- Sistem performans izleyici
- Zamanlanmış görevler
- Bulut senkronizasyonu

---

## 🙏 Geri Bildirim

Sizin geri bildiriminiz önemlidir! Lütfen:

- ⭐ GitHub'da repo'yu yıldızlayın
- 📝 İyileştirme önerilerini gönderin
- 🐛 Bulduğunuz hataları rapor edin
- 💬 Arkadaşlarınızla paylaşın

---

## 📞 İletişim

Sorun mu var? Destek mi gerekiyor?

1. **GitHub Issues:** https://github.com/sylorx/WinDeploy/issues
2. **Email:** Proje açıklamasında
3. **Discussions:** GitHub Discussions sayfası

---

**İyi Kullanımlar! 🎉**

WinDeploy v6.0 - Windows Sistem Yönetimi Artık Çok Kolay

**Sürüm:** 6.0.0
**Yayın Tarihi:** 25 Ocak 2026
**Platform:** Windows 10+
**PowerShell:** 5.1+
