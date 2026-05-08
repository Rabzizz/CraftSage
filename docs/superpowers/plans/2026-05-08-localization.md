# Localization (frFR + deDE) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add French (frFR) and German (deDE) locale support, replace all mat item name strings in Data files with item IDs, and use `GetItemInfo(id)` for localized display names everywhere.

**Architecture:** Three independent workstreams that can be executed in any order: (1) locale files + TOC update, (2) item ID conversion across all 8 Data files, (3) UI call-site updates. All three must be complete before the addon is functional. The ShoppingList CAT table (workstream 3) depends on the item IDs established in workstream 2.

**Tech Stack:** AceLocale-3.0 (already present), WoW Classic Era API (`GetItemInfo`, `GetItemCount`), Lua 5.1.

---

## Item ID Reference

All IDs verified on wowhead.com/classic. Used across Tasks 2–9.

```
-- Herbs
Peacebloom=2447, Silverleaf=765, Briarthorn=2450, Bruiseweed=2453
Mageroyal=785, Wild Steelbloom=3355, Stranglekelp=3820
Kingsblood=3356, Liferoot=3357, Khadgar's Whisker=3358
Goldthorn=3821, Firebloom=4625, Purple Lotus=8831
Arthas' Tears=8836, Sungrass=8838, Blindweed=8839
Golden Sansam=13464, Mountain Silversage=13465

-- Stone / Ore
Rough Stone=2835, Coarse Stone=2836, Heavy Stone=2838
Solid Stone=7912, Dense Stone=12365

-- Bars
Copper Bar=2840, Bronze Bar=2841, Silver Bar=2842
Iron Bar=3575, Gold Bar=3577, Steel Bar=3859
Mithril Bar=3860, Thorium Bar=12359

-- Grinding Stones (crafted)
Rough Grinding Stone=3470, Coarse Grinding Stone=3478
Heavy Grinding Stone=3486, Solid Grinding Stone=7966

-- Gems / Crystals
Moss Agate=1206, Shadowgem=1210, Star Ruby=7910
Red Power Crystal=11186, Blue Power Crystal=11184, Green Power Crystal=11185

-- Cloth
Linen Cloth=2589, Wool Cloth=2592, Silk Cloth=4306
Mageweave Cloth=4338, Runecloth=14047

-- Cloth (crafted bolts)
Bolt of Linen Cloth=2996, Bolt of Woolen Cloth=2997
Bolt of Silk Cloth=4305, Bolt of Mageweave=4339, Bolt of Runecloth=14048

-- Leather (raw)
Light Leather=2318, Medium Leather=2319, Heavy Leather=4234
Thick Leather=4304, Rugged Leather=8170
Ruined Leather Scraps=2934

-- Hides
Light Hide=783, Medium Hide=4232, Heavy Hide=4235

-- Leather (crafted)
Cured Medium Hide=4233, Cured Heavy Hide=4236
Fine Leather Belt=4246

-- Thread / Dye / Misc vendor
Coarse Thread=2320, Fine Thread=2321
Silken Thread=4291, Heavy Silken Thread=8343, Rune Thread=14341
Bleach=2324, Salt=4289, Weak Flux=2880
Gray Dye=4340, Black Dye=2325, Blue Dye=6260
Red Dye=2604, Green Dye=2605, Orange Dye=6261

-- Vials
Empty Vial=3371, Leaded Vial=3372, Crystal Vial=8925

-- Alchemy misc
Black Vitriol=9262
Minor Healing Potion=118

-- Engineering crafted intermediates
Rough Blasting Powder=4357, Handful of Copper Bolts=4359
Coarse Blasting Powder=4364, Bronze Tube=4371
Whirring Bronze Gizmo=4375, Heavy Blasting Powder=4377
Bronze Framework=4382, Solid Blasting Powder=10505
Unstable Trigger=10560, Mithril Casing=10561
Dense Blasting Powder=15992

-- Enchanting rods (reagents, not raw bars)
Copper Rod=6217, Silver Rod=6338, Golden Rod=11128
Truesilver Rod=11144, Arcanite Rod=16206

-- Enchanting dusts / essences / shards
Strange Dust=10940, Lesser Magic Essence=10938, Greater Magic Essence=10939
Lesser Astral Essence=10998, Greater Astral Essence=11082
Soul Dust=11083, Vision Dust=11137
Greater Mystic Essence=11135
Lesser Nether Essence=11174, Dream Dust=11176
Illusion Dust=16204, Greater Eternal Essence=16203
Small Brilliant Shard=14343, Large Brilliant Shard=14344

-- Enchanting misc
Simple Wood=4470
Iridescent Pearl=5500, Black Pearl=7971, Golden Pearl=13926

-- Cooking fish
Raw Brilliant Smallfish=6291, Raw Longjaw Mud Snapper=6289
Raw Bristle Whisker Catfish=6308, Raw Mithril Head Trout=8365
Raw Spotted Yellowtail=4603, Large Raw Mightfish=13893

-- Cooking spices
Hot Spices=2692, Soothing Spices=3713
```

---

## Task 1: Locale files + TOC

**Files:**
- Create: `Locale/frFR.lua`
- Create: `Locale/deDE.lua`
- Modify: `CraftSage.toc`

- [ ] **Step 1: Create Locale/frFR.lua**

```lua
local L = LibStub("AceLocale-3.0"):NewLocale("CraftSage", "frFR")
if not L then return end

L["PANEL_TITLE"]        = "CraftSage"
L["HC_BADGE"]           = "HC Recommandé"
L["GUIDE_STEPS"]        = "Étapes du guide"
L["STEP_MATS"]          = "Matériaux de l'étape :"
L["SHOPPING_LIST_BTN"]  = "Liste de courses"
L["RESET_BTN"]          = "Réinitialiser"
L["NO_GUIDE"]           = "Aucun guide disponible."
L["MAXED"]              = "Maîtrisé ! Félicitations !"
L["SKILL_FMT"]          = "%d / %d"
L["SHOPPING_TITLE"]     = "Liste de courses"
L["SHOPPING_RANGE_FMT"] = "%s - Compétence %d à 300"
L["GATHERED_FMT"]       = "%d sur %d récupérés (%d%%)"
L["CLEAR_CHECKS"]       = "Décocher tout"
L["COPY_TO_CHAT"]       = "Copier dans le chat"
L["Herbs"]              = "Herbes"
L["Metals"]             = "Métaux"
L["Leather"]            = "Cuir"
L["Cloth"]              = "Tissu"
L["Other"]              = "Autre"
```

