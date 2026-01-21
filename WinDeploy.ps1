[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

# Admin kontrolu
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    [Windows.Forms.MessageBox]::Show("Yonetici izni gerekli!", "Hata", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    exit 1
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

# Log sistemi
$logPath = "$env:APPDATA\WinDeploy"
if (-not (Test-Path $logPath)) { New-Item -ItemType Directory -Path $logPath | Out-Null }
$logFile = "$logPath\WinDeploy_$(Get-Date -Format 'yyyy-MM-dd').log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host $logEntry -ForegroundColor Cyan
}

Write-Log "=== WinDeploy v4.0 Basladi ==="
Write-Log "Isletim Sistemi: $([System.Environment]::OSVersion.VersionString)"
Write-Log "PowerShell Versiyonu: $($PSVersionTable.PSVersion)"

# Global Theme
$isDarkMode = $true
$colorDarkBg = [System.Drawing.Color]::FromArgb(30, 30, 30)
$colorDarkPanel = [System.Drawing.Color]::FromArgb(45, 45, 45)
$colorLightBg = [System.Drawing.Color]::FromArgb(240, 240, 240)
$colorLightPanel = [System.Drawing.Color]::FromArgb(255, 255, 255)
$colorPrimary = [System.Drawing.Color]::FromArgb(0, 150, 215)
$colorSuccess = [System.Drawing.Color]::FromArgb(0, 200, 83)
$colorDanger = [System.Drawing.Color]::FromArgb(220, 53, 69)

# Kategorize Uygulama Listesi
$uygulamalarByKategori = @{
    "Tarayicilar" = @(
        @{Ad = "Google Chrome"; Paket = "Google.Chrome"}
        @{Ad = "Firefox"; Paket = "Mozilla.Firefox"}
        @{Ad = "Brave Browser"; Paket = "BraveSoftware.BraveBrowser"}
        @{Ad = "Opera"; Paket = "Opera.Opera"}
        @{Ad = "Vivaldi"; Paket = "VivaldiTechnologies.Vivaldi"}
        @{Ad = "Edge"; Paket = "Microsoft.Edge"}
    )
    "Multimedia" = @(
        @{Ad = "Spotify"; Paket = "Spotify.Spotify"}
        @{Ad = "Foobar2000"; Paket = "PeterPawlowski.foobar2000"}
        @{Ad = "MusicBee"; Paket = "Getmusicbee.MusicBee"}
        @{Ad = "VLC Media Player"; Paket = "VideoLAN.VLC"}
        @{Ad = "MPC-HC"; Paket = "clsid2.mpc-hc"}
        @{Ad = "Potplayer"; Paket = "Daum.PotPlayer"}
        @{Ad = "OBS Studio"; Paket = "OBSProject.OBSStudio"}
    )
    "Gelistirme" = @(
        @{Ad = "Visual Studio Code"; Paket = "Microsoft.VisualStudioCode"}
        @{Ad = "Git"; Paket = "Git.Git"}
        @{Ad = "Node.js"; Paket = "OpenJS.NodeJS"}
        @{Ad = "Python"; Paket = "Python.Python.3.11"}
        @{Ad = "Docker"; Paket = "Docker.DockerDesktop"}
        @{Ad = "Postman"; Paket = "Postman.Postman"}
        @{Ad = "Sublime Text"; Paket = "SublimeHQ.SublimeText.4"}
        @{Ad = "Java JDK"; Paket = "Oracle.JDK.21"}
        @{Ad = "Visual Studio Community"; Paket = "Microsoft.VisualStudio.Community"}
        @{Ad = "Android Studio"; Paket = "Google.AndroidStudio"}
    )
    "Grafik Tasarim" = @(
        @{Ad = "GIMP"; Paket = "GNU.GIMP"}
        @{Ad = "Krita"; Paket = "KritaFoundation.Krita"}
        @{Ad = "Paint.NET"; Paket = "dotPDN.PaintDotNet"}
        @{Ad = "Figma"; Paket = "Figma.Figma"}
        @{Ad = "Inkscape"; Paket = "Inkscape.Inkscape"}
    )
    "3D Modelleme" = @(
        @{Ad = "Blender"; Paket = "BlenderFoundation.Blender"}
        @{Ad = "FreeCAD"; Paket = "FreeCAD.FreeCAD"}
    )
    "Sistem Araclar" = @(
        @{Ad = "PowerToys"; Paket = "Microsoft.PowerToys"}
        @{Ad = "AutoHotkey"; Paket = "AutoHotkey.AutoHotkey"}
        @{Ad = "Everything"; Paket = "voidtools.Everything"}
        @{Ad = "7-Zip"; Paket = "7zip.7zip"}
        @{Ad = "WinRAR"; Paket = "RARLab.WinRAR"}
        @{Ad = "VirtualBox"; Paket = "Oracle.VirtualBox"}
        @{Ad = "Notepad++"; Paket = "Notepad++.Notepad++"}
    )
    "Oyun Platformlari" = @(
        @{Ad = "Steam"; Paket = "Valve.Steam"}
        @{Ad = "Epic Games Launcher"; Paket = "EpicGames.EpicGamesLauncher"}
        @{Ad = "GOG Galaxy"; Paket = "GOG.Galaxy"}
    )
    "Iletisim" = @(
        @{Ad = "Discord"; Paket = "Discord.Discord"}
        @{Ad = "Telegram"; Paket = "Telegram.TelegramDesktop"}
        @{Ad = "Slack"; Paket = "SlackTechnologies.Slack"}
    )
    "Ofis" = @(
        @{Ad = "LibreOffice"; Paket = "TheDocumentFoundation.LibreOffice"}
        @{Ad = "Notepad"; Paket = "Microsoft.Notepad"}
    )
    "Diger" = @(
        @{Ad = "Audacity"; Paket = "Audacity.Audacity"}
        @{Ad = "FileZilla"; Paket = "FileZilla.FileZilla"}
        @{Ad = "Putty"; Paket = "PuTTY.PuTTY"}
        @{Ad = "qBittorrent"; Paket = "qBittorrent.qBittorrent"}
    )
}

$checkboxes = @{}
$expandedGroups = @{}

# Ana Form
$form = New-Object Windows.Forms.Form
$form.Text = "WinDeploy v4.0 - Kategorilendirilmis Uygulama Yoneticisi"
$form.Width = 950
$form.Height = 750
$form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = $colorDarkBg
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# === BASLIK PANELI ===
$panelHeader = New-Object Windows.Forms.Panel
$panelHeader.Dock = [Windows.Forms.DockStyle]::Top
$panelHeader.Height = 70
$panelHeader.BackColor = $colorDarkPanel

$labelTitle = New-Object Windows.Forms.Label
$labelTitle.Text = "WinDeploy v4.0"
$labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$labelTitle.ForeColor = $colorPrimary
$labelTitle.Location = New-Object System.Drawing.Point(15, 12)
$labelTitle.AutoSize = $true
$panelHeader.Controls.Add($labelTitle)

$buttonTheme = New-Object Windows.Forms.Button
$buttonTheme.Text = "Dark Mode"
$buttonTheme.Width = 100
$buttonTheme.Height = 35
$buttonTheme.Location = New-Object System.Drawing.Point(820, 18)
$buttonTheme.BackColor = $colorPrimary
$buttonTheme.ForeColor = [System.Drawing.Color]::White
$buttonTheme.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$buttonTheme.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonTheme.FlatAppearance.BorderSize = 0
$buttonTheme.Cursor = [Windows.Forms.Cursors]::Hand

$buttonTheme.Add_Click({
    $isDarkMode = -not $isDarkMode
    Write-Log "Tema degisti: $(if ($isDarkMode) { 'Dark Mode' } else { 'Light Mode' })"
})

$panelHeader.Controls.Add($buttonTheme)
$form.Controls.Add($panelHeader)

# === SCROLL PANEL (KATEGORILER) ===
$scrollPanel = New-Object Windows.Forms.Panel
$scrollPanel.Dock = [Windows.Forms.DockStyle]::Fill
$scrollPanel.AutoScroll = $true
$scrollPanel.BackColor = $colorDarkBg
$scrollPanel.Padding = New-Object Windows.Forms.Padding(10)

$y = 10
foreach ($kategori in $uygulamalarByKategori.Keys) {
    # Kategori Baslik
    $panelKategori = New-Object Windows.Forms.Panel
    $panelKategori.Width = 900
    $panelKategori.Height = 35
    $panelKategori.Location = New-Object System.Drawing.Point(10, $y)
    $panelKategori.BackColor = $colorDarkPanel
    $panelKategori.Cursor = [Windows.Forms.Cursors]::Hand
    
    $buttonKategori = New-Object Windows.Forms.Button
    $buttonKategori.Text = "â–¼ $kategori"
    $buttonKategori.Width = 900
    $buttonKategori.Height = 35
    $buttonKategori.Location = New-Object System.Drawing.Point(0, 0)
    $buttonKategori.BackColor = $colorDarkPanel
    $buttonKategori.ForeColor = $colorPrimary
    $buttonKategori.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $buttonKategori.FlatStyle = [Windows.Forms.FlatStyle]::Flat
    $buttonKategori.FlatAppearance.BorderSize = 1
    $buttonKategori.FlatAppearance.BorderColor = $colorPrimary
    
    $expandedGroups[$kategori] = $true
    
    $buttonKategori.Add_Click({
        $expandedGroups[$kategori] = -not $expandedGroups[$kategori]
        if ($expandedGroups[$kategori]) {
            $buttonKategori.Text = "â–¼ $kategori"
        } else {
            $buttonKategori.Text = "â–¶ $kategori"
        }
        Write-Log "Kategori toggle: $kategori -> $(if ($expandedGroups[$kategori]) { 'Expanded' } else { 'Collapsed' })"
    })
    
    $panelKategori.Controls.Add($buttonKategori)
    $scrollPanel.Controls.Add($panelKategori)
    $y += 40
    
    # Uygulamalar
    if ($expandedGroups[$kategori]) {
        foreach ($app in $uygulamalarByKategori[$kategori]) {
            $checkbox = New-Object Windows.Forms.CheckBox
            $checkbox.Text = $app.Ad
            $checkbox.Width = 900
            $checkbox.Height = 28
            $checkbox.Location = New-Object System.Drawing.Point(30, $y)
            $checkbox.BackColor = $colorDarkBg
            $checkbox.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
            $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
            $checkbox.Cursor = [Windows.Forms.Cursors]::Hand
            
            $checkbox.Add_CheckedChanged({
                $count = $checkboxes.Values | Where-Object { $_.Checked } | Measure-Object | Select-Object -ExpandProperty Count
                $labelCount.Text = "Secili: $count uygulama"
            })
            
            $scrollPanel.Controls.Add($checkbox)
            $checkboxes[$app.Paket] = $checkbox
            $y += 32
        }
    }
}

$form.Controls.Add($scrollPanel)

# === STATUS PANELI ===
$panelStatus = New-Object Windows.Forms.Panel
$panelStatus.Dock = [Windows.Forms.DockStyle]::Bottom
$panelStatus.Height = 100
$panelStatus.BackColor = $colorDarkPanel

$labelStatus = New-Object Windows.Forms.Label
$labelStatus.Text = "Hazir - Log dosyasi: $logFile"
$labelStatus.Location = New-Object System.Drawing.Point(15, 5)
$labelStatus.AutoSize = $true
$labelStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelStatus.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
$panelStatus.Controls.Add($labelStatus)

$progressBar = New-Object Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 25)
$progressBar.Width = 900
$progressBar.Height = 20
$progressBar.Style = [Windows.Forms.ProgressBarStyle]::Continuous
$panelStatus.Controls.Add($progressBar)

