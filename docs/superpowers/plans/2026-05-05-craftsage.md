# CraftSage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a WoW Classic Era / Hardcore addon that attaches a side panel to the TradeSkill window, auto-tracks profession skill level, shows the optimal crafting step, and generates a full material shopping list from current skill to 300.

**Architecture:** Pure Lua + minimal XML addon using the Ace3 library suite. Core.lua owns all state and event handling. Panel.lua and ShoppingList.lua each own their own frames. Data files are pure Lua tables — no logic. Frames are created programmatically in Lua (no Frames.xml) for simplicity and reliability when hooking into Blizzard frames.

**Tech Stack:** Lua 5.1 (WoW embedded), AceAddon-3.0, AceEvent-3.0, AceDB-3.0, AceConsole-3.0, AceHook-3.0, AceLocale-3.0, LibStub, CallbackHandler-1.0, SimpleSticky.lua

---

## File Map

| Action | Path | Responsibility |
|---|---|---|
| Create | `CraftSage.toc` | Addon manifest, load order |
| Create | `Core.lua` | Lifecycle, events, active-step logic |
| Create | `Locale/enUS.lua` | All display strings |
| Create | `Data/Alchemy.lua` | Alchemy leveling path 1-300 |
| Create | `Data/Blacksmithing.lua` | Blacksmithing leveling path 1-300 |
| Create | `Data/Engineering.lua` | Engineering leveling path 1-300 |
| Create | `Data/Enchanting.lua` | Enchanting leveling path 1-300 |
| Create | `Data/Leatherworking.lua` | Leatherworking leveling path 1-300 |
| Create | `Data/Tailoring.lua` | Tailoring leveling path 1-300 |
| Create | `Data/Cooking.lua` | Cooking leveling path 1-300 |
| Create | `Data/FirstAid.lua` | First Aid leveling path 1-300 |
| Create | `UI/Panel.lua` | Side panel frame, rendering, mat counts |
| Create | `UI/ShoppingList.lua` | Shopping list popup, aggregation, checkboxes |
| Copy | `Libs/` | LibStub, CallbackHandler-1.0, Ace suite, SimpleSticky |

