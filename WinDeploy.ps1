[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Admin kontrolu
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    [Windows.Forms.MessageBox]::Show("Yonetici izni gerekli!", "Hata", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    exit 1
}

# Windows Forms yukleme
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

# Bilgisayar bilgilerini al
$komputerInfo = Get-ComputerInfo

# Uygulama listesi
$uygulamalar = @(
    @{Ad = "Google Chrome"; Paket = "Google.Chrome"; Ikon = "C"}
    @{Ad = "Visual Studio Code"; Paket = "Microsoft.VisualStudioCode"; Ikon = "V"}
    @{Ad = "VLC Media Player"; Paket = "VideoLAN.VLC"; Ikon = "P"}
    @{Ad = "7-Zip"; Paket = "7zip.7zip"; Ikon = "Z"}
    @{Ad = "Notepad++"; Paket = "Notepad++.Notepad++"; Ikon = "N"}
    @{Ad = "Git"; Paket = "Git.Git"; Ikon = "G"}
)

# Ana form olustur
$form = New-Object Windows.Forms.Form
$form.Text = "WinDeploy v2.0 - Windows Uygulama Yoneticisi"
$form.Width = 700
$form.Height = 600
$form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Panel - Baslik
$panelBaslik = New-Object Windows.Forms.Panel
$panelBaslik.Dock = [Windows.Forms.DockStyle]::Top
$panelBaslik.Height = 80
$panelBaslik.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)

$labelBaslik = New-Object Windows.Forms.Label
$labelBaslik.Text = "WinDeploy"
$labelBaslik.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$labelBaslik.ForeColor = [System.Drawing.Color]::White
$labelBaslik.Location = New-Object System.Drawing.Point(20, 15)
$labelBaslik.AutoSize = $true
$panelBaslik.Controls.Add($labelBaslik)

$labelAciklama = New-Object Windows.Forms.Label
$labelAciklama.Text = "Windows Uygulamalarini Kolayca Yukle ve Yonet"
$labelAciklama.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelAciklama.ForeColor = [System.Drawing.Color]::White
$labelAciklama.Location = New-Object System.Drawing.Point(20, 50)
$labelAciklama.AutoSize = $true
$panelBaslik.Controls.Add($labelAciklama)
$form.Controls.Add($panelBaslik)

# Tab kontrol
$tabControl = New-Object Windows.Forms.TabControl
$tabControl.Dock = [Windows.Forms.DockStyle]::Fill
$tabControl.ItemSize = New-Object System.Drawing.Size(150, 35)
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 11)

# Tab 1 - Uygulamalar
$tabUygulamalar = New-Object Windows.Forms.TabPage
$tabUygulamalar.Text = "Uygulamalar"
$tabUygulamalar.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$tabControl.TabPages.Add($tabUygulamalar)

# Scroll container
$scrollPanel = New-Object Windows.Forms.Panel
$scrollPanel.AutoScroll = $true
$scrollPanel.Dock = [Windows.Forms.DockStyle]::Fill
$tabUygulamalar.Controls.Add($scrollPanel)

