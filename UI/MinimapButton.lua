local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local broker = LibStub("LibDataBroker-1.1"):NewDataObject("CraftSage", {
  type  = "launcher",
  label = "CraftSage",
  icon  = "Interface\\AddOns\\CraftSage\\CraftSage-logo",
  OnClick = function(_, button)
    if button == "LeftButton" then
      InterfaceOptionsFrame_OpenToCategory("CraftSage")
      InterfaceOptionsFrame_OpenToCategory("CraftSage")
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
