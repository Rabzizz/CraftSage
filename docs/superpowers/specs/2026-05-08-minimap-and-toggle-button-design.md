# CraftSage — Minimap Button & Profession Window Toggle

**Date:** 2026-05-08
**Status:** Approved

---

## Overview

Add two new UI entry points for the CraftSage panel:

1. **Minimap button** — a standard LibDBIcon circular icon that orbits the minimap, toggling the panel from anywhere in the game world.
2. **Profession window toggle** — a small button in the bottom button row of the Blizzard TradeSkill window, sitting alongside the native Create / Create All buttons.

The panel continues to auto-open when the profession window opens and auto-close when it closes. Both new buttons let the user dismiss or restore the panel temporarily within a session.

---

## Architecture

### New files

| File | Purpose |
|---|---|
| `UI/MinimapButton.lua` | LibDBIcon registration, tooltip, click handler |
| `Libs/LibDataBroker-1.1/LibDataBroker-1.1.lua` | Required dependency of LibDBIcon |
| `Libs/LibDBIcon-1.0/LibDBIcon-1.0.lua` | Minimap button management library |

### Modified files

| File | Change |
|---|---|
| `CraftSage.toc` | Add new libs and `UI/MinimapButton.lua` to load order |
| `Core.lua` | Add `minimap = { hide = false }` to `DB_DEFAULTS` |
| `UI/Panel.lua` | Add bottom-row toggle button in `_initialize()`; add anchor fallback for when TradeSkillFrame is hidden |
| `Locale/enUS.lua` | Add `MINIMAP_TOOLTIP` and `NO_PROFESSION_OPEN` keys |

### Unchanged files

`Data/*.lua`, `UI/ShoppingList.lua`, `UI/Frames.xml`

---

## Components

### ① Minimap button (`UI/MinimapButton.lua`)

Registers a LibDataBroker broker object:

```lua
local broker = LibStub("LibDataBroker-1.1"):NewDataObject("CraftSage", {
  type  = "launcher",
  label = "CraftSage",
  icon  = "Interface\\Icons\\Trade_Alchemy",
  OnClick = function(_, button)
    -- toggle logic (see Data flow below)
  end,
  OnTooltipShow = function(tip)
    tip:AddLine("CraftSage", 1, 0.82, 0)
    tip:AddLine(L["MINIMAP_TOOLTIP"], 1, 1, 1)
  end,
})

LibStub("LibDBIcon-1.0"):Register("CraftSage", broker, CraftSageDB.minimap)
```

LibDBIcon reads and writes the button's saved angle/position from `CraftSageDB.minimap` automatically. No manual position management needed.

### ② Bottom-row toggle button (`UI/Panel.lua`)

Created once in `_initialize()`, parented to `TradeSkillFrame`, anchored left of `TradeSkillCreateButton`:

```lua
local guideBtn = CreateFrame("Button", nil, TradeSkillFrame, "UIPanelButtonTemplate")
guideBtn:SetSize(60, 22)
guideBtn:SetText(L["GUIDE_BTN"])        -- "⚗ Guide"
guideBtn:SetPoint("RIGHT", TradeSkillCreateButton, "LEFT", -4, 0)
guideBtn:SetScript("OnClick", function() Panel:Toggle() end)
```

The button shows and hides with `TradeSkillFrame` automatically — no extra event management needed.

### ③ Panel anchor fallback (`UI/Panel.lua`)

`Panel:Refresh()` currently always anchors to `TradeSkillFrame:TOPRIGHT`. When the minimap button is clicked while no profession window is open, this would anchor to a hidden frame and float off-screen.

Fix — replace the hard-coded `SetPoint` with:

```lua
frame:ClearAllPoints()
if TradeSkillFrame:IsShown() then
  frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
else
  frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
end
```

### ④ `Panel:Toggle()` helper

A new method on `Panel` that both click handlers call:

```lua
function Panel:Toggle()
  if frame:IsShown() then
    frame:Hide()
  else
    local cs = NS.CraftSage
    Panel:Refresh(cs.currentProf, cs.currentSkill, cs.currentMaxSkill,
      cs.currentData, cs.activeStepIndex)
  end
end
```

### ⑤ `Panel:Refresh()` — `profName` nil check

`Refresh()` must distinguish two nil-data cases so the correct message is shown:

