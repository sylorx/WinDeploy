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

# Global Theme - Dark Mode varsayilan
$isDarkMode = $true

# Renkler
$colorDarkBg = [System.Drawing.Color]::FromArgb(30, 30, 30)
$colorDarkPanel = [System.Drawing.Color]::FromArgb(45, 45, 45)
$colorLightBg = [System.Drawing.Color]::FromArgb(240, 240, 240)
$colorLightPanel = [System.Drawing.Color]::FromArgb(255, 255, 255)
$colorPrimary = [System.Drawing.Color]::FromArgb(0, 150, 215)
$colorSuccess = [System.Drawing.Color]::FromArgb(0, 200, 83)
$colorDanger = [System.Drawing.Color]::FromArgb(220, 53, 69)

# Genis uygulama listesi
$uygulamalar = @(
    @{Ad = "Google Chrome"; Paket = "Google.Chrome"}
    @{Ad = "Firefox"; Paket = "Mozilla.Firefox"}
    @{Ad = "Brave Browser"; Paket = "BraveSoftware.BraveBrowser"}
    @{Ad = "Visual Studio Code"; Paket = "Microsoft.VisualStudioCode"}
    @{Ad = "Discord"; Paket = "Discord.Discord"}
    @{Ad = "Telegram"; Paket = "Telegram.TelegramDesktop"}
    @{Ad = "VLC Media Player"; Paket = "VideoLAN.VLC"}
    @{Ad = "7-Zip"; Paket = "7zip.7zip"}
    @{Ad = "Notepad++"; Paket = "Notepad++.Notepad++"}
    @{Ad = "Git"; Paket = "Git.Git"}
    @{Ad = "PowerToys"; Paket = "Microsoft.PowerToys"}
    @{Ad = "OBS Studio"; Paket = "OBSProject.OBSStudio"}
    @{Ad = "Audacity"; Paket = "Audacity.Audacity"}
    @{Ad = "GIMP"; Paket = "GNU.GIMP"}
    @{Ad = "Blender"; Paket = "BlenderFoundation.Blender"}
    @{Ad = "Figma"; Paket = "Figma.Figma"}
    @{Ad = "FileZilla"; Paket = "FileZilla.FileZilla"}
    @{Ad = "Putty"; Paket = "PuTTY.PuTTY"}
    @{Ad = "VirtualBox"; Paket = "Oracle.VirtualBox"}
    @{Ad = "Docker"; Paket = "Docker.DockerDesktop"}
    @{Ad = "Node.js"; Paket = "OpenJS.NodeJS"}
    @{Ad = "Python"; Paket = "Python.Python.3.11"}
    @{Ad = "Java JDK"; Paket = "Oracle.JDK.21"}
    @{Ad = "Visual Studio Community"; Paket = "Microsoft.VisualStudio.Community"}
    @{Ad = "Postman"; Paket = "Postman.Postman"}
    @{Ad = "Android Studio"; Paket = "Google.AndroidStudio"}
    @{Ad = "Steam"; Paket = "Valve.Steam"}
    @{Ad = "Epic Games Launcher"; Paket = "EpicGames.EpicGamesLauncher"}
    @{Ad = "Spotify"; Paket = "Spotify.Spotify"}
    @{Ad = "WinRAR"; Paket = "RARLab.WinRAR"}
)

# Checkboxlar icin dict
$checkboxes = @{}
$selectedApps = @()

# Ana Form
$form = New-Object Windows.Forms.Form
$form.Text = "WinDeploy v3.0 - Windows Uygulama Yoneticisi"
$form.Width = 900
$form.Height = 700
$form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = $colorDarkBg
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# === BASLIK PANELI ===
$panelHeader = New-Object Windows.Forms.Panel
$panelHeader.Dock = [Windows.Forms.DockStyle]::Top
$panelHeader.Height = 70
$panelHeader.BackColor = $colorDarkPanel

