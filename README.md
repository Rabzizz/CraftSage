# CraftSage

> Profession leveling guide for WoW Classic Era & Hardcore — tells you exactly what to craft next, from skill 1 to 300.


![CurseForgeGameVersions](https://img.shields.io/curseforge/game-versions/1537185?style=flat-square&logo=battledotnet
)
![CurseForge Downloads](https://img.shields.io/curseforge/dt/1537185)
[![Version](https://img.shields.io/github/v/release/Rabzizz/CraftSage?label=version&color=4ade80&style=flat-square)](https://github.com/Rabzizz/CraftSage/releases/latest)
---

## What it does

CraftSage attaches a side panel to the native TradeSkill window. It reads your current skill level, finds the optimal next recipe to craft, and keeps a live shopping list of everything you still need — all without any setup.

## Features

- **Auto-tracks skill level** — always in sync, no configuration required
- **Step-by-step guide** — active recipe highlighted in your TradeSkill list, upcoming steps shown dimmed (configurable: 0–3)
- **Trainer step callouts** — when you need to visit a trainer (Apprentice → Expert → Artisan), the panel shows an amber callout with the trainer's name and location for your faction
- **Live mat counts** — green/red have/need counts pulled directly from your bags
- **Vendor mat tags** — materials you buy from an NPC (vials, salt, rods, etc.) are highlighted in amber with a `[buy]` tag so you know not to farm them
- **Item tooltips** — hover any material or the active recipe to see its native WoW tooltip
- **Ctrl+Click → Wowhead** — Ctrl+click any mat or recipe to get a pre-filled Wowhead URL ready to copy
- **Shopping list** — full material aggregation with checkboxes and one-click Copy to Chat
- **Skill progress bar** — visual 0–300 bar at a glance
- **HC Recommended badge** — marks professions with gold-efficient leveling paths
- **Settings panel** — customize panel scale, opacity, number of upcoming steps, auto-open behavior, step flash, tooltips, vendor highlights, and more. Access via Escape → Interface → AddOns → CraftSage, or the minimap button
- **Minimap button** — click to open the settings panel from anywhere; position is draggable and saved between sessions
- **8 professions supported** — Alchemy, Blacksmithing, Engineering, Enchanting, Leatherworking, Tailoring, Cooking, First Aid

**Localizations:** English (enUS), French (frFR), German (deDE)

---

## Installation

**From CurseForge or Wago.io (recommended)**

Use the CurseForge App or Wago App to install and keep CraftSage up to date automatically.

**Manual**

1. Download the latest zip from the [Releases](../../releases) page
2. Extract into `World of Warcraft\_classic_era_\Interface\AddOns\`
3. Reload the game or log in

---

## Usage

Open any profession TradeSkill window — CraftSage appears automatically on the right side. The panel is freely movable; drag it anywhere. It hides when you close the window.

| Command            | Effect                                                    |
| ------------------ | --------------------------------------------------------- |
| `/craftsage`       | Toggle the panel open/closed                              |
| `/craftsage reset` | Clear shopping list checkmarks for the current profession |

Access settings via **Escape → Interface → AddOns → CraftSage** or click the minimap button.

---

## Compatibility

- **Game version:** WoW Classic Era (Interface 11508)
- Does **not** support Wrath Classic, Cataclysm Classic, or Retail

---

## Development

**Requirements:** WoW Classic Era client, a text editor

**Install path for testing:**
```
C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\CraftSage\
```

Symlink or copy the repo folder there. After code changes, reload in-game with `/reload`.

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
└── Libs/               # Ace3 suite + LibDBIcon + SimpleSticky
```

---

## Feedback & Contributing

CraftSage is actively being developed — new features and improvements are on the way. If you run into a bug or have a suggestion, feel free to open an issue on GitHub or leave a comment on CurseForge. All feedback is welcome!

---

## Credits

Crafting step order, quantities, and material lists are based on guides from [Wowhead](https://www.wowhead.com). All data has been verified against WoW Classic Era recipes and adjusted with ~30% buffer quantities for yellow-quality RNG.

Built with [Ace3](https://www.wowace.com/projects/ace3), [LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0), and [SimpleSticky](https://www.wowinterface.com/downloads/info7118).

*This addon was built with the assistance of AI tools.*
