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
      step_type   = "trainer",
      recipe      = "Learn Artisan Cooking",
      skill_up_to = 225,
      trainer_note = {
        alliance = "Zamja, Orgrimmar or any major city cooking trainer",
        horde    = "Zamja, Orgrimmar or any major city cooking trainer",
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
        { item = 2692,  count = 1, source = "vendor" }, -- Hot Spices
        { item = 3713,  count = 1, source = "vendor" }, -- Soothing Spices
      },
    },
  },
}