$labelTitle = New-Object Windows.Forms.Label
$labelTitle.Text = "WinDeploy"
$labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$labelTitle.ForeColor = $colorPrimary
$labelTitle.Location = New-Object System.Drawing.Point(15, 12)
$labelTitle.AutoSize = $true
$panelHeader.Controls.Add($labelTitle)

$buttonTheme = New-Object Windows.Forms.Button
$buttonTheme.Text = "Dark Mode"
$buttonTheme.Width = 100
$buttonTheme.Height = 35
$buttonTheme.Location = New-Object System.Drawing.Point(750, 18)
$buttonTheme.BackColor = $colorPrimary
$buttonTheme.ForeColor = [System.Drawing.Color]::White
$buttonTheme.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$buttonTheme.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$buttonTheme.FlatAppearance.BorderSize = 0
$buttonTheme.Cursor = [Windows.Forms.Cursors]::Hand

$buttonTheme.Add_Click({
    $isDarkMode = -not $isDarkMode
    if ($isDarkMode) {
        $form.BackColor = $colorDarkBg
        $panelHeader.BackColor = $colorDarkPanel
        $panelFooter.BackColor = $colorDarkPanel
        $scrollPanel.BackColor = $colorDarkBg
        $panelStatus.BackColor = $colorDarkPanel
        $labelTitle.ForeColor = $colorPrimary
        $labelStatus.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $labelCount.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $buttonTheme.Text = "Dark Mode"
        foreach ($cb in $checkboxes.Values) {
            $cb.BackColor = $colorDarkPanel
            $cb.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        }
    } else {
        $form.BackColor = $colorLightBg
        $panelHeader.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
        $panelFooter.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
        $scrollPanel.BackColor = $colorLightBg
        $panelStatus.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
        $labelTitle.ForeColor = $colorPrimary
        $labelStatus.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
        $labelCount.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
        $buttonTheme.Text = "Light Mode"
        foreach ($cb in $checkboxes.Values) {
            $cb.BackColor = $colorLightPanel
            $cb.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
        }
    }
})

$panelHeader.Controls.Add($buttonTheme)
$form.Controls.Add($panelHeader)

# === SCROLL PANEL (CHECKBOX'LAR) ===
$scrollPanel = New-Object Windows.Forms.Panel
$scrollPanel.Dock = [Windows.Forms.DockStyle]::Fill
$scrollPanel.AutoScroll = $true
$scrollPanel.BackColor = $colorDarkBg
$scrollPanel.Padding = New-Object Windows.Forms.Padding(15)

# Checkboxlar olustur
$y = 10
foreach ($app in $uygulamalar) {
    $checkbox = New-Object Windows.Forms.CheckBox
    $checkbox.Text = $app.Ad
    $checkbox.Width = 850
    $checkbox.Height = 30
    $checkbox.Location = New-Object System.Drawing.Point(10, $y)
    $checkbox.BackColor = $colorDarkPanel
    $checkbox.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $checkbox.Cursor = [Windows.Forms.Cursors]::Hand
    $checkbox.Padding = New-Object Windows.Forms.Padding(5)
    
    $checkbox.Add_CheckedChanged({
        $labelCount.Text = "Secili: $($checkboxes.Values | Where-Object { $_.Checked } | Measure-Object).Count"
    })
    
    $scrollPanel.Controls.Add($checkbox)
    $checkboxes[$app.Paket] = $checkbox
    $y += 35
}

$form.Controls.Add($scrollPanel)

# === STATUS PANELI ===
$panelStatus = New-Object Windows.Forms.Panel
$panelStatus.Dock = [Windows.Forms.DockStyle]::Bottom
$panelStatus.Height = 80
$panelStatus.BackColor = $colorDarkPanel

$labelStatus = New-Object Windows.Forms.Label
$labelStatus.Text = "Hazir"
$labelStatus.Location = New-Object System.Drawing.Point(15, 10)
$labelStatus.AutoSize = $true
$labelStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelStatus.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$panelStatus.Controls.Add($labelStatus)

