CraftSageData = CraftSageData or {}

CraftSageData["Leatherworking"] = {
  steps = {
    {
      recipe      = "Light Leather",
      spell_id    = 2881,
      skill_up_to = 30,
      qty         = 30,
      mats = {
        { item = 2934, count = 3 },  -- Ruined Leather Scraps
      },
    },
    {
      recipe      = "Light Armor Kit",
      spell_id    = 2152,
      skill_up_to = 45,
      qty         = 18,
      mats = {
        { item = 2318, count = 1 },  -- Light Leather
      },
    },
    {
      recipe      = "Cured Light Hide",
      spell_id    = 3816,
      skill_up_to = 55,
      qty         = 10,
      mats = {
        { item = 783,  count = 1 },  -- Light Hide
        { item = 4289, count = 1, source = "vendor" },  -- Salt
      },
    },
    {
      recipe      = "Embossed Leather Gloves",
      spell_id    = 3756,
      skill_up_to = 85,
      qty         = 30,
      mats = {
        { item = 2318, count = 3 },  -- Light Leather
        { item = 2320, count = 2, source = "vendor" },  -- Coarse Thread
      },
    },
    {
      recipe      = "Fine Leather Belt",
      spell_id    = 3763,
      skill_up_to = 100,
      qty         = 15,
      mats = {
        { item = 2318, count = 6 },  -- Light Leather
        { item = 2320, count = 2, source = "vendor" },  -- Coarse Thread
      },
    },
    {
      recipe      = "Cured Medium Hide",
      spell_id    = 3817,
      skill_up_to = 115,
      qty         = 15,
      mats = {
        { item = 4232, count = 1 },  -- Medium Hide
        { item = 4289, count = 1, source = "vendor" },  -- Salt
      },
    },
    {
      recipe      = "Dark Leather Boots",
      spell_id    = 2167,
      skill_up_to = 135,
      qty         = 22,
      mats = {
        { item = 2319, count = 4 },  -- Medium Leather
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
        { item = 4340, count = 1, source = "vendor" },  -- Gray Dye
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Expert Leatherworking",
      skill_up_to = 149,
      trainer_note = {
        alliance = "Telonis, Darnassus",
        horde    = "Una, Thunder Bluff",
      },
    },
    {
      recipe      = "Dark Leather Belt",
      spell_id    = 3766,
      skill_up_to = 150,
      qty         = 15,
      mats = {
        { item = 4246, count = 1, source = "craft" },  -- Fine Leather Belt
        { item = 4233, count = 1, source = "craft" },  -- Cured Medium Hide
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
        { item = 4340, count = 1, source = "vendor" },  -- Gray Dye
      },
    },
    {
      recipe      = "Heavy Leather",
      spell_id    = 20649,
      skill_up_to = 155,
      qty         = 5,
      mats = {
        { item = 2319, count = 5 },  -- Medium Leather
      },
    },
    {
      recipe      = "Cured Heavy Hide",
      spell_id    = 3818,
      skill_up_to = 160,
      qty         = 5,
      mats = {
        { item = 4235, count = 1 },  -- Heavy Hide
        { item = 4289, count = 3, source = "vendor" },  -- Salt
      },
    },
    {
      recipe      = "Heavy Armor Kit",
      spell_id    = 3780,
      skill_up_to = 180,
      qty         = 22,
      mats = {
        { item = 4234, count = 5 },  -- Heavy Leather
        { item = 2321, count = 1, source = "vendor" },  -- Fine Thread
      },
    },
    {
      recipe      = "Barbaric Shoulders",
      spell_id    = 7151,
      skill_up_to = 190,
      qty         = 10,
      mats = {
        { item = 4234, count = 8 },  -- Heavy Leather
        { item = 4236, count = 1, source = "craft" },  -- Cured Heavy Hide
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
      },
    },
    {
      recipe      = "Guardian Gloves",
      spell_id    = 7156,
      skill_up_to = 200,
      qty         = 10,
      mats = {
        { item = 4234, count = 4 },  -- Heavy Leather
        { item = 4236, count = 1, source = "craft" },  -- Cured Heavy Hide
        { item = 4291, count = 1, source = "vendor" },  -- Silken Thread
      },
    },
    {
      step_type   = "trainer",
      recipe      = "Learn Artisan Leatherworking",
      skill_up_to = 201,
      trainer_note = {
        alliance = "Drakk Stonehand, Aerie Peak, Hinterlands",
        horde    = "Brumn Winterhoof, Arathi Highlands",
      },
    },
    {
      recipe      = "Thick Armor Kit",
      spell_id    = 10487,
      skill_up_to = 220,
      qty         = 20,
      mats = {
        { item = 4304, count = 5 },  -- Thick Leather
        { item = 4291, count = 1, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Nightscape Headband",
      spell_id    = 10507,
      skill_up_to = 230,
      qty         = 11,
      mats = {
        { item = 4304, count = 5 },  -- Thick Leather
        { item = 4291, count = 2, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Nightscape Pants",
      spell_id    = 10548,
      skill_up_to = 250,
      qty         = 20,
      mats = {
        { item = 4304, count = 14 }, -- Thick Leather
        { item = 4291, count = 4, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Rugged Armor Kit",
      spell_id    = 19058,
      skill_up_to = 260,
      qty         = 12,
      mats = {
        { item = 8170, count = 5 },  -- Rugged Leather
      },
    },
    {
      recipe      = "Wicked Leather Gauntlets",
      spell_id    = 19049,
      skill_up_to = 290,
      qty         = 32,
      mats = {
        { item = 8170,  count = 8 }, -- Rugged Leather
        { item = 2325,  count = 1, source = "vendor" }, -- Black Dye
        { item = 14341, count = 1, source = "vendor" }, -- Rune Thread
      },
    },
    {
      recipe      = "Wicked Leather Headband",
      spell_id    = 19071,
      skill_up_to = 300,
      qty         = 10,
      mats = {
        { item = 8170,  count = 12 }, -- Rugged Leather
        { item = 2325,  count = 1, source = "vendor" },  -- Black Dye
        { item = 14341, count = 1, source = "vendor" },  -- Rune Thread
      },
    },
  },
}