> **Data validation note:** All profession step data in Tasks 4-7 must be spot-checked against [wowhead.com/classic/guide/professions-overview-wow-classic](https://www.wowhead.com/classic/guide/professions-overview-wow-classic) before release. Item names must match exactly what Classic returns from `GetItemCount()`.

---

## Task 1: Addon Scaffold — TOC + Directory Structure

**Files:**
- Create: `CraftSage.toc`
- Create: `Core.lua` (empty stub)
- Create: `Locale/enUS.lua` (empty stub)

- [ ] **Step 1: Create the directory skeleton**

```
CraftSage/
├── Data/
├── Libs/
├── Locale/
└── UI/
```

Run in the repo root:
```powershell
New-Item -ItemType Directory -Path Data, Libs, Locale, UI
```

- [ ] **Step 2: Create `CraftSage.toc`**

```
## Interface: 11504
## Title: CraftSage
## Notes: Profession leveling guide for WoW Classic Era / Hardcore
## Author: CraftSage
## Version: 1.0.0
## SavedVariables: CraftSageDB

Libs\LibStub\LibStub.lua
Libs\CallbackHandler-1.0\CallbackHandler-1.0.lua
Libs\AceAddon-3.0\AceAddon-3.0.lua
Libs\AceEvent-3.0\AceEvent-3.0.lua
Libs\AceDB-3.0\AceDB-3.0.lua
Libs\AceConsole-3.0\AceConsole-3.0.lua
Libs\AceHook-3.0\AceHook-3.0.lua
Libs\AceLocale-3.0\AceLocale-3.0.lua
Libs\SimpleSticky.lua

Locale\enUS.lua

Data\Alchemy.lua
Data\Blacksmithing.lua
Data\Engineering.lua
Data\Enchanting.lua
Data\Leatherworking.lua
Data\Tailoring.lua
Data\Cooking.lua
Data\FirstAid.lua

UI\Panel.lua
UI\ShoppingList.lua

Core.lua
```

- [ ] **Step 3: Create `Core.lua` stub** (just enough to load without errors)

```lua
local AddonName, NS = ...

local CraftSage = LibStub("AceAddon-3.0"):NewAddon("CraftSage",
  "AceEvent-3.0",
  "AceConsole-3.0",
  "AceHook-3.0"
)
NS.CraftSage = CraftSage

function CraftSage:OnInitialize()
end

function CraftSage:OnEnable()
end
```

- [ ] **Step 4: Create `Locale/enUS.lua` stub**

```lua
local L = LibStub("AceLocale-3.0"):NewLocale("CraftSage", "enUS", true)
```

- [ ] **Step 5: Create empty data stubs** (one line each so TOC loads without errors)

`Data/Alchemy.lua`:
```lua
CraftSageData = CraftSageData or {}
```

Repeat the same single-line content for: `Data/Blacksmithing.lua`, `Data/Engineering.lua`, `Data/Enchanting.lua`, `Data/Leatherworking.lua`, `Data/Tailoring.lua`, `Data/Cooking.lua`, `Data/FirstAid.lua`.

- [ ] **Step 6: Create empty UI stubs**

`UI/Panel.lua`:
```lua
local AddonName, NS = ...
NS.Panel = {}
```

`UI/ShoppingList.lua`:
```lua
local AddonName, NS = ...
NS.ShoppingList = {}
```

- [ ] **Step 7: Verify addon loads in-game**

Copy/symlink repo to:
```
C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\CraftSage\
```
Log in, run `/reload`. Expected: no Lua errors, CraftSage appears in the addon list.

- [ ] **Step 8: Commit**

```bash
git add CraftSage.toc Core.lua Locale/enUS.lua Data/ UI/
git commit -m "feat: addon scaffold with TOC and stubs"
```

---

## Task 2: Library Setup

**Files:**
- Copy into: `Libs/`
- Modify: `CraftSage.toc` (already references libs — just need files present)

- [ ] **Step 1: Copy libs from Bartender4**

```powershell
$src = "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\Bartender4\libs"
$dst = "d:\00_dev\Wow\CraftSage\Libs"

$libs = @(
  "LibStub",
  "CallbackHandler-1.0",
  "AceAddon-3.0",
  "AceEvent-3.0",
  "AceDB-3.0",
  "AceConsole-3.0",
  "AceHook-3.0",
  "AceLocale-3.0"
)

foreach ($lib in $libs) {
  Copy-Item -Path "$src\$lib" -Destination "$dst\$lib" -Recurse -Force
}

Copy-Item -Path "$src\SimpleSticky.lua" -Destination "$dst\SimpleSticky.lua" -Force
```

- [ ] **Step 2: Verify lib files exist**

```powershell
Get-ChildItem "d:\00_dev\Wow\CraftSage\Libs" -Recurse -Filter "*.lua" | Select-Object Name
```

Expected: LibStub.lua, CallbackHandler-1.0.lua, AceAddon-3.0.lua, AceEvent-3.0.lua, AceDB-3.0.lua, AceConsole-3.0.lua, AceHook-3.0.lua, AceLocale-3.0.lua, SimpleSticky.lua all present.

- [ ] **Step 3: Verify no errors in-game**

`/reload` in-game. Expected: no Lua errors.

- [ ] **Step 4: Commit**

```bash
git add Libs/
git commit -m "feat: add Ace3 libraries and SimpleSticky"
```

---

## Task 3: Locale File

**Files:**
- Modify: `Locale/enUS.lua`

- [ ] **Step 1: Write all display strings**

```lua
-- Locale/enUS.lua
local L = LibStub("AceLocale-3.0"):NewLocale("CraftSage", "enUS", true)

L["PANEL_TITLE"]         = "CraftSage"
L["HC_BADGE"]            = "HC Recommended"
L["GUIDE_STEPS"]         = "Guide Steps"
L["STEP_MATS"]           = "Step materials:"
L["SHOPPING_LIST_BTN"]   = "Shopping List"
L["RESET_BTN"]           = "Reset"
L["NO_GUIDE"]            = "No guide available."
L["MAXED"]               = "Maxed! Congratulations!"
L["HAVE"]                = "have"
L["NEED_FMT"]            = "x%d needed"
L["SKILL_FMT"]           = "%d / %d"
L["SHOPPING_TITLE"]      = "Shopping List"
L["SHOPPING_RANGE_FMT"]  = "%s - Skill %d to 300"
L["GATHERED_FMT"]        = "%d of %d gathered (%d%%)"
L["CLEAR_CHECKS"]        = "Clear Checks"
L["COPY_TO_CHAT"]        = "Copy to Chat"
L["Herbs"]               = "Herbs"
L["Metals"]              = "Metals"
L["Leather"]             = "Leather"
L["Cloth"]               = "Cloth"
L["Other"]               = "Other"
```

- [ ] **Step 2: Verify no errors in-game**

`/reload`. Expected: no Lua errors.

- [ ] **Step 3: Commit**

```bash
git add Locale/enUS.lua
git commit -m "feat: add enUS locale strings"
```

---

## Task 4: Data — Alchemy and Engineering

**Files:**
- Modify: `Data/Alchemy.lua`
- Modify: `Data/Engineering.lua`

> Both are HC-recommended (`hc_recommended = true`). Build these first so the panel has working data to render against during UI development.

- [ ] **Step 1: Write `Data/Alchemy.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Alchemy"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Minor Healing Potion",
      skill_up_to = 55,
      qty         = 65,
      mats = {
        { item = "Peacebloom",  count = 1 },
        { item = "Silverleaf",  count = 1 },
        { item = "Empty Vial",  count = 1 },
      },
    },
    {
      recipe      = "Lesser Healing Potion",
      skill_up_to = 110,
      qty         = 70,
      mats = {
        { item = "Briarthorn",  count = 1 },
        { item = "Silverleaf",  count = 1 },
        { item = "Leaded Vial", count = 1 },
      },
    },
    {
      recipe      = "Elixir of Wisdom",
      skill_up_to = 140,
      qty         = 40,
      mats = {
        { item = "Briarthorn",   count = 1 },
        { item = "Swiftthistle", count = 1 },
        { item = "Leaded Vial",  count = 1 },
      },
    },
    {
      recipe      = "Healing Potion",
      skill_up_to = 185,
      qty         = 55,
      mats = {
        { item = "Bruiseweed",  count = 1 },
        { item = "Briarthorn",  count = 1 },
        { item = "Leaded Vial", count = 1 },
      },
    },
    {
      recipe      = "Greater Healing Potion",
      skill_up_to = 215,
      qty         = 40,
      mats = {
        { item = "Kingsblood",   count = 1 },
        { item = "Liferoot",     count = 1 },
        { item = "Crystal Vial", count = 1 },
      },
    },
    {
      recipe      = "Superior Healing Potion",
      skill_up_to = 250,
      qty         = 50,
      mats = {
        { item = "Sungrass",     count = 1 },
        { item = "Kingsblood",   count = 1 },
        { item = "Crystal Vial", count = 1 },
      },
    },
    {
      recipe      = "Superior Mana Potion",
      skill_up_to = 265,
      qty         = 25,
      mats = {
        { item = "Sungrass",     count = 2 },
        { item = "Blindweed",    count = 1 },
        { item = "Crystal Vial", count = 1 },
      },
    },
    {
      recipe      = "Major Healing Potion",
      skill_up_to = 300,
      qty         = 40,
      mats = {
        { item = "Golden Sansam",        count = 3 },
        { item = "Mountain Silversage",  count = 1 },
        { item = "Crystal Vial",         count = 1 },
      },
    },
  },
}
```

- [ ] **Step 2: Write `Data/Engineering.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Engineering"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Rough Blasting Powder",
      skill_up_to = 50,
      qty         = 60,
      mats = {
        { item = "Rough Stone", count = 1 },
      },
    },
    {
      recipe      = "Handful of Copper Bolts",
      skill_up_to = 75,
      qty         = 35,
      mats = {
        { item = "Copper Bar", count = 1 },
      },
    },
    {
      recipe      = "Copper Tube",
      skill_up_to = 105,
      qty         = 40,
      mats = {
        { item = "Copper Bar", count = 2 },
      },
    },
    {
      recipe      = "Coarse Blasting Powder",
      skill_up_to = 125,
      qty         = 30,
      mats = {
        { item = "Coarse Stone", count = 1 },
      },
    },
    {
      recipe      = "Bronze Tube",
      skill_up_to = 150,
      qty         = 35,
      mats = {
        { item = "Bronze Bar", count = 3 },
        { item = "Weak Flux",  count = 1 },
      },
    },
    {
      recipe      = "Whirring Bronze Gizmo",
      skill_up_to = 175,
      qty         = 35,
      mats = {
        { item = "Bronze Bar", count = 2 },
        { item = "Silk Cloth", count = 1 },
      },
    },
    {
      recipe      = "Heavy Blasting Powder",
      skill_up_to = 200,
      qty         = 35,
      mats = {
        { item = "Heavy Stone", count = 1 },
      },
    },
    {
      recipe      = "Mithril Tube",
      skill_up_to = 225,
      qty         = 35,
      mats = {
        { item = "Mithril Bar", count = 3 },
      },
    },
    {
      recipe      = "Mithril Casing",
      skill_up_to = 250,
      qty         = 35,
      mats = {
        { item = "Mithril Bar", count = 3 },
      },
    },
    {
      recipe      = "Dense Blasting Powder",
      skill_up_to = 260,
      qty         = 20,
      mats = {
        { item = "Dense Stone", count = 2 },
      },
    },
    {
      recipe      = "Thorium Widget",
      skill_up_to = 285,
      qty         = 35,
      mats = {
        { item = "Thorium Bar", count = 3 },
        { item = "Runecloth",   count = 1 },
      },
    },
    {
      recipe      = "Thorium Tube",
      skill_up_to = 300,
      qty         = 25,
      mats = {
        { item = "Thorium Bar", count = 5 },
      },
    },
  },
}
```

- [ ] **Step 3: Verify no errors in-game**

`/reload`. Expected: no Lua errors, `CraftSageData["Alchemy"]` and `CraftSageData["Engineering"]` accessible from console.

- [ ] **Step 4: Commit**

```bash
git add Data/Alchemy.lua Data/Engineering.lua
git commit -m "feat: add Alchemy and Engineering leveling data"
```

---

## Task 5: Data — Blacksmithing and First Aid

**Files:**
- Modify: `Data/Blacksmithing.lua`
- Modify: `Data/FirstAid.lua`

- [ ] **Step 1: Write `Data/Blacksmithing.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Blacksmithing"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Rough Sharpening Stone",
      skill_up_to = 65,
      qty         = 75,
      mats = {
        { item = "Rough Stone", count = 1 },
      },
    },
    {
      recipe      = "Coarse Sharpening Stone",
      skill_up_to = 100,
      qty         = 45,
      mats = {
        { item = "Coarse Stone", count = 1 },
      },
    },
    {
      recipe      = "Rough Bronze Leggings",
      skill_up_to = 130,
      qty         = 40,
      mats = {
        { item = "Bronze Bar",  count = 3 },
        { item = "Coarse Stone", count = 2 },
      },
    },
    {
      recipe      = "Patterned Bronze Bracers",
      skill_up_to = 150,
      qty         = 25,
      mats = {
        { item = "Bronze Bar", count = 3 },
      },
    },
    {
      recipe      = "Green Iron Bracers",
      skill_up_to = 165,
      qty         = 20,
      mats = {
        { item = "Iron Bar", count = 4 },
      },
    },
    {
      recipe      = "Green Iron Leggings",
      skill_up_to = 200,
      qty         = 45,
      mats = {
        { item = "Iron Bar",          count = 8 },
        { item = "Toughened Leather", count = 1 },
      },
    },
    {
      recipe      = "Solid Grinding Stone",
      skill_up_to = 210,
      qty         = 15,
      mats = {
        { item = "Solid Stone", count = 5 },
      },
    },
    {
      recipe      = "Mithril Coif",
      skill_up_to = 235,
      qty         = 30,
      mats = {
        { item = "Mithril Bar", count = 8 },
        { item = "Solid Stone", count = 2 },
      },
    },
    {
      recipe      = "Mithril Shield Spike",
      skill_up_to = 250,
      qty         = 20,
      mats = {
        { item = "Mithril Bar", count = 4 },
        { item = "Solid Stone", count = 2 },
      },
    },
    {
      recipe      = "Dense Sharpening Stone",
      skill_up_to = 265,
      qty         = 25,
      mats = {
        { item = "Dense Stone", count = 1 },
      },
    },
    {
      recipe      = "Thorium Bracers",
      skill_up_to = 285,
      qty         = 30,
      mats = {
        { item = "Thorium Bar", count = 2 },
      },
    },
    {
      recipe      = "Imperial Plate Bracers",
      skill_up_to = 300,
      qty         = 20,
      mats = {
        { item = "Thorium Bar", count = 6 },
      },
    },
  },
}
```

- [ ] **Step 2: Write `Data/FirstAid.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["First Aid"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Linen Bandage",
      skill_up_to = 50,
      qty         = 60,
      mats = {
        { item = "Linen Cloth", count = 1 },
      },
    },
    {
      recipe      = "Heavy Linen Bandage",
      skill_up_to = 80,
      qty         = 40,
      mats = {
        { item = "Linen Cloth", count = 2 },
      },
    },
    {
      recipe      = "Wool Bandage",
      skill_up_to = 115,
      qty         = 50,
      mats = {
        { item = "Wool Cloth", count = 1 },
      },
    },
    {
      recipe      = "Heavy Wool Bandage",
      skill_up_to = 150,
      qty         = 50,
      mats = {
        { item = "Wool Cloth", count = 2 },
      },
    },
    {
      recipe      = "Silk Bandage",
      skill_up_to = 180,
      qty         = 40,
      mats = {
        { item = "Silk Cloth", count = 1 },
      },
    },
    {
      recipe      = "Heavy Silk Bandage",
      skill_up_to = 210,
      qty         = 40,
      mats = {
        { item = "Silk Cloth", count = 2 },
      },
    },
    {
      recipe      = "Mageweave Bandage",
      skill_up_to = 240,
      qty         = 40,
      mats = {
        { item = "Mageweave Cloth", count = 1 },
      },
    },
    {
      recipe      = "Heavy Mageweave Bandage",
      skill_up_to = 265,
      qty         = 35,
      mats = {
        { item = "Mageweave Cloth", count = 2 },
      },
    },
    {
      recipe      = "Runecloth Bandage",
      skill_up_to = 290,
      qty         = 35,
      mats = {
        { item = "Runecloth", count = 1 },
      },
    },
    {
      recipe      = "Heavy Runecloth Bandage",
      skill_up_to = 300,
      qty         = 20,
      mats = {
        { item = "Runecloth", count = 2 },
      },
    },
  },
}
```

- [ ] **Step 3: Verify no errors in-game**

`/reload`. Expected: no Lua errors.

- [ ] **Step 4: Commit**

```bash
git add Data/Blacksmithing.lua Data/FirstAid.lua
git commit -m "feat: add Blacksmithing and First Aid leveling data"
```

---

## Task 6: Data — Tailoring and Leatherworking

**Files:**
- Modify: `Data/Tailoring.lua`
- Modify: `Data/Leatherworking.lua`

- [ ] **Step 1: Write `Data/Tailoring.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Tailoring"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Bolt of Linen Cloth",
      skill_up_to = 45,
      qty         = 55,
      mats = {
        { item = "Linen Cloth", count = 2 },
      },
    },
    {
      recipe      = "Linen Bag",
      skill_up_to = 70,
      qty         = 35,
      mats = {
        { item = "Bolt of Linen Cloth", count = 3 },
        { item = "Coarse Thread",       count = 1 },
      },
    },
    {
      recipe      = "Bolt of Woolen Cloth",
      skill_up_to = 105,
      qty         = 50,
      mats = {
        { item = "Wool Cloth", count = 3 },
      },
    },
    {
      recipe      = "Double-stitched Woolen Shoulders",
      skill_up_to = 150,
      qty         = 55,
      mats = {
        { item = "Bolt of Woolen Cloth", count = 3 },
        { item = "Fine Thread",          count = 1 },
      },
    },
    {
      recipe      = "Bolt of Silk Cloth",
      skill_up_to = 165,
      qty         = 25,
      mats = {
        { item = "Silk Cloth", count = 4 },
      },
    },
    {
      recipe      = "Azure Silk Belt",
      skill_up_to = 200,
      qty         = 45,
      mats = {
        { item = "Bolt of Silk Cloth", count = 3 },
        { item = "Blue Dye",           count = 2 },
        { item = "Fine Thread",        count = 1 },
      },
    },
    {
      recipe      = "Bolt of Mageweave",
      skill_up_to = 215,
      qty         = 20,
      mats = {
        { item = "Mageweave Cloth", count = 4 },
      },
    },
    {
      recipe      = "Black Mageweave Gloves",
      skill_up_to = 250,
      qty         = 50,
      mats = {
        { item = "Bolt of Mageweave",   count = 2 },
        { item = "Heavy Silken Thread", count = 1 },
      },
    },
    {
      recipe      = "Bolt of Runecloth",
      skill_up_to = 260,
      qty         = 20,
      mats = {
        { item = "Runecloth", count = 4 },
      },
    },
    {
      recipe      = "Runecloth Gloves",
      skill_up_to = 285,
      qty         = 40,
      mats = {
        { item = "Bolt of Runecloth", count = 2 },
        { item = "Rugged Leather",    count = 1 },
        { item = "Rune Thread",       count = 1 },
      },
    },
    {
      recipe      = "Runecloth Headband",
      skill_up_to = 300,
      qty         = 25,
      mats = {
        { item = "Bolt of Runecloth", count = 4 },
        { item = "Rune Thread",       count = 2 },
      },
    },
  },
}
```

- [ ] **Step 2: Write `Data/Leatherworking.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Leatherworking"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Handstitched Leather Belt",
      skill_up_to = 55,
      qty         = 65,
      mats = {
        { item = "Light Leather", count = 3 },
        { item = "Coarse Thread", count = 1 },
      },
    },
    {
      recipe      = "Embossed Leather Gloves",
      skill_up_to = 100,
      qty         = 55,
      mats = {
        { item = "Light Leather", count = 3 },
        { item = "Coarse Thread", count = 1 },
      },
    },
    {
      recipe      = "Fine Leather Belt",
      skill_up_to = 130,
      qty         = 40,
      mats = {
        { item = "Light Leather", count = 6 },
        { item = "Fine Thread",   count = 1 },
      },
    },
    {
      recipe      = "Dark Leather Belt",
      skill_up_to = 155,
      qty         = 35,
      mats = {
        { item = "Medium Leather",    count = 6 },
        { item = "Fine Thread",       count = 1 },
        { item = "Cured Medium Hide", count = 1 },
      },
    },
    {
      recipe      = "Hillman's Leather Gloves",
      skill_up_to = 185,
      qty         = 40,
      mats = {
        { item = "Heavy Leather", count = 6 },
        { item = "Fine Thread",   count = 2 },
      },
    },
    {
      recipe      = "Guardian Gloves",
      skill_up_to = 220,
      qty         = 45,
      mats = {
        { item = "Thick Leather",  count = 4 },
        { item = "Silken Thread",  count = 2 },
        { item = "Iron Buckle",    count = 1 },
      },
    },
    {
      recipe      = "Nightscape Headband",
      skill_up_to = 250,
      qty         = 40,
      mats = {
        { item = "Thick Leather", count = 4 },
        { item = "Silken Thread", count = 2 },
      },
    },
    {
      recipe      = "Nightscape Pants",
      skill_up_to = 265,
      qty         = 20,
      mats = {
        { item = "Thick Leather", count = 14 },
        { item = "Silken Thread", count = 2 },
      },
    },
    {
      recipe      = "Rugged Armor Kit",
      skill_up_to = 285,
      qty         = 30,
      mats = {
        { item = "Rugged Leather", count = 3 },
      },
    },
    {
      recipe      = "Wicked Leather Belt",
      skill_up_to = 300,
      qty         = 25,
      mats = {
        { item = "Rugged Leather", count = 6 },
        { item = "Rune Thread",    count = 2 },
      },
    },
  },
}
```

- [ ] **Step 3: Verify no errors in-game**

`/reload`. Expected: no Lua errors.

- [ ] **Step 4: Commit**

```bash
git add Data/Tailoring.lua Data/Leatherworking.lua
git commit -m "feat: add Tailoring and Leatherworking leveling data"
```

---

## Task 7: Data — Enchanting and Cooking

**Files:**
- Modify: `Data/Enchanting.lua`
- Modify: `Data/Cooking.lua`

> Enchanting steps include an optional `note` field shown in the panel — needed because each enchant requires a physical item to enchant (a cheap vendor item). The `note` field is optional in the schema; Panel.lua reads it if present.

- [ ] **Step 1: Write `Data/Enchanting.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Enchanting"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Enchant Bracer - Minor Health",
      skill_up_to = 45,
      qty         = 55,
      note        = "Enchant any cheap vendor item (e.g., Worn Shortsword)",
      mats = {
        { item = "Strange Dust", count = 1 },
      },
    },
    {
      recipe      = "Enchant Bracer - Minor Deflection",
      skill_up_to = 70,
      qty         = 35,
      note        = "Enchant any cheap vendor item",
      mats = {
        { item = "Strange Dust",          count = 2 },
        { item = "Lesser Astral Essence", count = 1 },
      },
    },
    {
      recipe      = "Enchant Bracer - Minor Agility",
      skill_up_to = 100,
      qty         = 40,
      note        = "Enchant any cheap vendor item",
      mats = {
        { item = "Lesser Astral Essence", count = 1 },
      },
    },
    {
      recipe      = "Enchant Bracer - Minor Spirit",
      skill_up_to = 135,
      qty         = 50,
      note        = "Enchant any cheap vendor item",
      mats = {
        { item = "Lesser Mystic Essence", count = 2 },
      },
    },
    {
      recipe      = "Enchant Shield - Lesser Protection",
      skill_up_to = 155,
      qty         = 25,
      note        = "Enchant any cheap shield from vendor",
      mats = {
        { item = "Greater Magic Essence", count = 4 },
      },
    },
    {
      recipe      = "Enchant Bracer - Strength",
      skill_up_to = 200,
      qty         = 60,
      note        = "Enchant any cheap vendor item",
      mats = {
        { item = "Greater Mystic Essence", count = 4 },
      },
    },
    {
      recipe      = "Enchant Cloak - Greater Defense",
      skill_up_to = 225,
      qty         = 35,
      note        = "Enchant any cheap cloak",
      mats = {
        { item = "Greater Nether Essence", count = 3 },
        { item = "Vision Dust",            count = 2 },
      },
    },
    {
      recipe      = "Enchant Bracer - Greater Strength",
      skill_up_to = 250,
      qty         = 35,
      note        = "Enchant any cheap vendor item",
      mats = {
        { item = "Vision Dust", count = 8 },
      },
    },
    {
      recipe      = "Enchant Bracer - Superior Strength",
      skill_up_to = 290,
      qty         = 50,
      note        = "Enchant any cheap vendor item",
      mats = {
        { item = "Illusion Dust", count = 8 },
      },
    },
    {
      recipe      = "Enchant Weapon - Mighty Intellect",
      skill_up_to = 300,
      qty         = 15,
      note        = "Enchant any cheap weapon",
      mats = {
        { item = "Large Brilliant Shard", count = 1 },
        { item = "Illusion Dust",         count = 10 },
      },
    },
  },
}
```

- [ ] **Step 2: Write `Data/Cooking.lua`**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Cooking"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Spice Bread",
      skill_up_to = 40,
      qty         = 55,
      mats = {
        { item = "Simple Flour", count = 1 },
        { item = "Mild Spices",  count = 1 },
      },
    },
    {
      recipe      = "Roasted Boar Meat",
      skill_up_to = 85,
      qty         = 55,
      mats = {
        { item = "Raw Boar Meat", count = 1 },
      },
    },
    {
      recipe      = "Crab Cake",
      skill_up_to = 130,
      qty         = 60,
      mats = {
        { item = "Crawler Meat",            count = 1 },
        { item = "Refreshing Spring Water", count = 1 },
      },
    },
    {
      recipe      = "Curiously Tasty Omelet",
      skill_up_to = 175,
      qty         = 65,
      mats = {
        { item = "Raptor Egg",  count = 2 },
        { item = "Mild Spices", count = 1 },
      },
    },
    {
      recipe      = "Tender Wolf Steak",
      skill_up_to = 225,
      qty         = 70,
      mats = {
        { item = "Tender Wolf Meat", count = 2 },
        { item = "Soothing Spices",  count = 1 },
      },
    },
    {
      recipe      = "Juicy Bear Burger",
      skill_up_to = 285,
      qty         = 80,
      mats = {
        { item = "Bear Flank",      count = 2 },
        { item = "Soothing Spices", count = 1 },
      },
    },
    {
      recipe      = "Smoked Desert Dumplings",
      skill_up_to = 300,
      qty         = 25,
      mats = {
        { item = "Sandworm Meat",   count = 1 },
        { item = "Soothing Spices", count = 1 },
      },
    },
  },
}
```

- [ ] **Step 3: Verify no errors in-game**

`/reload`. Expected: no Lua errors.

- [ ] **Step 4: Commit**

```bash
git add Data/Enchanting.lua Data/Cooking.lua
git commit -m "feat: add Enchanting and Cooking leveling data"
```

---

## Task 8: Core.lua — Full Implementation

**Files:**
- Modify: `Core.lua`

- [ ] **Step 1: Write full `Core.lua`**

```lua
local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local CraftSage = LibStub("AceAddon-3.0"):NewAddon("CraftSage",
  "AceEvent-3.0",
  "AceConsole-3.0",
  "AceHook-3.0"
)
NS.CraftSage = CraftSage

