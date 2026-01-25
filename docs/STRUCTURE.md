# 📁 WinDeploy Project Structure

Last Updated: January 2026

## Directory Layout

```
WinDeploy/
│
├── scripts/                    # PowerShell Application Files
│   ├── WinDeploy.ps1          # Main GUI application (823 lines)
│   │   ├── Windows Forms UI with TabControl
│   │   ├── Tab 1: Uygulamalar (120+ pre-configured apps)
│   │   ├── Tab 2: Sistem (System Info & Management Tools)
│   │   ├── WinGet & Chocolatey integration
│   │   ├── BackgroundWorker for async installation
│   │   ├── Import/Export JSON support
│   │   ├── System information retrieval
│   │   └── Detailed file-based logging
│   │
│   ├── launcher.ps1           # Bootstrap script
│   │   ├── Admin privilege check
│   │   ├── Auto-elevation if needed
│   │   ├── Downloads WinDeploy.ps1 from Vercel
│   │   └── Entry point for one-liner
│   │
│   └── deploy.ps1             # Deployment automation
│       ├── Copies web/ to public/
│       ├── Manages file sync
│       └── Git push automation
│
├── web/                        # Website Source Code (HTML/CSS/JS)
│   ├── index.html             # Landing page (responsive)
│   ├── style.css              # Styles (dark theme, #0096d7)
│   └── script.js              # JavaScript (smooth scroll, copy-to-clipboard)
│
├── docs/                       # Documentation (Markdown)
│   ├── STRUCTURE.md           # This file - Project structure
│   ├── QUICKSTART.md          # 5-minute quick start guide
│   ├── INSTALL.md             # Installation methods & troubleshooting
│   ├── TROUBLESHOOTING.md     # Common issues & solutions
│   └── DEVELOPMENT.md         # Development & contribution guide
│
├── public/                     # Vercel Deployment Folder
│   ├── index.html             # Copy of web/index.html
│   ├── style.css              # Copy of web/style.css
│   ├── script.js              # Copy of web/script.js
│   ├── launcher.ps1           # Copy of scripts/launcher.ps1
│   └── WinDeploy.ps1          # Copy of scripts/WinDeploy.ps1
│
├── vercel.json                 # Vercel Configuration
│   └── Defines: build, deploy, headers, MIME types
│
├── .vercelignore               # Files to ignore during deploy
│   └── Excludes: scripts/, web/, docs/, git/
│
├── .gitignore                  # Git ignore rules
│   └── Ignores: .exe, .dll, temp/, etc.
│
├── README.md                   # Main documentation (GitHub)
│
└── LICENSE                     # MIT License

```

---

## Directory Roles

### `scripts/`
**Purpose**: PowerShell application and utilities

| File | Purpose | Size | Status |
|------|---------|------|--------|
| `WinDeploy.ps1` | Main GUI app | 515 lines | ✅ Working |
| `launcher.ps1` | Bootstrap | ~50 lines | ✅ Working |
| `deploy.ps1` | Deploy automation | ~200 lines | ✅ Working |

**Key Features**:
- Windows Forms GUI
- 120+ apps in 10 categories
- Async background installation
- Import/Export JSON
- File-based logging

### `web/`
**Purpose**: Website source code

| File | Purpose | Notes |
|------|---------|-------|
| `index.html` | Landing page | Dark theme, responsive |
| `style.css` | Styles | #0096d7 accent color |
| `script.js` | Interactions | Smooth scroll, copy-to-clipboard |

**Features**:
- Responsive design
- Dark theme (0f0f0f bg)
- Feature cards
- Code blocks
- Smooth animations

### `docs/`
**Purpose**: Documentation (all markdown files)

| File | Audience | Content |
|------|----------|---------|
| `STRUCTURE.md` | Developers | Project organization |
| `QUICKSTART.md` | Users | 5-minute setup |
| `INSTALL.md` | Users | Installation methods |
| `TROUBLESHOOTING.md` | Support | Issues & fixes |
| `DEVELOPMENT.md` | Contributors | Dev environment |