- [ ] **Step 2: Create Locale/deDE.lua**

```lua
local L = LibStub("AceLocale-3.0"):NewLocale("CraftSage", "deDE")
if not L then return end

L["PANEL_TITLE"]        = "CraftSage"
L["HC_BADGE"]           = "HC Empfohlen"
L["GUIDE_STEPS"]        = "Guide-Schritte"
L["STEP_MATS"]          = "Schritt-Materialien:"
L["SHOPPING_LIST_BTN"]  = "Einkaufsliste"
L["RESET_BTN"]          = "Zurücksetzen"
L["NO_GUIDE"]           = "Kein Guide verfügbar."
L["MAXED"]              = "Maximiert! Glückwunsch!"
L["SKILL_FMT"]          = "%d / %d"
L["SHOPPING_TITLE"]     = "Einkaufsliste"
L["SHOPPING_RANGE_FMT"] = "%s - Fertigkeit %d bis 300"
L["GATHERED_FMT"]       = "%d von %d gesammelt (%d%%)"
L["CLEAR_CHECKS"]       = "Auswahl aufheben"
L["COPY_TO_CHAT"]       = "In Chat kopieren"
L["Herbs"]              = "Kräuter"
L["Metals"]             = "Metalle"
L["Leather"]            = "Leder"
L["Cloth"]              = "Stoff"
L["Other"]              = "Sonstiges"
```

- [ ] **Step 3: Add locale files to CraftSage.toc**

In `CraftSage.toc`, replace:
```
Locale\enUS.lua
```
with:
```
Locale\enUS.lua
Locale\frFR.lua
Locale\deDE.lua
```

- [ ] **Step 4: Commit**

```
git add Locale\frFR.lua Locale\deDE.lua CraftSage.toc
git commit -m "feat: add frFR and deDE locale files"
```

---

## Task 2: Convert Data/Alchemy.lua to item IDs

**Files:**
- Modify: `Data/Alchemy.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Alchemy"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Minor Healing Potion",
      skill_up_to = 60,
      qty         = 59,
      mats = {
        { item = 2447, count = 1 },  -- Peacebloom
        { item = 765,  count = 1 },  -- Silverleaf
        { item = 3371, count = 1 },  -- Empty Vial
      },
    },
    {
      recipe      = "Lesser Healing Potion",
      skill_up_to = 110,
      qty         = 59,
      mats = {
        { item = 118,  count = 1 },  -- Minor Healing Potion
        { item = 2450, count = 1 },  -- Briarthorn
      },
    },
    {
      recipe      = "Healing Potion",
      skill_up_to = 140,
      qty         = 30,
      mats = {
        { item = 2453, count = 1 },  -- Bruiseweed
        { item = 2450, count = 1 },  -- Briarthorn
        { item = 3372, count = 1 },  -- Leaded Vial
      },
    },
    {
      recipe      = "Lesser Mana Potion",
      skill_up_to = 155,
      qty         = 15,
      mats = {
        { item = 785,  count = 1 },  -- Mageroyal
        { item = 3820, count = 1 },  -- Stranglekelp
        { item = 3371, count = 1 },  -- Empty Vial
      },
    },
    {
      recipe      = "Greater Healing Potion",
      skill_up_to = 185,
      qty         = 30,
      mats = {
        { item = 3357, count = 1 },  -- Liferoot
        { item = 3356, count = 1 },  -- Kingsblood
        { item = 3372, count = 1 },  -- Leaded Vial
      },
    },
    {
      recipe      = "Elixir of Agility",
      skill_up_to = 210,
      qty         = 25,
      mats = {
        { item = 3820, count = 1 },  -- Stranglekelp
        { item = 3821, count = 1 },  -- Goldthorn
        { item = 3372, count = 1 },  -- Leaded Vial
      },
    },
    {
      recipe      = "Elixir of Greater Defense",
      skill_up_to = 215,
      qty         = 10,
      mats = {
        { item = 3355, count = 1 },  -- Wild Steelbloom
        { item = 3821, count = 1 },  -- Goldthorn
        { item = 3372, count = 1 },  -- Leaded Vial
      },
    },
    {
      recipe      = "Superior Healing Potion",
      skill_up_to = 230,
      qty         = 15,
      mats = {
        { item = 8838, count = 1 },  -- Sungrass
        { item = 3358, count = 1 },  -- Khadgar's Whisker
        { item = 8925, count = 1 },  -- Crystal Vial
      },
    },
    {
      recipe      = "Philosophers' Stone",
      skill_up_to = 231,
      qty         = 1,
      mats = {
        { item = 3575, count = 4 },  -- Iron Bar
        { item = 9262, count = 1 },  -- Black Vitriol
        { item = 8831, count = 4 },  -- Purple Lotus
        { item = 4625, count = 4 },  -- Firebloom
      },
    },
    {
      recipe      = "Elixir of Detect Undead",
      skill_up_to = 250,
      qty         = 19,
      mats = {
        { item = 8836, count = 1 },  -- Arthas' Tears
        { item = 8925, count = 1 },  -- Crystal Vial
      },
    },
    {
      recipe      = "Elixir of Greater Agility",
      skill_up_to = 265,
      qty         = 15,
      mats = {
        { item = 8838, count = 1 },  -- Sungrass
        { item = 3821, count = 1 },  -- Goldthorn
        { item = 8925, count = 1 },  -- Crystal Vial
      },
    },
    {
      recipe      = "Superior Mana Potion",
      skill_up_to = 285,
      qty         = 20,
      mats = {
        { item = 8838, count = 2 },  -- Sungrass
        { item = 8839, count = 2 },  -- Blindweed
        { item = 8925, count = 1 },  -- Crystal Vial
      },
    },
    {
      recipe      = "Major Healing Potion",
      skill_up_to = 300,
      qty         = 18,
      mats = {
        { item = 13464, count = 2 }, -- Golden Sansam
        { item = 13465, count = 1 }, -- Mountain Silversage
        { item = 8925,  count = 1 }, -- Crystal Vial
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Alchemy.lua
git commit -m "refactor: Alchemy item names to item IDs"
```

