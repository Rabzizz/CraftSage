# CraftSage — Project Intelligence

## What this is

CraftSage is a WoW Classic Era / Hardcore addon (Lua + XML) that attaches a side panel to the native TradeSkill window. It auto-tracks your profession skill level, shows you exactly what to craft next, and generates a full material shopping list from your current skill to 300. Targets the `_classic_era_` client (Interface version 11504).

Full design spec: `docs/superpowers/specs/2026-05-05-craftsage-design.md`

---

## Tech stack

| Layer | Technology |
|---|---|
| Addon logic | Lua 5.1 (WoW embedded runtime) |
| UI frames | XML (`Frames.xml`) + Lua frame manipulation |
| Libraries | Ace3 suite + SimpleSticky (see Libs section below) |
| Persistence | AceDB-3.0 SavedVariables (per-character profiles) |
| Localization | AceLocale-3.0 (`Locale/enUS.lua`) |

---

## Install path (for testing)

```
C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\CraftSage\
```

Symlink or copy the repo folder there. After code changes, reload in-game with `/reload`.

---

## File structure

```
CraftSage/
├── CraftSage.toc          # Manifest — Interface version, SavedVariables, load order
├── Core.lua               # Lifecycle, events, active-step logic, state ownership
├── UI/
│   ├── Panel.lua          # Side panel: skill bar, steps, mat counts, anchored to TradeSkillFrame
│   ├── ShoppingList.lua   # Shopping list popup: full mat aggregation, checkboxes, copy-to-chat
│   └── Frames.xml         # XML frame definitions for both windows
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

`Data/*.lua` files are **pure data — no logic**. All logic lives in `Core.lua` and `UI/`.

---

## Libraries

| Library | Why |
|---|---|
| LibStub | Required versioning base for all Ace libs |
| CallbackHandler-1.0 | Internal dep of AceEvent + AceDB |
| AceAddon-3.0 | Addon lifecycle hooks (OnInitialize, OnEnable, OnDisable) |
| AceEvent-3.0 | Clean RegisterEvent / UnregisterEvent |
| AceDB-3.0 | Per-character SavedVariables with profile support |
| AceConsole-3.0 | `/craftsage` slash command registration |
| AceHook-3.0 | Safe hooking into TradeSkill frame to highlight recipes |
| AceLocale-3.0 | All display strings go through this — never hardcode strings in logic files |
| SimpleSticky.lua | Sticks CraftSage panel to TradeSkillFrame so it moves with it |

Not included: AceGUI (native frames instead), AceConfig/AceDBOptions (no settings panel in v1), LibDBIcon (no minimap button — panel opens with TradeSkill), LibSharedMedia (default fonts for v1).

---

## Data model

Each `Data/*.lua` adds one entry to the global `CraftSageData` table:

```lua
CraftSageData["Alchemy"] = {
  hc_recommended = true,    -- shows "★ HC Recommended" badge in the panel
  steps = {
    {
      recipe      = "Minor Healing Potion",
      skill_up_to = 55,     -- craft this step until current_skill reaches this value
      qty         = 60,     -- pre-calculated crafts needed (includes ~30% buffer for yellow RNG)
      mats        = {
        { item = "Peacebloom", count = 1 },
        { item = "Silverleaf", count = 1 },
        { item = "Empty Vial", count = 1 },
      },
    },
    -- ... steps ascending to skill 300
  },
}
```

**Schema invariants:**
- Steps are ordered ascending by `skill_up_to`
- Final step's `skill_up_to` must be exactly 300
- `mats` uses item name strings, not item IDs (Classic names are stable)
- `qty` is static and pre-calculated — never computed at runtime

**Active step** (recomputed on every `TRADE_SKILL_UPDATE`):
```
active_step = first step where step.skill_up_to > current_skill
```
Always derived from skill level, never incremented manually — off-guide crafting and multi-step jumps resolve automatically.

**Shopping list qty for active step:**
```
remaining = qty × (step.skill_up_to - current_skill) / (step.skill_up_to - step_start)
```
where `step_start` = previous step's `skill_up_to`, or 1 for the first step.

---

## Key WoW Classic API calls

| API | Returns | Used for |
|---|---|---|
| `GetTradeSkillLine()` | name, isExpanded, skillLevel, maxSkillLevel | Detect active profession + current skill |
| `GetItemCount(itemName)` | number | Check player bags for "have" count in mat list |
| `GetNumTradeSkills()` | number | Iterate recipe list for highlighting |
| `GetTradeSkillInfo(index)` | name, type, numAvailable, isExpanded, altVerb | Find recipe index to highlight |

Events used: `TRADE_SKILL_SHOW`, `TRADE_SKILL_HIDE`, `TRADE_SKILL_UPDATE`, `PLAYER_LOGOUT`.

---

## Event flow

```
ADDON_LOADED → OnInitialize
  AceDB init → slash command register → event registration

TRADE_SKILL_SHOW
  GetTradeSkillLine() → look up CraftSageData → compute active step
  → show panel → SimpleSticky anchor → highlight recipe via AceHook

TRADE_SKILL_UPDATE
  Re-read skill → recompute active step
  → if step changed: advance panel + brief green flash
  → refresh mat have/need counts via GetItemCount()

TRADE_SKILL_HIDE → hide panel

PLAYER_LOGOUT → AceDB auto-saves
```

---

## UI layout

**Side panel** — attached to right edge of TradeSkillFrame via SimpleSticky:
1. Title bar "⚗ CraftSage"
2. Profession name
3. HC badge (if `hc_recommended = true`): "★ HC Recommended"
4. Skill progress — "47 / 300" + progress bar
5. Guide steps — active step in green, next 2 dimmed
6. Divider
7. Current step mats — item name, have (green) vs need (red) via `GetItemCount()`
8. Bottom bar — "Shopping List" + "Reset" buttons

**Shopping list popup** — independent floating window:
- Header: profession + skill range
- Mats grouped by category (Herbs, Metals, Vendor Items, etc.)
- Each row: checkbox + item name + total qty
- Progress: "X of Y gathered (Z%)"
- Buttons: "Clear Checks" + "Copy to Chat" (populates active chat input box)

---

## Coding conventions

- **Global namespace** — all globals prefixed with `CraftSage` (e.g., `CraftSageData`, `CraftSageDB`). Never pollute the global table with short names.
- **No `print()`** — use `self:Print()` from AceConsole, or `DEFAULT_CHAT_FRAME:AddMessage()` for UI messages.
- **No hardcoded strings** — all display text goes through AceLocale (`L["key"]`). Define keys in `Locale/enUS.lua`.
- **Data files are data only** — `Data/*.lua` must never require or call any function. Pure table declarations.
- **Error-safe hooks** — always use AceHook (never raw function replacement) to hook into Blizzard frames.
- **Lua style** — 2-space indent, `snake_case` for locals and table keys, `PascalCase` for frame names.

---

## Slash commands

| Command | Effect |
|---|---|
| `/craftsage` | Toggle panel open/closed |
| `/craftsage reset` | Reset active profession progress for current character |
| `/craftsage debug <skill>` | Force skill level (dev only — strip before release) |

---

## Error handling rules

| Case | Rule |
|---|---|
| Profession not in CraftSageData | Show "No guide available" in panel — never crash |
| Skill at 300 | Show "Maxed!" state, hide step list |
| Missing mat in data | Log warning via AceConsole, skip row — don't block render |
| Step jump > 1 | Recompute from skill, no special handling needed |

---

## Testing

No unit test framework runs outside the game client. Test approach:

1. Install addon to `_classic_era_\Interface\AddOns\CraftSage\` and `/reload` in-game
2. Open each profession's TradeSkill window — verify correct step appears
3. Use `/craftsage debug <skill>` to fast-forward through steps without crafting
4. Spot-check shopping list mat totals for Alchemy and Engineering against wowhead
5. Test edge cases: skill = 300, unknown profession, rapid consecutive crafts

---

## Out of scope (v1)

- Auction House pricing or cost estimates
- Farming route maps or zone danger warnings
- Multiple target skill levels (always 1 → 300)
- Non-English locales
- Wrath / Cataclysm Classic versions
- Fishing (levels by casting, not TradeSkill recipes — incompatible with step model)

---

## Git

- No `Co-Authored-By` lines in commit messages — ever.