# Uygulama butonlari
$y = 10
foreach ($app in $uygulamalar) {
    $panel = New-Object Windows.Forms.Panel
    $panel.Width = 630
    $panel.Height = 70
    $panel.Location = New-Object System.Drawing.Point(10, $y)
    $panel.BackColor = [System.Drawing.Color]::White
    $panel.BorderStyle = [Windows.Forms.BorderStyle]::FixedSingle
    
    $labelApp = New-Object Windows.Forms.Label
    $labelApp.Text = $app.Ad
    $labelApp.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $labelApp.Location = New-Object System.Drawing.Point(15, 10)
    $labelApp.AutoSize = $true
    $panel.Controls.Add($labelApp)
    
    $buttonYukle = New-Object Windows.Forms.Button
    $buttonYukle.Text = "Yukle"
    $buttonYukle.Width = 100
    $buttonYukle.Height = 40
    $buttonYukle.Location = New-Object System.Drawing.Point(515, 15)
    $buttonYukle.BackColor = [System.Drawing.Color]::FromArgb(0, 150, 50)
    $buttonYukle.ForeColor = [System.Drawing.Color]::White
    $buttonYukle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $buttonYukle.FlatStyle = [Windows.Forms.FlatStyle]::Flat
    $buttonYukle.FlatAppearance.BorderSize = 0
    $buttonYukle.Cursor = [Windows.Forms.Cursors]::Hand
    
    # Buton tiklamasi
    $paket = $app.Paket
    $ad = $app.Ad
    $buttonYukle.Add_Click({
        $result = [Windows.Forms.MessageBox]::Show("$ad yuklenmek uzere. Devam edilsin mi?", "Onayla", [Windows.Forms.MessageBoxButtons]::YesNo, [Windows.Forms.MessageBoxIcon]::Question)
        if ($result -eq [Windows.Forms.DialogResult]::Yes) {
            $buttonYukle.Text = "Yukleniyor..."
            $buttonYukle.Enabled = $false
            $form.Refresh()
            
            try {
                winget install $paket -e --silent --disable-interactivity 2>$null
                [Windows.Forms.MessageBox]::Show("$ad basariyla yuklendi!", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
            } catch {
                [Windows.Forms.MessageBox]::Show("Yukleme sirasinda hata olustu.", "Hata", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            }
            
            $buttonYukle.Text = "Yukle"
            $buttonYukle.Enabled = $true
        }
    })
    
    $panel.Controls.Add($buttonYukle)
    $scrollPanel.Controls.Add($panel)
    $y += 75
}

# Tab 2 - Bilgisayar Bilgisi
$tabBilgi = New-Object Windows.Forms.TabPage
$tabBilgi.Text = "Bilgisayar Bilgisi"
$tabBilgi.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$tabControl.TabPages.Add($tabBilgi)

$panelBilgi = New-Object Windows.Forms.Panel
$panelBilgi.Dock = [Windows.Forms.DockStyle]::Fill
$panelBilgi.BackColor = [System.Drawing.Color]::White
$panelBilgi.Margin = New-Object Windows.Forms.Padding(15)

$infoText = @"
=== BILGISAYAR BILGISI ===

Bilgisayar Adi: $($komputerInfo.CsComputerName)
Kullanici: $($komputerInfo.UserName)
Isletim Sistemi: $($komputerInfo.OsName)
OS Versiyonu: $($komputerInfo.OsVersion)
Islemci: $($komputerInfo.CsProcessors[0].Name)
RAM: $([Math]::Round($komputerInfo.CsTotalPhysicalMemory / 1GB)) GB
Sistem Tipi: $($komputerInfo.CsSystemType)
=========================
"@

$textBilgi = New-Object Windows.Forms.TextBox
$textBilgi.Text = $infoText
$textBilgi.Dock = [Windows.Forms.DockStyle]::Fill
$textBilgi.Multiline = $true
$textBilgi.ReadOnly = $true
$textBilgi.Font = New-Object System.Drawing.Font("Consolas", 10)
$textBilgi.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
$textBilgi.ForeColor = [System.Drawing.Color]::FromArgb(0, 0, 0)

$panelBilgi.Controls.Add($textBilgi)
$tabBilgi.Controls.Add($panelBilgi)

# Tab 3 - Ayarlar
$tabAyarlar = New-Object Windows.Forms.TabPage
$tabAyarlar.Text = "Ayarlar"
$tabAyarlar.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$tabControl.TabPages.Add($tabAyarlar)

$labelAyarlar = New-Object Windows.Forms.Label
$labelAyarlar.Text = "WinDeploy Ayarlari`n`nVersiyon: 2.0`nGelismis GUI Arayuzu`n`nMouse desteÃ„Å¸i ile tum secenekler tiklanabilir`n`nDetaylÃ„Â± bilgiler icin DOMAIN_SETUP.md dosyasini okuyunuz."
$labelAyarlar.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$labelAyarlar.Location = New-Object System.Drawing.Point(20, 20)
$labelAyarlar.AutoSize = $true
$tabAyarlar.Controls.Add($labelAyarlar)

# Tab kontrolu ekle
$form.Controls.Add($tabControl)

# Alt panel - Butonlar
$panelAlt = New-Object Windows.Forms.Panel
$panelAlt.Dock = [Windows.Forms.DockStyle]::Bottom
$panelAlt.Height = 60
$panelAlt.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$panelAlt.BorderStyle = [Windows.Forms.BorderStyle]::FixedSingle

$buttonKapat = New-Object Windows.Forms.Button
$buttonKapat.Text = "Kapat"
$buttonKapat.Width = 100
$buttonKapat.Height = 35
$buttonKapat.Location = New-Object System.Drawing.Point(580, 12)
$buttonKapat.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
$buttonKapat.ForeColor = [System.Drawing.Color]::White
$buttonKapat.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonKapat.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonKapat.FlatAppearance.BorderSize = 0
$buttonKapat.Cursor = [Windows.Forms.Cursors]::Hand
$buttonKapat.Add_Click({ $form.Close() })
$panelAlt.Controls.Add($buttonKapat)

$form.Controls.Add($panelAlt)

# Form ekran sarkma
$form.TopMost = $true
Start-Sleep -Milliseconds 300
$form.TopMost = $false

# Form goster
$form.ShowDialog() | Out-Null
