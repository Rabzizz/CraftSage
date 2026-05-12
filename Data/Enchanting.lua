CraftSageData = CraftSageData or {}

CraftSageData["Enchanting"] = {
  steps = {
    {
      recipe      = "Runed Copper Rod",
      spell_id    = 7421,
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
      spell_id    = 7418,
      skill_up_to = 90,
      qty         = 108,
      mats = {
        { item = 10940, count = 1 }, -- Strange Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Minor Stamina",
      spell_id    = 7457,
      skill_up_to = 100,
      qty         = 10,
      mats = {
        { item = 10940, count = 3 }, -- Strange Dust
      },
    },
    {
      recipe      = "Runed Silver Rod",
      spell_id    = 7795,
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
      spell_id    = 14807,
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
      spell_id    = 13419,
      skill_up_to = 135,
      qty         = 25,
      mats = {
        { item = 10998, count = 1 }, -- Lesser Astral Essence
      },
    },
    {
      recipe      = "Enchant Bracer - Lesser Stamina",
      spell_id    = 13501,
      skill_up_to = 155,
      qty         = 20,
      mats = {
        { item = 11083, count = 2 }, -- Soul Dust
      },
    },
    {
      recipe      = "Runed Golden Rod",
      spell_id    = 13628,
      skill_up_to = 156,
      qty         = 1,
      mats = {
        { item = 11128, count = 1, source = "vendor" }, -- Golden Rod
        { item = 5500,  count = 1 }, -- Iridescent Pearl
        { item = 11082, count = 2 }, -- Greater Astral Essence
        { item = 11083, count = 2 }, -- Soul Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Lesser Strength",
      spell_id    = 13536,
      skill_up_to = 185,
      qty         = 40,
      mats = {
        { item = 11083, count = 2 }, -- Soul Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Strength",
      spell_id    = 20010,
      skill_up_to = 200,
      qty         = 15,
      mats = {
        { item = 11137, count = 1 }, -- Vision Dust
      },
    },
    {
      recipe      = "Runed Truesilver Rod",
      spell_id    = 13702,
      skill_up_to = 201,
      qty         = 1,
      mats = {
        { item = 11144, count = 1, source = "vendor" }, -- Truesilver Rod
        { item = 7971,  count = 1 }, -- Black Pearl
        { item = 11135, count = 2 }, -- Greater Mystic Essence
        { item = 11137, count = 2 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Bracer - Strength",
      spell_id    = 20010,
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
      spell_id    = 13746,
      skill_up_to = 225,
      qty         = 5,
      mats = {
        { item = 11137, count = 3 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Gloves - Agility",
      spell_id    = 25080,
      skill_up_to = 230,
      qty         = 5,
      mats = {
        { item = 11174, count = 1 }, -- Lesser Nether Essence
        { item = 11137, count = 1 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Boots - Stamina",
      spell_id    = 20020,
      skill_up_to = 235,
      qty         = 5,
      mats = {
        { item = 11137, count = 5 }, -- Vision Dust
      },
    },
    {
      recipe      = "Enchant Chest - Superior Health",
      spell_id    = 13858,
      skill_up_to = 250,
      qty         = 25,
      mats = {
        { item = 11137, count = 6 }, -- Vision Dust
      },
    },
    {
      recipe      = "Lesser Mana Oil",
      spell_id    = 25127,
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
      spell_id    = 20017,
      skill_up_to = 294,
      qty         = 30,
      mats = {
        { item = 11176, count = 10 }, -- Dream Dust
      },
    },
    {
      recipe      = "Runed Arcanite Rod",
      spell_id    = 20051,
      skill_up_to = 295,
      qty         = 1,
      mats = {
        { item = 16206, count = 1, source = "vendor" },  -- Arcanite Rod
        { item = 13926, count = 1 },  -- Golden Pearl
        { item = 16204, count = 10 }, -- Illusion Dust
        { item = 16203, count = 4 },  -- Greater Eternal Essence
        { item = 14343, count = 4 },  -- Small Brilliant Shard
        { item = 14344, count = 2 },  -- Large Brilliant Shard
      },
    },
    {
      recipe      = "Enchant Cloak - Superior Defense",
      spell_id    = 20015,
      skill_up_to = 300,
      qty         = 5,
      mats = {
        { item = 16204, count = 8 },  -- Illusion Dust
      },
    },
  },
}
