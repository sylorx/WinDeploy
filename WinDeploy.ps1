[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    [Windows.Forms.MessageBox]::Show("Yonetici izni gerekli!", "Hata", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    exit 1
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$logPath = "$env:APPDATA\WinDeploy"
if (-not (Test-Path $logPath)) { New-Item -ItemType Directory -Path $logPath | Out-Null }
$logFile = "$logPath\WinDeploy_$(Get-Date -Format 'yyyy-MM-dd').log"

function Write-Log {
    param([string]$Message)
    try {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "[$timestamp] $Message"
        Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
        Write-Host $logEntry -ForegroundColor Cyan -ErrorAction SilentlyContinue
    } catch {}
}

function Check-WinGet {
    try {
        $wingetPath = Get-Command winget -ErrorAction SilentlyContinue
        if ($wingetPath) {
            Write-Log "WinGet tespit edildi: $($wingetPath.Source)"
            return $true
        }
        Write-Log "WinGet bulunamadi - Kurulum gerekli"
        return $false
    } catch {
        Write-Log "WinGet kontrol hatasi"
        return $false
    }
}

function Install-WinGet {
    Write-Log "WinGet kuruluyor..."
    try {
        $ProgressPreference = "SilentlyContinue"
        $appxUrl = "https://github.com/microsoft/winget-cli/releases/download/v1.6.3231/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        $tempPath = "$env:TEMP\WinGet.msixbundle"
        
        Write-Log "WinGet indiriliyorr: $appxUrl"
        Invoke-WebRequest -Uri $appxUrl -OutFile $tempPath -ErrorAction SilentlyContinue
        
        if (Test-Path $tempPath) {
            Write-Log "WinGet paketi indirilen - Kurulum baslatiliyor"
            Add-AppxPackage -Path $tempPath -ForceUpdateFromAnyVersion -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 3
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
            Write-Log "WinGet kuruldu"
            return $true
        } else {
            Write-Log "WinGet indirme basarisiz"
            return $false
        }
    } catch {
        Write-Log "WinGet kurulum hatasi: $_"
        return $false
    }
}

function Check-Chocolatey {
    try {
        $chocoPath = Get-Command choco -ErrorAction SilentlyContinue
        if ($chocoPath) {
            Write-Log "Chocolatey tespit edildi: $($chocoPath.Source)"
            return $true
        }
        Write-Log "Chocolatey bulunamadi - Kurulum gerekli"
        return $false
    } catch {
        Write-Log "Chocolatey kontrol hatasi"
        return $false
    }
}

function Install-Chocolatey {
    Write-Log "Chocolatey kuruluyor..."
    try {
        $ProgressPreference = "SilentlyContinue"
        $chocoScript = "https://community.chocolatey.org/install.ps1"
        
        Write-Log "Chocolatey script indiriliyor: $chocoScript"
        $script = (New-Object Net.WebClient).DownloadString($chocoScript)
        
        if ($script) {
            Write-Log "Chocolatey kurulum baslatiliyor"
            Invoke-Expression $script
            Write-Log "Chocolatey kuruldu"
            return $true
        } else {
            Write-Log "Chocolatey script indirme basarisiz"
            return $false
        }
    } catch {
        Write-Log "Chocolatey kurulum hatasi: $_"
        return $false
    }
}

Write-Log "=== WinDeploy v5.2 Basladi ==="
Write-Log "Paket Yoneticileri Kontrol Ediliyor..."

$isDarkMode = $true
$colorDarkBg = [System.Drawing.Color]::FromArgb(30, 30, 30)
$colorDarkPanel = [System.Drawing.Color]::FromArgb(45, 45, 45)
$colorPrimary = [System.Drawing.Color]::FromArgb(0, 150, 215)
$colorSuccess = [System.Drawing.Color]::FromArgb(0, 200, 83)
$colorDanger = [System.Drawing.Color]::FromArgb(220, 53, 69)

$selectedPackageManager = "WinGet"

$uygulamalarByKategori = @{
    "Tarayicilar" = @(
        @{Ad = "Google Chrome"; WinGet = "Google.Chrome"; Chocolatey = "googlechrome"}
        @{Ad = "Firefox"; WinGet = "Mozilla.Firefox"; Chocolatey = "firefox"}
        @{Ad = "Brave"; WinGet = "BraveSoftware.BraveBrowser"; Chocolatey = "brave"}
        @{Ad = "Opera"; WinGet = "Opera.Opera"; Chocolatey = "opera"}
        @{Ad = "Edge"; WinGet = "Microsoft.Edge"; Chocolatey = "microsoft-edge"}
    )
    "Multimedia" = @(
        @{Ad = "Spotify"; WinGet = "Spotify.Spotify"; Chocolatey = "spotify"}
        @{Ad = "VLC"; WinGet = "VideoLAN.VLC"; Chocolatey = "vlc"}
        @{Ad = "OBS Studio"; WinGet = "OBSProject.OBSStudio"; Chocolatey = "obs-studio"}
        @{Ad = "Audacity"; WinGet = "Audacity.Audacity"; Chocolatey = "audacity"}
    )
    "Gelistirme" = @(
        @{Ad = "Visual Studio Code"; WinGet = "Microsoft.VisualStudioCode"; Chocolatey = "vscode"}
        @{Ad = "Git"; WinGet = "Git.Git"; Chocolatey = "git"}
        @{Ad = "Python"; WinGet = "Python.Python.3.11"; Chocolatey = "python"}
        @{Ad = "Node.js"; WinGet = "OpenJS.NodeJS"; Chocolatey = "nodejs"}
        @{Ad = "Docker"; WinGet = "Docker.DockerDesktop"; Chocolatey = "docker-desktop"}
        @{Ad = "Postman"; WinGet = "Postman.Postman"; Chocolatey = "postman"}
    )
    "Sistem" = @(
        @{Ad = "PowerToys"; WinGet = "Microsoft.PowerToys"; Chocolatey = "powertoys"}
        @{Ad = "7-Zip"; WinGet = "7zip.7zip"; Chocolatey = "7zip"}
        @{Ad = "Notepad++"; WinGet = "Notepad++.Notepad++"; Chocolatey = "notepadplusplus"}
        @{Ad = "VirtualBox"; WinGet = "Oracle.VirtualBox"; Chocolatey = "virtualbox"}
    )
    "Oyun" = @(
        @{Ad = "Steam"; WinGet = "Valve.Steam"; Chocolatey = "steam"}
        @{Ad = "Epic Games"; WinGet = "EpicGames.EpicGamesLauncher"; Chocolatey = "epicgameslauncher"}
    )
}

$checkboxes = @{}
$expandedGroups = @{}

# === OTOMATIK PAKET YONETICISI KURULUMU (HEMEN) ===
Write-Log "Kurulum Kontrol Asamasi Baslaniyor..."
Write-Host ""
Write-Host "Paket yoneticileri kontrol ediliyor..." -ForegroundColor Yellow

if (-not (Check-WinGet)) {
    Write-Log "WinGet OTOMATIK kuruluyor..."
    Write-Host "WinGet kuruluyor... Lutfen bekleyiniz..." -ForegroundColor Yellow
    Install-WinGet
    Start-Sleep -Seconds 2
}

if (-not (Check-Chocolatey)) {
    Write-Log "Chocolatey OTOMATIK kuruluyor..."
    Write-Host "Chocolatey kuruluyor... Lutfen bekleyiniz..." -ForegroundColor Yellow
    Install-Chocolatey
    Start-Sleep -Seconds 2
}

Write-Log "Kurulum Kontrol Tamamlandi"
Write-Host "Hazirlik tamamlandi - GUI aciliyor..." -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 1

$form = New-Object Windows.Forms.Form
$form.Text = "WinDeploy v5.2"
$form.Width = 950
$form.Height = 750
$form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = $colorDarkBg
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

try {
    $panelHeader = New-Object Windows.Forms.Panel
    $panelHeader.Dock = [Windows.Forms.DockStyle]::Top
    $panelHeader.Height = 75
    $panelHeader.BackColor = $colorDarkPanel

    $labelTitle = New-Object Windows.Forms.Label
    $labelTitle.Text = "WinDeploy v5.2"
    $labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $labelTitle.ForeColor = $colorPrimary
    $labelTitle.Location = New-Object System.Drawing.Point(15, 12)
    $labelTitle.AutoSize = $true
    $panelHeader.Controls.Add($labelTitle)

    $labelManager = New-Object Windows.Forms.Label
    $labelManager.Text = "Paket Yoneticisi:"
    $labelManager.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $labelManager.ForeColor = [System.Drawing.Color]::White
    $labelManager.Location = New-Object System.Drawing.Point(650, 15)
    $labelManager.AutoSize = $true
    $panelHeader.Controls.Add($labelManager)

    $comboManager = New-Object Windows.Forms.ComboBox
    $comboManager.Items.AddRange(@("WinGet", "Chocolatey"))
    $comboManager.SelectedItem = "WinGet"
    $comboManager.Location = New-Object System.Drawing.Point(650, 38)
    $comboManager.Width = 120
    $comboManager.Height = 25
    $comboManager.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
    $comboManager.ForeColor = [System.Drawing.Color]::White
    $comboManager.Add_SelectedIndexChanged({
        $selectedPackageManager = $comboManager.SelectedItem
        Write-Log "Paket Yoneticisi: $selectedPackageManager"
    })
    $panelHeader.Controls.Add($comboManager)

    $form.Controls.Add($panelHeader)

    $scrollPanel = New-Object Windows.Forms.Panel
    $scrollPanel.Dock = [Windows.Forms.DockStyle]::Fill
    $scrollPanel.AutoScroll = $true
    $scrollPanel.BackColor = $colorDarkBg
    $scrollPanel.Padding = New-Object Windows.Forms.Padding(10)

    $y = 10
    foreach ($kategori in $uygulamalarByKategori.Keys) {
        $panelKategori = New-Object Windows.Forms.Panel
        $panelKategori.Width = 900
        $panelKategori.Height = 35
        $panelKategori.Location = New-Object System.Drawing.Point(10, $y)
        $panelKategori.BackColor = $colorDarkPanel

        $buttonKategori = New-Object Windows.Forms.Button
        $buttonKategori.Text = "[+] $kategori"
        $buttonKategori.Width = 900
        $buttonKategori.Height = 35
        $buttonKategori.Location = New-Object System.Drawing.Point(0, 0)
        $buttonKategori.BackColor = $colorDarkPanel
        $buttonKategori.ForeColor = $colorPrimary
        $buttonKategori.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $buttonKategori.FlatStyle = [Windows.Forms.FlatStyle]::Flat
        $buttonKategori.FlatAppearance.BorderSize = 1
        $buttonKategori.FlatAppearance.BorderColor = $colorPrimary
        $buttonKategori.Tag = $kategori

        $expandedGroups[$kategori] = $true
        $buttonKategori.Text = "[-] $kategori"

        $buttonKategori.Add_Click({
            $kat = $buttonKategori.Tag
            $expandedGroups[$kat] = -not $expandedGroups[$kat]
            $buttonKategori.Text = if ($expandedGroups[$kat]) { "[-] $kat" } else { "[+] $kat" }
        })

        $panelKategori.Controls.Add($buttonKategori)
        $scrollPanel.Controls.Add($panelKategori)
        $y += 40

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
                    $count = @($checkboxes.Values | Where-Object { $_.Checkbox.Checked }).Count
                    $labelCount.Text = "Secili: $count uygulama"
                })

                $scrollPanel.Controls.Add($checkbox)
                $checkboxes[$app.Ad] = @{Checkbox = $checkbox; Data = $app}
                $y += 32
            }
        }
    }

    $form.Controls.Add($scrollPanel)

    $panelStatus = New-Object Windows.Forms.Panel
    $panelStatus.Dock = [Windows.Forms.DockStyle]::Bottom
    $panelStatus.Height = 80
    $panelStatus.BackColor = $colorDarkPanel

    $labelStatus = New-Object Windows.Forms.Label
    $labelStatus.Text = "Hazir"
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

    $form.Controls.Add($panelStatus)

    $panelFooter = New-Object Windows.Forms.Panel
    $panelFooter.Dock = [Windows.Forms.DockStyle]::Bottom
    $panelFooter.Height = 60
    $panelFooter.BackColor = $colorDarkPanel

    $buttonInstall = New-Object Windows.Forms.Button
    $buttonInstall.Text = "Indir ve Yukle"
    $buttonInstall.Width = 140
    $buttonInstall.Height = 40
    $buttonInstall.Location = New-Object System.Drawing.Point(760, 10)
    $buttonInstall.BackColor = $colorSuccess
    $buttonInstall.ForeColor = [System.Drawing.Color]::White
    $buttonInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $buttonInstall.FlatStyle = [Windows.Forms.FlatStyle]::Flat
    $buttonInstall.FlatAppearance.BorderSize = 0
    $buttonInstall.Cursor = [Windows.Forms.Cursors]::Hand

    $buttonInstall.Add_Click({
        $selectedApps = @($checkboxes.Keys | Where-Object { $checkboxes[$_].Checkbox.Checked })
        
        if ($selectedApps.Count -eq 0) {
            [Windows.Forms.MessageBox]::Show("Lutfen en az bir uygulama seciniz!", "Uyari", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            Write-Log "HATA: Hic uygulama secilmedi"
            return
        }

        $manager = $comboManager.SelectedItem
        Write-Log "=== YUKLEME BASLANDI ==="
        Write-Log "Paket Yoneticisi: $manager"
        Write-Log "Toplam Uygulama: $($selectedApps.Count)"

        $buttonInstall.Enabled = $false
        $progressBar.Value = 0
        $form.Refresh()

        $basarili = 0
        $basarisiz = 0
        $toplam = $selectedApps.Count

        foreach ($appName in $selectedApps) {
            $appData = $checkboxes[$appName].Data
            $paket = if ($manager -eq "WinGet") { $appData.WinGet } else { $appData.Chocolatey }

            $labelStatus.Text = "Indiriliyor: $appName"
            Write-Log "UYGULAMA: $appName"
            Write-Log "  Paket Yoneticisi: $manager"
            Write-Log "  Paket: $paket"
            $form.Refresh()

            try {
                if ($manager -eq "WinGet") {
                    Write-Log "  Komut: winget install $paket -e --silent --disable-interactivity"
                    $exitCode = (cmd /c "winget install $paket -e --silent --disable-interactivity" 2>&1; echo $LASTEXITCODE)
                    $lastCode = $exitCode[-1]
                    
                    if ($lastCode -eq "0" -or $lastCode -eq $null) {
                        Write-Log "  Sonuc: BASARILI (Exit Code: $lastCode)"
                        $basarili++
                    } else {
                        Write-Log "  Sonuc: BASARISIZ (Exit Code: $lastCode)"
                        $basarisiz++
                    }
                } else {
                    Write-Log "  Komut: choco install $paket -y"
                    $output = & choco install $paket -y 2>&1
                    
                    if ($output -match "installed" -or $output -match "up to date") {
                        Write-Log "  Sonuc: BASARILI"
                        $basarili++
                    } else {
                        Write-Log "  Sonuc: BASARISIZ"
                        $basarisiz++
                    }
                }
            } catch {
                Write-Log "  HATA: $_"
                $basarisiz++
            }

            $progressBar.Value = [Math]::Min([Math]::Round((($basarili + $basarisiz) / $toplam) * 100), 100)
            $form.Refresh()
            Start-Sleep -Milliseconds 500
        }

        $labelStatus.Text = "Tamamlandi! $basarili/$toplam basarili"
        $progressBar.Value = 100
        $buttonInstall.Enabled = $true

        Write-Log "=== YUKLEME TAMAMLANDI ==="
        Write-Log "Basarili: $basarili | Basarisiz: $basarisiz | Toplam: $toplam"

        [Windows.Forms.MessageBox]::Show("Yukleme Tamamlandi!`n`nBasarili: $basarili`nBasarisiz: $basarisiz", "Tamamlandi", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
    })

    $panelFooter.Controls.Add($buttonInstall)

    $buttonExport = New-Object Windows.Forms.Button
    $buttonExport.Text = "Export"
    $buttonExport.Width = 90
    $buttonExport.Height = 40
    $buttonExport.Location = New-Object System.Drawing.Point(650, 10)
    $buttonExport.BackColor = $colorPrimary
    $buttonExport.ForeColor = [System.Drawing.Color]::White
    $buttonExport.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $buttonExport.FlatStyle = [Windows.Forms.FlatStyle]::Flat
    $buttonExport.FlatAppearance.BorderSize = 0
    $buttonExport.Cursor = [Windows.Forms.Cursors]::Hand

    $buttonExport.Add_Click({
        $selectedApps = @($checkboxes.Keys | Where-Object { $checkboxes[$_].Checkbox.Checked })
        if ($selectedApps.Count -eq 0) {
            [Windows.Forms.MessageBox]::Show("Lutfen uygulama seciniz!", "Uyari", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            return
        }

        $saveDialog = New-Object Windows.Forms.SaveFileDialog
        $saveDialog.Filter = "JSON dosyalari (*.json)|*.json"
        $saveDialog.DefaultExt = "json"
        $saveDialog.FileName = "WinDeploy_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').json"

        if ($saveDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
            $exportData = @{
                Uygulamalar = $selectedApps
                Tarih = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                Versiyon = "5.2"
            }
            $exportData | ConvertTo-Json | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
            Write-Log "Export yapildi: $($saveDialog.FileName)"
            [Windows.Forms.MessageBox]::Show("Export Basarili!", "OK", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        }
    })

    $panelFooter.Controls.Add($buttonExport)

    $buttonImport = New-Object Windows.Forms.Button
    $buttonImport.Text = "Import"
    $buttonImport.Width = 90
    $buttonImport.Height = 40
    $buttonImport.Location = New-Object System.Drawing.Point(540, 10)
    $buttonImport.BackColor = $colorPrimary
    $buttonImport.ForeColor = [System.Drawing.Color]::White
    $buttonImport.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $buttonImport.FlatStyle = [Windows.Forms.FlatStyle]::Flat
    $buttonImport.FlatAppearance.BorderSize = 0
    $buttonImport.Cursor = [Windows.Forms.Cursors]::Hand

    $buttonImport.Add_Click({
        $openDialog = New-Object Windows.Forms.OpenFileDialog
        $openDialog.Filter = "JSON dosyalari (*.json)|*.json"

        if ($openDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
            try {
                $importData = Get-Content $openDialog.FileName -Raw | ConvertFrom-Json
                foreach ($cb in $checkboxes.Values) { $cb.Checkbox.Checked = $false }
                foreach ($appName in $importData.Uygulamalar) {
                    if ($checkboxes.ContainsKey($appName)) {
                        $checkboxes[$appName].Checkbox.Checked = $true
                    }
                }
                Write-Log "Import yapildi: $($importData.Uygulamalar.Count) uygulama"
                [Windows.Forms.MessageBox]::Show("Import OK! $($importData.Uygulamalar.Count) uygulama", "Tamamlandi", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
            } catch {
                Write-Log "Import Hatasi: $_"
                [Windows.Forms.MessageBox]::Show("Hata!", "Hata", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
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
        foreach ($cb in $checkboxes.Values) { $cb.Checkbox.Checked = -not $cb.Checkbox.Checked }
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
        foreach ($cb in $checkboxes.Values) { $cb.Checkbox.Checked = $false }
    })

    $panelFooter.Controls.Add($buttonTemizle)

    $form.Controls.Add($panelFooter)

    Write-Log "GUI Basariyla Olusturuldu"

    [void]$form.ShowDialog()

} catch {
    Write-Log "KRITIK HATA: $_"
    [Windows.Forms.MessageBox]::Show("HATA: $_", "ERROR", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
}

Write-Log "=== WinDeploy Kapatildi ==="
