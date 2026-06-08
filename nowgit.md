# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | CatKey |
| **Git URL** | git@github.com:asunnyboy861/CatKey.git |
| **Repo URL** | https://github.com/asunnyboy861/CatKey |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/CatKey/ | ✅ Active |
| Support | https://asunnyboy861.github.io/CatKey/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/CatKey/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/CatKey/terms.html | ✅ Active |

## Repository Structure

```
CatKey/
├── CatKey/                        # iOS App Source Code
│   ├── CatKey.xcodeproj/          # Xcode Project
│   ├── CatKey/                    # Main App Swift Source Files
│   │   ├── Views/
│   │   ├── Services/
│   │   └── CatKeyApp.swift
│   ├── CatKeyKeyboard/            # Keyboard Extension
│   │   ├── Engines/
│   │   ├── Models/
│   │   ├── Resources/
│   │   ├── Views/
│   │   └── KeyboardViewController.swift
│   ├── CatKeyShared/              # Shared Code (App + Extension)
│   │   ├── Constants/
│   │   ├── Extensions/
│   │   └── Protocols/
│   └── CatKeyTests/               # Unit & UI Tests
├── docs/                          # Policy Pages (GitHub Pages source)
│   ├── index.html
│   ├── support.html
│   ├── privacy.html
│   └── terms.html
├── .github/workflows/
│   └── deploy.yml
├── us.md
├── keytext.md
├── capabilities.md
├── icon.md
├── price.md
└── nowgit.md
```
