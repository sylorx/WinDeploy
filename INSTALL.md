# Bu dosya, WinDeploy'u başarıyla çalıştırmak için gerekli bilgileri içerir

## 📋 Kurulum Adımları

### Adım 1: Repository'i Clone Edin
```powershell
git clone https://github.com/sylorx/WinDeploy.git
cd WinDeploy
```

### Adım 2: Execution Policy Ayarını Yapın (İlk Sefer)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Adım 3: WinDeploy'u Çalıştırın
PowerShell'i **Yönetici olarak** açıp:
```powershell
.\WinDeploy.ps1
```

## 🌐 Internetten Tek Komutla Çalıştırma

```powershell
irm "https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1" | iex
```

## 📂 Proje Yapısı

```
WinDeploy/
├── WinDeploy.ps1          # Ana program (tüm özellikler burada)
├── launcher.ps1           # İnternet üzerinden indirme scripti
├── README.md              # Detaylı belgeler
├── QUICKSTART.md          # Hızlı başlangıç rehberi
├── INSTALL.md             # Bu dosya
├── LICENSE                # MIT Lisansı
├── .gitignore             # Git'in yok sayması gereken dosyalar
└── docs/                  # Ek belgeler (gelecek)
    ├── TROUBLESHOOTING.md # Sorun giderme
    └── DEVELOPMENT.md     # Geliştirici rehberi
```

## 🔧 Gereksinimler

- **İşletim Sistemi:** Windows 10 veya üzeri
- **PowerShell:** 5.1 veya 7+
- **İzin:** Yönetici izni
- **İnternet:** Uygulama indirilirken gerekli

## ⚙️ Otomatik Olarak Kurulacaklar

WinDeploy ilk çalışmada şunları yapacaktır:

1. ✅ Konfigürasyon dizini oluştur (`%APPDATA%\WinDeploy`)
2. ✅ Uygulama veritabanını yükle
3. ✅ Chocolatey ve WinGet'i kontrol et
4. ✅ Eksik olanları kurmayı iste

## 📦 Desteklenen Paket Yöneticileri

| Yönetici | Durum | Kurulum |
|----------|-------|---------|
| **Chocolatey** | Opsiyonel | Otomatik |
| **WinGet** | Opsiyonel | Otomatik |

Minimum bir tanesi kurulmalıdır.

## 🚀 Başlangıçta Kontrol Edilen İşlemler

```powershell
# 1. Yönetici Kontrolü
if (-not (Test-Administrator)) { 
    exit "Yönetici izni gerekli"
}

# 2. Konfigürasyon Klasörü
$ConfigPath = "$env:APPDATA\WinDeploy"

# 3. Uygulama Veritabanı
$DbPath = "$ConfigPath\apps.json"

# 4. Paket Yöneticileri
Test-CommandExists "choco"
Test-CommandExists "winget"
```

## 💾 Veri Depolama

Tüm veriler güvenli şekilde `%APPDATA%\WinDeploy\` klasöründe saklanır:
- `apps.json` - Uygulama listesi
- `apps_export.json` - Dışa aktarılmış konfigürasyonlar

## 🔐 Güvenlik Notları

- 🔒 Her zaman yönetici olarak çalıştırın
- 🔒 Kaynağa güvenin (GitHub veya kişisel sunucu)
- 🔒 Dosyaları değiştirmeden önce yedeğini alın
- 🔒 Yalnızca resmi paket yöneticilerini kullanın

## 🐛 Yaygın Sorunlar

### "ExecutionPolicy" Hatası
```powershell
# Çözüm:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### "Yönetici izni gerekli" Hatası
- PowerShell'i sağ tıklayın
- "Yönetici olarak çalıştır" seçin

### Paket yöneticileri yüklenmiyor
- İnternet bağlantısını kontrol edin
- Windows Defender Firewall'u kontrol edin
- VPN kullanıyorsanız devre dışı bırakın

## 📖 Daha Fazla Bilgi

- Detaylı rehber: [README.md](README.md)
- Hızlı başlangıç: [QUICKSTART.md](QUICKSTART.md)
- Sorun giderme: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) (yakında)

## 🤝 Katkıda Bulunmak

1. Repository'i fork edin
2. Feature branch oluşturun
3. Değişiklikleri commit edin
4. Pull request gönderin

## 📝 Versiyon Geçmişi

### v1.0 (Geçerli)
- ✅ Ana GUI menüsü
- ✅ Uygulama yönetimi
- ✅ Import/Export desteği
- ✅ Paket yöneticisi otomasyonu
- ✅ Sistem bilgisi

### Planlanan (v1.1+)
- 🔄 Grafik arayüz (GUI)
- 🔄 Sistem optimizasyonu
- 🔄 Sürücü yönetimi
- 🔄 Firewall ayarları

---

**Kurulum tamamlandı! WinDeploy'u kullanmaya başlayabilirsiniz!** 🎉