local DB_DEFAULTS = {
  char = {
    checkmarks = {},
  }
}

function CraftSage:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("CraftSageDB", DB_DEFAULTS, true)
  self:RegisterChatCommand("craftsage", "SlashCommand")
end

function CraftSage:OnEnable()
  self:RegisterEvent("TRADE_SKILL_SHOW", "OnTradeSkillShow")
  self:RegisterEvent("TRADE_SKILL_HIDE", "OnTradeSkillHide")
  self:RegisterEvent("TRADE_SKILL_UPDATE", "OnTradeSkillUpdate")
end

function CraftSage:OnTradeSkillShow()
  local profName, _, skillLevel, maxSkillLevel = GetTradeSkillLine()
  self.currentProf    = profName
  self.currentSkill   = skillLevel
  self.currentMaxSkill = maxSkillLevel
  self.currentData    = CraftSageData and CraftSageData[profName]
  self.activeStepIndex = self:ComputeActiveStep(self.currentData, skillLevel)
  NS.Panel:Refresh(profName, skillLevel, maxSkillLevel, self.currentData, self.activeStepIndex)
  self:HighlightActiveRecipe()
end

function CraftSage:OnTradeSkillHide()
  NS.Panel:Hide()
end

function CraftSage:OnTradeSkillUpdate()
  local _, _, skillLevel = GetTradeSkillLine()
  if skillLevel == self.currentSkill then return end
  local prevStep = self.activeStepIndex
  self.currentSkill = skillLevel
  self.activeStepIndex = self:ComputeActiveStep(self.currentData, skillLevel)
  NS.Panel:Refresh(
    self.currentProf, skillLevel, self.currentMaxSkill,
    self.currentData, self.activeStepIndex,
    self.activeStepIndex ~= prevStep
  )
  self:HighlightActiveRecipe()