---

## Task 3: Convert Data/Blacksmithing.lua to item IDs

**Files:**
- Modify: `Data/Blacksmithing.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Blacksmithing"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Rough Sharpening Stone",
      skill_up_to = 30,
      qty         = 40,
      mats = {
        { item = 2835, count = 1 },  -- Rough Stone
      },
    },
    {
      recipe      = "Rough Grinding Stone",
      skill_up_to = 65,
      qty         = 60,
      mats = {
        { item = 2835, count = 2 },  -- Rough Stone
      },
    },
    {
      recipe      = "Coarse Sharpening Stone",
      skill_up_to = 75,
      qty         = 25,
      mats = {
        { item = 2836, count = 1 },  -- Coarse Stone
      },
    },
    {
      recipe      = "Coarse Grinding Stone",
      skill_up_to = 90,
      qty         = 35,
      mats = {
        { item = 2836, count = 2 },  -- Coarse Stone
      },
    },
    {
      recipe      = "Runed Copper Belt",
      skill_up_to = 100,
      qty         = 10,
      mats = {
        { item = 2840, count = 10 }, -- Copper Bar
      },
    },
    {
      recipe      = "Silver Rod",
      skill_up_to = 105,
      qty         = 5,
      mats = {
        { item = 2842, count = 1 },  -- Silver Bar
        { item = 3470, count = 2 },  -- Rough Grinding Stone
      },
    },
    {
      recipe      = "Runed Copper Belt",
      skill_up_to = 110,
      qty         = 5,
      mats = {
        { item = 2840, count = 10 }, -- Copper Bar
      },
    },
    {
      recipe      = "Rough Bronze Leggings",
      skill_up_to = 125,
      qty         = 15,
      mats = {
        { item = 2841, count = 6 },  -- Bronze Bar
      },
    },
    {
      recipe      = "Heavy Grinding Stone",
      skill_up_to = 140,
      qty         = 35,
      mats = {
        { item = 2838, count = 3 },  -- Heavy Stone
      },
    },
    {
      recipe      = "Patterned Bronze Bracers",
      skill_up_to = 150,
      qty         = 10,
      mats = {
        { item = 2841, count = 5 },  -- Bronze Bar
        { item = 3478, count = 2 },  -- Coarse Grinding Stone
      },
    },
    {
      recipe      = "Golden Rod",
      skill_up_to = 155,
      qty         = 5,
      mats = {
        { item = 3577, count = 1 },  -- Gold Bar
        { item = 3478, count = 2 },  -- Coarse Grinding Stone
      },
    },
    {
      recipe      = "Green Iron Leggings",
      skill_up_to = 165,
      qty         = 10,
      mats = {
        { item = 3575, count = 8 },  -- Iron Bar
        { item = 3486, count = 1 },  -- Heavy Grinding Stone
        { item = 2605, count = 1 },  -- Green Dye
      },
    },
    {
      recipe      = "Green Iron Bracers",
      skill_up_to = 190,
      qty         = 25,
      mats = {
        { item = 3575, count = 6 },  -- Iron Bar
        { item = 2605, count = 1 },  -- Green Dye
      },
    },
    {
      recipe      = "Golden Scale Bracers",
      skill_up_to = 200,
      qty         = 10,
      mats = {
        { item = 3859, count = 5 },  -- Steel Bar
        { item = 3486, count = 2 },  -- Heavy Grinding Stone
      },
    },
    {
      recipe      = "Solid Grinding Stone",
      skill_up_to = 210,
      qty         = 30,
      mats = {
        { item = 7912, count = 4 },  -- Solid Stone
      },
    },
    {
      recipe      = "Heavy Mithril Gauntlet",
      skill_up_to = 225,
      qty         = 15,
      mats = {
        { item = 3860, count = 6 },  -- Mithril Bar
        { item = 4338, count = 4 },  -- Mageweave Cloth
      },
    },
    {
      recipe      = "Steel Plate Helm",
      skill_up_to = 235,
      qty         = 10,
      mats = {
        { item = 3859, count = 14 }, -- Steel Bar
        { item = 7966, count = 1 },  -- Solid Grinding Stone
      },
    },
    {
      recipe      = "Mithril Coif",
      skill_up_to = 250,
      qty         = 15,
      mats = {
        { item = 3860, count = 10 }, -- Mithril Bar
        { item = 4338, count = 6 },  -- Mageweave Cloth
      },
    },
    {
      recipe      = "Dense Sharpening Stone",
      skill_up_to = 260,
      qty         = 20,
      mats = {
        { item = 12365, count = 1 }, -- Dense Stone
      },
    },
    {
      recipe      = "Thorium Belt",
      skill_up_to = 270,
      qty         = 10,
      mats = {
        { item = 12359, count = 12 }, -- Thorium Bar
        { item = 11186, count = 4 },  -- Red Power Crystal
      },
    },
    {
      recipe      = "Thorium Bracers",
      skill_up_to = 275,
      qty         = 5,
      mats = {
        { item = 12359, count = 12 }, -- Thorium Bar
        { item = 11184, count = 4 },  -- Blue Power Crystal
      },
    },
    {
      recipe      = "Imperial Plate Bracers",
      skill_up_to = 290,
      qty         = 15,
      mats = {
        { item = 12359, count = 20 }, -- Thorium Bar
        { item = 7910,  count = 1 },  -- Star Ruby
      },
    },
    {
      recipe      = "Thorium Boots",
      skill_up_to = 300,
      qty         = 10,
      mats = {
        { item = 12359, count = 20 }, -- Thorium Bar
        { item = 8170,  count = 8 },  -- Rugged Leather
        { item = 11185, count = 4 },  -- Green Power Crystal
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Blacksmithing.lua
git commit -m "refactor: Blacksmithing item names to item IDs"
```

---

## Task 4: Convert Data/Engineering.lua to item IDs

