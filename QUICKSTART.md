# WinDeploy - Hızlı Başlangıç Rehberi

## 🚀 30 Saniyede Başlayın

### 1. PowerShell Açın (Yönetici olarak)
- Windows tuşu + X tuşuna basın
- "Windows PowerShell (Yönetici)" seçin
- "Evet" butonuna tıklayın

### 2. Tek Komutu Çalıştırın
```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
```

### 3. Bitti! 🎉

---

## 📋 Temel Menü Seçenekleri

| Seçim | İşlem | Açıklama |
|-------|-------|----------|
| **1** | Uygulama Yönetimi | Uygulamaları yükle, kaldır, düzenle |
| **2** | Sistem Paneli | Sistem ayarlarına erişim (yakında) |
| **3** | Sistem Bilgisi | Bilgisayar hakkında detaylı bilgi |
| **4** | Araçlar | Sistem araçları (yakında) |
| **5** | Ayarlar | Uygulama ayarları (yakında) |
| **0** | Çıkış | Programdan çık |

---

## 🎯 Yaygın Görevler

### Uygulama Yükleme
1. Ana menüden **1** seçin
2. Yüklemek istediğiniz uygulamanın numarasını yazın
3. Yükleme otomatik başlayacak

### Birden Fazla Uygulama Yükleme
1. Ana menüden **1** seçin
2. **G** tuşuna basın (Tümünü İndir)
3. Onay için **Y** yazın
4. Sabırla bekleyin ☕

### Uygulama Listesini Dışa Aktarma
1. Ana menüden **1** seçin (Uygulama Yönetimi)
2. **E** tuşuna basın (Dışa Aktarma)
3. Dosya şurada kaydedilir: `%APPDATA%\WinDeploy\apps_export.json`

### Uygulama Listesini İçe Aktarma
1. Ana menüden **1** seçin (Uygulama Yönetimi)
2. **I** tuşuna basın (İçe Aktarma)
3. Dosya yolunu belirtin

### Sistem Bilgisi Görüntüleme
1. Ana menüden **3** seçin (Sistem Bilgisi)
2. Bilgisayarınızın detayları görüntülenecek

---

## ⚙️ Paket Yöneticileri

### Chocolatey
- **Ne işe yarar?** Windows için popüler paket yöneticisi
- **Yükleme:** Otomatik (İlk çalışmada)
- **Web:** https://chocolatey.org/
- **Komut:** `choco install [paket-adı]`

### WinGet
- **Ne işe yarar?** Microsoft'un resmi Windows paket yöneticisi
- **Yükleme:** Otomatik (İlk çalışmada)
- **Web:** https://github.com/microsoft/winget-cli
- **Komut:** `winget install [paket-adı]`

---

## 🆘 Hızlı Çözümler

### Problem: "Yönetici izni gerekli"
✅ **Çözüm:** PowerShell'i yönetici olarak açın (üstte gösterildi)

### Problem: Script çalışmıyor
✅ **Çözüm:** Execution Policy ayarını yapın
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Problem: Paket yöneticileri yüklenmiyor
✅ **Çözüm:** İnternet bağlantısını kontrol edin ve yeniden deneyin

### Problem: Uygulama kurulumunda hata
✅ **Çözüm:** 
- İnternet bağlantısını kontrol edin
- Bilgisayarınızı yeniden başlatın
- WinDeploy'u yeniden çalıştırın

---

## 📦 Önceden Yüklü Uygulamalar

### Geliştirme Araçları
- Visual Studio Code (Kod Editörü)
- Git (Versiyon Kontrol)
- Python (Programlama Dili)
- Node.js (JavaScript Runtime)

### Sıkıştırma Araçları
- 7-Zip (Sıkıştırma)

### Tarayıcılar
- Google Chrome
- Mozilla Firefox

### Multimedya
- VLC Media Player

---

## 💾 Özel Uygulama Ekleme

1. Uygulama Yönetimi menüsünde **Y** seçin
2. Sorulara cevap verin:
   ```
   Uygulama Adı: Discord
   Paket Adı: discord
   Kategori: Sosyal Ağlar
   Paket Yöneticisi: chocolatey
   ```
3. Uygulama başarıyla eklenecektir!

---

## 🔗 Faydalı Linkler

| Kaynak | Link |
|--------|------|
| WinDeploy GitHub | https://github.com/sylorx/WinDeploy |
| Chocolatey Paketleri | https://community.chocolatey.org/packages |
| WinGet Paketleri | https://github.com/microsoft/winget-cli |
| PowerShell Dokumanları | https://learn.microsoft.com/powershell |

---

## 📞 Destek

Sorun yaşıyorsanız:
1. README.md dosyasının "Sorun Giderme" bölümünü okuyun
2. GitHub Issues'ta benzer bir sorun olup olmadığını kontrol edin
3. Yeni bir issue oluşturun

---

**💡 İpucu:** Programı her çalıştırdığınızda, paket yöneticileri otomatik olarak kontrol edilecek ve eksikse kurulacaktır!
