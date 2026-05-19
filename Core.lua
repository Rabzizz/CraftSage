local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local CraftSage = LibStub("AceAddon-3.0"):NewAddon("CraftSage",
  "AceEvent-3.0",
  "AceConsole-3.0",
  "AceHook-3.0"
)
NS.CraftSage = CraftSage

NS.PRIMARY_PROFESSIONS = {
  ["Alchemy"]        = "Interface\\Icons\\Trade_Alchemy",
  ["Blacksmithing"]  = "Interface\\Icons\\Trade_BlackSmithing",
  ["Enchanting"]     = "Interface\\Icons\\Trade_Engraving",
  ["Engineering"]    = "Interface\\Icons\\Trade_Engineering",
  ["Herbalism"]      = "Interface\\Icons\\Spell_Nature_Naturetouchgrow",
  ["Leatherworking"] = "Interface\\Icons\\Trade_LeatherWorking",
  ["Mining"]         = "Interface\\Icons\\Trade_Mining",
  ["Skinning"]       = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
  ["Tailoring"]      = "Interface\\Icons\\Trade_Tailoring",
}

local DB_DEFAULTS = {
  char = {
    checkmarks = {},
    minimap    = { hide = false },
  },
  global = {
    settings = {
      panel_scale       = 1.0,
      panel_opacity     = 0.97,
      upcoming_steps    = 2,
      auto_open_panel   = true,
      step_flash        = true,
      show_tooltips     = true,
      vendor_highlight  = true,
      shopping_progress = true,
      theme             = "default",
    },
    alts = {},
  }
}

-- GetCraftLine() was removed in Classic Era 11508. CraftFrame is always Enchanting,
-- so fall back to GetSkillLineInfo which is still present and returns the same data.
local function GetCraftLineSafe()
  if GetCraftLine then
    local p, s, m = GetCraftLine()
    if p then return p, s, m end
  end
  for i = 1, GetNumSkillLines() do
    local name, _, _, rank, _, _, maxRank = GetSkillLineInfo(i)
    if name == "Enchanting" then
      return name, rank, maxRank
    end
  end
  return nil, 0, 0
end

local function AltKey()
  return UnitName("player") .. "-" .. GetRealmName()
end

local function UpsertAltProf(profName, rank, maxRank)
  local icon = NS.PRIMARY_PROFESSIONS[profName]
  if not icon then return end
  local key  = AltKey()
  local alts = NS.CraftSage.db.global.alts
  if not alts[key] then
    alts[key] = {
      name        = UnitName("player"),
      realm       = GetRealmName(),
      last_seen   = time(),
      professions = {},
    }
  end
  for _, p in ipairs(alts[key].professions) do
    if p.name == profName then
      p.rank = rank; p.maxRank = maxRank
      return
    end
  end
  table.insert(alts[key].professions, {
    name    = profName,
    icon    = icon,
    rank    = rank,
    maxRank = maxRank,
  })
end

function CraftSage:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("CraftSageDB", DB_DEFAULTS, true)
  self:RegisterChatCommand("craftsage", "SlashCommand")
end

function CraftSage:OnEnable()
  self:RegisterEvent("TRADE_SKILL_SHOW", "OnTradeSkillShow")
  self:RegisterEvent("TRADE_SKILL_HIDE", "OnTradeSkillHide")
  NS.Panel:ApplyTheme(self.db.global.settings.theme)
  -- Enchanting / CraftFrame: CRAFT_SHOW does not fire in Classic Era 11508,
  -- and GetCraftLine() no longer exists. Detection via CraftFrame:HookScript("OnShow")
  -- registered at PLAYER_LOGIN / ADDON_LOADED, with GetCraftLineSafe() for skill data.
end

function CraftSage:OnTradeSkillShow()
  self.usesCraftFrame = false
  NS.Panel:EnsureGuideBtn()
  local profName, skillLevel, maxSkillLevel = GetTradeSkillLine()
  self.currentProf     = profName
  self.currentSkill    = skillLevel
  self.currentMaxSkill = maxSkillLevel
  self.currentData     = CraftSageData and CraftSageData[profName]
  self.activeStepIndex = self:ComputeActiveStep(self.currentData, skillLevel)
  if self.db.global.settings.auto_open_panel then
    NS.Panel:Refresh(profName, skillLevel, maxSkillLevel, self.currentData, self.activeStepIndex)
  end
  self:HighlightActiveRecipe()
  UpsertAltProf(profName, skillLevel, maxSkillLevel)
end

function CraftSage:OnTradeSkillHide()
  self.currentProf = nil
  NS.Panel:Hide()
end

function CraftSage:OnCraftShow()
  self.usesCraftFrame = true
  local profName, skillLevel, maxSkillLevel = GetCraftLineSafe()
  self.currentProf     = profName
  self.currentSkill    = skillLevel
  self.currentMaxSkill = maxSkillLevel
  self.currentData     = CraftSageData and CraftSageData[profName]
  self.activeStepIndex = self:ComputeActiveStep(self.currentData, skillLevel)
  if self.db.global.settings.auto_open_panel then
    NS.Panel:Refresh(profName, skillLevel, maxSkillLevel, self.currentData, self.activeStepIndex)
  end
  self:HighlightActiveRecipe()
  if NS.Panel.EnsureCraftGuideBtn then NS.Panel:EnsureCraftGuideBtn() end
  UpsertAltProf(profName, skillLevel, maxSkillLevel)
