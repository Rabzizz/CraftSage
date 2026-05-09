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
        { item = 3371, count = 1, source = "vendor" },  -- Empty Vial
      },
    },
    {
      recipe      = "Lesser Healing Potion",
      skill_up_to = 110,
      qty         = 59,
      mats = {
        { item = 118,  count = 1, source = "craft" },  -- Minor Healing Potion
        { item = 2450, count = 1 },  -- Briarthorn
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Expert Alchemy",
      skill_up_to = 125,
      trainer_note = {
        alliance = "Ghak Healtouch, Ironforge",
        horde    = "Bena Winterhoof, Thunder Bluff",
      },
    },
    {
      recipe      = "Healing Potion",
      skill_up_to = 140,
      qty         = 30,
      mats = {
        { item = 2453, count = 1 },  -- Bruiseweed
        { item = 2450, count = 1 },  -- Briarthorn
        { item = 3372, count = 1, source = "vendor" },  -- Leaded Vial
      },
    },
    {
      recipe      = "Lesser Mana Potion",
      skill_up_to = 155,
      qty         = 15,
      mats = {
        { item = 785,  count = 1 },  -- Mageroyal
        { item = 3820, count = 1 },  -- Stranglekelp
        { item = 3371, count = 1, source = "vendor" },  -- Empty Vial
      },
    },
    {
      recipe      = "Greater Healing Potion",
      skill_up_to = 185,
      qty         = 30,
      mats = {
        { item = 3357, count = 1 },  -- Liferoot
        { item = 3356, count = 1 },  -- Kingsblood
        { item = 3372, count = 1, source = "vendor" },  -- Leaded Vial
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Artisan Alchemy",
      skill_up_to = 200,
      trainer_note = {
        alliance = "Kylanna Windwhisper, Feathermoon Stronghold, Feralas",
        horde    = "Doctor Martin Felias, Stonard, Swamp of Sorrows",
      },
    },
    {
      recipe      = "Elixir of Agility",
      skill_up_to = 210,
      qty         = 25,
      mats = {
        { item = 3820, count = 1 },  -- Stranglekelp
        { item = 3821, count = 1 },  -- Goldthorn
        { item = 3372, count = 1, source = "vendor" },  -- Leaded Vial
      },
    },
    {
      recipe      = "Elixir of Greater Defense",
      skill_up_to = 215,
      qty         = 10,
      mats = {
        { item = 3355, count = 1 },  -- Wild Steelbloom
        { item = 3821, count = 1 },  -- Goldthorn
        { item = 3372, count = 1, source = "vendor" },  -- Leaded Vial
      },
    },
    {
      recipe      = "Superior Healing Potion",
      skill_up_to = 230,
      qty         = 15,
      mats = {
        { item = 8838, count = 1 },  -- Sungrass
        { item = 3358, count = 1 },  -- Khadgar's Whisker
        { item = 8925, count = 1, source = "vendor" },  -- Crystal Vial
      },
    },
    {
      recipe      = "Philosophers' Stone",
      skill_up_to = 231,
      qty         = 1,
      mats = {
        { item = 3575, count = 4 },  -- Iron Bar
        { item = 9262, count = 1, source = "vendor" },  -- Black Vitriol
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
        { item = 8925, count = 1, source = "vendor" },  -- Crystal Vial
      },
    },
    {
      recipe      = "Elixir of Greater Agility",
      skill_up_to = 265,
      qty         = 15,
      mats = {
        { item = 8838, count = 1 },  -- Sungrass
        { item = 3821, count = 1 },  -- Goldthorn
        { item = 8925, count = 1, source = "vendor" },  -- Crystal Vial
      },
    },
    {
      recipe      = "Superior Mana Potion",
      skill_up_to = 285,
      qty         = 20,
      mats = {
        { item = 8838, count = 2 },  -- Sungrass
        { item = 8839, count = 2 },  -- Blindweed
        { item = 8925, count = 1, source = "vendor" },  -- Crystal Vial
      },
    },
    {
      recipe      = "Major Healing Potion",
      skill_up_to = 300,
      qty         = 18,
      mats = {
        { item = 13464, count = 2 }, -- Golden Sansam
        { item = 13465, count = 1 }, -- Mountain Silversage
        { item = 8925,  count = 1, source = "vendor" }, -- Crystal Vial
      },
    },
  },
}
