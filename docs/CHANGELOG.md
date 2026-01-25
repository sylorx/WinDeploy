# CHANGELOG - WinDeploy v6.0

## [6.0.0] - 2026-01-25

### 🎉 Major Release: System Information Tab Added

#### ✨ New Features

**🖥️ System Information Tab**
- Display system information in dedicated tab
- Show computer name, OS, version, and architecture
- Display total, used, and free disk space
- Show installed RAM amount
- Real-time system metrics retrieval

**🛠️ System Management Tools Panel**
- One-click access to 8 system management tools
- Color-coded buttons for quick identification
- Tools included:
  - System Optimization (Settings)
  - Windows Update Management
  - One-Click Windows Update
  - Driver Management (Device Manager)
  - System Cleanup (Disk Cleanup)
  - Startup Programs Management
  - Network Settings
  - Firewall Management

#### 🔧 Technical Improvements

- **TabControl Integration:** Replaced single scroll panel with multi-tab interface
- **Tab 1 (Uygulamalar):** Contains 120+ pre-configured applications
- **Tab 2 (Sistem):** New system information and management tools
- **Window Size:** Increased to 1000x800 for better visibility
- **Version Update:** v5.5 → v6.0
- **Code Size:** 515 lines → 823 lines (+308 lines for new features)

#### 📝 Function Additions

```powershell
function Get-SystemInfo
    - Retrieves: Computer name, OS, version, architecture
    - Disk metrics: Total, Used, Free space
    - RAM information

function Open-SystemTools
    - Handles system tool launching
    - 8 different system management shortcuts
```

#### 📚 Documentation Updates

- **README.md:** Updated system tools section with 8 management tools listed
- **STRUCTURE.md:** Updated app count (50+ → 120+), category count (8 → 10)
- **QUICKSTART.md:** Added System tab information and usage tips
- **NEW:** SYSTEM_TAB_GUIDE.md - Comprehensive guide for System tab (250+ lines)

#### 🎨 UI/UX Improvements

- Consistent color scheme across tabs
- Tool buttons arranged in 2-column grid
- Clear visual distinction between different tool categories
- Better use of window space with dual-tab layout

---

## [5.5] - Previous Release

### Features
- 120+ pre-configured applications
- 10 application categories (including Open Source and Extra Tools)
- WinGet and Chocolatey support
- Import/Export JSON functionality
- Beautiful dark-themed Windows Forms GUI
- Real-time installation logging
- Background worker for async operations

### Categories
1. Tarayıcılar (Browsers) - 10 apps
2. Multimedia - 15 apps
3. Geliştirme (Development) - 24 apps
4. Sistem (System) - 20 apps
5. İletişim (Communication) - 10 apps
6. Office - 6 apps
7. Güvenlik (Security) - 10 apps
8. Oyun (Games) - 10 apps
9. Açık Kaynak (Open Source) - 20 apps
10. Ekstra Araçlar (Extra Tools) - 20 apps

---

## Version History Summary

| Version | Release | Focus | Apps | Tabs |
|---------|---------|-------|------|------|
| 1.0 | Initial | Basic app manager | 30 | N/A |
| 2.0 | | Improved UI | 40 | N/A |
| 3.0 | | WinGet support | 50 | N/A |
| 4.0 | | Chocolatey fallback | 50 | N/A |
| 5.0 | | Modern dark GUI | 50+ | 1 |
| 5.5 | | 120+ apps | 120+ | 1 |
| **6.0** | **2026-01-25** | **System Management** | **120+** | **2** |

---

## Upgrade Notes

### From v5.5 to v6.0

**No Breaking Changes**
- All existing functionality preserved
- Applications tab identical to v5.5
- New system tab is additive

**Migration:**
1. Delete old `WinDeploy.ps1`
2. Download new version
3. Run as before
4. Explore new System tab

**Data Compatibility:**
- Old JSON exports still work
- Import/Export functionality unchanged
- All app configurations preserved

---

## Future Roadmap

### v6.1 (Q1 2026)
- [ ] System information refresh button
- [ ] App search/filter functionality
- [ ] System benchmark tools
- [ ] Network speed test integration

### v7.0 (Q2 2026)
- [ ] Scheduled system tasks
- [ ] System backup management
- [ ] Performance monitoring tab
- [ ] Cloud sync for app configs

### Wishlist
- [ ] Modern Windows 11 Fluent design
- [ ] System restore points management
- [ ] Windows Settings shortcuts
- [ ] Registry editor quick access
- [ ] Task scheduler integration
- [ ] Services management panel

---

## Known Issues

None reported for v6.0. If you encounter issues:
1. Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
2. Report on [GitHub Issues](https://github.com/sylorx/WinDeploy/issues)
3. Include WinDeploy log file: `%APPDATA%\WinDeploy\logs\`

---

## Credits

**Development:** WinDeploy Team
**Inspiration:** Chris Titus Tech (WinUtil)
**Package Managers:** Microsoft (WinGet), Chocolatey Community

---

## License

MIT License - See LICENSE file for details

---

**Latest Update:** January 25, 2026
**Next Check:** Check releases page for newer versions
**Website:** https://windeploy.vercel.app