end

function CraftSage:ComputeActiveStep(data, skillLevel)
  if not data then return nil end
  if skillLevel >= 300 then return nil end
  for i, step in ipairs(data.steps) do
    if step.skill_up_to > skillLevel then
      return i
    end
  end
  return nil
end

function CraftSage:HighlightActiveRecipe()
  if not self.currentData or not self.activeStepIndex then
    NS.Panel:SetHighlightedRecipeIndex(nil)
    return
  end
  local target = self.currentData.steps[self.activeStepIndex].recipe
  local numSkills = GetNumTradeSkills()
  for i = 1, numSkills do
    local skillName = GetTradeSkillInfo(i)
    if skillName == target then
      NS.Panel:SetHighlightedRecipeIndex(i)
      return
    end
  end
  NS.Panel:SetHighlightedRecipeIndex(nil)
end

function CraftSage:SlashCommand(input)
  local cmd = strtrim(input):lower()
  if cmd == "" then
    if NS.Panel:IsVisible() then
      NS.Panel:Hide()
    else
      NS.Panel:Refresh(self.currentProf, self.currentSkill, self.currentMaxSkill, self.currentData, self.activeStepIndex)
    end
  elseif cmd == "reset" then
    if self.currentProf then
      self.db.char.checkmarks[self.currentProf] = nil
      if NS.ShoppingList:IsVisible() then NS.ShoppingList:Refresh() end
      self:Print("Progress reset for " .. self.currentProf)
    end
  elseif cmd:sub(1, 5) == "debug" then
    local skill = tonumber(strtrim(cmd:sub(6)))
    if skill then
      self.currentSkill    = skill
      self.activeStepIndex = self:ComputeActiveStep(self.currentData, skill)
      NS.Panel:Refresh(self.currentProf, skill, self.currentMaxSkill, self.currentData, self.activeStepIndex, true)
      self:Print("Debug: skill forced to " .. skill)
    end
  end
