# Sistem Bilgisi Sekmesi Rehberi

## Genel Bakış

WinDeploy v6.0, yeni **Sistem** sekmesi ile birlikte gelir. Bu sekme, sistem bilgilerinizi görüntülemek ve sistem yönetim araçlarına hızlı erişim sağlamak için tasarlanmıştır.

---

## 📍 Sistem Sekmesine Erişim

1. WinDeploy'u başlatın
2. Üst kısımdaki **"Sistem"** sekmesine tıklayın
3. Sistem bilgileriniz ve yönetim araçlarını göreceksiniz

---

## 💻 Sistem Bilgileri

Sistem sekmesinin üst bölümünde şu bilgiler gösterilir:

### Bilgisayar Adı
Bilgisayarınızın ağ adı (hostname). Örnek: `DESKTOP-ABC123`

### İşletim Sistemi
Yüklü Windows sürümü. Örnek: `Microsoft Windows 11 Pro`

### OS Versiyonu ve Mimarisi
Windows versiyonu ve sistem mimarisi (32-bit veya 64-bit). Örnek: `22631.5863 (64-bit)`

### Disk Bilgileri

#### Disk - Toplam
C: sürücüsünün toplam kapasitesi. Örnek: `238.47 GB`

#### Disk - Kullanılan
C: sürücüsündeki kullanılan alan. Örnek: `120.82 GB`

#### Disk - Boş
C: sürücüsündeki boş alan. Örnek: `117.65 GB`

### RAM Miktarı
Yüklü toplam bellek (RAM) kapasitesi. Örnek: `32.00 GB`

---

## 🛠️ Sistem Yönetim Araçları

Sistem sekmesinin alt bölümünde 8 adet hızlı erişim düğmesi bulunur:

### 1. Sistem Optimizasyonu
**Renkle:** Yeşil

Windows'ta Ayarlar > Sistem > Depolama > Depolama Sensörü sayfasını açar.

**Kullanım:** Eski dosyalar temizlemek, disk alanı boşaltmak

---

### 2. Windows Güncellemesi
**Renkle:** Mavi

Windows Update ayarları sayfasını açar. Güncellemeleri kontrol edebilir ve zamanlamayı değiştirebilirsiniz.

**Kullanım:** Mevcut güncellemeleri görmek, otomatik güncellemeleri ayarlamak

---

### 3. Tek Tuşla Güncelleme ⚡
**Renkle:** Turuncu

Bu düğme **anında** Windows güncellemesini çalıştırır. Tıklandığında:
- Windows Update sayfası açılır
- Mevcut güncellemeler kontrol edilir
- Bulunansa hemen kurulumuna başlar

**Kullanım:** Acil sistem güncellemeleri için

---

### 4. Sürücü Yönetimi
**Renkle:** Mor

Cihaz Yöneticisi'ni açar. Buradan:
- Tüm donanım sürücülerini görebilirsiniz
- Sürücüleri güncelleyebilirsiniz
- Sorunlu cihazları teşhis edebilirsiniz

**Kullanım:** Ekran kartı, ses, ağ, etc. sürücü sorunları için

---

### 5. Sistem Temizleme
**Renkle:** Kırmızı

Disk Temizleme aracını açar. Windows'un geçici dosyalarını temizleyebilirsiniz:
- Geçici dosyalar
- İndirilmiş dosyalar
- Çöp kutusu
- Sistem dosyaları

**Kullanım:** Disk alanı boşaltma, sistem temizliği

---

### 6. Başlangıç Programları Yönetimi
**Renkle:** Açık Yeşil

Görev Yöneticisi'ni Başlangıç sekmesiyle açar. Buradan:
- Başlangıçta hangi programların çalıştığını görebilirsiniz
- Program başlangıcını devre dışı bırakabilirsiniz
- Sistem performansını iyileştirebilirsiniz

**Kullanım:** Yavaş bilgisayar başlangıcını hızlandırmak

---

### 7. Network Ayarları
**Renkle:** Açık Mavi

Ağ Bağlantıları Kontrol Paneli'ni açar. Buradan:
- WiFi veya Ethernet bağlantısını değiştirebilirsiniz
- Adaptör ayarlarını konfigüre edebilirsiniz
- IP adresini görebilirsiniz
- DNS ayarlarını değiştirebilirsiniz

**Kullanım:** Ağ sorunu çözme, VPN setup'ı

---

### 8. Firewall Yönetimi
**Renkle:** Pembe