### `public/`
**Purpose**: Vercel deployment root

**Contents** (copies of source):
- `index.html` ← web/index.html
- `style.css` ← web/style.css
- `script.js` ← web/script.js
- `launcher.ps1` ← scripts/launcher.ps1
- `WinDeploy.ps1` ← scripts/WinDeploy.ps1

**Auto-served by Vercel** at: https://windeploy.vercel.app

---

## File Organization Philosophy

### Source of Truth
- **Scripts**: `scripts/` folder
- **Website**: `web/` folder  
- **Docs**: `docs/` folder

### Deployment Copy
- **Public**: `public/` folder (synced from source)
- **Deployment**: Vercel reads from `public/`

### Never Edit
- `public/` files directly (edit source instead)
- Auto-copy on deployment

---

## Build & Deployment Flow

```
Local Development
    ↓
scripts/ + web/ + docs/ (edit here)
    ↓
git push
    ↓
GitHub (main branch)
    ↓
Vercel Webhook
    ↓
Copy web/ → public/
Copy scripts/ → public/
    ↓
Build (static files only)
    ↓
Deploy to https://windeploy.vercel.app
```

---

## Configuration Files

### `vercel.json`
Controls Vercel deployment:
- Build command
- Output directory (`public/`)
- Content-Type headers
- URL routing rules

### `.vercelignore`
Files to ignore during deployment:
- `scripts/` (source, not deployed)
- `web/` (source, not deployed)
- `docs/` (source, not deployed)
- `.git/`
- `.gitignore`

### `.gitignore`
Files to ignore in Git:
- `.exe`, `.dll` (compiled binaries)
- `temp/`, `*.tmp` (temporary)
- `.vscode/` (IDE configs)

---

## Key Statistics

| Metric | Value |
|--------|-------|
| **Total Lines (PowerShell)** | ~765 lines |
| **Pre-configured Apps** | 120+ |
| **App Categories** | 8 |
| **Supported Package Managers** | 2 (WinGet, Chocolatey) |
| **Website Files** | 3 (HTML, CSS, JS) |
| **Documentation Files** | 5 markdown |
| **Main App Size** | ~25 KB |

---

## Development Notes

### Adding New Files

1. **PowerShell Script**: Add to `scripts/`
2. **Web Asset**: Add to `web/`
3. **Documentation**: Add to `docs/`
4. **Deployment**: Copy to `public/` or use `scripts/deploy.ps1`

### Before Committing

```powershell
# Check structure
Get-ChildItem -Recurse | Select-Object FullName

# Verify no unwanted files
git status

# Add and commit
git add -A
git commit -m "feat: description"
git push origin main
```

### Vercel Redeploy

Automatic on `git push` to main branch.
Manual: Visit [Vercel Dashboard](https://vercel.com) → Projects → WinDeploy → Redeploy

---

## Common Tasks

### Update Website
```
Edit: web/index.html, style.css, script.js
Deploy: git push (auto-deploy)
```

### Update PowerShell App
```
Edit: scripts/WinDeploy.ps1
Copy: scripts/WinDeploy.ps1 → public/
Deploy: git push
```

### Add Documentation
```
Create: docs/NewGuide.md
Deploy: git push
```

---

## Troubleshooting

**Q: Changes not showing on website?**
- Check: `public/` folder has updated files
- Try: Clear browser cache (Ctrl+F5)
- Wait: Vercel cache (30-60 seconds)

**Q: PowerShell not downloading?**
- Check: `public/launcher.ps1` exists
- Check: Vercel content-type headers

**Q: Deployment failed?**
- Check: `vercel.json` syntax
- Check: `.vercelignore` rules
- View: Vercel dashboard logs

---

**Last Updated**: January 25, 2026  
**Status**: ✅ Current & Complete
