CraftSageData = CraftSageData or {}

CraftSageData["Cooking"] = {
  steps = {
    {
      recipe      = "Brilliant Smallfish",
      spell_id    = 7751,
      skill_up_to = 50,
      qty         = 50,
      mats = {
        { item = 6291, count = 1 },  -- Raw Brilliant Smallfish
      },
    },
    {
      recipe      = "Longjaw Mud Snapper",
      spell_id    = 7753,
      skill_up_to = 100,
      qty         = 50,
      mats = {
        { item = 6289, count = 1 },  -- Raw Longjaw Mud Snapper
      },
    },
    {
      recipe      = "Bristle Whisker Catfish",
      spell_id    = 7755,
      skill_up_to = 175,
      qty         = 120,
      mats = {
        { item = 6308, count = 1 },  -- Raw Bristle Whisker Catfish
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Artisan Cooking",
      skill_up_to = 200,
      trainer_note = {
        alliance = "Gremlock Pilsnor, Ironforge, or any city cooking trainer",
        horde    = "Zamja, Orgrimmar, or any city cooking trainer",
      },
    },
    {
      recipe      = "Mithril Headed Trout",
      spell_id    = 20916,
      skill_up_to = 225,
      qty         = 60,
      mats = {
        { item = 8365, count = 1 },  -- Raw Mithril Head Trout
      },
    },
    {
      recipe      = "Spotted Yellowtail",
      spell_id    = 18238,
      skill_up_to = 275,
      qty         = 70,
      mats = {
        { item = 4603, count = 1 },  -- Raw Spotted Yellowtail
      },
    },
    {
      recipe      = "Mightfish Steak",
      spell_id    = 18246,
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