end
```

- [ ] **Step 2: Verify no errors in-game**

`/reload`. Open Alchemy TradeSkill window. Expected: no Lua errors. Panel namespace functions exist (no nil errors in console).

- [ ] **Step 3: Commit**

```bash
git add Core.lua
git commit -m "feat: Core.lua event handling and active-step logic"
```

---

## Task 9: UI — Side Panel

**Files:**
- Modify: `UI/Panel.lua`

- [ ] **Step 1: Write full `UI/Panel.lua`**

```lua
local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local Panel = {}
NS.Panel = Panel

local PANEL_W = 185
local PANEL_H = 355

-- ── Frame ────────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "CraftSagePanelFrame", UIParent)
frame:SetSize(PANEL_W, PANEL_H)
frame:Hide()
frame:SetFrameStrata("HIGH")
frame:SetBackdrop({
  bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:SetBackdropColor(0.05, 0.1, 0.05, 0.97)
frame:SetBackdropBorderColor(0.2, 0.6, 0.2, 1)

-- Title
local titleBg = frame:CreateTexture(nil, "BACKGROUND")
titleBg:SetPoint("TOPLEFT",  frame, "TOPLEFT",  5, -5)
titleBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
titleBg:SetHeight(20)
titleBg:SetColorTexture(0.1, 0.3, 0.1, 0.8)

local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
titleText:SetPoint("TOP", frame, "TOP", 0, -11)
titleText:SetText(L["PANEL_TITLE"])
titleText:SetTextColor(0.5, 1, 0.5, 1)

-- Profession name
local profText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profText:SetPoint("TOP", frame, "TOP", 0, -31)
profText:SetTextColor(1, 0.82, 0, 1)

-- HC badge
local hcText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
hcText:SetPoint("TOP", profText, "BOTTOM", 0, -2)
hcText:SetTextColor(1, 0.5, 0.1, 1)
hcText:SetText(L["HC_BADGE"])
hcText:Hide()

-- Skill bar
local skillBarBg = frame:CreateTexture(nil, "BACKGROUND")
skillBarBg:SetPoint("TOPLEFT",  frame, "TOPLEFT",  10, -58)
skillBarBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -58)
skillBarBg:SetHeight(8)
skillBarBg:SetColorTexture(0, 0, 0, 0.7)

local skillBarFill = frame:CreateTexture(nil, "ARTWORK")
skillBarFill:SetPoint("TOPLEFT", skillBarBg, "TOPLEFT", 1, -1)
skillBarFill:SetHeight(6)
skillBarFill:SetColorTexture(0.2, 0.8, 0.2, 1)
skillBarFill:SetWidth(1)

local skillText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
skillText:SetPoint("TOP", skillBarBg, "BOTTOM", 0, -3)
skillText:SetTextColor(0.8, 0.8, 0.8, 1)

-- Guide steps label
local stepsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
stepsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -82)
stepsLabel:SetTextColor(0.5, 0.5, 0.5, 1)
stepsLabel:SetText(L["GUIDE_STEPS"])

