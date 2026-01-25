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

    # === UYGULAMALAR (Genişletildi) ===
    $uygulamalarByKategori = @{
        "Tarayicilar" = @(
            @{Ad = "Google Chrome"; WinGet = "Google.Chrome"; Chocolatey = "googlechrome"}
            @{Ad = "Mozilla Firefox"; WinGet = "Mozilla.Firefox"; Chocolatey = "firefox"}
            @{Ad = "Brave Browser"; WinGet = "BraveSoftware.BraveBrowser"; Chocolatey = "brave"}
            @{Ad = "Opera"; WinGet = "Opera.Opera"; Chocolatey = "opera"}
            @{Ad = "Microsoft Edge"; WinGet = "Microsoft.Edge"; Chocolatey = "microsoft-edge"}
            @{Ad = "Vivaldi"; WinGet = "Vivaldi.Vivaldi"; Chocolatey = "vivaldi"}
            @{Ad = "Tor Browser"; WinGet = "TorProject.TorBrowser"; Chocolatey = "tor-browser"}
            @{Ad = "Chromium"; WinGet = "Chromium.Chromium"; Chocolatey = "chromium"}
            @{Ad = "LibreWolf"; WinGet = "LibreWolf.LibreWolf"; Chocolatey = "librewolf"}
            @{Ad = "Pale Moon"; WinGet = ""; Chocolatey = "palemoon"}
        )
        "Multimedia" = @(
            @{Ad = "VLC Media Player"; WinGet = "VideoLAN.VLC"; Chocolatey = "vlc"}
            @{Ad = "OBS Studio"; WinGet = "OBSProject.OBSStudio"; Chocolatey = "obs-studio"}
            @{Ad = "Audacity"; WinGet = "Audacity.Audacity"; Chocolatey = "audacity"}
            @{Ad = "GIMP"; WinGet = "GIMP.GIMP"; Chocolatey = "gimp"}
            @{Ad = "HandBrake"; WinGet = "HandBrake.HandBrake"; Chocolatey = "handbrake"}
            @{Ad = "FFmpeg"; WinGet = "Gyan.FFmpeg"; Chocolatey = "ffmpeg"}
            @{Ad = "MPC-HC"; WinGet = ""; Chocolatey = "mpc-hc"}
            @{Ad = "foobar2000"; WinGet = "foobar2000.foobar2000"; Chocolatey = "foobar2000"}
            @{Ad = "Shotcut"; WinGet = "Meltytech.Shotcut"; Chocolatey = "shotcut"}
            @{Ad = "Blender"; WinGet = "BlenderFoundation.Blender"; Chocolatey = "blender"}
            @{Ad = "Krita"; WinGet = "Krita.Krita"; Chocolatey = "krita"}
            @{Ad = "Inkscape"; WinGet = "Inkscape.Inkscape"; Chocolatey = "inkscape"}
            @{Ad = "Wesnoth"; WinGet = "Wesnoth.Wesnoth"; Chocolatey = "wesnoth"}
            @{Ad = "Spotify"; WinGet = "Spotify.Spotify"; Chocolatey = "spotify"}
            @{Ad = "Musescore"; WinGet = "MuseScore.MuseScore"; Chocolatey = "musescore"}
        )
        "Gelistirme" = @(
            @{Ad = "Visual Studio Code"; WinGet = "Microsoft.VisualStudioCode"; Chocolatey = "vscode"}
            @{Ad = "Git"; WinGet = "Git.Git"; Chocolatey = "git"}
            @{Ad = "Python"; WinGet = "Python.Python.3.11"; Chocolatey = "python"}
            @{Ad = "Node.js"; WinGet = "OpenJS.NodeJS"; Chocolatey = "nodejs"}
            @{Ad = "Docker Desktop"; WinGet = "Docker.DockerDesktop"; Chocolatey = "docker-desktop"}
            @{Ad = "Postman"; WinGet = "Postman.Postman"; Chocolatey = "postman"}
            @{Ad = "JetBrains Toolbox"; WinGet = "JetBrains.Toolbox"; Chocolatey = "jetbrains-toolbox"}
            @{Ad = "Sublime Text"; WinGet = "SublimeHQ.SublimeText"; Chocolatey = "sublimetext3"}
            @{Ad = "IntelliJ IDEA (Community)"; WinGet = "JetBrains.IntelliJIDEA.Community"; Chocolatey = "intellijidea-community"}
            @{Ad = "Visual Studio 2022 (Community)"; WinGet = "Microsoft.VisualStudio.2022.Community"; Chocolatey = "visualstudio2022community"}
            @{Ad = "Ruby"; WinGet = "RubyInstallerTeam.Ruby"; Chocolatey = "ruby"}
            @{Ad = "Golang"; WinGet = "GoLang.Go"; Chocolatey = "golang"}
            @{Ad = "Rust"; WinGet = "Rustlang.Rust.GNU"; Chocolatey = "rust"}
            @{Ad = "Java (OpenJDK)"; WinGet = "EclipseAdoptium.Temurin.17.JDK"; Chocolatey = "openjdk"}
            @{Ad = "Apache Maven"; WinGet = "ApacheFoundation.Maven"; Chocolatey = "maven"}
            @{Ad = "Gradle"; WinGet = "Gradle.Gradle"; Chocolatey = "gradle"}
            @{Ad = "CMake"; WinGet = "Kitware.CMake"; Chocolatey = "cmake"}
            @{Ad = "MinGW"; WinGet = ""; Chocolatey = "mingw"}
            @{Ad = "WireShark"; WinGet = "WiresharkFoundation.Wireshark"; Chocolatey = "wireshark"}
            @{Ad = "VirtualBox"; WinGet = "Oracle.VirtualBox"; Chocolatey = "virtualbox"}
            @{Ad = "GIMP (Dev)"; WinGet = "GIMP.GIMP"; Chocolatey = "gimp"}
            @{Ad = "SQLite Studio"; WinGet = ""; Chocolatey = "sqlitestudio"}
            @{Ad = "DBeaver Community"; WinGet = "dbeaver.dbeaver"; Chocolatey = "dbeaver"}
            @{Ad = "Insomnia"; WinGet = "Kong.Insomnia"; Chocolatey = "insomnia"}
        )
        "Sistem" = @(
            @{Ad = "PowerToys"; WinGet = "Microsoft.PowerToys"; Chocolatey = "powertoys"}
            @{Ad = "7-Zip"; WinGet = "7zip.7zip"; Chocolatey = "7zip"}
            @{Ad = "Notepad++"; WinGet = "Notepad++.Notepad++"; Chocolatey = "notepadplusplus"}
            @{Ad = "VirtualBox"; WinGet = "Oracle.VirtualBox"; Chocolatey = "virtualbox"}
            @{Ad = "Sysinternals"; WinGet = "Microsoft.Sysinternals"; Chocolatey = "sysinternals"}
            @{Ad = "CPU-Z"; WinGet = "cpuz.cpuz"; Chocolatey = "cpu-z"}
            @{Ad = "GPU-Z"; WinGet = ""; Chocolatey = "gpu-z"}
            @{Ad = "Everything Search"; WinGet = "voidtools.Everything"; Chocolatey = "everything"}
            @{Ad = "WinRAR"; WinGet = "RarLab.WinRAR"; Chocolatey = "winrar"}
            @{Ad = "Rufus"; WinGet = "pbatard.rufus"; Chocolatey = "rufus"}
            @{Ad = "HWiNFO"; WinGet = ""; Chocolatey = "hwinfo"}
            @{Ad = "Ditto Clipboard"; WinGet = ""; Chocolatey = "ditto"}
            @{Ad = "Sharex"; WinGet = "ShareX.ShareX"; Chocolatey = "sharex"}
            @{Ad = "WizFile"; WinGet = ""; Chocolatey = "wizfile"}
            @{Ad = "Geek Uninstaller"; WinGet = ""; Chocolatey = "geek-uninstaller"}
            @{Ad = "CCleaner"; WinGet = "Piriform.CCleaner"; Chocolatey = "ccleaner"}
            @{Ad = "Recuva"; WinGet = "Piriform.Recuva"; Chocolatey = "recuva"}
            @{Ad = "WiseCare365"; WinGet = ""; Chocolatey = "wisecare365"}
            @{Ad = "Memtest86"; WinGet = ""; Chocolatey = "memtest86"}
            @{Ad = "Hard Disk Sentinel"; WinGet = ""; Chocolatey = "hdsentinel"}
        )
        "Iletisim" = @(
            @{Ad = "Discord"; WinGet = "Discord.Discord"; Chocolatey = "discord"}
            @{Ad = "Slack"; WinGet = "SlackTechnologies.Slack"; Chocolatey = "slack"}
            @{Ad = "Telegram"; WinGet = "Telegram.TelegramDesktop"; Chocolatey = "telegram"}
            @{Ad = "Zoom"; WinGet = "Zoom.Zoom"; Chocolatey = "zoom"}
            @{Ad = "Microsoft Teams"; WinGet = "Microsoft.Teams"; Chocolatey = "microsoft-teams"}
            @{Ad = "Skype"; WinGet = "Microsoft.Skype"; Chocolatey = "skype"}
            @{Ad = "WhatsApp"; WinGet = "Microsoft.WhatsAppDesktop"; Chocolatey = "whatsapp"}
            @{Ad = "Signal Desktop"; WinGet = "OpenWhisperSystems.Signal"; Chocolatey = "signal"}
            @{Ad = "Mumble"; WinGet = ""; Chocolatey = "mumble"}
            @{Ad = "Jami (GNU Ring)"; WinGet = ""; Chocolatey = "jami"}
        )
        "Office" = @(
            @{Ad = "LibreOffice"; WinGet = "TheDocumentFoundation.LibreOffice"; Chocolatey = "libreoffice-fresh"}
            @{Ad = "OnlyOffice"; WinGet = "Ascensio.Systems.OnlyOffice"; Chocolatey = "onlyoffice"}
            @{Ad = "Microsoft Office 365"; WinGet = "Microsoft.Office"; Chocolatey = "office365proplus"}
            @{Ad = "WPS Office"; WinGet = ""; Chocolatey = "wpsoffice"}
            @{Ad = "Calligra Suite"; WinGet = ""; Chocolatey = "calligra"}
            @{Ad = "Markdown Editor"; WinGet = ""; Chocolatey = "markdown-edit"}
        )
        "Guvenlik" = @(
            @{Ad = "Bitwarden"; WinGet = "Bitwarden.Bitwarden"; Chocolatey = "bitwarden"}
            @{Ad = "KeePass XC"; WinGet = "DominikReichl.KeePassXC"; Chocolatey = "keepassxc"}
            @{Ad = "Malwarebytes"; WinGet = "Malwarebytes.Malwarebytes"; Chocolatey = "malwarebytes"}
            @{Ad = "ProtonVPN"; WinGet = "ProtonTechnologies.ProtonVPN"; Chocolatey = "protonvpn"}
            @{Ad = "NordVPN"; WinGet = "NordVPN.NordVPN"; Chocolatey = "nordvpn"}
            @{Ad = "Windscribe"; WinGet = "Windscribe.Windscribe"; Chocolatey = "windscribe"}
            @{Ad = "Encrypto"; WinGet = "SpiesoftSrl.Encrypto"; Chocolatey = ""}
            @{Ad = "VeraCrypt"; WinGet = "IDRIX.VeraCrypt"; Chocolatey = "veracrypt"}
            @{Ad = "Tor Browser"; WinGet = "TorProject.TorBrowser"; Chocolatey = "tor-browser"}
            @{Ad = "Glasswire"; WinGet = "GlassWire.GlassWire"; Chocolatey = "glasswire-basic"}
        )
        "Oyun" = @(
            @{Ad = "Steam"; WinGet = "Valve.Steam"; Chocolatey = "steam"}
            @{Ad = "Epic Games Launcher"; WinGet = "EpicGames.EpicGamesLauncher"; Chocolatey = "epicgameslauncher"}
            @{Ad = "GOG Galaxy"; WinGet = "GOG.Galaxy"; Chocolatey = "goggalaxy"}
            @{Ad = "Minecraft"; WinGet = "Mojang.MinecraftLauncher"; Chocolatey = "minecraft-launcher"}
            @{Ad = "OBS Studio"; WinGet = "OBSProject.OBSStudio"; Chocolatey = "obs-studio"}
            @{Ad = "Dolphin Emulator"; WinGet = "DolphinEmu.Dolphin"; Chocolatey = "dolphin"}
            @{Ad = "PCSX2 Emulator"; WinGet = ""; Chocolatey = "pcsx2"}
            @{Ad = "RetroArch"; WinGet = ""; Chocolatey = "retroarch"}
            @{Ad = "Lutris"; WinGet = ""; Chocolatey = "lutris"}
            @{Ad = "Heroic Game Launcher"; WinGet = "HeroicGamesLauncher.HeroicGamesLauncher"; Chocolatey = ""}
        )
        "Acik Kaynak" = @(
            @{Ad = "Blender"; WinGet = "BlenderFoundation.Blender"; Chocolatey = "blender"}
            @{Ad = "Krita"; WinGet = "Krita.Krita"; Chocolatey = "krita"}
            @{Ad = "Inkscape"; WinGet = "Inkscape.Inkscape"; Chocolatey = "inkscape"}
            @{Ad = "LibreOffice"; WinGet = "TheDocumentFoundation.LibreOffice"; Chocolatey = "libreoffice-fresh"}
            @{Ad = "GIMP"; WinGet = "GIMP.GIMP"; Chocolatey = "gimp"}
            @{Ad = "Audacity"; WinGet = "Audacity.Audacity"; Chocolatey = "audacity"}
            @{Ad = "VLC"; WinGet = "VideoLAN.VLC"; Chocolatey = "vlc"}
            @{Ad = "Firefox"; WinGet = "Mozilla.Firefox"; Chocolatey = "firefox"}
            @{Ad = "Thunderbird"; WinGet = "Mozilla.Thunderbird"; Chocolatey = "thunderbird"}
            @{Ad = "Vim"; WinGet = "vim.vim"; Chocolatey = "vim"}
            @{Ad = "Emacs"; WinGet = ""; Chocolatey = "emacs"}
            @{Ad = "Neovim"; WinGet = "Neovim.Neovim"; Chocolatey = "neovim"}
            @{Ad = "GNU Bash"; WinGet = ""; Chocolatey = "bash"}
            @{Ad = "Git"; WinGet = "Git.Git"; Chocolatey = "git"}
            @{Ad = "Wget"; WinGet = ""; Chocolatey = "wget"}
            @{Ad = "Curl"; WinGet = ""; Chocolatey = "curl"}
            @{Ad = "7-Zip"; WinGet = "7zip.7zip"; Chocolatey = "7zip"}
            @{Ad = "VirtualBox"; WinGet = "Oracle.VirtualBox"; Chocolatey = "virtualbox"}
            @{Ad = "Shotcut"; WinGet = "Meltytech.Shotcut"; Chocolatey = "shotcut"}
            @{Ad = "Musescore"; WinGet = "MuseScore.MuseScore"; Chocolatey = "musescore"}
        )
        "Ekstra Araclar" = @(
            @{Ad = "Everything"; WinGet = "voidtools.Everything"; Chocolatey = "everything"}
            @{Ad = "ShareX"; WinGet = "ShareX.ShareX"; Chocolatey = "sharex"}
            @{Ad = "Rufus"; WinGet = "pbatard.rufus"; Chocolatey = "rufus"}
            @{Ad = "VeraCrypt"; WinGet = "IDRIX.VeraCrypt"; Chocolatey = "veracrypt"}
            @{Ad = "WinRAR"; WinGet = "RarLab.WinRAR"; Chocolatey = "winrar"}
            @{Ad = "HWiNFO"; WinGet = ""; Chocolatey = "hwinfo"}
            @{Ad = "GPU-Z"; WinGet = ""; Chocolatey = "gpu-z"}
            @{Ad = "CPU-Z"; WinGet = "cpuz.cpuz"; Chocolatey = "cpu-z"}
            @{Ad = "DBeaver Community"; WinGet = "dbeaver.dbeaver"; Chocolatey = "dbeaver"}
            @{Ad = "Insomnia"; WinGet = "Kong.Insomnia"; Chocolatey = "insomnia"}
            @{Ad = "WireShark"; WinGet = "WiresharkFoundation.Wireshark"; Chocolatey = "wireshark"}
            @{Ad = "Putty"; WinGet = "PuTTY.PuTTY"; Chocolatey = "putty"}
            @{Ad = "FileZilla"; WinGet = "FileZilla.FileZilla"; Chocolatey = "filezilla"}
            @{Ad = "Synergy"; WinGet = "Symless.Synergy"; Chocolatey = "synergy"}
            @{Ad = "AutoHotkey"; WinGet = "AutoHotkey.AutoHotkey"; Chocolatey = "autohotkey"}
            @{Ad = "Bulk Rename Utility"; WinGet = ""; Chocolatey = "bulkrenameutility"}
            @{Ad = "Total Commander"; WinGet = ""; Chocolatey = "totalcommander"}
            @{Ad = "Double Commander"; WinGet = ""; Chocolatey = "doublecommander"}
            @{Ad = "Paint.NET"; WinGet = "dotPDN.PaintNET"; Chocolatey = "paint.net"}
            @{Ad = "Greenshot"; WinGet = ""; Chocolatey = "greenshot"}
        )
    }

    $checkboxes = @{}
    $expandedGroups = @{}
    $categoryContainers = @{}
    $selectedManager = "WinGet"

    # === SISTEM BILGILERI FONKSIYONLARI ===
    function Get-SystemInfo {
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor
        $disk = Get-Volume | Where-Object {$_.DriveLetter -eq 'C'}
        $memory = Get-CimInstance Win32_ComputerSystem
        
        return @{
            ComputerName = $env:COMPUTERNAME
            OS = $os.Caption
            OSVersion = "$($os.Version) ($($os.OSArchitecture))"
            DiskTotal = [Math]::Round($disk.Size / 1GB, 2)
            DiskUsed = [Math]::Round(($disk.Size - $disk.SizeRemaining) / 1GB, 2)
            DiskFree = [Math]::Round($disk.SizeRemaining / 1GB, 2)
            RAM = [Math]::Round($memory.TotalPhysicalMemory / 1GB, 2)
        }
    }

    function Open-SystemTools {
        param([string]$Tool)
        
        switch ($Tool) {
            "optimization" { Start-Process ms-settings:system-advanced }
            "updates" { Start-Process ms-settings:windowsupdate }
            "drivers" { Start-Process devmgmt.msc }
            "cleanup" { Start-Process cleanmgr }
            "startup" { Start-Process taskmgr -ArgumentList "/startup" }
            "network" { Start-Process ncpa.cpl }
            "firewall" { Start-Process wf.msc }
            "updates-now" { Start-Process ms-settings:windowsupdate-action }
        }
    }

    # === FORM ===
    $form = New-Object Windows.Forms.Form
    $form.Text = "WinDeploy v6.0"
    $form.Width = 1000
    $form.Height = 800
    $form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    $form.BackColor = $colorDarkBg
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    # === HEADER ===
    $panelHeader = New-Object Windows.Forms.Panel
    $panelHeader.Dock = [Windows.Forms.DockStyle]::Top
    $panelHeader.Height = 75
    $panelHeader.BackColor = $colorDarkPanel

    $labelTitle = New-Object Windows.Forms.Label
    $labelTitle.Text = "WinDeploy v6.0"
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

    # === TAB CONTROL ===
    $tabControl = New-Object Windows.Forms.TabControl
    $tabControl.Dock = [Windows.Forms.DockStyle]::Fill
    $tabControl.BackColor = $colorDarkBg
    $tabControl.ForeColor = [System.Drawing.Color]::White
    $tabControl.ItemSize = New-Object System.Drawing.Size(150, 25)

    # --- TAB 1: UYGULAMALAR ---
    $tabUygulamalar = New-Object Windows.Forms.TabPage
    $tabUygulamalar.Text = "Uygulamalar"
    $tabUygulamalar.BackColor = $colorDarkBg

    # === SCROLL ===
    $scrollPanel = New-Object Windows.Forms.Panel
    $scrollPanel.Dock = [Windows.Forms.DockStyle]::Fill
    $scrollPanel.AutoScroll = $true
    $scrollPanel.BackColor = $colorDarkBg
    $scrollPanel.Padding = New-Object Windows.Forms.Padding(10)

    $y = 10
    foreach ($kategori in $uygulamalarByKategori.Keys) {
        $apps = $uygulamalarByKategori[$kategori]

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

        $panelKategori.Controls.Add($buttonKategori)
        $scrollPanel.Controls.Add($panelKategori)
        $y += 40

        # create container panel for apps in this category so we can toggle visibility
        $container = New-Object Windows.Forms.Panel
        $container.Width = 900
        $container.Location = New-Object System.Drawing.Point(10, $y)
        $container.BackColor = $colorDarkBg

        $countApps = $apps.Count
        $containerHeight = [Math]::Max( ($countApps * 32), 0 )
        $container.Height = $containerHeight
        $container.AutoScroll = $false

        $categoryContainers[$kategori] = $container

        $i = 0
        foreach ($app in $apps) {
            $checkbox = New-Object Windows.Forms.CheckBox
            $checkbox.Text = $app.Ad
            $checkbox.Width = 880
            $checkbox.Height = 28
            $checkbox.Location = New-Object System.Drawing.Point(20, (4 + ($i * 32)))
            $checkbox.BackColor = $colorDarkBg
            $checkbox.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
            $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
            $checkbox.Cursor = [Windows.Forms.Cursors]::Hand

            $checkbox.Add_CheckedChanged({
                $count = @($checkboxes.Values | Where-Object { $_.Checkbox.Checked }).Count
                $labelCount.Text = "Secili: $count uygulama"
            })

            $container.Controls.Add($checkbox)
            $checkboxes[$app.Ad] = @{Checkbox = $checkbox; Data = $app}
            $i++
        }

        $scrollPanel.Controls.Add($container)
        $y += $containerHeight + 8

        # toggle handler uses sender so closure binding is safe
        $buttonKategori.Add_Click({ param($s,$e)
            $kat = $s.Tag
            $expandedGroups[$kat] = -not $expandedGroups[$kat]
            $categoryContainers[$kat].Visible = $expandedGroups[$kat]
            $s.Text = if ($expandedGroups[$kat]) { "[-] $kat" } else { "[+] $kat" }
        })
    }

    $tabUygulamalar.Controls.Add($scrollPanel)
    $tabControl.TabPages.Add($tabUygulamalar)

    # --- TAB 2: SİSTEM BİLGİSİ VE YÖNETIMI ---
    $tabSistem = New-Object Windows.Forms.TabPage
    $tabSistem.Text = "Sistem"
    $tabSistem.BackColor = $colorDarkBg

    # Sistem bilgilerini al
    $sysInfo = Get-SystemInfo

    # Scroll panel for system tab
    $scrollSistem = New-Object Windows.Forms.Panel
    $scrollSistem.Dock = [Windows.Forms.DockStyle]::Fill
    $scrollSistem.AutoScroll = $true
    $scrollSistem.BackColor = $colorDarkBg
    $scrollSistem.Padding = New-Object Windows.Forms.Padding(15)

    # --- SISTEM BİLGİLERİ SECTION ---
    $labelBilgiBaslik = New-Object Windows.Forms.Label
    $labelBilgiBaslik.Text = "Sistem Bilgileri"
    $labelBilgiBaslik.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $labelBilgiBaslik.ForeColor = $colorPrimary
    $labelBilgiBaslik.Location = New-Object System.Drawing.Point(15, 15)
    $labelBilgiBaslik.AutoSize = $true
    $scrollSistem.Controls.Add($labelBilgiBaslik)

    $y = 50
    $labelWidth = 900
    $labelHeight = 28
    $labelSpacing = 35

    # Bilgiler
    $infos = @(
        @{Icon = "PC"; Label = "Bilgisayar Adi"; Value = $sysInfo.ComputerName}
        @{Icon = "OS"; Label = "Isletim Sistemi"; Value = $sysInfo.OS}
        @{Icon = "VER"; Label = "OS Versiyonu ve Mimarisi"; Value = $sysInfo.OSVersion}
        @{Icon = "DSK"; Label = "Disk - Toplam"; Value = "$($sysInfo.DiskTotal) GB"}
        @{Icon = "DSK"; Label = "Disk - Kullanilan"; Value = "$($sysInfo.DiskUsed) GB"}
        @{Icon = "DSK"; Label = "Disk - Bos"; Value = "$($sysInfo.DiskFree) GB"}
        @{Icon = "RAM"; Label = "RAM Miktari"; Value = "$($sysInfo.RAM) GB"}
    )

    foreach ($info in $infos) {
        $labelInfo = New-Object Windows.Forms.Label
        $labelInfo.Text = "$($info.Icon) $($info.Label): $($info.Value)"
        $labelInfo.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $labelInfo.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $labelInfo.Location = New-Object System.Drawing.Point 15, $y
        $labelInfo.Width = $labelWidth
        $labelInfo.Height = $labelHeight
        $scrollSistem.Controls.Add($labelInfo)
        $y += $labelSpacing
    }

    # --- SİSTEM ARAÇLARI SECTION ---
    $y += 15
    $labelAracBaslik = New-Object Windows.Forms.Label
    $labelAracBaslik.Text = "Sistem Yonetim Araclari"
    $labelAracBaslik.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $labelAracBaslik.ForeColor = $colorPrimary
    $labelAracBaslik.Location = New-Object System.Drawing.Point(15, $y)
    $labelAracBaslik.AutoSize = $true
    $scrollSistem.Controls.Add($labelAracBaslik)

    $y += 40

    $tools = @(
        @{Text = "Sistem Optimizasyonu"; Cmd = "optimization"; Color = [System.Drawing.Color]::FromArgb(0, 180, 100)}
        @{Text = "Windows Guncellemesi"; Cmd = "updates"; Color = [System.Drawing.Color]::FromArgb(0, 150, 215)}
        @{Text = "Tek Tusla Guncelleme"; Cmd = "updates-now"; Color = [System.Drawing.Color]::FromArgb(220, 150, 0)}
        @{Text = "Surucu Yonetimi"; Cmd = "drivers"; Color = [System.Drawing.Color]::FromArgb(180, 80, 200)}
        @{Text = "Sistem Temizleme"; Cmd = "cleanup"; Color = [System.Drawing.Color]::FromArgb(200, 100, 100)}
        @{Text = "Baslangic Programlari"; Cmd = "startup"; Color = [System.Drawing.Color]::FromArgb(100, 200, 100)}
        @{Text = "Network Ayarlari"; Cmd = "network"; Color = [System.Drawing.Color]::FromArgb(100, 150, 200)}
        @{Text = "Firewall Yonetimi"; Cmd = "firewall"; Color = [System.Drawing.Color]::FromArgb(200, 100, 150)}
    )

    $col = 0
    foreach ($tool in $tools) {
        $x = if ($col -eq 0) { 15 } else { 480 }
        $row = [Math]::Floor($tools.IndexOf($tool) / 2)
        $pointY = $y + ($row * 55)

        $buttonTool = New-Object Windows.Forms.Button
        $buttonTool.Text = $tool.Text
        $buttonTool.Width = 430
        $buttonTool.Height = 45
        $buttonTool.Location = New-Object System.Drawing.Point $x, $pointY
        $buttonTool.BackColor = $tool.Color
        $buttonTool.ForeColor = [System.Drawing.Color]::White
        $buttonTool.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $buttonTool.FlatStyle = [Windows.Forms.FlatStyle]::Flat
        $buttonTool.FlatAppearance.BorderSize = 0
        $buttonTool.Cursor = [Windows.Forms.Cursors]::Hand
        $buttonTool.Tag = $tool.Cmd

        $buttonTool.Add_Click({
            $toolCmd = $this.Tag
            Write-Log "Sistem Aracı Aciliyor: $toolCmd"
            Open-SystemTools $toolCmd
        })

        $scrollSistem.Controls.Add($buttonTool)
        $col = ($col + 1) % 2
    }

    $tabSistem.Controls.Add($scrollSistem)
    $tabControl.TabPages.Add($tabSistem)

    $form.Controls.Add($tabControl)

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
                    $exitCode = -1
                    $output = ""
                    
                    if ($manager -eq "WinGet") {
                        # WinGet kurulumu
                        Write-Log "  Komut: winget install $paket -e --silent..."
                        & cmd /c "winget install $paket -e --silent --disable-interactivity --accept-package-agreements --accept-source-agreements" | Out-Null
                        $exitCode = $LASTEXITCODE
                        
                        # WinGet başarısız olursa Chocolatey'ye geç
                        if ($exitCode -ne 0 -and $checkboxes[$appName].Data.Chocolatey) {
                            Write-Log "  WinGet ExitCode: $exitCode - Chocolatey Deniyor..."
                            $chocolateyPaket = $checkboxes[$appName].Data.Chocolatey
                            & cmd /c "choco install $chocolateyPaket -y --no-progress" | Out-Null
                            $exitCode = $LASTEXITCODE
                            Write-Log "  Chocolatey Komut: choco install $chocolateyPaket -y"
                        }
                    } else {
                        # Chocolatey kurulumu
                        Write-Log "  Komut: choco install $paket -y --no-progress"
                        & cmd /c "choco install $paket -y --no-progress" | Out-Null
                        $exitCode = $LASTEXITCODE
                    }

                    if ($exitCode -eq 0) {
                        Write-Log "  SONUC: BASARILI (ExitCode: $exitCode)"
                        $basarili++
                    } else {
                        Write-Log "  SONUC: BASARISIZ (ExitCode: $exitCode)"
                        $basarisiz++
                        $failedApps += $appName
                    }
                } catch {
                    Write-Log "  SONUC: BASARISIZ - Exception: $_"
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