**Files:**
- Modify: `Data/Engineering.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Engineering"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Rough Blasting Powder",
      skill_up_to = 30,
      qty         = 60,
      mats = {
        { item = 2835, count = 1 },  -- Rough Stone
      },
    },
    {
      recipe      = "Handful of Copper Bolts",
      skill_up_to = 50,
      qty         = 30,
      mats = {
        { item = 2840, count = 1 },  -- Copper Bar
      },
    },
    {
      recipe      = "Arclight Spanner",
      skill_up_to = 51,
      qty         = 1,
      mats = {
        { item = 2840, count = 6 },  -- Copper Bar
      },
    },
    {
      recipe      = "Rough Copper Bomb",
      skill_up_to = 75,
      qty         = 30,
      mats = {
        { item = 2840, count = 1 },  -- Copper Bar
        { item = 4359, count = 1 },  -- Handful of Copper Bolts
        { item = 4357, count = 2 },  -- Rough Blasting Powder
        { item = 2589, count = 1 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Coarse Blasting Powder",
      skill_up_to = 90,
      qty         = 60,
      mats = {
        { item = 2836, count = 1 },  -- Coarse Stone
      },
    },
    {
      recipe      = "Coarse Dynamite",
      skill_up_to = 100,
      qty         = 20,
      mats = {
        { item = 4364, count = 3 },  -- Coarse Blasting Powder
        { item = 2589, count = 1 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Silver Contact",
      skill_up_to = 105,
      qty         = 5,
      mats = {
        { item = 2842, count = 1 },  -- Silver Bar
      },
    },
    {
      recipe      = "Bronze Tube",
      skill_up_to = 125,
      qty         = 25,
      mats = {
        { item = 2841, count = 2 },  -- Bronze Bar
        { item = 2880, count = 1 },  -- Weak Flux
      },
    },
    {
      recipe      = "Standard Scope",
      skill_up_to = 135,
      qty         = 10,
      mats = {
        { item = 4371, count = 1 },  -- Bronze Tube
        { item = 1206, count = 1 },  -- Moss Agate
      },
    },
    {
      recipe      = "Heavy Blasting Powder",
      skill_up_to = 145,
      qty         = 30,
      mats = {
        { item = 2838, count = 1 },  -- Heavy Stone
      },
    },
    {
      recipe      = "Whirring Bronze Gizmo",
      skill_up_to = 150,
      qty         = 15,
      mats = {
        { item = 2841, count = 2 },  -- Bronze Bar
        { item = 2592, count = 1 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Bronze Framework",
      skill_up_to = 160,
      qty         = 15,
      mats = {
        { item = 2841, count = 2 },  -- Bronze Bar
        { item = 2319, count = 1 },  -- Medium Leather
        { item = 2592, count = 1 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Explosive Sheep",
      skill_up_to = 175,
      qty         = 15,
      mats = {
        { item = 4382, count = 1 },  -- Bronze Framework
        { item = 4375, count = 1 },  -- Whirring Bronze Gizmo
        { item = 4377, count = 2 },  -- Heavy Blasting Powder
        { item = 2592, count = 2 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Gyromatic Micro-Adjustor",
      skill_up_to = 176,
      qty         = 1,
      mats = {
        { item = 3859, count = 4 },  -- Steel Bar
      },
    },
    {
      recipe      = "Solid Blasting Powder",
      skill_up_to = 195,
      qty         = 60,
      mats = {
        { item = 7912, count = 2 },  -- Solid Stone
      },
    },
    {
      recipe      = "Mithril Tube",
      skill_up_to = 200,
      qty         = 7,
      mats = {
        { item = 3860, count = 3 },  -- Mithril Bar
      },
    },
    {
      recipe      = "Unstable Trigger",
      skill_up_to = 215,
      qty         = 20,
      mats = {
        { item = 3860,  count = 1 }, -- Mithril Bar
        { item = 4338,  count = 1 }, -- Mageweave Cloth
        { item = 10505, count = 1 }, -- Solid Blasting Powder
      },
    },
    {
      recipe      = "Mithril Casing",
      skill_up_to = 238,
      qty         = 40,
      mats = {
        { item = 3860, count = 3 },  -- Mithril Bar
      },
    },
    {
      recipe      = "Hi-Explosive Bomb",
      skill_up_to = 250,
      qty         = 20,
      mats = {
        { item = 10561, count = 2 }, -- Mithril Casing
        { item = 10560, count = 1 }, -- Unstable Trigger
        { item = 10505, count = 2 }, -- Solid Blasting Powder
      },
    },
    {
      recipe      = "Dense Blasting Powder",
      skill_up_to = 260,
      qty         = 30,
      mats = {
        { item = 12365, count = 2 }, -- Dense Stone
      },
    },
    {
      recipe      = "Thorium Widget",
      skill_up_to = 285,
      qty         = 35,
      mats = {
        { item = 12359, count = 3 }, -- Thorium Bar
        { item = 14047, count = 1 }, -- Runecloth
      },
    },
    {
      recipe      = "Thorium Shells",
      skill_up_to = 300,
      qty         = 15,
      mats = {
        { item = 12359, count = 2 }, -- Thorium Bar
        { item = 15992, count = 1 }, -- Dense Blasting Powder
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Engineering.lua
git commit -m "refactor: Engineering item names to item IDs"
```

---

## Task 5: Convert Data/Enchanting.lua to item IDs

