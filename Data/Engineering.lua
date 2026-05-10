CraftSageData = CraftSageData or {}

CraftSageData["Engineering"] = {
  hc_recommended = true,
  steps = {
    {
      recipe      = "Rough Blasting Powder",
      spell_id    = 3918,
      skill_up_to = 30,
      qty         = 60,
      mats = {
        { item = 2835, count = 1 },  -- Rough Stone
      },
    },
    {
      recipe      = "Handful of Copper Bolts",
      spell_id    = 3922,
      skill_up_to = 50,
      qty         = 30,
      mats = {
        { item = 2840, count = 1 },  -- Copper Bar
      },
    },
    {
      recipe      = "Arclight Spanner",
      spell_id    = 7430,
      skill_up_to = 51,
      qty         = 1,
      mats = {
        { item = 2840, count = 6 },  -- Copper Bar
      },
    },
    {
      recipe      = "Rough Copper Bomb",
      spell_id    = 3923,
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
      spell_id    = 3929,
      skill_up_to = 90,
      qty         = 60,
      mats = {
        { item = 2836, count = 1 },  -- Coarse Stone
      },
    },
    {
      recipe      = "Coarse Dynamite",
      spell_id    = 3931,
      skill_up_to = 100,
      qty         = 20,
      mats = {
        { item = 4364, count = 3, source = "craft" },  -- Coarse Blasting Powder
        { item = 2589, count = 1 },  -- Linen Cloth
      },
    },
    {
      recipe      = "Silver Contact",
      spell_id    = 3973,
      skill_up_to = 105,
      qty         = 5,
      mats = {
        { item = 2842, count = 1 },  -- Silver Bar
      },
    },
    {
      recipe      = "Bronze Tube",
      spell_id    = 3938,
      skill_up_to = 125,
      qty         = 25,
      mats = {
        { item = 2841, count = 2 },  -- Bronze Bar
        { item = 2880, count = 1, source = "vendor" },  -- Weak Flux
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Expert Engineering",
      skill_up_to = 126,
      trainer_note = {
        alliance = "Lilliam Sparkspindle, Stormwind",
        horde    = "Roxxik, Orgrimmar",
      },
    },
    {
      recipe      = "Standard Scope",
      spell_id    = 3978,
      skill_up_to = 135,
      qty         = 10,
      mats = {
        { item = 4371, count = 1, source = "craft" },  -- Bronze Tube
        { item = 1206, count = 1 },  -- Moss Agate
      },
    },
    {
      recipe      = "Heavy Blasting Powder",
      spell_id    = 3945,
      skill_up_to = 145,
      qty         = 30,
      mats = {
        { item = 2838, count = 1 },  -- Heavy Stone
      },
    },
    {
      recipe      = "Whirring Bronze Gizmo",
      spell_id    = 3942,
      skill_up_to = 150,
      qty         = 15,
      mats = {
        { item = 2841, count = 2 },  -- Bronze Bar
        { item = 2592, count = 1 },  -- Wool Cloth
      },
    },
    {
      recipe      = "Bronze Framework",
      spell_id    = 3953,
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
      spell_id    = 3955,
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
      spell_id    = 12590,
      skill_up_to = 176,
      qty         = 1,
      mats = {
        { item = 3859, count = 4 },  -- Steel Bar
      },
    },
    {
      recipe      = "Solid Blasting Powder",
      spell_id    = 12585,
      skill_up_to = 195,
      qty         = 60,
      mats = {
        { item = 7912, count = 2 },  -- Solid Stone
      },
    },
    {
      recipe      = "Mithril Tube",
      spell_id    = 12589,
      skill_up_to = 200,
      qty         = 7,
      mats = {
        { item = 3860, count = 3 },  -- Mithril Bar
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Artisan Engineering",
      skill_up_to = 201,
      trainer_note = {
        alliance = "Deek Fizzlebizz, Tanaris",
        horde    = "Og'loc, Gadgetzan, Tanaris (neutral)",
      },
    },
    {
      recipe      = "Unstable Trigger",
      spell_id    = 12591,
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
      spell_id    = 12599,
      skill_up_to = 238,
      qty         = 40,
      mats = {
        { item = 3860, count = 3 },  -- Mithril Bar
      },
    },
    {
      recipe      = "Hi-Explosive Bomb",
      spell_id    = 12619,
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
      spell_id    = 19788,
      skill_up_to = 260,
      qty         = 30,
      mats = {
        { item = 12365, count = 2 }, -- Dense Stone
      },
    },
    {
      recipe      = "Thorium Widget",
      spell_id    = 19791,
      skill_up_to = 285,
      qty         = 35,
      mats = {
        { item = 12359, count = 3 }, -- Thorium Bar
        { item = 14047, count = 1 }, -- Runecloth
      },
    },
    {
      recipe      = "Thorium Shells",
      spell_id    = 19800,
      skill_up_to = 300,
      qty         = 15,
      mats = {
        { item = 12359, count = 2 }, -- Thorium Bar
        { item = 15992, count = 1, source = "craft" }, -- Dense Blasting Powder
      },
    },
  },
}