$labelCount = New-Object Windows.Forms.Label
$labelCount.Text = "Secili: 0 uygulama"
$labelCount.Location = New-Object System.Drawing.Point(15, 50)
$labelCount.AutoSize = $true
$labelCount.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelCount.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
$panelStatus.Controls.Add($labelCount)

$linkLog = New-Object Windows.Forms.LinkLabel
$linkLog.Text = "Log Dosyasini Ac"
$linkLog.Location = New-Object System.Drawing.Point(15, 70)
$linkLog.AutoSize = $true
$linkLog.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$linkLog.LinkColor = $colorPrimary
$linkLog.Add_Click({ Invoke-Item $logFile })
$panelStatus.Controls.Add($linkLog)

$form.Controls.Add($panelStatus)

# === FOOTER PANELI ===
$panelFooter = New-Object Windows.Forms.Panel
$panelFooter.Dock = [Windows.Forms.DockStyle]::Bottom
$panelFooter.Height = 60
$panelFooter.BackColor = $colorDarkPanel

$buttonInstall = New-Object Windows.Forms.Button
$buttonInstall.Text = "Indir ve Yukle"
$buttonInstall.Width = 140
$buttonInstall.Height = 40
$buttonInstall.Location = New-Object System.Drawing.Point(770, 10)
$buttonInstall.BackColor = $colorSuccess
$buttonInstall.ForeColor = [System.Drawing.Color]::White
$buttonInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonInstall.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonInstall.FlatAppearance.BorderSize = 0
$buttonInstall.Cursor = [Windows.Forms.Cursors]::Hand

