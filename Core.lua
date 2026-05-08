local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local CraftSage = LibStub("AceAddon-3.0"):NewAddon("CraftSage",
  "AceEvent-3.0",
  "AceConsole-3.0",
  "AceHook-3.0"
)
NS.CraftSage = CraftSage

local DB_DEFAULTS = {
  char = {
    checkmarks = {},
  }
}

function CraftSage:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("CraftSageDB", DB_DEFAULTS, true)
  self:RegisterChatCommand("craftsage", "SlashCommand")
end

function CraftSage:OnEnable()
  self:RegisterEvent("TRADE_SKILL_SHOW", "OnTradeSkillShow")
  self:RegisterEvent("TRADE_SKILL_HIDE", "OnTradeSkillHide")
end

function CraftSage:OnTradeSkillShow()
  local profName, skillLevel, maxSkillLevel = GetTradeSkillLine()
  self.currentProf     = profName
  self.currentSkill    = skillLevel
  self.currentMaxSkill = maxSkillLevel
  self.currentData     = CraftSageData and CraftSageData[profName]
  self.activeStepIndex = self:ComputeActiveStep(self.currentData, skillLevel)
  NS.Panel:Refresh(profName, skillLevel, maxSkillLevel, self.currentData, self.activeStepIndex)
  self:HighlightActiveRecipe()
end

function CraftSage:OnTradeSkillHide()
  self.currentProf = nil
  NS.Panel:Hide()
end

-- AceEvent RegisterEvent is unreliable for high-frequency events in Classic Era.
-- Use a raw frame for BAG_UPDATE (mat count refresh) and SKILL_LINES_CHANGED (skill-ups).
local _craftFrame = CreateFrame("Frame")
_craftFrame:RegisterEvent("BAG_UPDATE")
_craftFrame:RegisterEvent("SKILL_LINES_CHANGED")
_craftFrame:SetScript("OnEvent", function(self, event)
  local cs = NS.CraftSage
  if not cs.currentProf or not NS.Panel:IsVisible() then return end

  if event == "SKILL_LINES_CHANGED" then
    local profName, skillLevel, maxSkillLevel = GetTradeSkillLine()
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
  local target = self.currentData.steps[self.activeStepIndex].recipe
  local numSkills = GetNumTradeSkills()
  for i = 1, numSkills do
    local skillName = GetTradeSkillInfo(i)
    if skillName == target then
      NS.Panel:SetHighlightedRecipeIndex(i)
      return
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
  elseif cmd:sub(1, 5) == "debug" then
    local skill = tonumber(strtrim(cmd:sub(6)))
    if not skill then
      self:Print("Usage: /craftsage debug <skill>")
      return
    end
    if not self.currentProf then
      self:Print("Open a profession window first.")
      return
    end
    self.currentSkill    = skill
    self.activeStepIndex = self:ComputeActiveStep(self.currentData, skill)
    NS.Panel:Refresh(self.currentProf, skill, self.currentMaxSkill, self.currentData, self.activeStepIndex, true)
    self:Print("Debug: skill forced to " .. skill)
  end
end
