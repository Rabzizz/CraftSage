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
        { item = 4359, count = 1, source = "craft" },  -- Handful of Copper Bolts
        { item = 4357, count = 2, source = "craft" },  -- Rough Blasting Powder
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
        { item = 4364, count = 3, source = "craft" },  -- Coarse Blasting Powder
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
        { item = 2880, count = 1, source = "vendor" },  -- Weak Flux
      },
    },
    {
      recipe      = "Standard Scope",
      skill_up_to = 135,
      qty         = 10,
      mats = {
        { item = 4371, count = 1, source = "craft" },  -- Bronze Tube
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
        { item = 4382, count = 1, source = "craft" },  -- Bronze Framework
        { item = 4375, count = 1, source = "craft" },  -- Whirring Bronze Gizmo
        { item = 4377, count = 2, source = "craft" },  -- Heavy Blasting Powder
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
        { item = 10505, count = 1, source = "craft" }, -- Solid Blasting Powder
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
        { item = 10561, count = 2, source = "craft" }, -- Mithril Casing
        { item = 10560, count = 1, source = "craft" }, -- Unstable Trigger
        { item = 10505, count = 2, source = "craft" }, -- Solid Blasting Powder
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
        { item = 15992, count = 1, source = "craft" }, -- Dense Blasting Powder
      },
    },
  },
}
