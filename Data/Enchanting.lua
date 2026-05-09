CraftSageData = CraftSageData or {}

CraftSageData["Enchanting"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Runed Copper Rod",
      skill_up_to = 2,
      qty         = 1,
      mats = {
        { item = 6217,  count = 1, source = "vendor" }, -- Copper Rod
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
        { item = 4470,  count = 1, source = "vendor" }, -- Simple Wood
        { item = 10939, count = 1 }, -- Greater Magic Essence
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Expert Enchanting",
      skill_up_to = 125,
      trainer_note = {
        alliance = "Kitta Firewind, Tower of Azora, Elwynn Forest",
        horde    = "Hgarth, Sun Rock Retreat, Stonetalon Mountains",
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
      step_type   = "trainer",
      recipe      = "Learn Artisan Enchanting",
      skill_up_to = 221,
      trainer_note = {
        alliance = "Annora, Uldaman (dungeon)",
        horde    = "Annora, Uldaman (dungeon)",
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
        { item = 8925,  count = 1, source = "vendor" }, -- Crystal Vial
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
