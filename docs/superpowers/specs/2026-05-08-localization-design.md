# CraftSage Localization — Design Spec

**Date:** 2026-05-08
**Status:** Approved

---

## Goal

Add French (frFR) and German (deDE) client language support to CraftSage. UI chrome strings are translated manually via AceLocale locale files. Item names are resolved automatically from the WoW client using `GetItemInfo(itemID)`, which returns the localized name for the active client language — no manual item translation required.

---

## Approach: Item IDs + GetItemInfo (B+)

All 8 `Data/*.lua` files currently store mat item names as strings (e.g., `"Peacebloom"`). These strings are used for:

1. **Display** — shown in the panel mat list and shopping list
2. **Bag lookup** — passed to `GetItemCount()` to check how many the player has

On non-English clients, both uses break: the game uses localized item names in bags, so English strings won't match.

The fix: replace all item name strings with **item ID integers**. The game's `GetItemInfo(itemID)` API returns the localized name in the client's active language automatically. `GetItemCount()` accepts item IDs directly.

---

## Data Model Change

### Before

```lua
mats = {
  { item = "Peacebloom", count = 1 },
  { item = "Silverleaf",  count = 1 },
  { item = "Empty Vial",  count = 1 },
}
```

### After

```lua
mats = {
  { item = 2453,  count = 1 },  -- Peacebloom
  { item = 785,   count = 1 },  -- Silverleaf
  { item = 3371,  count = 1 },  -- Empty Vial
}
```

- Field name `item` unchanged — only value type changes (string → integer)
- Inline comments preserve the English name for developer readability
- All 8 professions updated: Alchemy, Blacksmithing, Engineering, Enchanting, Leatherworking, Tailoring, Cooking, FirstAid
- Item IDs sourced from wowhead.com/classic

---

## UI Changes

### Display name resolution

Anywhere `mat.item` was rendered directly as a string, replace with:

```lua
local name = GetItemInfo(mat.item) or ("Item:" .. mat.item)
```

`GetItemInfo` returns the localized item name as its first return value. The fallback `"Item:2453"` is shown only if the item isn't in the client cache yet (rare, resolves automatically).

### Bag count lookup

```lua
-- before
local have = GetItemCount(mat.item)  -- mat.item was a string

-- after
local have = GetItemCount(mat.item)  -- mat.item is now an integer — no call-site change needed
```

`GetItemCount` already accepts item IDs in the Classic Era client, so no functional change is required here beyond the data model switch.

### Cache miss handling

`GetItemInfo` can return `nil` for items not yet loaded into the client cache. To handle this:

- Register `GET_ITEM_INFO_RECEIVED` event in `Core.lua`
- On fire, trigger a panel refresh so placeholders resolve once the item loads
- Items open in the active TradeSkill window are always cached; only cross-profession mats in the shopping list may briefly show placeholders

---

## Locale Files

### New files

| File | Language |
|---|---|
| `Locale/frFR.lua` | French |
| `Locale/deDE.lua` | German |

### Structure (same pattern as enUS)

```lua
-- frFR.lua
local L = LibStub("AceLocale-3.0"):NewLocale("CraftSage", "frFR")
if not L then return end

L["PANEL_TITLE"]       = "CraftSage"
L["HC_BADGE"]          = "HC Recommandé"
L["GUIDE_STEPS"]       = "Étapes du guide"
L["STEP_MATS"]         = "Matériaux de l'étape :"
L["SHOPPING_LIST_BTN"] = "Liste de courses"
L["RESET_BTN"]         = "Réinitialiser"
L["NO_GUIDE"]          = "Aucun guide disponible."
L["MAXED"]             = "Maîtrisé ! Félicitations !"
L["SKILL_FMT"]         = "%d / %d"
L["SHOPPING_TITLE"]    = "Liste de courses"
L["SHOPPING_RANGE_FMT"]= "%s - Compétence %d à 300"
L["GATHERED_FMT"]      = "%d sur %d récupérés (%d%%)"
L["CLEAR_CHECKS"]      = "Décocher tout"
L["COPY_TO_CHAT"]      = "Copier dans le chat"
L["Herbs"]             = "Herbes"
L["Metals"]            = "Métaux"
L["Leather"]           = "Cuir"
L["Cloth"]             = "Tissu"
L["Other"]             = "Autre"
```

AceLocale automatically selects the correct file based on `GetLocale()` at runtime. The `enUS` locale is flagged as the default fallback (third argument `true` in `NewLocale`) — any client locale without a matching file (esES, ruRU, zhCN, koKR, etc.) automatically receives English strings. No extra code needed; this is built into AceLocale.

### TOC update

```
Locale\enUS.lua
Locale\frFR.lua
Locale\deDE.lua
```

---

## Files Changed

| File | Change |
|---|---|
| `CraftSage.toc` | Add frFR and deDE locale entries |
| `Locale/frFR.lua` | New — French UI strings |
| `Locale/deDE.lua` | New — German UI strings |
| `Data/Alchemy.lua` | Item names → item IDs |
| `Data/Blacksmithing.lua` | Item names → item IDs |
| `Data/Engineering.lua` | Item names → item IDs |
| `Data/Enchanting.lua` | Item names → item IDs |
| `Data/Leatherworking.lua` | Item names → item IDs |
| `Data/Tailoring.lua` | Item names → item IDs |
| `Data/Cooking.lua` | Item names → item IDs |
| `Data/FirstAid.lua` | Item names → item IDs |
| `UI/Panel.lua` | Use `GetItemInfo(mat.item)` for display names |
| `UI/ShoppingList.lua` | Use `GetItemInfo(mat.item)` for display names |
| `Core.lua` | Register `GET_ITEM_INFO_RECEIVED` → panel refresh |

---

## Error Handling

| Case | Behavior |
|---|---|
| `GetItemInfo` returns nil | Show `"Item:<id>"` placeholder; refreshes on `GET_ITEM_INFO_RECEIVED` |
| Client locale not frFR/deDE/enUS | AceLocale falls back to enUS strings automatically — no code required |
| Item ID wrong or invalid | `GetItemInfo` returns nil → placeholder shown, never crashes |

---

## Out of Scope

- Category labels (Herbs, Metals, etc.) in shopping list — these are already in the locale files and will be translated
- Item quality colors or item links — display stays as plain name text
- Any locales beyond frFR and deDE
- Translating profession names (returned by `GetTradeSkillLine()` already in client language)
