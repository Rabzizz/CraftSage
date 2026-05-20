local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

-- Right-click dropdown
local menuFrame = CreateFrame("Frame", "CraftSageMinimapMenuFrame", UIParent, "UIDropDownMenuTemplate")

local function MinimapMenu_Init(self, level)
  local info = UIDropDownMenu_CreateInfo()
  info.text         = "CraftSage"
  info.isTitle      = true
  info.notCheckable = true
  UIDropDownMenu_AddButton(info, level)

  info = UIDropDownMenu_CreateInfo()
  info.text         = L["ALT_TRACKER_TITLE"]
  info.notCheckable = true
  info.func         = function() NS.AltTracker:Toggle() end
  UIDropDownMenu_AddButton(info, level)
end

local broker = LibStub("LibDataBroker-1.1"):NewDataObject("CraftSage", {
  type  = "launcher",
  label = "CraftSage",
  icon  = "Interface\\AddOns\\CraftSage\\CraftSage-logo",
  OnClick = function(_, button)
    if button == "LeftButton" then
      local ACD = LibStub("AceConfigDialog-3.0")
      if ACD.OpenFrames["CraftSage"] then
        ACD:Close("CraftSage")
      else
        ACD:Open("CraftSage")
      end
    elseif button == "RightButton" then
      UIDropDownMenu_Initialize(menuFrame, MinimapMenu_Init, "MENU")
      ToggleDropDownMenu(1, nil, menuFrame, "cursor", 3, -3)
    end
  end,
  OnTooltipShow = function(tip)
    tip:AddLine("CraftSage", 1, 0.82, 0)
    tip:AddLine(L["MINIMAP_TOOLTIP"], 1, 1, 1)
  end,
})

-- LibDBIcon:Register() needs CraftSage.db which is only set after OnInitialize
-- (AceAddon fires OnInitialize during ADDON_LOADED, before our handler below).
local _mb = CreateFrame("Frame")
_mb:RegisterEvent("ADDON_LOADED")
_mb:SetScript("OnEvent", function(self, event, name)
  if name == AddonName then
    LibStub("LibDBIcon-1.0"):Register("CraftSage", broker, NS.CraftSage.db.char.minimap)
    self:UnregisterAllEvents()
  end
end)
