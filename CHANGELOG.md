# CraftSage Changelog

## [1.2.0] — 2026-05-09

### Added
- **Trainer steps** — data files now include trainer-visit steps (e.g. "Learn Expert Alchemy"). The active step renders as an amber callout block with faction-appropriate trainer location (Alliance vs. Horde via `UnitFactionGroup`). Dimmed upcoming steps show `[Trainer]` instead of a skill range.
- **Mat source tags** — all materials now carry a `source` field (`gather` / `vendor` / `craft`). Vendor-bought items (vials, salt, rods, etc.) render their name in amber with a `[buy]` tag in both the panel and the shopping list.
- **Item tooltips on hover** — hovering any mat row in the panel or shopping list shows the native WoW item tooltip. Hovering the active recipe row shows the recipe tooltip.
- **Ctrl+Click → Wowhead popup** — Ctrl+clicking any mat row opens a dialog pre-filled with the Wowhead URL (`https://www.wowhead.com/classic/item=<id>`). Ctrl+clicking the active recipe row opens the spell URL (`https://www.wowhead.com/classic/spell=<id>`).

---

## [1.1.0] — 2026-05-08

### Added
- **Minimap button** — a LibDBIcon circular icon orbits the minimap and toggles the guide panel from anywhere in the game world. Position is draggable and saved between sessions.
- **"Guide >" title bar button** — a compact button in the TradeSkill window's title bar (left of the ✕) replaces the old overlay toggle. Label reads `Guide >` when the panel is closed and `< Guide` when open.
- **Panel open without profession** — clicking the minimap button when no profession window is open now shows the guide panel centered on screen with an "Open a profession window to use CraftSage" message.
- **French and German locale strings** for `MINIMAP_TOOLTIP`, `NO_PROFESSION_OPEN`, and `GUIDE_BTN`.
- **LibDataBroker-1.1** and **LibDBIcon-1.0** added to `Libs/`.

### Changed
- Guide panel is now **freely movable** — drag it anywhere by its background. Position is preserved until the panel is hidden and reshown.
- Panel auto-anchors to the right of the TradeSkill window on first open; subsequent refreshes (bag updates, skill-ups) no longer snap it back.
- Panel now **auto-closes** when the profession window closes, via a direct `OnHide` hook on `TradeSkillFrame` (more reliable than the `TRADE_SKILL_HIDE` event in Classic Era).

### Fixed
- Guide button creation deferred to first `TRADE_SKILL_SHOW` so `TradeSkillFrame` and `TradeSkillCreateButton` are guaranteed to exist (they are lazy-loaded in the Classic Era client).
- `Panel:Refresh()` no longer errors when called before any profession has been opened (`TradeSkillFrame` nil guard added).

---

## [1.0.0] — 2026-05-08

Initial public release on CurseForge and Wago.

### Features
- Side panel attaches to the right of the Blizzard TradeSkill window, showing the current leveling step, skill progress bar, and per-step material counts (have vs. need).
- **Active step auto-advances** — computed from your live skill level every time it changes; no manual tracking needed.
- **Shopping list popup** — aggregates all materials from your current skill to 300, grouped by category (Herbs, Metals, Leather, Cloth, Other), with per-item checkboxes and a "Copy to Chat" button.
- Supports all eight Classic Era crafting professions: **Alchemy, Blacksmithing, Engineering, Enchanting, Leatherworking, Tailoring, Cooking, First Aid**.
- **HC Recommended badge** on Hardcore-friendly profession paths.
- **Localization** — English, French (frFR), and German (deDE).
- All material quantities pre-calculated with ~30 % RNG buffer for yellow recipes.
- `/craftsage` slash command to toggle the panel; `/craftsage reset` to reset progress for the current profession.
- Per-character SavedVariables via AceDB-3.0 (shopping list checkmarks persisted across sessions).
- Item IDs used throughout for reliable localized item names via `GetItemInfo`.