**Files:**
- Modify: `Data/Enchanting.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Enchanting"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Runed Copper Rod",
      skill_up_to = 2,
      qty         = 1,
      mats = {
        { item = 6217,  count = 1 }, -- Copper Rod
        { item = 10940, count = 1 }, -- Strange Dust
        { item = 10938, count = 1 }, -- Lesser Magic Essence
      },
    },
    {
      recipe      = "Enchant Bracer - Minor Health",
      skill_up_to = 90,
      qty         = 108,
      mats = {
        { item = 10940, count = 1 }, -- Strange Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Minor Stamina",
      skill_up_to = 100,
      qty         = 10,
      mats = {
        { item = 10940, count = 3 }, -- Strange Dust
      },
    },
    {
      recipe      = "Runed Silver Rod",
      skill_up_to = 101,
      qty         = 1,
      mats = {
        { item = 6338,  count = 1 }, -- Silver Rod
        { item = 10940, count = 6 }, -- Strange Dust
        { item = 10939, count = 3 }, -- Greater Magic Essence
        { item = 1210,  count = 1 }, -- Shadowgem
      },
    },
    {
      recipe      = "Greater Magic Wand",
      skill_up_to = 110,
      qty         = 9,
      mats = {
        { item = 4470,  count = 1 }, -- Simple Wood
        { item = 10939, count = 1 }, -- Greater Magic Essence
      },
    },
    {
      recipe      = "Enchant Cloak - Minor Agility",
      skill_up_to = 135,
      qty         = 25,
      mats = {
        { item = 10998, count = 1 }, -- Lesser Astral Essence
      },
    },
    {
      recipe      = "Enchant Bracer - Lesser Stamina",
      skill_up_to = 155,
      qty         = 20,
      mats = {
        { item = 11083, count = 2 }, -- Soul Dust
      },
    },
    {
      recipe      = "Runed Golden Rod",
      skill_up_to = 156,
      qty         = 1,
      mats = {
        { item = 11128, count = 1 }, -- Golden Rod
        { item = 5500,  count = 1 }, -- Iridescent Pearl
        { item = 11082, count = 2 }, -- Greater Astral Essence
        { item = 11083, count = 2 }, -- Soul Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Lesser Strength",
      skill_up_to = 185,
      qty         = 40,
      mats = {
        { item = 11083, count = 2 }, -- Soul Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Strength",
      skill_up_to = 200,
      qty         = 15,
      mats = {
        { item = 11137, count = 1 }, -- Vision Dust
      },
    },
    {
      recipe      = "Runed Truesilver Rod",
      skill_up_to = 201,
      qty         = 1,
      mats = {
        { item = 11144, count = 1 }, -- Truesilver Rod
        { item = 7971,  count = 1 }, -- Black Pearl
        { item = 11135, count = 2 }, -- Greater Mystic Essence
        { item = 11137, count = 2 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Strength",
      skill_up_to = 220,
      qty         = 25,
      mats = {
        { item = 11137, count = 1 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Cloak - Greater Defense",
      skill_up_to = 225,
      qty         = 5,
      mats = {
        { item = 11137, count = 3 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Gloves - Agility",
      skill_up_to = 230,
      qty         = 5,
      mats = {
        { item = 11174, count = 1 }, -- Lesser Nether Essence
        { item = 11137, count = 1 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Boots - Stamina",
      skill_up_to = 235,
      qty         = 5,
      mats = {
        { item = 11137, count = 5 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Chest - Superior Health",
      skill_up_to = 250,
      qty         = 25,
      mats = {
        { item = 11137, count = 6 }, -- Vision Dust
      },
    },
    {
      recipe      = "Lesser Mana Oil",
      skill_up_to = 265,
      qty         = 20,
      mats = {
        { item = 11176, count = 3 }, -- Dream Dust
        { item = 8831,  count = 2 }, -- Purple Lotus
        { item = 8925,  count = 1 }, -- Crystal Vial
      },
    },
    {
      recipe      = "Enchant Shield - Greater Stamina",
      skill_up_to = 294,
      qty         = 30,
      mats = {
        { item = 11176, count = 10 }, -- Dream Dust
      },
    },
    {
      recipe      = "Runed Arcanite Rod",
      skill_up_to = 295,
      qty         = 1,
      mats = {
        { item = 16206, count = 1 },  -- Arcanite Rod
        { item = 13926, count = 1 },  -- Golden Pearl
        { item = 16204, count = 10 }, -- Illusion Dust
        { item = 16203, count = 4 },  -- Greater Eternal Essence
        { item = 14343, count = 4 },  -- Small Brilliant Shard
        { item = 14344, count = 2 },  -- Large Brilliant Shard
      },
    },
    {
      recipe      = "Enchant Cloak - Superior Defense",
      skill_up_to = 300,
      qty         = 5,
      mats = {
        { item = 16204, count = 8 },  -- Illusion Dust
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Enchanting.lua
git commit -m "refactor: Enchanting item names to item IDs"
```

---

## Task 6: Convert Data/Leatherworking.lua to item IDs

