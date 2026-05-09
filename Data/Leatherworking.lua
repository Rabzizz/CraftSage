CraftSageData = CraftSageData or {}

CraftSageData["Leatherworking"] = {
  hc_recommended = false,
  steps = {
    {
      recipe      = "Light Leather",
      skill_up_to = 30,
      qty         = 30,
      mats = {
        { item = 2934, count = 3 },  -- Ruined Leather Scraps
      },
    },
    {
      recipe      = "Light Armor Kit",
      skill_up_to = 45,
      qty         = 18,
      mats = {
        { item = 2318, count = 1 },  -- Light Leather
      },
    },
    {
      recipe      = "Cured Light Hide",
      skill_up_to = 55,
      qty         = 10,
      mats = {
        { item = 783,  count = 1 },  -- Light Hide
        { item = 4289, count = 1, source = "vendor" },  -- Salt
      },
    },
    {
      recipe      = "Embossed Leather Gloves",
      skill_up_to = 85,
      qty         = 30,
      mats = {
        { item = 2318, count = 3 },  -- Light Leather
        { item = 2320, count = 2, source = "vendor" },  -- Coarse Thread
      },
    },
    {
      recipe      = "Fine Leather Belt",
      skill_up_to = 100,
      qty         = 15,
      mats = {
        { item = 2318, count = 6 },  -- Light Leather
        { item = 2320, count = 2, source = "vendor" },  -- Coarse Thread
      },
    },
    {
      recipe      = "Cured Medium Hide",
      skill_up_to = 115,
      qty         = 15,
      mats = {
        { item = 4232, count = 1 },  -- Medium Hide
        { item = 4289, count = 1, source = "vendor" },  -- Salt
      },
    },
    {
      recipe      = "Dark Leather Boots",
      skill_up_to = 135,
      qty         = 22,
      mats = {
        { item = 2319, count = 4 },  -- Medium Leather
        { item = 2321, count = 2, source = "vendor" },  -- Fine Thread
        { item = 4340, count = 1, source = "vendor" },  -- Gray Dye
      },
    },
    {
      recipe      = "Dark Leather Belt",
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
      skill_up_to = 155,
      qty         = 5,
      mats = {
        { item = 2319, count = 5 },  -- Medium Leather
      },
    },
    {
      recipe      = "Cured Heavy Hide",
      skill_up_to = 160,
      qty         = 5,
      mats = {
        { item = 4235, count = 1 },  -- Heavy Hide
        { item = 4289, count = 3, source = "vendor" },  -- Salt
      },
    },
    {
      recipe      = "Heavy Armor Kit",
      skill_up_to = 180,
      qty         = 22,
      mats = {
        { item = 4234, count = 5 },  -- Heavy Leather
        { item = 2321, count = 1, source = "vendor" },  -- Fine Thread
      },
    },
    {
      recipe      = "Barbaric Shoulders",
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
      skill_up_to = 200,
      qty         = 10,
      mats = {
        { item = 4234, count = 4 },  -- Heavy Leather
        { item = 4236, count = 1, source = "craft" },  -- Cured Heavy Hide
        { item = 4291, count = 1, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Thick Armor Kit",
      skill_up_to = 220,
      qty         = 20,
      mats = {
        { item = 4304, count = 5 },  -- Thick Leather
        { item = 4291, count = 1, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Nightscape Headband",
      skill_up_to = 230,
      qty         = 11,
      mats = {
        { item = 4304, count = 5 },  -- Thick Leather
        { item = 4291, count = 2, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Nightscape Pants",
      skill_up_to = 250,
      qty         = 20,
      mats = {
        { item = 4304, count = 14 }, -- Thick Leather
        { item = 4291, count = 4, source = "vendor" },  -- Silken Thread
      },
    },
    {
      recipe      = "Rugged Armor Kit",
      skill_up_to = 260,
      qty         = 12,
      mats = {
        { item = 8170, count = 5 },  -- Rugged Leather
      },
    },
    {
      recipe      = "Wicked Leather Gauntlets",
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
      skill_up_to = 300,
      qty         = 10,
      mats = {
        { item = 8170,  count = 12 }, -- Rugged Leather
        { item = 2325,  count = 1 },  -- Black Dye
        { item = 14341, count = 1 },  -- Rune Thread
      },
    },
  },
}