end

function CraftSage:OnCraftHide()
  self.usesCraftFrame = false
  self.currentProf = nil
  NS.Panel:Hide()
end

-- CraftFrame is demand-loaded; hook it as soon as it becomes available.
-- CRAFT_SHOW/CRAFT_HIDE do not fire in Classic Era 11508.
local _craftHooked = false
local function TryHookCraftFrame()
  if _craftHooked or not CraftFrame then return false end
  _craftHooked = true
  CraftFrame:HookScript("OnShow", function() NS.CraftSage:OnCraftShow() end)
  if CraftFrame:IsShown() then
    NS.CraftSage:OnCraftShow()
  end
  return true
end

local _craftFrame = CreateFrame("Frame")
_craftFrame:RegisterEvent("PLAYER_LOGIN")
_craftFrame:RegisterEvent("ADDON_LOADED")
_craftFrame:RegisterEvent("BAG_UPDATE")
_craftFrame:RegisterEvent("SKILL_LINES_CHANGED")
_craftFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
_craftFrame:RegisterEvent("TRADE_SKILL_UPDATE")
_craftFrame:RegisterEvent("CRAFT_UPDATE")
_craftFrame:SetScript("OnEvent", function(self, event, arg1)
  local cs = NS.CraftSage

  if event == "PLAYER_LOGIN" then
    self:UnregisterEvent("PLAYER_LOGIN")
    TryHookCraftFrame()
    return
  end

  if event == "ADDON_LOADED" then
    if TryHookCraftFrame() then
      self:UnregisterEvent("ADDON_LOADED")
    end
    return
  end

  if event == "CRAFT_UPDATE" and not _craftHooked then
    TryHookCraftFrame()
  end

  if not cs.currentProf or not NS.Panel:IsVisible() then return end

  if event == "GET_ITEM_INFO_RECEIVED" then
    NS.Panel:Refresh(cs.currentProf, cs.currentSkill, cs.currentMaxSkill,
      cs.currentData, cs.activeStepIndex)
    if NS.ShoppingList:IsVisible() then NS.ShoppingList:Refresh() end
    return
  end

  if event == "SKILL_LINES_CHANGED" then
    local profName, skillLevel, maxSkillLevel
    if cs.usesCraftFrame then
      profName, skillLevel, maxSkillLevel = GetCraftLineSafe()
    else
      profName, skillLevel, maxSkillLevel = GetTradeSkillLine()
    end
    if profName == cs.currentProf then
      cs.currentSkill    = skillLevel
      cs.currentMaxSkill = maxSkillLevel
    end
  end

  local prevStep = cs.activeStepIndex
  cs.activeStepIndex = cs:ComputeActiveStep(cs.currentData, cs.currentSkill)
  NS.Panel:Refresh(
    cs.currentProf, cs.currentSkill, cs.currentMaxSkill,
    cs.currentData, cs.activeStepIndex,
    cs.activeStepIndex ~= prevStep
  )
  cs:HighlightActiveRecipe()
end)

function CraftSage:ComputeActiveStep(data, skillLevel)
  if not data then return nil end
  if skillLevel >= 300 then return nil end
  for i, step in ipairs(data.steps) do
    if step.skill_up_to > skillLevel then
      return i
    end
  end
  return nil
end

function CraftSage:HighlightActiveRecipe()
  if not self.currentData or not self.activeStepIndex then
    NS.Panel:SetHighlightedRecipeIndex(nil)
    return
  end
  local step = self.currentData.steps[self.activeStepIndex]
  if step and step.step_type == "trainer" then
    NS.Panel:SetHighlightedRecipeIndex(nil)
    return
  end
  local target = step.recipe
  if self.usesCraftFrame then
    local n = GetNumCrafts()
    for i = 1, n do
      local skillName = GetCraftInfo(i)
      if skillName == target then
        NS.Panel:SetHighlightedRecipeIndex(i)
        return
      end
    end
  else
    local numSkills = GetNumTradeSkills()
    for i = 1, numSkills do
      local skillName = GetTradeSkillInfo(i)
      if skillName == target then
        NS.Panel:SetHighlightedRecipeIndex(i)
        return
      end
    end
  end
  NS.Panel:SetHighlightedRecipeIndex(nil)
end

function CraftSage:SlashCommand(input)
  local cmd = strtrim(input):lower()
  if cmd == "" then
    if NS.Panel:IsVisible() then
      NS.Panel:Hide()
    else
      NS.Panel:Refresh(self.currentProf, self.currentSkill, self.currentMaxSkill, self.currentData, self.activeStepIndex)
    end
  elseif cmd == "reset" then
    if self.currentProf then
      self.db.char.checkmarks[self.currentProf] = nil
      if NS.ShoppingList:IsVisible() then NS.ShoppingList:Refresh() end
      self:Print("Progress reset for " .. self.currentProf)
    end
  end
end
