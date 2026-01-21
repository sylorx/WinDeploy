[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if(-not $isAdmin){
    Write-Host "Admin gerekli..."
    Start-Process powershell -Verb RunAs -ArgumentList "-Command","& {irm https://raw.githubusercontent.com/sylorx/WinDeploy/main/launcher.ps1 | iex}"
    exit
}
Write-Host "WinDeploy baslatiliyor..." -ForegroundColor Cyan
& (irm https://raw.githubusercontent.com/sylorx/WinDeploy/main/WinDeploy.ps1)