$progressBar = New-Object Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 30)
$progressBar.Width = 850
$progressBar.Height = 20
$progressBar.Style = [Windows.Forms.ProgressBarStyle]::Continuous
$panelStatus.Controls.Add($progressBar)

$labelCount = New-Object Windows.Forms.Label
$labelCount.Text = "Secili: 0"
$labelCount.Location = New-Object System.Drawing.Point(15, 55)
$labelCount.AutoSize = $true
$labelCount.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelCount.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$panelStatus.Controls.Add($labelCount)

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
$buttonInstall.Location = New-Object System.Drawing.Point(650, 10)
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
        return
    }
    
    $buttonInstall.Enabled = $false
    $progressBar.Value = 0
    $form.Refresh()
    
    $basarili = 0
    $toplam = $seciliUygulamalar.Count
    
    foreach ($paket in $seciliUygulamalar) {
        $appName = ($uygulamalar | Where-Object { $_.Paket -eq $paket }).Ad
        $labelStatus.Text = "Indiriliyor: $appName"
        $form.Refresh()
        
        try {
            winget install $paket -e --silent --disable-interactivity 2>$null
            $basarili++
        } catch {
            # Devam et
        }
        
        $progressBar.Value = [Math]::Min([Math]::Round(($basarili / $toplam) * 100), 100)
        $form.Refresh()
    }
    
    $labelStatus.Text = "Tamamlandi! $basarili/$toplam uygulama yuklendi"
    $progressBar.Value = 100
    $buttonInstall.Enabled = $true
    
    [Windows.Forms.MessageBox]::Show("Yukleme tamamlandi!`n`nBasarili: $basarili/$toplam", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
})

$panelFooter.Controls.Add($buttonInstall)

$buttonExport = New-Object Windows.Forms.Button
$buttonExport.Text = "Export"
$buttonExport.Width = 90
$buttonExport.Height = 40
$buttonExport.Location = New-Object System.Drawing.Point(545, 10)
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
    $saveDialog.Filter = "JSON dosyalari (*.json)|*.json|Tum dosyalar (*.*)|*.*"
    $saveDialog.DefaultExt = "json"
    $saveDialog.FileName = "WinDeploy_Uygulamalar_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').json"
    
    if ($saveDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
        $exportData = @{
            Uygulamalar = $seciliUygulamalar
            Tarih = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Versiyon = "3.0"
        }
        
        $exportData | ConvertTo-Json | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
        [Windows.Forms.MessageBox]::Show("Basariyla export edildi!`n`n$($saveDialog.FileName)", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
    }
})

$panelFooter.Controls.Add($buttonExport)

$buttonImport = New-Object Windows.Forms.Button
$buttonImport.Text = "Import"
$buttonImport.Width = 90
$buttonImport.Height = 40
$buttonImport.Location = New-Object System.Drawing.Point(440, 10)
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
            
            # Tum checkboxlari unchecked yap
            foreach ($cb in $checkboxes.Values) {
                $cb.Checked = $false
            }
            
            # Secili olanlar kontrol et
            foreach ($paket in $importData.Uygulamalar) {
                if ($checkboxes.ContainsKey($paket)) {
                    $checkboxes[$paket].Checked = $true
                }
            }
            
            $labelCount.Text = "Secili: $($importData.Uygulamalar.Count)"
            [Windows.Forms.MessageBox]::Show("Basariyla import edildi!`n`nSecili: $($importData.Uygulamalar.Count) uygulama", "Basarili", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        } catch {
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
    foreach ($cb in $checkboxes.Values) {
        $cb.Checked = -not $cb.Checked
    }
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
    foreach ($cb in $checkboxes.Values) {
        $cb.Checked = $false
    }
})

$panelFooter.Controls.Add($buttonTemizle)

$form.Controls.Add($panelFooter)

# Form ozelliklerini ayarla
$form.TopMost = $true
Start-Sleep -Milliseconds 200
$form.TopMost = $false

# Formu goster
$form.ShowDialog() | Out-Null