-- 3 step rows: [1]=active (green), [2],[3]=next (dimmed)
local stepRows = {}
for i = 1, 3 do
  local r = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  r:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -95 - (i - 1) * 16)
  r:SetWidth(PANEL_W - 20)
  r:SetJustifyH("LEFT")
  stepRows[i] = r
end

-- Divider
local divider = frame:CreateTexture(nil, "ARTWORK")
divider:SetPoint("TOPLEFT",  frame, "TOPLEFT",  5, -148)
divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -148)
divider:SetHeight(1)
divider:SetColorTexture(0.2, 0.5, 0.2, 0.5)

-- Mats label
local matsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
matsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -154)
matsLabel:SetTextColor(0.5, 0.5, 0.5, 1)
matsLabel:SetText(L["STEP_MATS"])

-- Note text (Enchanting target-item hints)
local noteText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
noteText:SetPoint("TOPLEFT",  frame, "TOPLEFT",  10, -167)
noteText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -167)
noteText:SetJustifyH("LEFT")
noteText:SetTextColor(0.6, 0.6, 0.4, 1)
noteText:Hide()

-- 6 mat rows
local matRows = {}
for i = 1, 6 do
  local yOff = -170 - (i - 1) * 14
  local nm = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  nm:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOff)
  nm:SetWidth(120)
  nm:SetJustifyH("LEFT")
  nm:SetTextColor(0.85, 0.85, 0.85, 1)

  local ct = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  ct:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, yOff)
  ct:SetJustifyH("RIGHT")

  matRows[i] = { name = nm, count = ct }
end

-- Message (No guide / Maxed)
local msgText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
msgText:SetPoint("CENTER", frame, "CENTER", 0, 20)
msgText:SetTextColor(1, 0.82, 0, 1)
msgText:Hide()

-- Buttons
local shopBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
shopBtn:SetSize(110, 20)
shopBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
shopBtn:SetText(L["SHOPPING_LIST_BTN"])
shopBtn:SetScript("OnClick", function() NS.ShoppingList:Toggle() end)

local resetBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
resetBtn:SetSize(55, 20)
resetBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
resetBtn:SetText(L["RESET_BTN"])
resetBtn:SetScript("OnClick", function() NS.CraftSage:SlashCommand("reset") end)

-- ── State ─────────────────────────────────────────────────────────────────────
local highlightedIndex = nil

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function ShowAllMats(show)
  for i = 1, 6 do
    matRows[i].name:SetShown(show)
    matRows[i].count:SetShown(show)
  end
end

local function HideUnusedMatRows(count)
  for i = count + 1, 6 do
    matRows[i].name:Hide()
    matRows[i].count:Hide()
  end
end

-- ── API ───────────────────────────────────────────────────────────────────────

function Panel:Refresh(profName, skillLevel, maxSkillLevel, data, activeStepIndex, stepChanged)
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
  frame:Show()

  profText:SetText(profName or "")

  if data and data.hc_recommended then hcText:Show() else hcText:Hide() end

  if not data then
    msgText:SetText(L["NO_GUIDE"])
    msgText:Show()
    stepsLabel:Hide()
    divider:Hide()
    matsLabel:Hide()
    noteText:Hide()
    ShowAllMats(false)
    skillBarFill:SetWidth(1)
    skillText:SetText("")
    for i = 1, 3 do stepRows[i]:SetText("") end
    return
  end

  msgText:Hide()
  stepsLabel:Show()
  divider:Show()
  matsLabel:Show()

  -- skill bar
  local max = maxSkillLevel or 300
  local pct = math.max(0, math.min(1, skillLevel / max))
  local barW = (PANEL_W - 22) * pct
  skillBarFill:SetWidth(math.max(1, barW))
  skillText:SetText(string.format(L["SKILL_FMT"], skillLevel, max))

  if not activeStepIndex then
    msgText:SetText(L["MAXED"])
    msgText:Show()
    for i = 1, 3 do stepRows[i]:SetText("") end
    matsLabel:Hide()
    noteText:Hide()
    ShowAllMats(false)
    return
  end

  -- guide step rows
  for i = 1, 3 do
    local idx  = activeStepIndex + (i - 1)
    local step = data.steps[idx]
    if step then
      if i == 1 then
        stepRows[i]:SetText(string.format("|cff88ff88> %s (to %d)|r", step.recipe, step.skill_up_to))
      else
        stepRows[i]:SetText(string.format("|cff555555%d. %s (to %d)|r", idx, step.recipe, step.skill_up_to))
      end
    else
      stepRows[i]:SetText("")
    end
  end

  -- active step mats
  local step      = data.steps[activeStepIndex]
  local stepStart = activeStepIndex > 1 and data.steps[activeStepIndex - 1].skill_up_to or 1
  local remaining = math.max(1, math.ceil(
    step.qty * (step.skill_up_to - skillLevel) / (step.skill_up_to - stepStart)
  ))

  -- optional note (Enchanting etc.)
  if step.note then
    noteText:SetText(step.note)
    noteText:Show()
  else
    noteText:Hide()
  end

  for i, mat in ipairs(step.mats) do
    if i > 6 then break end
    local have = GetItemCount(mat.item) or 0
    local need = mat.count * remaining
    matRows[i].name:SetText(mat.item)
    matRows[i].name:Show()
    if have >= need then
      matRows[i].count:SetText(L["HAVE"])
      matRows[i].count:SetTextColor(0.3, 1, 0.3, 1)
    else
      matRows[i].count:SetText(string.format(L["NEED_FMT"], need - have))
      matRows[i].count:SetTextColor(1, 0.3, 0.3, 1)
    end
    matRows[i].count:Show()
  end
  HideUnusedMatRows(#step.mats)
end

function Panel:Hide()
  frame:Hide()
end

function Panel:IsVisible()
  return frame:IsShown()
end

function Panel:SetHighlightedRecipeIndex(idx)
  highlightedIndex = idx
end
```

- [ ] **Step 2: Verify panel in-game**

Open the Alchemy TradeSkill window. Expected:
- CraftSage panel appears to the right of the TradeSkill window
- Profession name shows "Alchemy"
- HC badge visible
- Skill bar fills proportionally to current skill
- Active step shows in green with `→ skill_up_to` value
- Two dimmed steps below
- Mat rows show with have/need counts in correct colors
- "Shopping List" and "Reset" buttons visible

- [ ] **Step 3: Commit**

```bash
git add UI/Panel.lua
git commit -m "feat: side panel UI with skill bar, steps, and mat counts"
```

---

## Task 10: UI — Shopping List

**Files:**
- Modify: `UI/ShoppingList.lua`

- [ ] **Step 1: Write full `UI/ShoppingList.lua`**

```lua
local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local ShoppingList = {}
NS.ShoppingList = ShoppingList

local SL_W = 225
local SL_H = 390

-- ── Frame ────────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "CraftSageShoppingListFrame", UIParent)
frame:SetSize(SL_W, SL_H)
frame:SetPoint("CENTER")
frame:Hide()
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)
frame:SetFrameStrata("DIALOG")
frame:SetBackdrop({
  bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:SetBackdropColor(0.05, 0.05, 0.12, 0.97)
frame:SetBackdropBorderColor(0.3, 0.3, 0.8, 1)

-- Title
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOP", frame, "TOP", 0, -12)
titleText:SetTextColor(0.6, 0.6, 1, 1)
titleText:SetText(L["SHOPPING_TITLE"])

-- Subtitle
local subtitleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
subtitleText:SetPoint("TOP", titleText, "BOTTOM", 0, -4)
subtitleText:SetTextColor(0.6, 0.6, 0.6, 1)

-- Scroll frame
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT",     frame, "TOPLEFT",     8,  -46)
scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 50)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(SL_W - 36, 1)
scrollFrame:SetScrollChild(scrollChild)

-- Progress
local progressText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
progressText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 33)
progressText:SetTextColor(0.6, 0.6, 0.6, 1)