**Files:**
- Modify: `Data/Leatherworking.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Leatherworking"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Light Leather",
      skill_up_to = 30,
      qty         = 30,
      mats = {
        { item = 2934, count = 3 },  -- Ruined Leather Scraps
      },
    },
    {
      recipe      = "Light Armor Kit",
      skill_up_to = 45,
      qty         = 18,
      mats = {
        { item = 2318, count = 1 },  -- Light Leather
      },
    },
    {
      recipe      = "Cured Light Hide",
      skill_up_to = 55,
      qty         = 10,
      mats = {
        { item = 783,  count = 1 },  -- Light Hide
        { item = 4289, count = 1 },  -- Salt
      },
    },
    {
      recipe      = "Embossed Leather Gloves",
      skill_up_to = 85,
      qty         = 30,
      mats = {
        { item = 2318, count = 3 },  -- Light Leather
        { item = 2320, count = 2 },  -- Coarse Thread
      },
    },
    {
      recipe      = "Fine Leather Belt",
      skill_up_to = 100,
      qty         = 15,
      mats = {
        { item = 2318, count = 6 },  -- Light Leather
        { item = 2320, count = 2 },  -- Coarse Thread
      },
    },
    {
      recipe      = "Cured Medium Hide",
      skill_up_to = 115,
      qty         = 15,
      mats = {
        { item = 4232, count = 1 },  -- Medium Hide
        { item = 4289, count = 1 },  -- Salt
      },
    },
    {
      recipe      = "Dark Leather Boots",
      skill_up_to = 135,
      qty         = 22,
      mats = {
        { item = 2319, count = 4 },  -- Medium Leather
        { item = 2321, count = 2 },  -- Fine Thread
        { item = 4340, count = 1 },  -- Gray Dye
      },
    },
    {
      recipe      = "Dark Leather Belt",
      skill_up_to = 150,
      qty         = 15,
      mats = {
        { item = 4246, count = 1 },  -- Fine Leather Belt
        { item = 4233, count = 1 },  -- Cured Medium Hide
        { item = 2321, count = 2 },  -- Fine Thread
        { item = 4340, count = 1 },  -- Gray Dye
      },
    },
    {
      recipe      = "Heavy Leather",
      skill_up_to = 155,
      qty         = 5,
      mats = {
        { item = 2319, count = 5 },  -- Medium Leather
      },
    },
    {
      recipe      = "Cured Heavy Hide",
      skill_up_to = 160,
      qty         = 5,
      mats = {
        { item = 4235, count = 1 },  -- Heavy Hide
        { item = 4289, count = 3 },  -- Salt
      },
    },
    {
      recipe      = "Heavy Armor Kit",
      skill_up_to = 180,
      qty         = 22,
      mats = {
        { item = 4234, count = 5 },  -- Heavy Leather
        { item = 2321, count = 1 },  -- Fine Thread
      },
    },
    {
      recipe      = "Barbaric Shoulders",
      skill_up_to = 190,
      qty         = 10,
      mats = {
        { item = 4234, count = 8 },  -- Heavy Leather
        { item = 4236, count = 1 },  -- Cured Heavy Hide
        { item = 2321, count = 2 },  -- Fine Thread
      },
    },
    {
      recipe      = "Guardian Gloves",
      skill_up_to = 200,
      qty         = 10,
      mats = {
        { item = 4234, count = 4 },  -- Heavy Leather
        { item = 4236, count = 1 },  -- Cured Heavy Hide
        { item = 4291, count = 1 },  -- Silken Thread
      },
    },
    {
      recipe      = "Thick Armor Kit",
      skill_up_to = 220,
      qty         = 20,
      mats = {
        { item = 4304, count = 5 },  -- Thick Leather
        { item = 4291, count = 1 },  -- Silken Thread
      },
    },
    {
      recipe      = "Nightscape Headband",
      skill_up_to = 230,
      qty         = 11,
      mats = {
        { item = 4304, count = 5 },  -- Thick Leather
        { item = 4291, count = 2 },  -- Silken Thread
      },
    },
    {
      recipe      = "Nightscape Pants",
      skill_up_to = 250,
      qty         = 20,
      mats = {
        { item = 4304, count = 14 }, -- Thick Leather
        { item = 4291, count = 4 },  -- Silken Thread
      },
    },
    {
      recipe      = "Rugged Armor Kit",
      skill_up_to = 260,
      qty         = 12,
      mats = {
        { item = 8170, count = 5 },  -- Rugged Leather
      },
    },
    {
      recipe      = "Wicked Leather Gauntlets",
      skill_up_to = 290,
      qty         = 32,
      mats = {
        { item = 8170,  count = 8 }, -- Rugged Leather
        { item = 2325,  count = 1 }, -- Black Dye
        { item = 14341, count = 1 }, -- Rune Thread
      },
    },
    {
      recipe      = "Wicked Leather Headband",
      skill_up_to = 300,
      qty         = 10,
      mats = {
        { item = 8170,  count = 12 }, -- Rugged Leather
        { item = 2325,  count = 1 },  -- Black Dye
        { item = 14341, count = 1 },  -- Rune Thread
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Leatherworking.lua
git commit -m "refactor: Leatherworking item names to item IDs"
```

---

## Task 7: Convert Data/Tailoring.lua to item IDs

**Files:**
- Modify: `Data/Tailoring.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Tailoring"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Bolt of Linen Cloth",
      skill_up_to = 45,
      qty         = 95,
      mats = {
        { item = 2589, count = 2 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Linen Belt",
      skill_up_to = 70,
      qty         = 25,
      mats = {
        { item = 2996, count = 1 },  -- Bolt of Linen Cloth
        { item = 2320, count = 1 },  -- Coarse Thread
      },
    },
    {
      recipe      = "Reinforced Linen Cape",
      skill_up_to = 75,
      qty         = 5,
      mats = {
        { item = 2996, count = 2 },  -- Bolt of Linen Cloth
        { item = 2320, count = 3 },  -- Coarse Thread
      },
    },
    {
      recipe      = "Bolt of Woolen Cloth",
      skill_up_to = 100,
      qty         = 45,
      mats = {
        { item = 2592, count = 3 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Simple Kilt",
      skill_up_to = 110,
      qty         = 15,
      mats = {
        { item = 2996, count = 4 },  -- Bolt of Linen Cloth
        { item = 2321, count = 1 },  -- Fine Thread
      },
    },
    {
      recipe      = "Double-stitched Woolen Shoulders",
      skill_up_to = 125,
      qty         = 15,
      mats = {
        { item = 2997, count = 3 },  -- Bolt of Woolen Cloth
        { item = 2321, count = 2 },  -- Fine Thread
      },
    },
    {
      recipe      = "Bolt of Silk Cloth",
      skill_up_to = 145,
      qty         = 205,
      mats = {
        { item = 4306, count = 4 },  -- Silk Cloth
      },
    },
    {
      recipe      = "Azure Silk Hood",
      skill_up_to = 160,
      qty         = 20,
      mats = {
        { item = 4305, count = 2 },  -- Bolt of Silk Cloth
        { item = 2321, count = 1 },  -- Fine Thread
        { item = 6260, count = 2 },  -- Blue Dye
      },
    },
    {
      recipe      = "Silk Headband",
      skill_up_to = 170,
      qty         = 10,
      mats = {
        { item = 4305, count = 3 },  -- Bolt of Silk Cloth
        { item = 2321, count = 2 },  -- Fine Thread
      },
    },
    {
      recipe      = "Formal White Shirt",
      skill_up_to = 175,
      qty         = 5,
      mats = {
        { item = 4305, count = 3 },  -- Bolt of Silk Cloth
        { item = 2321, count = 1 },  -- Fine Thread
        { item = 2324, count = 2 },  -- Bleach
      },
    },
    {
      recipe      = "Bolt of Mageweave",
      skill_up_to = 185,
      qty         = 100,
      mats = {
        { item = 4338, count = 5 },  -- Mageweave Cloth
      },
    },
    {
      recipe      = "Crimson Silk Vest",
      skill_up_to = 205,
      qty         = 20,
      mats = {
        { item = 4305, count = 4 },  -- Bolt of Silk Cloth
        { item = 2321, count = 2 },  -- Fine Thread
        { item = 2604, count = 2 },  -- Red Dye
      },
    },
    {
      recipe      = "Crimson Silk Pantaloons",
      skill_up_to = 215,
      qty         = 10,
      mats = {
        { item = 4305, count = 4 },  -- Bolt of Silk Cloth
        { item = 4291, count = 2 },  -- Silken Thread
        { item = 2604, count = 2 },  -- Red Dye
      },
    },
    {
      recipe      = "Orange Mageweave Shirt",
      skill_up_to = 220,
      qty         = 5,
      mats = {
        { item = 4339, count = 1 },  -- Bolt of Mageweave
        { item = 8343, count = 1 },  -- Heavy Silken Thread
        { item = 6261, count = 1 },  -- Orange Dye
      },
    },
    {
      recipe      = "Black Mageweave Gloves",
      skill_up_to = 230,
      qty         = 10,
      mats = {
        { item = 4339, count = 2 },  -- Bolt of Mageweave
        { item = 8343, count = 2 },  -- Heavy Silken Thread
      },
    },
    {
      recipe      = "Black Mageweave Headband",
      skill_up_to = 250,
      qty         = 25,
      mats = {
        { item = 4339,  count = 3 }, -- Bolt of Mageweave
        { item = 8343,  count = 2 }, -- Heavy Silken Thread
      },
    },
    {
      recipe      = "Bolt of Runecloth",
      skill_up_to = 260,
      qty         = 155,
      mats = {
        { item = 14047, count = 5 }, -- Runecloth
      },
    },
    {
      recipe      = "Runecloth Belt",
      skill_up_to = 280,
      qty         = 25,
      mats = {
        { item = 14048, count = 3 }, -- Bolt of Runecloth
        { item = 14341, count = 1 }, -- Rune Thread
      },
    },
    {
      recipe      = "Runecloth Gloves",
      skill_up_to = 300,
      qty         = 20,
      mats = {
        { item = 14048, count = 4 }, -- Bolt of Runecloth
        { item = 8170,  count = 4 }, -- Rugged Leather
        { item = 14341, count = 1 }, -- Rune Thread
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Tailoring.lua
git commit -m "refactor: Tailoring item names to item IDs"
```

