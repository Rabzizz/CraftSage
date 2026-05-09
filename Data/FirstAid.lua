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
      step_type   = "trainer",
      recipe      = "Learn Expert First Aid",
      skill_up_to = 151,
      trainer_note = {
        alliance = "Bring 'Expert First Aid - Under Wraps' quest to Doctor Gustaf VanHowzen, Theramore",
        horde    = "Bring 'Field Medic Penny' quest to Doctor Gregory Victor, Hammerfall, Arathi Highlands",
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
      step_type   = "trainer",
      recipe      = "Learn Artisan First Aid",
      skill_up_to = 225,
      trainer_note = {
        alliance = "Bring 'Triage' quest to Doctor Gustaf VanHowzen, Theramore",
        horde    = "Bring 'Triage' quest to Doctor Gregory Victor, Hammerfall, Arathi Highlands",
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
