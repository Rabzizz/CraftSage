# CraftSage — Design Spec

**Date:** 2026-05-05
**Target:** WoW Classic Era / Hardcore (1-60, skill cap 300)
**Language:** Lua + XML (standard WoW addon)

---

## Overview

CraftSage is a WoW Classic Era addon that helps players level crafting professions efficiently. It attaches a side panel to the native TradeSkill window that auto-tracks your current skill level, tells you exactly what to craft next, and generates a full material shopping list from your current skill to 300.

It covers 8 crafting professions: Alchemy, Blacksmithing, Engineering, Enchanting, Leatherworking, Tailoring, Cooking, and First Aid. Fishing is excluded — it levels by casting, not via the TradeSkill recipe window, so it cannot share the step-based data model.

---

## Goals

- Show the optimal crafting step for the currently open profession, auto-advancing when skill increases
- Generate a full material shopping list (current skill → 300) grouped by category with checkable rows
- Highlight the recommended recipe inside the native TradeSkill recipe list
- Mark Hardcore-recommended professions with a lightweight badge (Engineering, Alchemy, First Aid)
- Persist progress per character via SavedVariables

---

## File Structure

```
CraftSage/
├── CraftSage.toc
├── Core.lua
├── UI/
│   ├── Panel.lua
│   ├── ShoppingList.lua
│   └── Frames.xml
├── Data/
│   ├── Alchemy.lua
│   ├── Blacksmithing.lua
│   ├── Engineering.lua
│   ├── Enchanting.lua
│   ├── Leatherworking.lua
│   ├── Tailoring.lua
│   ├── Cooking.lua
│   └── FirstAid.lua
├── Libs/
│   ├── LibStub/
│   ├── CallbackHandler-1.0/
│   ├── AceAddon-3.0/
│   ├── AceEvent-3.0/
│   ├── AceDB-3.0/
│   ├── AceConsole-3.0/
│   ├── AceHook-3.0/
│   ├── AceLocale-3.0/
│   └── SimpleSticky.lua
└── Locale/
    └── enUS.lua
```

### Component responsibilities

| File | Responsibility |
|---|---|
| `CraftSage.toc` | Addon manifest — version, title, saved variables declaration, file load order |
| `Core.lua` | Addon lifecycle, event registration, active-step computation, state ownership |
| `UI/Panel.lua` | Side panel frame — renders steps, mat counts, skill bar; anchors to TradeSkillFrame |
| `UI/ShoppingList.lua` | Shopping list popup — aggregates all mats from current skill to 300, renders checklist |
| `UI/Frames.xml` | XML frame definitions for Panel and ShoppingList windows |
| `Data/*.lua` | Pure data tables — one per profession, no logic |
| `Locale/enUS.lua` | All user-facing strings |

---

## Data Model

Each `Data/*.lua` file exposes one entry in the global `CraftSageData` table:

```lua
CraftSageData["Alchemy"] = {
  hc_recommended = true,   -- drives the HC badge in the side panel
  steps = {
    {
      recipe      = "Minor Healing Potion",
      skill_up_to = 55,    -- craft until reaching this skill level
      qty         = 60,    -- recommended crafts (includes ~30% buffer for yellow RNG)
      mats        = {
        { item = "Peacebloom",  count = 1 },
        { item = "Silverleaf",  count = 1 },
        { item = "Empty Vial",  count = 1 },
      },
    },
    {
      recipe      = "Lesser Healing Potion",
      skill_up_to = 110,
      qty         = 80,
      mats        = {
        { item = "Minor Healing Potion", count = 1 },
        { item = "Briarthorn",           count = 1 },
      },
    },
    -- steps continue to skill 300
  },
}
```

**Schema rules:**
- `skill_up_to` is always the skill level at which this step ends and the next begins
- `qty` is a static pre-calculated value; it includes a buffer for yellow-colour RNG crafts
- `mats` uses item name strings (not IDs) — Classic item names are stable and human-readable
- Steps must be ordered ascending by `skill_up_to`
- The final step's `skill_up_to` must equal 300

**Active step computation** (runs on every `TRADE_SKILL_UPDATE`):
```
active_step = first step where step.skill_up_to > current_skill
```
The step index is always derived from current skill level — never manually incremented — so off-guide crafting and skill jumps are handled automatically.

**Shopping list aggregation:**
1. Find active step index
2. Sum `mat.count × step.qty` for all mats across all steps from active step to end
3. For the active step, adjust qty proportionally: `remaining = qty × (step.skill_up_to - current_skill) / (step.skill_up_to - step_start)` where `step_start` is the previous step's `skill_up_to`, or 1 for the first step.

---

## Libraries