Windows Defender Firewall'u ve Gelişmiş Güvenlik yöneticisini açar. Buradan:
- Firewall kurallarını yönetebilirsiniz
- Program geri planı trafiğini kontrol edebilirsiniz
- İnbound/Outbound kuralları ayarlayabilirsiniz

**Kullanım:** Ağ güvenliği, program izinleri

---

## 📱 Araç Düğmeleri Düzeni

Düğmeler 2 sütun halinde düzenlenmiştir:

```
┌─────────────────────────────┬─────────────────────────────┐
│  Sistem Optimizasyonu       │  Windows Güncellemesi       │
├─────────────────────────────┼─────────────────────────────┤
│  Tek Tuşla Güncelleme       │  Sürücü Yönetimi            │
├─────────────────────────────┼─────────────────────────────┤
│  Sistem Temizleme           │  Başlangıç Programları      │
├─────────────────────────────┼─────────────────────────────┤
│  Network Ayarları           │  Firewall Yönetimi          │
└─────────────────────────────┴─────────────────────────────┘
```

---

## ✨ İpuçları ve Püf Noktaları

### 💡 Sistem Bilgilerini Güncelle
Sistem sekmesine girişten çıkış yapıp yeniden girdiğinizde, bilgiler otomatik olarak yenilenir.

### 💡 Hızlı Erişim
Sistem araçlarına tıklamak, ilgili Windows ayarlarını veya yönetim aracını doğrudan açar. Ayrı ayrı aramaya gerek yoktur.

### 💡 Disk Temizleme Stratejisi
- İlk olarak "Sistem Temizleme" aracını açın
- "Sistem dosyalarını temizle" seçeneğini etkinleştirin
- Güvenli olmayan eski dosyaları temizleyin

### 💡 Başlangıç Performansı
"Başlangıç Programları" yönetiminden gereksiz programları devre dışı bırakarak:
- Bilgisayar başlangıç hızını 30-50% artırabilirsiniz
- İlk açılışta RAM kullanımını azaltabilirsiniz

### 💡 Ağ Sorunu Çözme Sırası
1. Sistem Bilgisi'nde IP adresini kontrol edin
2. Network Ayarları'na gidin
3. Bağlantıyı yeniden kurun (Disconnect > Connect)

---

## ⚠️ Uyarılar ve Güvenlik

### Cihaz Yöneticisi
❌ **DİKKAT:** Bilmediğiniz cihaz sürücülerini kaldırmayın. Sistem bozulabilir.

### Windows Defender Firewall
⚠️ **ÖNEMLİ:** Firewall kurallarını değiştirirken, güvenilen uygulamaları engellemeyin.

### Sistem Temizleme
⚠️ **TAVSIYE:** Temizlemeden önce önemli dosyaları yedekleyin.

### Başlangıç Programları
⚠️ **UYARI:** Windows veya sistem yönetimi programlarını devre dışı bırakmayın.

---

## 🔧 İş Akışı Örneği

### Senaryo: Yavaş Bilgisayar

1. **Sistem Bilgisi'ni kontrol edin**
   - RAM ve Disk boş alanını görmek için Sistem sekmesine bakın
   - Disk %90+ doluysa, limiti azaltmanız gerekiyor

2. **Başlangıç Programları'nı düzenleyin**
   - "Başlangıç Programları" düğmesine tıklayın
   - İhtiyaç olmayan programları devre dışı bırakın
   - Bilgisayarı yeniden başlatın

3. **Sistem Temizleme yapın**
   - "Sistem Temizleme" düğmesine tıklayın
   - Tüm kategorileri seçin
   - "Sistem dosyalarını temizle" etkinleştirin

4. **Sürücüleri güncelleyin**
   - "Sürücü Yönetimi" düğmesine tıklayın
   - Ünlem işareti olan cihazları ara
   - Sürücü güncellemelerini yükleyin

---

## 📞 Sorun Giderme

### Sistem Bilgileri gösterilmiyorsa
- PowerShell admin izni ile çalıştığından emin olun
- WinDeploy'u kapatıp yeniden açın

### Araçlar açılmıyorsa
- İnternet bağlantısını kontrol edin
- Windows Defender'ın programı engellemediğinden emin olun
- Bilgisayarı yeniden başlatın

### Yanlış sistem bilgileri gösteriliyorsa
- Bilgisayarı yeniden başlatın
- Sistem sekmesine tekrar gidin

---

## 🚀 Sonraki Adımlar

- Uygulamalar sekmesinde yeni yazılımlar yükleyin
- Sistem yönetim araçlarını tanıyın
- İş akışınızı optimize edin

---

**WinDeploy v6.0** ile sistem yönetimi hiç bu kadar kolay olmamıştı! 🎉
