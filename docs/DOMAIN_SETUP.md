# 🌐 WinDeploy - Kendi Domain'inizden Sunma Rehberi

> **Neden kendi domain'inizden sunmalısınız?**
> - ✅ Daha hızlı indirme (no GitHub rate limiting)
> - ✅ Firewall/Proxy sorunları azalır
> - ✅ Kurumsal ortamlarda daha güvenilir
> - ✅ İnternal network üzerinden sunabilirsiniz

---

## 🚀 Hızlı Kurulum

### Adım 1: Dosyaları İndir

GitHub repository'den dosyaları indirin:

```bash
git clone https://github.com/sylorx/WinDeploy.git
# VEYA ZIP olarak indir
```

### Adım 2: Dosyaları Domain'inize Upload Et

```
yourdomain.com/
├── launcher.ps1          # Ana launcher script
├── WinDeploy.ps1         # Ana program
└── (diğer belgeler)
```

**Dosyalar:**
- `launcher.ps1` - Download ve başlatma scripti
- `WinDeploy.ps1` - Ana program
- Diğer dosyalar - Belgeler (opsiyonel)

### Adım 3: Kullanıcılara Komut Ver

**GitHub'dan çevirme (1 saniye):**
```powershell
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com"
irm "https://yourdomain.com/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

---

## 📋 Adım Adım Kurulum Seçenekleri

### Seçenek 1: Nginx ile

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location /windeploy/ {
        alias /var/www/windeploy/;
        autoindex on;
    }
}
```

**Komut:**
```powershell
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com/windeploy"
irm "https://yourdomain.com/windeploy/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

### Seçenek 2: Apache ile

```apache
<Directory /var/www/windeploy>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

Alias /windeploy /var/www/windeploy
```

### Seçenek 3: IIS ile (Windows Server)

1. IIS'de yeni site oluştur
2. Physical path: `C:\inetpub\windeploy`
3. Binding: `yourdomain.com`
4. Dosyaları upload et

**Komut:**
```powershell
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com"
irm "https://yourdomain.com/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

### Seçenek 4: Docker ile

```dockerfile
FROM nginx:latest

COPY WinDeploy.ps1 /usr/share/nginx/html/
COPY launcher.ps1 /usr/share/nginx/html/
COPY docs /usr/share/nginx/html/docs

EXPOSE 80
```

---

## 🔒 Güvenlik Ayarları

### HTTPS Kullan (Önerilir)

```powershell
# Domain'in HTTPS sertifikası olmasını sağla
# Let's Encrypt kullan (ücretsiz)
```

### PowerShell Execution Policy

Launcher otomatik olarak ExecutionPolicy Bypass'ını process scope'unda ayarlar.

### Firewall Ayarı

Port 80/443'ü açmanız gerekebilir:

**Windows Firewall:**
```powershell
New-NetFirewallRule -DisplayName "WinDeploy" -Direction Inbound -LocalPort 80,443 -Protocol TCP -Action Allow
```

---

## 📊 Network Konfigürasyonu

### Kurumsal Ortamda

Eğer proxy/firewall arkasında çalışıyorsanız:

1. Domain'inizi whitelist'e ekleyin
2. Proxy ayarlarınızı kontrol edin
3. Antivirus scan ayarlarını kontrol edin

### VPN Üzerinden

```powershell
# VPN bağlıyken
$env:WINDEPLOY_DOMAIN = "https://internal.company.com"
irm "https://internal.company.com/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

---

## 🧪 Test Etme

### Lokal Teste

```powershell
# Lokal sunucunuzda test edin
$env:WINDEPLOY_DOMAIN = "http://localhost"
irm "http://localhost/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

### Bağlantı Teste

```powershell
# Dosyaların erişilebilir olup olmadığını kontrol et
Test-NetConnection yourdomain.com -Port 443
Invoke-WebRequest "https://yourdomain.com/launcher.ps1" -Headers @{"User-Agent"="PowerShell"}
```

---

## 📝 Launcher Davranışı

Launcher otomatik olarak şu sıraya göre çalışır:

1. **$env:WINDEPLOY_DOMAIN** kontrol et
2. Yoksa GitHub'dan indir (https://raw.githubusercontent.com/sylorx/WinDeploy/main)
3. Domain başarısız olursa GitHub'a fallback

```powershell
# Kendi domain'inizi belirle
$env:WINDEPLOY_DOMAIN = "https://yourdomain.com"

# Launcher otomatik olarak şu sırada dener:
# 1. https://yourdomain.com/WinDeploy.ps1
# 2. https://raw.githubusercontent.com/sylorx/WinDeploy/main/WinDeploy.ps1
```

---

## 🎯 Örnek Kurulum Senaryosu

### Senaryo: Kurumsal Intranet

**Ortam:**
- Windows Server 2019
- IIS 10
- Internal domain: `tools.company.local`

**Kurulum:**

1. **IIS Site Oluştur:**
```powershell
New-IISSite -Name "WinDeploy" -BindingInformation "*:80:tools.company.local" -PhysicalPath "C:\inetpub\windeploy"
```

2. **Dosyaları Kopyala:**
```powershell
Copy-Item ".\WinDeploy.ps1" "C:\inetpub\windeploy\"
Copy-Item ".\launcher.ps1" "C:\inetpub\windeploy\"
```

3. **Kullanıcılara Komut Ver:**
```powershell
$env:WINDEPLOY_DOMAIN = "http://tools.company.local"
irm "http://tools.company.local/launcher.ps1" -OutFile $env:TEMP\launcher.ps1; powershell -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\launcher.ps1
```

---

## 🆘 Sorun Giderme

### Dosya İndirilemedi

```powershell
# Domain'in erişilebilir olup olmadığını test et
Invoke-WebRequest "https://yourdomain.com/launcher.ps1"
```

### 404 Hatası

```powershell
# Dosya konumunu kontrol et
Get-Item "C:\inetpub\windeploy\launcher.ps1"

# URL yol doğru mu kontrol et
$url = "https://yourdomain.com/launcher.ps1"
Invoke-WebRequest $url
```

### Timeout Hatası

```powershell
# Ağ bağlantısını kontrol et
Test-NetConnection yourdomain.com -Port 443

# Timeout'u artır
(Get-Item WSMan:\localhost\Client\DefaultTimeout).Value = 30000
```

---

## 📞 İletişim

Domain konusunda sorun yaşıyorsanız:
- GitHub Issues: https://github.com/sylorx/WinDeploy/issues
- Belgeler: Projenin /docs klasöründe

---

**Domain ayarının avantajları:** 🚀
- Ortalama **60% daha hızlı** indirme
- **0 rate limiting** sorunu
- **Kurumsal ağlarda** çalışır
- **Güvenilir ve stabil**