| Library | Purpose |
|---|---|
| LibStub | Universal library versioning — required by all Ace libs |
| CallbackHandler-1.0 | Internal dependency of AceEvent and AceDB |
| AceAddon-3.0 | Addon lifecycle (OnInitialize, OnEnable, OnDisable) |
| AceEvent-3.0 | Clean event registration and unregistration |
| AceDB-3.0 | Per-character SavedVariables with profile support |
| AceConsole-3.0 | Slash command registration (`/craftsage`) |
| AceHook-3.0 | Safe hooking into TradeSkill frame functions |
| AceLocale-3.0 | Localization string management |
| SimpleSticky.lua | Sticks the CraftSage panel to TradeSkillFrame so it moves with it |

---

## UI Design

### Side Panel

Attaches to the right edge of the native TradeSkillFrame via SimpleSticky. Opens and closes with the TradeSkill window automatically.

**Panel contents (top to bottom):**
1. Title bar — "⚗ CraftSage"
2. Profession name
3. HC badge — shown only if `hc_recommended = true` ("★ HC Recommended")
4. Skill display — "47 / 300" with a progress bar
5. Guide Steps section — active step highlighted in green, next 2 steps shown dimmed
6. Divider
7. Current step materials — item name + quantity needed vs. have (green = have, red = need). "Have" count is read live from the player's bags via `GetItemCount(itemName)` on each panel refresh.
8. Bottom bar — "Shopping List" button + "Reset" button

The recommended recipe is also highlighted in green inside the native TradeSkill recipe list via AceHook.

### Shopping List Popup

Opens from the "Shopping List" button. Floats independently (not attached to TradeSkillFrame).

**Contents:**
- Subtitle showing profession + skill range (e.g., "Alchemy — Skill 47 → 300")
- Materials grouped by category (Herbs, Metals, Vendor Items, etc.)
- Each row: checkbox + item name + total quantity needed
- Progress indicator — "X of Y items gathered (Z%)"
- Bottom bar — "Clear Checks" + "Copy to Chat" buttons

"Copy to Chat" pastes the unchecked items as a formatted string into the chat input box so the player can share the shopping list in guild chat.

---

## Event Flow

```
ADDON_LOADED
  └─ AceAddon:OnInitialize()
       └─ Initialize AceDB (per-character profile)
       └─ Register slash command /craftsage
       └─ Register TRADE_SKILL_SHOW, TRADE_SKILL_HIDE, TRADE_SKILL_UPDATE

TRADE_SKILL_SHOW
  └─ GetTradeSkillLine() → profession name + current skill level
  └─ Look up CraftSageData[profession_name]
  └─ Compute active step
  └─ Render and show side panel
  └─ Anchor panel to TradeSkillFrame via SimpleSticky
  └─ Highlight active recipe in TradeSkill list via AceHook

TRADE_SKILL_UPDATE
  └─ Re-read skill via GetTradeSkillLine()
  └─ Recompute active step
  └─ If step changed → advance panel display, brief green flash animation
  └─ Refresh mat counts for new active step

TRADE_SKILL_HIDE
  └─ Hide side panel

PLAYER_LOGOUT
  └─ AceDB auto-saves state (current profession, skill level snapshot)
```

---

## Error Handling

| Situation | Handling |
|---|---|
| Profession not in CraftSageData | Show "No guide available for this profession" in panel — no crash |
| Skill already at 300 | Show "Maxed!" state, hide step list, show congratulations message |
| Skill jumps multiple steps at once | Active step always derived from current skill — never incremented manually — so jumps resolve correctly |
| Missing mat data (data entry error) | Log a warning via AceConsole, skip that mat row gracefully |

---

## Slash Commands

| Command | Effect |
|---|---|
| `/craftsage` | Toggle the side panel open/closed |
| `/craftsage reset` | Reset progress for current character's active profession |
| `/craftsage debug <skill>` | (dev builds only) Force skill level to test step advancement |

---

## Testing Approach

WoW addons cannot be unit tested outside the game client. Testing strategy:

1. **Manual in-game validation** — load addon with a test character at skill 1, 50, 100, 150, 200, 250 for each profession; verify correct step is shown and mats are accurate
2. **Shopping list spot-check** — verify total material counts for at least 2 professions (Alchemy, Engineering) against wowhead data
3. **Edge case verification** — test skill-at-300 state, unknown-profession state, and rapid skill advancement (crafting multiple items quickly)
4. **Debug command** — `/craftsage debug <skill>` lets developers force a skill value without crafting, making step-advancement testing fast

---

## Out of Scope (v1)

- Auction House price integration or cost estimation
- Farming route maps or zone danger warnings
- Multiple target skill levels (always plans to 300)
- Non-English locales (enUS only)
- Wrath / Cataclysm Classic versions
- Fishing (levels by casting, not via TradeSkill recipe window — incompatible with the step-based model)