-- Buttons
local clearBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
clearBtn:SetSize(100, 20)
clearBtn:SetPoint("BOTTOMLEFT",  frame, "BOTTOMLEFT",  8, 8)
clearBtn:SetText(L["CLEAR_CHECKS"])

local copyBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
copyBtn:SetSize(100, 20)
copyBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
copyBtn:SetText(L["COPY_TO_CHAT"])

-- ── Category map ─────────────────────────────────────────────────────────────

local CAT = {
  ["Peacebloom"]="Herbs",["Silverleaf"]="Herbs",["Briarthorn"]="Herbs",
  ["Bruiseweed"]="Herbs",["Mageroyal"]="Herbs",["Swiftthistle"]="Herbs",
  ["Stranglekelp"]="Herbs",["Kingsblood"]="Herbs",["Liferoot"]="Herbs",
  ["Goldthorn"]="Herbs",["Sungrass"]="Herbs",["Blindweed"]="Herbs",
  ["Golden Sansam"]="Herbs",["Mountain Silversage"]="Herbs",
  ["Rough Stone"]="Metals",["Coarse Stone"]="Metals",["Heavy Stone"]="Metals",
  ["Solid Stone"]="Metals",["Dense Stone"]="Metals",
  ["Copper Bar"]="Metals",["Bronze Bar"]="Metals",["Iron Bar"]="Metals",
  ["Gold Bar"]="Metals",["Mithril Bar"]="Metals",["Thorium Bar"]="Metals",
  ["Truesilver Bar"]="Metals",["Weak Flux"]="Metals",
  ["Light Leather"]="Leather",["Medium Leather"]="Leather",
  ["Heavy Leather"]="Leather",["Thick Leather"]="Leather",
  ["Rugged Leather"]="Leather",["Cured Medium Hide"]="Leather",
  ["Toughened Leather"]="Leather",
  ["Linen Cloth"]="Cloth",["Wool Cloth"]="Cloth",["Silk Cloth"]="Cloth",
  ["Mageweave Cloth"]="Cloth",["Runecloth"]="Cloth",
}
local CAT_ORDER = { "Herbs", "Metals", "Leather", "Cloth", "Other" }

-- ── Row pool ─────────────────────────────────────────────────────────────────

local rowPool    = {}
local headerPool = {}
local activeRows = {}

local function AcquireRow(n)
  if not rowPool[n] then
    local r = {}
    r.frame = CreateFrame("Frame", nil, scrollChild)
    r.frame:SetHeight(16)
    r.frame:EnableMouse(true)

    r.check = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.check:SetPoint("LEFT", r.frame, "LEFT", 2, 0)
    r.check:SetWidth(14)

    r.name = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.name:SetPoint("LEFT", r.frame, "LEFT", 18, 0)
    r.name:SetWidth(148)
    r.name:SetJustifyH("LEFT")

    r.qty = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.qty:SetPoint("RIGHT", r.frame, "RIGHT", -4, 0)

    r.frame:SetScript("OnMouseDown", function(self)
      local item = self._item
      if not item then return end
      local prof   = NS.CraftSage.currentProf
      local checks = NS.CraftSage.db.char.checkmarks
      if not checks[prof] then checks[prof] = {} end
      checks[prof][item] = not checks[prof][item]
      NS.ShoppingList:Refresh()
    end)

    rowPool[n] = r
  end
  return rowPool[n]
end

local function AcquireHeader(n)
  if not headerPool[n] then
    local h = CreateFrame("Frame", nil, scrollChild)
    h:SetHeight(18)
    h.label = h:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    h.label:SetPoint("LEFT", h, "LEFT", 2, 0)
    h.label:SetTextColor(0.55, 0.55, 0.55, 1)
    h.line = h:CreateTexture(nil, "ARTWORK")
    h.line:SetPoint("BOTTOMLEFT",  h, "BOTTOMLEFT",  0, 2)
    h.line:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 2)
    h.line:SetHeight(1)
    h.line:SetColorTexture(0.2, 0.2, 0.5, 0.6)
    headerPool[n] = h
  end
  return headerPool[n]
end

-- ── Aggregation ───────────────────────────────────────────────────────────────

local function AggregateMats(data, fromIdx, skillLevel)
  local totals = {}
  local stepStart = fromIdx > 1 and data.steps[fromIdx - 1].skill_up_to or 1

  for i = fromIdx, #data.steps do
    local step = data.steps[i]
    local qty  = step.qty
    if i == fromIdx then
      qty = math.ceil(qty * (step.skill_up_to - skillLevel) / (step.skill_up_to - stepStart))
      qty = math.max(0, qty)
    end
    for _, mat in ipairs(step.mats) do
      totals[mat.item] = (totals[mat.item] or 0) + mat.count * qty
    end
  end

  local groups = {}
  for _, cat in ipairs(CAT_ORDER) do groups[cat] = {} end
  for item, qty in pairs(totals) do
    local cat = CAT[item] or "Other"
    table.insert(groups[cat], { item = item, qty = qty })
  end
  for _, cat in ipairs(CAT_ORDER) do
    table.sort(groups[cat], function(a, b) return a.item < b.item end)
  end
  return groups
end

-- ── Refresh ───────────────────────────────────────────────────────────────────