---

## Task 8: Convert Data/Cooking.lua to item IDs

**Files:**
- Modify: `Data/Cooking.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["Cooking"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Brilliant Smallfish",
      skill_up_to = 50,
      qty         = 50,
      mats = {
        { item = 6291, count = 1 },  -- Raw Brilliant Smallfish
      },
    },
    {
      recipe      = "Longjaw Mud Snapper",
      skill_up_to = 100,
      qty         = 50,
      mats = {
        { item = 6289, count = 1 },  -- Raw Longjaw Mud Snapper
      },
    },
    {
      recipe      = "Bristle Whisker Catfish",
      skill_up_to = 175,
      qty         = 120,
      mats = {
        { item = 6308, count = 1 },  -- Raw Bristle Whisker Catfish
      },
    },
    {
      recipe      = "Mithril Headed Trout",
      skill_up_to = 225,
      qty         = 60,
      mats = {
        { item = 8365, count = 1 },  -- Raw Mithril Head Trout
      },
    },
    {
      recipe      = "Spotted Yellowtail",
      skill_up_to = 275,
      qty         = 70,
      mats = {
        { item = 4603, count = 1 },  -- Raw Spotted Yellowtail
      },
    },
    {
      recipe      = "Mightfish Steak",
      skill_up_to = 300,
      qty         = 25,
      mats = {
        { item = 13893, count = 1 }, -- Large Raw Mightfish
        { item = 2692,  count = 1 }, -- Hot Spices
        { item = 3713,  count = 1 }, -- Soothing Spices
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\Cooking.lua
git commit -m "refactor: Cooking item names to item IDs"
```

---

## Task 9: Convert Data/FirstAid.lua to item IDs

**Files:**
- Modify: `Data/FirstAid.lua`

- [ ] **Step 1: Replace file contents**

```lua
CraftSageData = CraftSageData or {}

CraftSageData["First Aid"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Linen Bandage",
      skill_up_to = 40,
      qty         = 40,
      mats = {
        { item = 2589, count = 1 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Heavy Linen Bandage",
      skill_up_to = 80,
      qty         = 40,
      mats = {
        { item = 2589, count = 2 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Wool Bandage",
      skill_up_to = 115,
      qty         = 35,
      mats = {
        { item = 2592, count = 1 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Heavy Wool Bandage",
      skill_up_to = 150,
      qty         = 35,
      mats = {
        { item = 2592, count = 2 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Silk Bandage",
      skill_up_to = 180,
      qty         = 30,
      mats = {
        { item = 4306, count = 1 },  -- Silk Cloth
      },
    },
    {
      recipe      = "Heavy Silk Bandage",
      skill_up_to = 210,
      qty         = 30,
      mats = {
        { item = 4306, count = 2 },  -- Silk Cloth
      },
    },
    {
      recipe      = "Mageweave Bandage",
      skill_up_to = 240,
      qty         = 30,
      mats = {
        { item = 4338, count = 1 },  -- Mageweave Cloth
      },
    },
    {
      recipe      = "Heavy Mageweave Bandage",
      skill_up_to = 260,
      qty         = 20,
      mats = {
        { item = 4338, count = 2 },  -- Mageweave Cloth
      },
    },
    {
      recipe      = "Runecloth Bandage",
      skill_up_to = 290,
      qty         = 30,
      mats = {
        { item = 14047, count = 1 }, -- Runecloth
      },
    },
    {
      recipe      = "Heavy Runecloth Bandage",
      skill_up_to = 300,
      qty         = 10,
      mats = {
        { item = 14047, count = 2 }, -- Runecloth
      },
    },
  },
}
```

- [ ] **Step 2: Commit**

```
git add Data\FirstAid.lua
git commit -m "refactor: FirstAid item names to item IDs"
```

---

## Task 10: Update UI/Panel.lua display names

**Files:**
- Modify: `UI/Panel.lua:237-242`

The mat rendering loop currently uses `mat.item` directly as the display name. Replace with `GetItemInfo`.

- [ ] **Step 1: Update the mat rendering loop in Panel:Refresh**

Find this block (around line 237):
```lua
    for i, mat in ipairs(step.mats) do
      if i > 6 then break end
      local have = GetItemCount(mat.item) or 0
      local need = mat.count * remaining
      matRows[i].name:SetText(mat.item)
```

