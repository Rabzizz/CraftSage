# Minimap Button & Profession Window Toggle Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a LibDBIcon minimap button that toggles the CraftSage panel from anywhere, and replace the floating toggleBtn with a native-feeling button in the TradeSkill window's bottom button row.

**Architecture:** New `UI/MinimapButton.lua` owns all LibDBIcon registration and click handling via a shared `Panel:Toggle()` helper. `Panel.lua` gains the Toggle helper, a profName-nil guard in Refresh(), a conditional anchor (TradeSkillFrame vs UIParent fallback), and a bottom-row button replacing the existing overlay toggleBtn. Two new libraries (LibDataBroker-1.1 + LibDBIcon-1.0) are added to Libs/.

**Tech Stack:** Lua 5.1, LibDataBroker-1.1, LibDBIcon-1.0, LibStub, AceDB-3.0, WoW Classic Era API (Interface 11504)

---

## File Map

| Action | File | What changes |
|---|---|---|
| Create | `Libs/LibDataBroker-1.1/LibDataBroker-1.1.lua` | Downloaded library |
| Create | `Libs/LibDBIcon-1.0/LibDBIcon-1.0.lua` | Downloaded library |
| Create | `UI/MinimapButton.lua` | All minimap button logic |
| Modify | `CraftSage.toc` | New libs + MinimapButton.lua in load order |
| Modify | `Core.lua` | `minimap = { hide = false }` in DB_DEFAULTS |
| Modify | `UI/Panel.lua` | Toggle(), Refresh() fixes, remove toggleBtn, add guideBtn |
| Modify | `Locale/enUS.lua` | 3 new keys |
| Modify | `Locale/frFR.lua` | 3 new keys (French) |
| Modify | `Locale/deDE.lua` | 3 new keys (German) |

---

## Task 1: Download and place library files

**Files:**
- Create: `Libs/LibDataBroker-1.1/LibDataBroker-1.1.lua`
- Create: `Libs/LibDBIcon-1.0/LibDBIcon-1.0.lua`

These are standard WoW addon libraries. Download the single `.lua` file from each repo.

- [ ] **Step 1: Create the lib directories**

```powershell
mkdir "Libs\LibDataBroker-1.1"
mkdir "Libs\LibDBIcon-1.0"
```

- [ ] **Step 2: Download LibDataBroker-1.1**

Go to `https://github.com/tekkub/libdatabroker-1-1` and download `LibDataBroker-1.1.lua`. Place it at:
```
Libs\LibDataBroker-1.1\LibDataBroker-1.1.lua
```

- [ ] **Step 3: Download LibDBIcon-1.0**

Go to `https://github.com/Nevcairiel/LibDBIcon` and download `LibDBIcon-1.0.lua`. Place it at:
```
Libs\LibDBIcon-1.0\LibDBIcon-1.0.lua
```

- [ ] **Step 4: Verify files exist**

```powershell
Get-Item "Libs\LibDataBroker-1.1\LibDataBroker-1.1.lua"
Get-Item "Libs\LibDBIcon-1.0\LibDBIcon-1.0.lua"
```

Expected: both files listed with non-zero size.

---

## Task 2: Update TOC and DB_DEFAULTS

**Files:**
- Modify: `CraftSage.toc`
- Modify: `Core.lua`

- [ ] **Step 1: Update CraftSage.toc**

Replace the libs block so the two new libraries load before SimpleSticky, and add `UI\MinimapButton.lua` as the last file (must load after `Core.lua`):

```diff
 Libs\AceLocale-3.0\AceLocale-3.0.lua
+Libs\LibDataBroker-1.1\LibDataBroker-1.1.lua
+Libs\LibDBIcon-1.0\LibDBIcon-1.0.lua
 Libs\SimpleSticky.lua
```

```diff
 UI\Panel.lua
 UI\ShoppingList.lua
 
 Core.lua
+UI\MinimapButton.lua
```

Full file after change:

```
## Interface: 11504
## Title: CraftSage
## Notes: Profession leveling guide for WoW Classic Era / Hardcore
## Author: Rabzizz
## Version: 1.0.0
## IconTexture: Interface\AddOns\CraftSage\CraftSage-logo
## SavedVariables: CraftSageDB

Libs\LibStub\LibStub.lua
Libs\CallbackHandler-1.0\CallbackHandler-1.0.lua
Libs\AceAddon-3.0\AceAddon-3.0.lua
Libs\AceEvent-3.0\AceEvent-3.0.lua
Libs\AceDB-3.0\AceDB-3.0.lua
Libs\AceConsole-3.0\AceConsole-3.0.lua
Libs\AceHook-3.0\AceHook-3.0.lua
Libs\AceLocale-3.0\AceLocale-3.0.lua
Libs\LibDataBroker-1.1\LibDataBroker-1.1.lua
Libs\LibDBIcon-1.0\LibDBIcon-1.0.lua
Libs\SimpleSticky.lua

Locale\enUS.lua
Locale\frFR.lua
Locale\deDE.lua

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
UI\MinimapButton.lua
```

