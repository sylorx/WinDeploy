[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "         WinDeploy v1.0                " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Admin kontrolu
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Hata: Yonetici izni gerekli!" -ForegroundColor Red
    exit 1
}

# Ana menu
while ($true) {
    Write-Host ""
    Write-Host "ANA MENU:" -ForegroundColor Yellow
    Write-Host "1. Uygulama Yonet" -ForegroundColor Cyan
    Write-Host "2. Bilgisayar Bilgisi" -ForegroundColor Cyan
    Write-Host "3. Cikis" -ForegroundColor Cyan
    Write-Host ""
    
    $secim = Read-Host "Seciminiz"
    
    switch ($secim) {
        "1" {
            Write-Host ""
            Write-Host "UYGULAMA YONETIMI:" -ForegroundColor Yellow
            Write-Host "1. Google Chrome Yukle" -ForegroundColor Cyan
            Write-Host "2. Visual Studio Code Yukle" -ForegroundColor Cyan
            Write-Host "3. VLC Media Player Yukle" -ForegroundColor Cyan
            Write-Host "4. Geri" -ForegroundColor Cyan
            Write-Host ""
            
            $app = Read-Host "Seciminiz"
            switch ($app) {
                "1" { 
                    Write-Host "Chrome indiriliyor..." -ForegroundColor Green
                    winget install Google.Chrome -e --silent
                }
                "2" { 
                    Write-Host "VS Code indiriliyor..." -ForegroundColor Green
                    winget install Microsoft.VisualStudioCode -e --silent
                }
                "3" { 
                    Write-Host "VLC indiriliyor..." -ForegroundColor Green
                    winget install VideoLAN.VLC -e --silent
                }
                "4" { continue }
            }
        }
        "2" {
            Write-Host ""
            Write-Host "BILGISAYAR BILGISI:" -ForegroundColor Yellow
            Write-Host ""
            $comp = Get-ComputerInfo
            Write-Host "Bilgisayar Adi: $($comp.CsComputerName)" -ForegroundColor Cyan
            Write-Host "OS: $($comp.OsName)" -ForegroundColor Cyan
            Write-Host "Versiyon: $($comp.OsVersion)" -ForegroundColor Cyan
            Write-Host ""
        }
        "3" {
            Write-Host "Cikiliyor..." -ForegroundColor Yellow
            exit 0
        }
        default {
            Write-Host "Gecersiz secim!" -ForegroundColor Red
        }
    }
}