Replace with:
```lua
    for i, mat in ipairs(step.mats) do
      if i > 6 then break end
      local have = GetItemCount(mat.item) or 0
      local need = mat.count * remaining
      local name = GetItemInfo(mat.item) or ("Item:" .. mat.item)
      matRows[i].name:SetText(name)
```

- [ ] **Step 2: Commit**

```
git add UI\Panel.lua
git commit -m "feat: use GetItemInfo for localized mat names in panel"
```

---

## Task 11: Update UI/ShoppingList.lua

**Files:**
- Modify: `UI/ShoppingList.lua`

Four changes: (1) CAT table switches to integer keys, (2) sort uses localized names, (3) display uses GetItemInfo, (4) copy-to-chat uses GetItemInfo.

- [ ] **Step 1: Replace the CAT table (lines 75–92)**

Find:
```lua
local CAT = {
  ["Peacebloom"]="Herbs",["Silverleaf"]="Herbs",["Briarthorn"]="Herbs",
  ...
}
```

Replace the entire CAT table with:
```lua
local CAT = {
  -- Herbs
  [2447]="Herbs",[765]="Herbs",[2450]="Herbs",[2453]="Herbs",
  [785]="Herbs",[3355]="Herbs",[3820]="Herbs",[3356]="Herbs",
  [3357]="Herbs",[3358]="Herbs",[3821]="Herbs",[4625]="Herbs",
  [8831]="Herbs",[8836]="Herbs",[8838]="Herbs",[8839]="Herbs",
  [13464]="Herbs",[13465]="Herbs",
  -- Metals / Stone
  [2835]="Metals",[2836]="Metals",[2838]="Metals",[7912]="Metals",[12365]="Metals",
  [2840]="Metals",[2841]="Metals",[2842]="Metals",[3575]="Metals",[3577]="Metals",
  [3859]="Metals",[3860]="Metals",[12359]="Metals",
  [2880]="Metals",[3470]="Metals",[3478]="Metals",[3486]="Metals",[7966]="Metals",
  [11184]="Metals",[11185]="Metals",[11186]="Metals",[7910]="Metals",
  -- Leather
  [2318]="Leather",[2319]="Leather",[4234]="Leather",[4304]="Leather",[8170]="Leather",
  [4233]="Leather",[4236]="Leather",
  -- Cloth
  [2589]="Cloth",[2592]="Cloth",[4306]="Cloth",[4338]="Cloth",[14047]="Cloth",
}
```

- [ ] **Step 2: Update AggregateMats sort to use localized names**

Find (around line 176):
```lua
    table.sort(groups[cat], function(a, b) return a.item < b.item end)
```

Replace with:
```lua
    table.sort(groups[cat], function(a, b)
      local na = GetItemInfo(a.item) or tostring(a.item)
      local nb = GetItemInfo(b.item) or tostring(b.item)
      return na < nb
    end)
```

- [ ] **Step 3: Update row display name (line 239)**

Find:
```lua
        r.name:SetText(entry.item)
```

Replace with:
```lua
        r.name:SetText(GetItemInfo(entry.item) or ("Item:" .. entry.item))
```

- [ ] **Step 4: Update copy-to-chat handler**

Find (in copyBtn handler, around line 290):
```lua
      if not checks[entry.item] then
        table.insert(parts, entry.item .. " x" .. entry.qty)
      end
```

Replace with:
```lua
      if not checks[entry.item] then
        local name = GetItemInfo(entry.item) or ("Item:" .. entry.item)
        table.insert(parts, name .. " x" .. entry.qty)
      end
```

- [ ] **Step 5: Commit**

```
git add UI\ShoppingList.lua
git commit -m "feat: use item IDs and GetItemInfo in shopping list"
```

---

## Task 12: Register GET_ITEM_INFO_RECEIVED in Core.lua

**Files:**
- Modify: `Core.lua:46-68`

When `GetItemInfo` returns nil for an uncached item, the game fires `GET_ITEM_INFO_RECEIVED` once the data arrives. We hook this to refresh the panel and shopping list so placeholders resolve automatically.

- [ ] **Step 1: Add event registration to the existing raw frame**

Find (around line 46):
```lua
local _craftFrame = CreateFrame("Frame")
_craftFrame:RegisterEvent("BAG_UPDATE")
_craftFrame:RegisterEvent("SKILL_LINES_CHANGED")
```

Replace with:
```lua
local _craftFrame = CreateFrame("Frame")
_craftFrame:RegisterEvent("BAG_UPDATE")
_craftFrame:RegisterEvent("SKILL_LINES_CHANGED")
_craftFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
```

- [ ] **Step 2: Handle the event in the OnEvent script**

Find (the OnEvent handler, around line 48):
```lua
_craftFrame:SetScript("OnEvent", function(self, event)
  local cs = NS.CraftSage
  if not cs.currentProf or not NS.Panel:IsVisible() then return end

  if event == "SKILL_LINES_CHANGED" then
```

Replace with:
```lua
_craftFrame:SetScript("OnEvent", function(self, event)
  local cs = NS.CraftSage
  if not cs.currentProf or not NS.Panel:IsVisible() then return end

  if event == "GET_ITEM_INFO_RECEIVED" then
    NS.Panel:Refresh(cs.currentProf, cs.currentSkill, cs.currentMaxSkill,
      cs.currentData, cs.activeStepIndex)
    if NS.ShoppingList:IsVisible() then NS.ShoppingList:Refresh() end
    return
  end

  if event == "SKILL_LINES_CHANGED" then
```

- [ ] **Step 3: Commit**

```
git add Core.lua
git commit -m "feat: refresh panel on GET_ITEM_INFO_RECEIVED for cache misses"
```

---

## In-game verification

After all tasks are complete, test with `/reload` in-game:

- [ ] Open Alchemy TradeSkill — panel shows mat names in the client language
- [ ] Open Shopping List — item names are localized, categories group correctly
- [ ] Use `/craftsage debug 50` to advance steps — mat list updates correctly
- [ ] Use "Copy to Chat" — paste shows localized item names
- [ ] On a frFR or deDE client (or simulate with `GetLocale` override): UI chrome strings are translated
- [ ] Open a profession not in CraftSageData — panel shows "No guide available" (or translated equivalent)
- [ ] Reach skill 300 — panel shows "Maxed!" (or translated equivalent)
