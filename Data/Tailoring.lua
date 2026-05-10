CraftSageData = CraftSageData or {}

CraftSageData["Tailoring"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Bolt of Linen Cloth",
      spell_id    = 2963,
      skill_up_to = 45,
      qty         = 95,
      mats = {
        { item = 2589, count = 2 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Linen Belt",
      spell_id    = 8776,
      skill_up_to = 70,
      qty         = 25,
      mats = {
        { item = 2996, count = 1, source = "craft" },  -- Bolt of Linen Cloth
        { item = 2320, count = 1, source = "vendor" },  -- Coarse Thread
      },
    },
    {
      recipe      = "Reinforced Linen Cape",
      spell_id    = 2397,
      skill_up_to = 75,
      qty         = 5,
      mats = {
        { item = 2996, count = 2, source = "craft" },  -- Bolt of Linen Cloth
        { item = 2320, count = 3, source = "vendor" },  -- Coarse Thread
      },
    },
    {
      recipe      = "Bolt of Woolen Cloth",
      spell_id    = 2964,
      skill_up_to = 100,
      qty         = 45,
      mats = {
        { item = 2592, count = 3 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Simple Kilt",
      spell_id    = 12046,
      skill_up_to = 110,
      qty         = 15,
      mats = {
        { item = 2996, count = 4, source = "craft" },  -- Bolt of Linen Cloth
        { item = 2321, count = 1, source = "vendor" },  -- Fine Thread
      },
    },
    {
      recipe      = "Double-stitched Woolen Shoulders",
      spell_id    = 3848,
      skill_up_to = 125,
      qty         = 15,
      mats = {
        { item = 2997, count = 3, source = "craft" },  -- Bolt of Woolen Cloth
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Expert Tailoring",
      skill_up_to = 126,
      trainer_note = {
        alliance = "Joseph Moore, Darkshire, Duskwood",
        horde    = "Tepa, Thunder Bluff",
      },
    },
    {
      recipe      = "Bolt of Silk Cloth",
      spell_id    = 3839,
      skill_up_to = 145,
      qty         = 205,
      mats = {
        { item = 4306, count = 4 },  -- Silk Cloth
      },
    },
    {
      recipe      = "Azure Silk Hood",
      spell_id    = 8760,
      skill_up_to = 160,
      qty         = 20,
      mats = {
        { item = 4305, count = 2, source = "craft" },  -- Bolt of Silk Cloth
        { item = 2321, count = 1, source = "vendor" },  -- Fine Thread
        { item = 6260, count = 2, source = "vendor" },  -- Blue Dye
      },
    },
    {
      recipe      = "Silk Headband",
      spell_id    = 8762,
      skill_up_to = 170,
      qty         = 10,
      mats = {
        { item = 4305, count = 3, source = "craft" },  -- Bolt of Silk Cloth
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
      },
    },
    {
      recipe      = "Formal White Shirt",
      spell_id    = 3871,
      skill_up_to = 175,
      qty         = 5,
      mats = {
        { item = 4305, count = 3, source = "craft" },  -- Bolt of Silk Cloth
        { item = 2321, count = 1, source = "vendor" },  -- Fine Thread
        { item = 2324, count = 2, source = "vendor" },  -- Bleach
      },
    },
    {
      recipe      = "Bolt of Mageweave",
      spell_id    = 3865,
      skill_up_to = 185,
      qty         = 100,
      mats = {
        { item = 4338, count = 5 },  -- Mageweave Cloth
      },
    },
    {
      recipe      = "Crimson Silk Vest",
      spell_id    = 8791,
      skill_up_to = 205,
      qty         = 20,
      mats = {
        { item = 4305, count = 4, source = "craft" },  -- Bolt of Silk Cloth
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
        { item = 2604, count = 2, source = "vendor" },  -- Red Dye
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Artisan Tailoring",
      skill_up_to = 210,
      trainer_note = {
        alliance = "Daryl Stack, Hillsbrad Foothills",
        horde    = "Meilosh, Felwood",
      },
    },
    {
      recipe      = "Crimson Silk Pantaloons",
      spell_id    = 8799,
      skill_up_to = 215,
      qty         = 10,
      mats = {
        { item = 4305, count = 4, source = "craft" },  -- Bolt of Silk Cloth
        { item = 4291, count = 2, source = "vendor" },  -- Silken Thread
        { item = 2604, count = 2, source = "vendor" },  -- Red Dye
      },
    },
    {
      recipe      = "Orange Mageweave Shirt",
      spell_id    = 12061,
      skill_up_to = 220,
      qty         = 5,
      mats = {
        { item = 4339, count = 1, source = "craft" },  -- Bolt of Mageweave
        { item = 8343, count = 1, source = "vendor" },  -- Heavy Silken Thread
        { item = 6261, count = 1, source = "vendor" },  -- Orange Dye
      },
    },
    {
      recipe      = "Black Mageweave Gloves",
      spell_id    = 12053,
      skill_up_to = 230,
      qty         = 10,
      mats = {
        { item = 4339, count = 2, source = "craft" },  -- Bolt of Mageweave
        { item = 8343, count = 2, source = "vendor" },  -- Heavy Silken Thread
      },
    },
    {
      recipe      = "Black Mageweave Headband",
      spell_id    = 12072,
      skill_up_to = 250,
      qty         = 25,
      mats = {
        { item = 4339,  count = 3, source = "craft" }, -- Bolt of Mageweave
        { item = 8343,  count = 2, source = "vendor" }, -- Heavy Silken Thread
      },
    },
    {
      recipe      = "Bolt of Runecloth",
      spell_id    = 18401,
      skill_up_to = 260,
      qty         = 155,
      mats = {
        { item = 14047, count = 5 }, -- Runecloth
      },
    },
    {
      recipe      = "Runecloth Belt",
      spell_id    = 18402,
      skill_up_to = 280,
      qty         = 25,
      mats = {
        { item = 14048, count = 3, source = "craft" }, -- Bolt of Runecloth
        { item = 14341, count = 1, source = "vendor" }, -- Rune Thread
      },
    },
    {
      recipe      = "Runecloth Gloves",
      spell_id    = 18417,
      skill_up_to = 300,
      qty         = 20,
      mats = {
        { item = 14048, count = 4, source = "craft" }, -- Bolt of Runecloth
        { item = 8170,  count = 4 }, -- Rugged Leather
        { item = 14341, count = 1, source = "vendor" }, -- Rune Thread
      },
    },
  },
}