- [ ] **Step 2: Add `minimap` to DB_DEFAULTS in Core.lua**

Find the `DB_DEFAULTS` table (line 11) and add the `minimap` key:

```lua
local DB_DEFAULTS = {
  char = {
    checkmarks = {},
    minimap    = { hide = false },
  }
}
```

- [ ] **Step 3: Commit**

```powershell
git add CraftSage.toc Core.lua
git commit -m "feat: add LibDataBroker + LibDBIcon to TOC; add minimap DB field"
```

---

## Task 3: Add locale keys

**Files:**
- Modify: `Locale/enUS.lua`
- Modify: `Locale/frFR.lua`
- Modify: `Locale/deDE.lua`

Three new keys are needed: `MINIMAP_TOOLTIP`, `NO_PROFESSION_OPEN`, `GUIDE_BTN`.

- [ ] **Step 1: Add to enUS.lua**

Append after the last existing line:

```lua
L["MINIMAP_TOOLTIP"]    = "Click to toggle guide"
L["NO_PROFESSION_OPEN"] = "Open a profession window\nto use CraftSage"
L["GUIDE_BTN"]          = "⚗ Guide"
```

- [ ] **Step 2: Add to frFR.lua**

Append after the last existing line:

```lua
L["MINIMAP_TOOLTIP"]    = "Cliquez pour afficher le guide"
L["NO_PROFESSION_OPEN"] = "Ouvrez une fenêtre de métier\npour utiliser CraftSage"
L["GUIDE_BTN"]          = "⚗ Guide"
```

- [ ] **Step 3: Add to deDE.lua**

Append after the last existing line:

```lua
L["MINIMAP_TOOLTIP"]    = "Klicken zum Guide ein-/ausblenden"
L["NO_PROFESSION_OPEN"] = "Öffne ein Berufsfenster\num CraftSage zu nutzen"
L["GUIDE_BTN"]          = "⚗ Guide"
```

- [ ] **Step 4: Commit**

```powershell
git add Locale\enUS.lua Locale\frFR.lua Locale\deDE.lua
git commit -m "feat: add MINIMAP_TOOLTIP, NO_PROFESSION_OPEN, GUIDE_BTN locale keys"
```

---

## Task 4: Overhaul Panel.lua

**Files:**
- Modify: `UI/Panel.lua`

Four changes in one file: (a) add `Panel:Toggle()`, (b) fix `Refresh()` anchor, (c) add `profName` nil guard in `Refresh()`, (d) remove old `toggleBtn`, (e) add `guideBtn` in the bottom row.

- [ ] **Step 1: Add `Panel:Toggle()` after the closing `end` of `_initialize()` (line 259), before the pcall**

The toggle helper is defined as a module-level method, not inside `_initialize()`. Insert it between the closing `end` of `_initialize` and the `pcall` call:

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

- [ ] **Step 2: Fix the anchor in `Panel:Refresh()` (currently lines 178–181)**

Replace:
```lua
frame:ClearAllPoints()
frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
frame:Show()
```

With:
```lua
frame:ClearAllPoints()
if TradeSkillFrame:IsShown() then
  frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
else
  frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
end
frame:Show()
```

- [ ] **Step 3: Add `profName` nil guard at the top of the `Refresh()` body, before the existing `if not data then` block**

The existing nil-data block starts around line 186. Insert immediately before it:

```lua
if not profName then
  msgText:SetText(L["NO_PROFESSION_OPEN"])
  msgText:Show()
  stepsLabel:Hide(); divider:Hide(); matsLabel:Hide(); noteText:Hide()
  ShowAllMats(false)
  skillBarFill:SetWidth(1)
  skillText:SetText("")
  for i = 1, 3 do stepRows[i]:SetText("") end
  return
end
```

- [ ] **Step 4: Remove the old `toggleBtn` block from `_initialize()` (lines 157–169) and replace it with `guideBtn`**

Delete:
```lua
toggleBtn = CreateFrame("Button", nil, TradeSkillFrame, "UIPanelButtonTemplate")
toggleBtn:SetSize(72, 16)
toggleBtn:SetText(L["PANEL_TITLE"])
toggleBtn:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -42, -6)
toggleBtn:SetScript("OnClick", function()
  if frame:IsShown() then
    frame:Hide()
  else
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
    frame:Show()
  end
end)
```

Replace with:
```lua
local guideBtn = CreateFrame("Button", nil, TradeSkillFrame, "UIPanelButtonTemplate")
guideBtn:SetSize(60, 22)
guideBtn:SetText(L["GUIDE_BTN"])
guideBtn:SetPoint("RIGHT", TradeSkillCreateButton, "LEFT", -4, 0)
guideBtn:SetScript("OnClick", function() Panel:Toggle() end)
```

