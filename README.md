# CraftSage

> Profession leveling guide for WoW Classic Era & Hardcore — tells you exactly what to craft next, from skill 1 to 300.

![WoW Classic Era](https://img.shields.io/badge/WoW-Classic%20Era-c69b3a?style=flat-square)
![Version](https://img.shields.io/badge/version-1.0.0-4ade80?style=flat-square)
![Interface](https://img.shields.io/badge/interface-11504-4ade80?style=flat-square)

---

## What it does

CraftSage attaches a side panel to the native TradeSkill window. It reads your current skill level, finds the optimal next recipe to craft, and keeps a live shopping list of everything you still need — all without any setup.

## Features

- **Auto-tracks skill level** — always in sync, no configuration required
- **Step-by-step guide** — active recipe highlighted in your TradeSkill list, next two steps shown dimmed
- **Live mat counts** — green/red have/need counts pulled directly from your bags
- **Shopping list** — full material aggregation with checkboxes and one-click Copy to Chat
- **Skill progress bar** — visual 0–300 bar at a glance
- **HC Recommended badge** — marks professions with gold-efficient
- **8 professions supported** — Alchemy, Blacksmithing, Engineering, Enchanting, Leatherworking, Tailoring, Cooking, First Aid

**Localizations:** English (enUS), French (frFR), German (deDE)

---

## Installation

**From CurseForge or Wago.io (recommended)**

Use the CurseForge App or Wago App to install and keep CraftSage up to date automatically.

**Manual**

1. Download the latest zip from the [Releases](../../releases) page
2. Extract into `World of Warcraft\_classic_era_\Interface\AddOns\`
3. The result should be `Interface\AddOns\CraftSage\CraftSage.toc`
4. Reload the game or log in

---

## Usage

Open any profession TradeSkill window — CraftSage appears automatically on the right side. It hides when you close the window.

| Command            | Effect                                                    |
| ------------------ | --------------------------------------------------------- |
| `/craftsage`       | Toggle the panel open/closed                              |
| `/craftsage reset` | Clear shopping list checkmarks for the current profession |

---

## Compatibility

- **Game version:** WoW Classic Era (Interface 11504)
- Does **not** support Wrath Classic, Cataclysm Classic, or Retail

---

## Development

**Requirements:** WoW Classic Era client, a text editor

**Install path for testing:**
```
C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\CraftSage\
```

Symlink or copy the repo folder there. After code changes, reload in-game with `/reload`.

**Build a release zip:**
```powershell
.\build-release.ps1
# Output: dist/CraftSage-<version>.zip
```

**Project structure:**

```
CraftSage/
├── CraftSage.toc       # Manifest
├── Core.lua            # Lifecycle, events, active-step logic
├── UI/
│   ├── Panel.lua       # Side panel
│   ├── ShoppingList.lua
│   └── Frames.xml
├── Data/               # Pure data files, one per profession
├── Locale/             # AceLocale-3.0 strings (enUS, frFR, deDE)
└── Libs/               # Ace3 suite + SimpleSticky
```

---

## Credits

Crafting step order, quantities, and material lists are based on guides from [Wowhead](https://www.wowhead.com). All data has been verified against WoW Classic Era recipes and adjusted with ~30% buffer quantities for yellow-quality RNG.

Built with [Ace3](https://www.wowace.com/projects/ace3) and [SimpleSticky](https://www.wowinterface.com/downloads/info7118).
