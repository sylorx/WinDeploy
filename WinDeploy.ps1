[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"

trap {
    Write-Host "KRITIK HATA: $_" -ForegroundColor Red
    exit 1
}

try {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "Hata: Yonetici izni gerekli!" -ForegroundColor Red
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
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "[$timestamp] $Message"
        Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
        Write-Host $logEntry -ForegroundColor Cyan -ErrorAction SilentlyContinue
    }

    Write-Log "=== WinDeploy v5.3 Basladi ==="
    
    # === OTOMATIK KURULUM BASLA ===
    Write-Host ""
    Write-Host "Paket yoneticileri kontrol ediliyor..." -ForegroundColor Yellow
    
    $wingetCheck = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetCheck) {
        Write-Host "WinGet kuruluyor..." -ForegroundColor Yellow
        Write-Log "WinGet kuruluyor..."
        try {
            $ProgressPreference = "SilentlyContinue"
            $url = "https://github.com/microsoft/winget-cli/releases/download/v1.6.3231/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
            $temp = "$env:TEMP\WinGet.msixbundle"
            (New-Object Net.WebClient).DownloadFile($url, $temp)
            if (Test-Path $temp) {
                Add-AppxPackage -Path $temp -ForceUpdateFromAnyVersion -ErrorAction SilentlyContinue
                Remove-Item $temp -Force -ErrorAction SilentlyContinue
                Write-Host "WinGet kuruldu" -ForegroundColor Green
                Write-Log "WinGet kuruldu"
                Start-Sleep -Seconds 2
            }
        } catch {
            Write-Log "WinGet kurulum hatasi: $_"
        }
    } else {
        Write-Host "WinGet zaten kurulu" -ForegroundColor Green
        Write-Log "WinGet tespit edildi"
    }

    $chocoCheck = Get-Command choco -ErrorAction SilentlyContinue
    if (-not $chocoCheck) {
        Write-Host "Chocolatey kuruluyor..." -ForegroundColor Yellow
        Write-Log "Chocolatey kuruluyor..."
        try {
            $ProgressPreference = "SilentlyContinue"
            $url = "https://community.chocolatey.org/install.ps1"
            $script = (New-Object Net.WebClient).DownloadString($url)
            if ($script) {
                Invoke-Expression $script
                Write-Host "Chocolatey kuruldu" -ForegroundColor Green
                Write-Log "Chocolatey kuruldu"
                Start-Sleep -Seconds 2
            }
        } catch {
            Write-Log "Chocolatey kurulum hatasi: $_"
        }
    } else {
        Write-Host "Chocolatey zaten kurulu" -ForegroundColor Green
        Write-Log "Chocolatey tespit edildi"
    }

    Write-Host "Hazirlik tamamlandi - GUI aciliyor..." -ForegroundColor Green
    Write-Host ""
    Start-Sleep -Seconds 1

    # === RENKLER ===
    $colorDarkBg = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $colorDarkPanel = [System.Drawing.Color]::FromArgb(45, 45, 45)
    $colorPrimary = [System.Drawing.Color]::FromArgb(0, 150, 215)
    $colorSuccess = [System.Drawing.Color]::FromArgb(0, 200, 83)
    $colorDanger = [System.Drawing.Color]::FromArgb(220, 53, 69)

    # === UYGULAMALAR ===
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
    $selectedManager = "WinGet"

    # === FORM ===
    $form = New-Object Windows.Forms.Form
    $form.Text = "WinDeploy v5.3"
    $form.Width = 950
    $form.Height = 750
    $form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    $form.BackColor = $colorDarkBg
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    # === HEADER ===
    $panelHeader = New-Object Windows.Forms.Panel
    $panelHeader.Dock = [Windows.Forms.DockStyle]::Top
    $panelHeader.Height = 75
    $panelHeader.BackColor = $colorDarkPanel

    $labelTitle = New-Object Windows.Forms.Label
    $labelTitle.Text = "WinDeploy v5.3"
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
    $comboManager.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
    $comboManager.ForeColor = [System.Drawing.Color]::White
    $comboManager.Add_SelectedIndexChanged({
        $selectedManager = $comboManager.SelectedItem
        Write-Log "Paket Yoneticisi: $selectedManager"
    })
    $panelHeader.Controls.Add($comboManager)
    $form.Controls.Add($panelHeader)

    # === SCROLL ===
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
        $buttonKategori.Text = "[-] $kategori"
        $buttonKategori.Width = 900
        $buttonKategori.Height = 35
        $buttonKategori.BackColor = $colorDarkPanel
        $buttonKategori.ForeColor = $colorPrimary
        $buttonKategori.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $buttonKategori.FlatStyle = [Windows.Forms.FlatStyle]::Flat
        $buttonKategori.FlatAppearance.BorderSize = 1
        $buttonKategori.FlatAppearance.BorderColor = $colorPrimary
        $buttonKategori.Tag = $kategori

        $expandedGroups[$kategori] = $true

        $buttonKategori.Add_Click({
            $kat = $this.Tag
            $expandedGroups[$kat] = -not $expandedGroups[$kat]
            $this.Text = if ($expandedGroups[$kat]) { "[-] $kat" } else { "[+] $kat" }
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
                    $count = @($checkboxes.Values | Where-Object { $_.Checked }).Count
                    $labelCount.Text = "Secili: $count uygulama"
                })

                $scrollPanel.Controls.Add($checkbox)
                $checkboxes[$app.Ad] = @{Checkbox = $checkbox; Data = $app}
                $y += 32
            }
        }
    }

    $form.Controls.Add($scrollPanel)

    # === STATUS ===
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
    $panelStatus.Controls.Add($progressBar)

    $labelCount = New-Object Windows.Forms.Label
    $labelCount.Text = "Secili: 0 uygulama"
    $labelCount.Location = New-Object System.Drawing.Point(15, 50)
    $labelCount.AutoSize = $true
    $labelCount.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $labelCount.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
    $panelStatus.Controls.Add($labelCount)

    $form.Controls.Add($panelStatus)

    # === FOOTER ===
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
            [Windows.Forms.MessageBox]::Show("Lutfen uygulama seciniz!", "Uyari", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            return
        }

        $manager = $comboManager.SelectedItem
        Write-Log "=== YUKLEME BASLANDI ==="
        Write-Log "Paket Yoneticisi: $manager"
        Write-Log "Uygulama Sayisi: $($selectedApps.Count)"

        $buttonInstall.Enabled = $false
        $progressBar.Value = 0
        $form.Refresh()

        # === ASYNC KURULUM (BACKGROUND WORKER) ===
        $backgroundWorker = New-Object System.ComponentModel.BackgroundWorker
        $backgroundWorker.DoWork += {
            param($sender, $e)
            
            $basarili = 0
            $basarisiz = 0
            $toplam = $selectedApps.Count
            $failedApps = @()

            foreach ($appName in $selectedApps) {
                $appData = $checkboxes[$appName].Data
                $paket = if ($manager -eq "WinGet") { $appData.WinGet } else { $appData.Chocolatey }

                $form.Invoke([Action]{
                    $labelStatus.Text = "Indiriliyor: $appName"
                    $form.Refresh()
                })

                Write-Log "UYGULAMA: $appName | Paket: $paket"

                try {
                    if ($manager -eq "WinGet") {
                        # Silent + Accept Source Agreement + Accept License
                        $output = & cmd /c "winget install $paket -e --silent --disable-interactivity --accept-package-agreements --accept-source-agreements 2>&1"
                        $exitCode = $LASTEXITCODE
                        
                        # WinGet başarısız olursa Chocolatey'ye geç
                        if ($exitCode -ne 0 -and $checkboxes[$appName].Data.Chocolatey) {
                            Write-Log "  WinGet Basarisiz - Chocolatey Deniyor..."
                            $chocolateyPaket = $checkboxes[$appName].Data.Chocolatey
                            $output = & cmd /c "choco install $chocolateyPaket -y --no-progress 2>&1"
                            $exitCode = $LASTEXITCODE
                            Write-Log "  Chocolatey kullanildi"
                        }
                    } else {
                        # Chocolatey silent kurulum
                        $output = & cmd /c "choco install $paket -y --no-progress 2>&1"
                        $exitCode = $LASTEXITCODE
                    }

                    if ($exitCode -eq 0) {
                        Write-Log "  SONUC: BASARILI (ExitCode: $exitCode)"
                        $basarili++
                    } else {
                        Write-Log "  SONUC: BASARISIZ (ExitCode: $exitCode)"
                        Write-Log "  HATA: $output"
                        $basarisiz++
                        $failedApps += $appName
                    }
                } catch {
                    Write-Log "  SONUC: BASARISIZ - Exception"
                    Write-Log "  HATA: $_"
                    $basarisiz++
                    $failedApps += $appName
                }

                $progress = [Math]::Min([Math]::Round((($basarili + $basarisiz) / $toplam) * 100), 100)
                $form.Invoke([Action]{
                    $progressBar.Value = $progress
                    $form.Refresh()
                })

                Start-Sleep -Milliseconds 500
            }

            $e.Result = @{
                Basarili = $basarili
                Basarisiz = $basarisiz
                Basarisizlar = $failedApps
            }
        }

        $backgroundWorker.RunWorkerCompleted += {
            param($sender, $e)
            
            $result = $e.Result
            $labelStatus.Text = "Tamamlandi! $($result.Basarili)/$($selectedApps.Count)"
            $progressBar.Value = 100
            $buttonInstall.Enabled = $true

            Write-Log "=== YUKLEME TAMAMLANDI ==="
            Write-Log "Basarili: $($result.Basarili) | Basarisiz: $($result.Basarisiz)"

            $msg = "Tamamlandi!`n`nBasarili: $($result.Basarili)`nBasarisiz: $($result.Basarisiz)"
            
            if ($result.Basarisiz -gt 0) {
                $msg += "`n`nBasarısız olanlar:`n"
                $msg += ($result.Basarisizlar | ForEach-Object { "  • $_" }) -join "`n"
                $msg += "`n`n(Chocolatey'ye gecmeyi deneyin veya paketi manuel kurun)"
            }

            [Windows.Forms.MessageBox]::Show($msg, "Yukleme Tamamlandi", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        }

        $backgroundWorker.RunWorkerAsync()
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

    $buttonExport.Add_Click({
        $selectedApps = @($checkboxes.Keys | Where-Object { $checkboxes[$_].Checkbox.Checked })
        if ($selectedApps.Count -eq 0) { return }
        
        $saveDialog = New-Object Windows.Forms.SaveFileDialog
        $saveDialog.Filter = "JSON (*.json)|*.json"
        $saveDialog.FileName = "WinDeploy_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').json"
        
        if ($saveDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
            @{Uygulamalar = $selectedApps; Tarih = Get-Date} | ConvertTo-Json | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
            Write-Log "Export: $($saveDialog.FileName)"
            [Windows.Forms.MessageBox]::Show("Kaydedildi!", "OK", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information) | Out-Null
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

    $buttonImport.Add_Click({
        $openDialog = New-Object Windows.Forms.OpenFileDialog
        $openDialog.Filter = "JSON (*.json)|*.json"
        
        if ($openDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
            try {
                $data = Get-Content $openDialog.FileName -Raw | ConvertFrom-Json
                foreach ($cb in $checkboxes.Values) { $cb.Checkbox.Checked = $false }
                foreach ($name in $data.Uygulamalar) {
                    if ($checkboxes.ContainsKey($name)) { $checkboxes[$name].Checkbox.Checked = $true }
                }
                Write-Log "Import: $($data.Uygulamalar.Count) uygulama"
            } catch {}
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

    $buttonTemizle.Add_Click({
        foreach ($cb in $checkboxes.Values) { $cb.Checkbox.Checked = $false }
    })

    $panelFooter.Controls.Add($buttonTemizle)

    $form.Controls.Add($panelFooter)

    Write-Log "GUI Basariyla Olusturuldu"
    [void]$form.ShowDialog()

} catch {
    Write-Host "HATA: $_" -ForegroundColor Red
    Write-Log "KRITIK HATA: $_"
    exit 1
}

Write-Log "=== WinDeploy Kapatildi ==="