Also remove the `toggleBtn` variable declaration at the top of the file (line 14):
```lua
local shopBtn, resetBtn, toggleBtn   -- remove toggleBtn from this line
```
→
```lua
local shopBtn, resetBtn
```

- [ ] **Step 5: In-game smoke test — Panel.lua only**

Copy the addon to `C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\CraftSage\` and `/reload` in-game.

Expected:
- No Lua errors in chat on load
- Open any profession (e.g. Alchemy): CraftSage panel appears on the right, bottom row now shows a "⚗ Guide" button next to Create/Create All
- Clicking "⚗ Guide" hides the panel; clicking again shows it
- No floating "CraftSage" button in the title bar anymore

- [ ] **Step 6: Commit**

```powershell
git add UI\Panel.lua
git commit -m "feat: add Panel:Toggle(), fix anchor fallback, replace toggleBtn with bottom-row guideBtn"
```

---

## Task 5: Create UI/MinimapButton.lua

**Files:**
- Create: `UI/MinimapButton.lua`

- [ ] **Step 1: Create the file with this exact content**

```lua
local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local broker = LibStub("LibDataBroker-1.1"):NewDataObject("CraftSage", {
  type  = "launcher",
  label = "CraftSage",
  icon  = "Interface\\AddOns\\CraftSage\\CraftSage-logo",
  OnClick = function(_, button)
    if button == "LeftButton" then
      NS.Panel:Toggle()
    end
  end,
  OnTooltipShow = function(tip)
    tip:AddLine("CraftSage", 1, 0.82, 0)
    tip:AddLine(L["MINIMAP_TOOLTIP"], 1, 1, 1)
  end,
})

-- LibDBIcon:Register() needs CraftSage.db which is only set after OnInitialize
-- (AceAddon fires OnInitialize during ADDON_LOADED, before our handler below).
local _mb = CreateFrame("Frame")
_mb:RegisterEvent("ADDON_LOADED")
_mb:SetScript("OnEvent", function(self, event, name)
  if name == AddonName then
    LibStub("LibDBIcon-1.0"):Register("CraftSage", broker, NS.CraftSage.db.char.minimap)
    self:UnregisterAllEvents()
  end
end)
```

**Why the deferred registration:** `NS.CraftSage.db` is set inside `CraftSage:OnInitialize()`, which AceAddon calls during `ADDON_LOADED`. AceAddon's `ADDON_LOADED` handler runs before ours (it registered first), so by the time our handler fires `db` is guaranteed to exist.

- [ ] **Step 2: In-game test — minimap button**

Copy the addon folder to the WoW AddOns directory and `/reload`.

Expected:
- A small CraftSage logo button appears orbiting the minimap
- Hovering shows tooltip: "CraftSage" + "Click to toggle guide"
- Left-clicking toggles the panel

- [ ] **Step 3: Test minimap button with no profession window open**

Close all profession windows. Click the minimap button.

Expected:
- Panel appears centered-right on screen (`UIParent CENTER+200`)
- Panel shows "Open a profession window\nto use CraftSage" (not "No guide available")
- Clicking the minimap button again hides the panel

- [ ] **Step 4: Test auto-show/hide**

Open a profession (Alchemy). Panel should auto-appear attached to the right of the TradeSkill window. Close the profession window. Panel should disappear.

- [ ] **Step 5: Test draggable position**

Drag the minimap button to a new position around the minimap. `/reload`. Verify it returns to the dragged position (saved in `CraftSageDB.char.minimap`).

- [ ] **Step 6: Commit**

```powershell
git add UI\MinimapButton.lua
git commit -m "feat: add LibDBIcon minimap button for CraftSage panel toggle"
```

---

## Task 6: Edge case testing

No code changes — validation only.

- [ ] **Step 1: Test a profession with no guide data**

Open a profession not in `CraftSageData` (e.g. First Aid if you're testing another). Verify panel shows "No guide available." (not "Open a profession window").

- [ ] **Step 2: Test skill at 300**

Use `/craftsage debug 300` with Alchemy open. Verify panel shows "Maxed! Congratulations!" and the ⚗ Guide button still works.

- [ ] **Step 3: Test French locale**

If testing on a frFR client: verify tooltip shows "CraftSage\nCliquez pour afficher le guide" and the panel shows "Ouvrez une fenêtre de métier\npour utiliser CraftSage" when no profession is open.

- [ ] **Step 4: Test rapid open/close**

Open and close the profession window quickly 5–6 times. Verify the panel tracks correctly every time with no Lua errors.

- [ ] **Step 5: Test with another minimap addon installed (if available)**

Install Bartender4 or another minimap button manager. Verify the CraftSage button coexists without overlapping.