function ShoppingList:Refresh()
  local prof      = NS.CraftSage.currentProf
  local data      = NS.CraftSage.currentData
  local activeIdx = NS.CraftSage.activeStepIndex
  local skill     = NS.CraftSage.currentSkill or 0

  subtitleText:SetText(string.format(L["SHOPPING_RANGE_FMT"], prof or "?", skill))

  for _, r in ipairs(activeRows) do
    if r.Hide then r:Hide()
    elseif r.frame then r.frame:Hide() end
  end
  activeRows = {}

  if not data or not activeIdx then return end

  local groups  = AggregateMats(data, activeIdx, skill)
  local checks  = NS.CraftSage.db.char.checkmarks[prof] or {}
  local scrollY = 0
  local total   = 0
  local checked = 0
  local rowN    = 0
  local hdrN    = 0

  for _, cat in ipairs(CAT_ORDER) do
    local items = groups[cat]
    if #items > 0 then
      hdrN = hdrN + 1
      local h = AcquireHeader(hdrN)
      h:SetPoint("TOPLEFT",  scrollChild, "TOPLEFT",  0, -scrollY)
      h:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, -scrollY)
      h.label:SetText(L[cat] or cat)
      h:Show()
      table.insert(activeRows, h)
      scrollY = scrollY + 18

      for _, entry in ipairs(items) do
        rowN  = rowN + 1
        total = total + 1
        local r = AcquireRow(rowN)
        r.frame:SetPoint("TOPLEFT",  scrollChild, "TOPLEFT",  0, -scrollY)
        r.frame:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, -scrollY)
        r.frame._item = entry.item

        local isChecked = checks[entry.item]
        if isChecked then
          checked = checked + 1
          r.check:SetText("|cff44aa44v|r")
          r.name:SetTextColor(0.4, 0.4, 0.4, 1)
          r.qty:SetTextColor(0.4, 0.4, 0.4, 1)
        else
          r.check:SetText("|cff666666o|r")
          r.name:SetTextColor(0.85, 0.85, 0.85, 1)
          r.qty:SetTextColor(0.7, 0.7, 1, 1)
        end
        r.name:SetText(entry.item)
        r.qty:SetText("x" .. entry.qty)
        r.frame:Show()
        table.insert(activeRows, r.frame)
        scrollY = scrollY + 16
      end
    end
  end

  scrollChild:SetHeight(math.max(scrollY, 1))
  local pct = total > 0 and math.floor(checked / total * 100) or 0
  progressText:SetText(string.format(L["GATHERED_FMT"], checked, total, pct))
end

function ShoppingList:Toggle()
  if frame:IsShown() then
    frame:Hide()
  else
    self:Refresh()
    frame:Show()
  end
end

function ShoppingList:IsVisible()
  return frame:IsShown()
end

-- ── Button handlers ───────────────────────────────────────────────────────────

clearBtn:SetScript("OnClick", function()
  local prof = NS.CraftSage.currentProf
  if prof then
    NS.CraftSage.db.char.checkmarks[prof] = nil
    NS.ShoppingList:Refresh()
  end
end)

copyBtn:SetScript("OnClick", function()
  local data      = NS.CraftSage.currentData
  local activeIdx = NS.CraftSage.activeStepIndex
  local prof      = NS.CraftSage.currentProf
  local skill     = NS.CraftSage.currentSkill or 0
  if not data or not activeIdx then return end

  local checks  = NS.CraftSage.db.char.checkmarks[prof] or {}
  local groups  = AggregateMats(data, activeIdx, skill)
  local parts   = {}

  for _, cat in ipairs(CAT_ORDER) do
    for _, entry in ipairs(groups[cat]) do
      if not checks[entry.item] then
        table.insert(parts, entry.item .. " x" .. entry.qty)
      end
    end
  end

  if #parts == 0 then return end

  local editBox = ChatEdit_GetActiveWindow()
  if editBox then
    editBox:SetText(table.concat(parts, ", "))
    editBox:SetFocus()
  end
end)
```

- [ ] **Step 2: Verify shopping list in-game**

Open Alchemy TradeSkill window → click "Shopping List". Expected:
- Popup appears, draggable
- Mats grouped under "Herbs" and "Other" sections
- Each row shows item name and total quantity
- Click a row toggles check mark and dims the row
- "Clear Checks" resets all checks
- "Copy to Chat" populates chat input with unchecked items as comma-separated list
- Progress line shows "X of Y gathered (Z%)"

- [ ] **Step 3: Commit**

```bash
git add UI/ShoppingList.lua
git commit -m "feat: shopping list popup with aggregation and checkboxes"
```

---

## Task 11: Integration Verification

**Files:** none — in-game testing only

> Run through all 8 professions and edge cases with a test character.

- [ ] **Step 1: Verify auto-tracking**

On a character with Alchemy at skill ~47:
1. Open Alchemy TradeSkill window
2. Confirm panel shows correct active step (first step where `skill_up_to > 47`)
3. Craft the active recipe once
4. Confirm panel advances to new step automatically if skill increased
5. Confirm mat counts update after each craft

- [ ] **Step 2: Verify debug command across all step boundaries**

Run in order and confirm the correct step appears each time:
```
/craftsage debug 1
/craftsage debug 54
/craftsage debug 55
/craftsage debug 109
/craftsage debug 110
/craftsage debug 299
/craftsage debug 300
```
Expected at 300: panel shows `L["MAXED"]`, step list hidden.

- [ ] **Step 3: Verify all 8 professions load without errors**

Open each profession's TradeSkill window in turn:
Alchemy → Engineering → Blacksmithing → First Aid → Tailoring → Leatherworking → Enchanting → Cooking

Expected: panel appears for each, correct profession name shown, HC badge appears for Alchemy, Engineering, First Aid only.

- [ ] **Step 4: Verify unknown profession**

If you have a gathering profession open (Mining, Herbalism, Skinning), open its TradeSkill window.
Expected: panel shows `L["NO_GUIDE"]`, no Lua errors.

- [ ] **Step 5: Verify shopping list totals (spot-check)**

With Alchemy at skill 1:
- Open shopping list
- Verify "Peacebloom" quantity ≈ 65 and "Empty Vial" ≈ 65
- Check 2-3 items and verify progress counter updates correctly
- Click "Clear Checks" and verify all rows unchecked
- Click "Copy to Chat" and verify chat input box populated with unchecked items

- [ ] **Step 6: Verify reset command**

1. Check several items in shopping list
2. Run `/craftsage reset`
3. Re-open shopping list — all checks cleared

- [ ] **Step 7: Commit**

```bash
git commit -m "chore: integration verified across all 8 professions"
```

---

## Self-Review Notes

**Spec coverage check:**

| Spec requirement | Task |
|---|---|
| Auto-track skill via TRADE_SKILL_UPDATE | Task 8 |
| Side panel attaches to TradeSkill window | Task 9 |
| Active step highlighted in green | Task 9 |
| Next 2 steps shown dimmed | Task 9 |
| Mat have/need via GetItemCount | Task 9 |
| HC badge for hc_recommended professions | Task 9 |
| Shopping list aggregates all mats to 300 | Task 10 |
| Mats grouped by category | Task 10 |
| Checkable rows with progress indicator | Task 10 |
| Copy to Chat button | Task 10 |
| /craftsage slash commands | Task 8 |
| Per-character progress via AceDB | Task 8 |
| All 8 professions with data | Tasks 4-7 |
| Enchanting note field | Task 7, Task 9 |
| Skill = 300 edge case | Task 9, Task 11 |
| Unknown profession edge case | Task 9, Task 11 |