$buttonInstall.Add_Click({
    $seciliUygulamalar = @($checkboxes.Keys | Where-Object { $checkboxes[$_].Checked })
    if ($seciliUygulamalar.Count -eq 0) {
        [Windows.Forms.MessageBox]::Show("Lutfen en az bir uygulama seciniz!", "Uyari", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        Write-Log "HATA: Hic uygulama secilmedi"
        return
    }
    
    Write-Log "Yukleme baslatildi - Secili: $($seciliUygulamalar.Count) uygulama"
    
    $buttonInstall.Enabled = $false
    $progressBar.Value = 0
    $form.Refresh()
    
    # WinGet Setup
    Write-Log "WinGet setup kontrol ediliyor..."
    $labelStatus.Text = "WinGet ayarlanÄ±yor..."
    $form.Refresh()
    
    try {
        winget source update 2>$null
        Write-Log "WinGet kaynaklar guncellendi"
    } catch {
        Write-Log "WinGet kaynak guncellemesi basarisiz - Devam ediliyor"
    }
    
    $basarili = 0
    $basarisiz = 0
    $toplam = $seciliUygulamalar.Count
    
    foreach ($paket in $seciliUygulamalar) {
        $appName = ""
        foreach ($kat in $uygulamalarByKategori.Values) {
            $found = $kat | Where-Object { $_.Paket -eq $paket }
            if ($found) {
                $appName = $found.Ad
                break
            }
        }
        
        $labelStatus.Text = "Indiriliyor: $appName (Paket: $paket)"
        Write-Log "YUKLEME BASLANDI: $appName"
        Write-Log "  Paket: $paket"
        Write-Log "  PowerShell Komutu: winget install $paket -e --silent --disable-interactivity"
        $form.Refresh()
        
        try {
            $output = winget install $paket -e --silent --disable-interactivity 2>&1
            Write-Log "  Sonuc: BASARILI"
            Write-Log "  Cikti: $output"
            $basarili++
        } catch {
            Write-Log "  Sonuc: BASARISIZ - $_"
            $basarisiz++
        }
        
        $progressBar.Value = [Math]::Min([Math]::Round((($basarili + $basarisiz) / $toplam) * 100), 100)
        $form.Refresh()
    }
    
    $labelStatus.Text = "Tamamlandi! $basarili/$toplam basarili - $basarisiz basarisiz"
    $progressBar.Value = 100
    $buttonInstall.Enabled = $true
    
    Write-Log "=== YUKLEME TAMAMLANDI ==="
    Write-Log "Basarili: $basarili"
    Write-Log "Basarisiz: $basarisiz"
    Write-Log "Toplam: $toplam"
    
    [Windows.Forms.MessageBox]::Show("Yukleme tamamlandi!`n`nBasarili: $basarili/$toplam`nBasarisiz: $basarisiz", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
})

$panelFooter.Controls.Add($buttonInstall)

$buttonExport = New-Object Windows.Forms.Button
$buttonExport.Text = "Export"
$buttonExport.Width = 90
$buttonExport.Height = 40
$buttonExport.Location = New-Object System.Drawing.Point(660, 10)
$buttonExport.BackColor = $colorPrimary
$buttonExport.ForeColor = [System.Drawing.Color]::White
$buttonExport.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonExport.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonExport.FlatAppearance.BorderSize = 0
$buttonExport.Cursor = [Windows.Forms.Cursors]::Hand

$buttonExport.Add_Click({
    $seciliUygulamalar = @($checkboxes.Keys | Where-Object { $checkboxes[$_].Checked })
    if ($seciliUygulamalar.Count -eq 0) {
        [Windows.Forms.MessageBox]::Show("Lutfen en az bir uygulama seciniz!", "Uyari", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }
    
    $saveDialog = New-Object Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "JSON dosyalari (*.json)|*.json|CSV dosyalari (*.csv)|*.csv"
    $saveDialog.DefaultExt = "json"
    $saveDialog.FileName = "WinDeploy_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').json"
    
    if ($saveDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
        $exportData = @{
            Uygulamalar = $seciliUygulamalar
            Tarih = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Versiyon = "4.0"
            Toplam = $seciliUygulamalar.Count
        }
        
        $exportData | ConvertTo-Json | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
        Write-Log "Export yapildi: $($saveDialog.FileName) - $($seciliUygulamalar.Count) uygulama"
        [Windows.Forms.MessageBox]::Show("Basariyla export edildi!`n`n$($saveDialog.FileName)", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
    }
})

$panelFooter.Controls.Add($buttonExport)

$buttonImport = New-Object Windows.Forms.Button
$buttonImport.Text = "Import"
$buttonImport.Width = 90
$buttonImport.Height = 40
$buttonImport.Location = New-Object System.Drawing.Point(555, 10)
$buttonImport.BackColor = $colorPrimary
$buttonImport.ForeColor = [System.Drawing.Color]::White
$buttonImport.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonImport.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonImport.FlatAppearance.BorderSize = 0
$buttonImport.Cursor = [Windows.Forms.Cursors]::Hand

$buttonImport.Add_Click({
    $openDialog = New-Object Windows.Forms.OpenFileDialog
    $openDialog.Filter = "JSON dosyalari (*.json)|*.json|Tum dosyalar (*.*)|*.*"
    
    if ($openDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
        try {
            $importData = Get-Content $openDialog.FileName -Raw | ConvertFrom-Json
            
            foreach ($cb in $checkboxes.Values) {
                $cb.Checked = $false
            }
            
            foreach ($paket in $importData.Uygulamalar) {
                if ($checkboxes.ContainsKey($paket)) {
                    $checkboxes[$paket].Checked = $true
                }
            }
            
            $labelCount.Text = "Secili: $($importData.Uygulamalar.Count) uygulama"
            Write-Log "Import yapildi: $($openDialog.FileName) - $($importData.Uygulamalar.Count) uygulama otomatik isareti kaldirÄ±ldÄ±"
            [Windows.Forms.MessageBox]::Show("Basariyla import edildi!`n`nSecili: $($importData.Uygulamalar.Count) uygulama", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        } catch {
            Write-Log "Import hatasi: $_"
            [Windows.Forms.MessageBox]::Show("Import sirasinda hata olustu!", "Hata", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        }
    }
})

$panelFooter.Controls.Add($buttonImport)

$buttonHepsi = New-Object Windows.Forms.Button
$buttonHepsi.Text = "Hepsi"
$buttonHepsi.Width = 60
$buttonHepsi.Height = 40
$buttonHepsi.Location = New-Object System.Drawing.Point(10, 10)
$buttonHepsi.BackColor = $colorPrimary
$buttonHepsi.ForeColor = [System.Drawing.Color]::White
$buttonHepsi.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonHepsi.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonHepsi.FlatAppearance.BorderSize = 0
$buttonHepsi.Cursor = [Windows.Forms.Cursors]::Hand

$buttonHepsi.Add_Click({
    $seciliOncekiCozum = $checkboxes.Values | Where-Object { $_.Checked } | Measure-Object | Select-Object -ExpandProperty Count
    foreach ($cb in $checkboxes.Values) {
        $cb.Checked = -not $cb.Checked
    }
    $seciliSonra = $checkboxes.Values | Where-Object { $_.Checked } | Measure-Object | Select-Object -ExpandProperty Count
    Write-Log "Hepsi butonu - Onceki: $seciliOncekiCozum, Sonra: $seciliSonra"
})

$panelFooter.Controls.Add($buttonHepsi)

$buttonTemizle = New-Object Windows.Forms.Button
$buttonTemizle.Text = "Temizle"
$buttonTemizle.Width = 75
$buttonTemizle.Height = 40
$buttonTemizle.Location = New-Object System.Drawing.Point(80, 10)
$buttonTemizle.BackColor = $colorDanger
$buttonTemizle.ForeColor = [System.Drawing.Color]::White
$buttonTemizle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonTemizle.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonTemizle.FlatAppearance.BorderSize = 0
$buttonTemizle.Cursor = [Windows.Forms.Cursors]::Hand

$buttonTemizle.Add_Click({
    $seciliOnceki = $checkboxes.Values | Where-Object { $_.Checked } | Measure-Object | Select-Object -ExpandProperty Count
    foreach ($cb in $checkboxes.Values) {
        $cb.Checked = $false
    }
    Write-Log "Temizle butonu - Onceki secili: $seciliOnceki, Simdi: 0"
})

$panelFooter.Controls.Add($buttonTemizle)

$form.Controls.Add($panelFooter)

Write-Log "GUI Olusturuldu - Tamamlanmis uygulama sayisi: $($uygulamalarByKategori.Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum)"

# Form goster
$form.ShowDialog() | Out-Null

Write-Log "=== WinDeploy v4.0 Kapatildi ==="
