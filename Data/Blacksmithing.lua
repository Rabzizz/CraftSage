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
        { item = 3470, count = 2, source = "craft" },  -- Rough Grinding Stone
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
      step_type   = "trainer",
      recipe      = "Learn Expert Blacksmithing",
      skill_up_to = 126,
      trainer_note = {
        alliance = "Bengus Deepforge, Ironforge",
        horde    = "Brikk Keencraft, Booty Bay (neutral)",
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
        { item = 3478, count = 2, source = "craft" },  -- Coarse Grinding Stone
      },
    },
    {
      recipe      = "Golden Rod",
      skill_up_to = 155,
      qty         = 5,
      mats = {
        { item = 3577, count = 1 },  -- Gold Bar
        { item = 3478, count = 2, source = "craft" },  -- Coarse Grinding Stone
      },
    },
    {
      recipe      = "Green Iron Leggings",
      skill_up_to = 165,
      qty         = 10,
      mats = {
        { item = 3575, count = 8 },  -- Iron Bar
        { item = 3486, count = 1, source = "craft" },  -- Heavy Grinding Stone
        { item = 2605, count = 1, source = "vendor" },  -- Green Dye
      },
    },
    {
      recipe      = "Green Iron Bracers",
      skill_up_to = 190,
      qty         = 25,
      mats = {
        { item = 3575, count = 6 },  -- Iron Bar
        { item = 2605, count = 1, source = "vendor" },  -- Green Dye
      },
    },
    {
      recipe      = "Golden Scale Bracers",
      skill_up_to = 200,
      qty         = 10,
      mats = {
        { item = 3859, count = 5 },  -- Steel Bar
        { item = 3486, count = 2, source = "craft" },  -- Heavy Grinding Stone
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Artisan Blacksmithing",
      skill_up_to = 201,
      trainer_note = {
        alliance = "Brikk Keencraft, Booty Bay",
        horde    = "Brikk Keencraft, Booty Bay",
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
        { item = 7966, count = 1, source = "craft" },  -- Solid Grinding Stone
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
