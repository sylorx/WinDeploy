# ⚡ Quick Start Guide

Get WinDeploy running in **5 minutes** ⏱️

---

## 1️⃣ Prerequisites (30 seconds)

- ✅ Windows 10 or 11
- ✅ PowerShell 5.1+ (built-in)
- ✅ Administrator access
- ✅ Internet connection

---

## 2️⃣ Install (1 minute)

### The Easy Way (Recommended)

Open PowerShell as **Administrator** and run:

```powershell
irm "https://windeploy.vercel.app/launcher.ps1" | iex
```

**Done!** The GUI launches automatically. ✅

### Alternative: From GitHub

```powershell
git clone https://github.com/sylorx/WinDeploy.git
cd WinDeploy
.\scripts\launcher.ps1
```

---

## 3️⃣ First Launch (2 minutes)

### What You'll See

1. **Permission Request** - Click "Yes" (admin needed)
2. **GUI Window Opens** - Dark theme, blue accents
3. **Two Tabs Available:**
   - **Uygulamalar:** 120+ apps ready
   - **Sistem:** System info & management tools

### What to Do

1. **Browse** the app list
2. **Check** apps you want (☑️ checkbox)
3. **Select** Package Manager (dropdown):
   - **WinGet** (recommended, faster)
   - **Chocolatey** (fallback)
4. **Click** the Install button 🚀

### Watch It Work

- ✅ Progress bar fills up
- ✅ Apps download silently
- ✅ UI stays responsive
- ✅ Logs appear in real-time

---

## 4️⃣ After Installation (1 minute)

### Check Logs

```powershell
cat $env:APPDATA\WinDeploy\logs\latest.log
```

### Re-Run Anytime

```powershell
irm "https://windeploy.vercel.app/launcher.ps1" | iex
```

---

## 🎯 Tips & Tricks

### Tab 1: Uygulamalar (Applications)
- Use "Select All" button to check all apps
- Or manually check individual checkboxes
- Use **Export** to save your choices as JSON
- Use **Import** to re-load on other PCs

### Tab 2: Sistem (System)
- View computer info: name, OS, RAM, disk usage
- Quick access to system management tools
- One-click Windows updates
- Manage drivers, firewall, network settings

### Troubleshoot Issues
- Check logs: `%APPDATA%\WinDeploy\logs\`
- Read: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Open issue: [GitHub Issues](https://github.com/sylorx/WinDeploy/issues)
- Run locally

---

## 📊 App Categories

**50+ Apps Across 8 Categories:**

| Category | Count | Examples |
|----------|-------|----------|
| 🌐 **Browsers** | 6 | Chrome, Firefox, Edge, Brave |
| 🎬 **Multimedia** | 5 | VLC, OBS, Audacity, FFmpeg |
| 💻 **Development** | 10 | VS Code, Git, Node, Python, Docker |
| 🖥️ **System** | 8 | 7-Zip, Everything, CCleaner, Rufus |
| 💬 **Communication** | 4 | Discord, Telegram, Slack, Teams |
| 📄 **Office** | 3 | LibreOffice, Notepad++ |
| 🔒 **Security** | 3 | Bitwarden, VPN, Windows Defender |
| 🎮 **Games** | 3 | Steam, Epic Games, GOG |

---

## ⏱️ How Long Does It Take?

| Task | Time |
|------|------|
| Download installer | 10 seconds |
| Launch GUI | 3-5 seconds |
| Select 10 apps | 1 minute |
| Install 10 apps | 5-15 minutes* |

*Depends on internet speed and app sizes

---

## 🆘 Common Issues

### ❌ "Yönetici izni gerekli" (Admin required)
**Solution**: Right-click PowerShell → "Run as Administrator"

### ❌ "Execution Policy" error
**Solution**: Run once:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### ❌ Can't download launcher
**Solution**: Check internet, try:
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
irm "https://windeploy.vercel.app/launcher.ps1" | iex
```

### ❌ Installation failed for some apps
**Solution**: 
- Check logs: `$env:APPDATA\WinDeploy\logs\latest.log`
- Some apps may have system requirements
- Try installing manually if critical

---

## 🔄 Next Steps

### Learn More
- 📖 Read [INSTALL.md](INSTALL.md) for detailed setup
- 📚 Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for help
- 👨‍💻 See [DEVELOPMENT.md](DEVELOPMENT.md) to contribute

### Advanced Usage
- ⚙️ Customize which apps appear
- 🔗 Run from your own domain
- 📦 Create custom app packages
- 🌐 Contribute to the project

### Get Involved
- ⭐ Star the [GitHub repo](https://github.com/sylorx/WinDeploy)
- 🐛 Report bugs: [Issues](https://github.com/sylorx/WinDeploy/issues)
- 💡 Suggest features: [Discussions](https://github.com/sylorx/WinDeploy/discussions)
- 🤝 Contribute code: [Pull Requests](https://github.com/sylorx/WinDeploy/pulls)

---

## 📞 Need Help?

- **Website**: [windeploy.vercel.app](https://windeploy.vercel.app)
- **GitHub**: [sylorx/WinDeploy](https://github.com/sylorx/WinDeploy)
- **Issues**: [Report a problem](https://github.com/sylorx/WinDeploy/issues)

---

**Enjoy!** 🎉

Your apps will be installed in no time. Grab a coffee ☕ and let WinDeploy do the work!