```lua
-- Before the existing `if not data then` branch:
if not profName then
  msgText:SetText(L["NO_PROFESSION_OPEN"])
  msgText:Show()
  -- hide all other rows (same as the existing nil-data path)
  return
end
if not data then
  msgText:SetText(L["NO_GUIDE"])
  ...
end
```

Without this, a minimap click with no profession open would show "No guide available" instead of "Open a profession window to use CraftSage".

---

## Data flow

### Minimap button click (profession window open)
1. `OnClick` calls `Panel:Toggle()`
2. If panel visible → `frame:Hide()`
3. If panel hidden → `Panel:Refresh(...)` with current Core state → panel re-anchors to `TradeSkillFrame:TOPRIGHT` and shows

### Minimap button click (no profession window open)
1. `OnClick` calls `Panel:Toggle()`
2. If panel visible → `frame:Hide()`
3. If panel hidden → `Panel:Refresh(nil, nil, nil, nil, nil)` → anchor falls back to `UIParent CENTER+200` → panel shows with `NO_PROFESSION_OPEN` message

### Profession window opens (`TRADE_SKILL_SHOW`)
Unchanged — `Core:OnTradeSkillShow()` calls `Panel:Refresh(...)` which anchors to `TradeSkillFrame` and shows the panel. No interaction with the minimap button state.

### Profession window closes (`TRADE_SKILL_HIDE`)
Unchanged — `Core:OnTradeSkillHide()` calls `Panel:Hide()`.

---

## Locale keys

Three new keys added to all three locale files (`Locale/enUS.lua`, `Locale/frFR.lua`, `Locale/deDE.lua`):

| Key | enUS value | frFR value | deDE value |
|---|---|---|---|
| `MINIMAP_TOOLTIP` | `"Click to toggle guide"` | `"Cliquez pour afficher le guide"` | `"Klicken zum Guide ein-/ausblenden"` |
| `NO_PROFESSION_OPEN` | `"Open a profession window\nto use CraftSage"` | `"Ouvrez une fenêtre de métier\npour utiliser CraftSage"` | `"Öffne ein Berufsfenster\num CraftSage zu nutzen"` |
| `GUIDE_BTN` | `"⚗ Guide"` | `"⚗ Guide"` | `"⚗ Guide"` |

---

## DB schema change

`DB_DEFAULTS` in `Core.lua` gains one new char-level table:

```lua
local DB_DEFAULTS = {
  char = {
    checkmarks  = {},
    minimap     = { hide = false },
  }
}
```

LibDBIcon reads this table directly by reference after `AceDB:New()` is called, so the field must exist in defaults before `LibDBIcon:Register()` is called. `MinimapButton.lua` must therefore load after `Core.lua` (TOC order handles this).

---

## Error handling

| Case | Handling |
|---|---|
| LibDataBroker or LibDBIcon missing | `LibStub` call will throw — caught by the existing `pcall` wrapper pattern; error message shown in chat |
| `TradeSkillCreateButton` nil at init | `_initialize()` is called at frame load time; `TradeSkillCreateButton` exists as a global in Classic Era at load — safe to anchor against |
| Panel opened with no profession | Shows `NO_PROFESSION_OPEN` message; all step/mat rows hidden (existing nil-data path in `Refresh()` handles this) |

---

## TOC load order

```
Libs\LibStub\LibStub.lua
Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml
Libs\AceAddon-3.0\AceAddon-3.0.xml
Libs\AceEvent-3.0\AceEvent-3.0.xml
Libs\AceDB-3.0\AceDB-3.0.xml
Libs\AceConsole-3.0\AceConsole-3.0.xml
Libs\AceHook-3.0\AceHook-3.0.xml
Libs\AceLocale-3.0\AceLocale-3.0.xml
Libs\LibDataBroker-1.1\LibDataBroker-1.1.lua   ← new
Libs\LibDBIcon-1.0\LibDBIcon-1.0.lua            ← new
Libs\SimpleSticky.lua
Locale\enUS.lua
Data\...
Core.lua
UI\Panel.lua
UI\ShoppingList.lua
UI\MinimapButton.lua                            ← new (after Core.lua)
```

---

## Out of scope

- Right-click context menu on the minimap button
- Hiding the minimap button via an options panel
- Any non-English locale strings (will be added in a future localization pass)
