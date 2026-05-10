local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local function S()
  return NS.CraftSage.db.global.settings
end

local options = {
  type = "group",
  name = "CraftSage",
  args = {
    display = {
      type   = "group",
      name   = L["SETTINGS_DISPLAY"],
      inline = true,
      order  = 1,
      args   = {
        panel_scale = {
          type  = "range",
          name  = L["SETTINGS_PANEL_SCALE"],
          desc  = L["SETTINGS_PANEL_SCALE_TIP"],
          min   = 0.7, max = 1.5, step = 0.05,
          order = 1,
          get   = function() return S().panel_scale end,
          set   = function(_, v) S().panel_scale = v; NS.Panel:ApplySettings() end,
        },
        panel_opacity = {
          type  = "range",
          name  = L["SETTINGS_PANEL_OPACITY"],
          desc  = L["SETTINGS_PANEL_OPACITY_TIP"],
          min   = 0.3, max = 1.0, step = 0.05,
          order = 2,
          get   = function() return S().panel_opacity end,
          set   = function(_, v) S().panel_opacity = v; NS.Panel:ApplySettings() end,
        },
        upcoming_steps = {
          type  = "range",
          name  = L["SETTINGS_UPCOMING_STEPS"],
          desc  = L["SETTINGS_UPCOMING_STEPS_TIP"],
          min   = 0, max = 2, step = 1,
          order = 3,
          get   = function() return S().upcoming_steps end,
          set   = function(_, v) S().upcoming_steps = v; NS.Panel:ApplySettings() end,
        },
      },
    },
    behavior = {
      type   = "group",
      name   = L["SETTINGS_BEHAVIOR"],
      inline = true,
      order  = 2,
      args   = {
        auto_open_panel = {
          type  = "toggle",
          name  = L["SETTINGS_AUTO_OPEN"],
          desc  = L["SETTINGS_AUTO_OPEN_TIP"],
          order = 1,
          width = "full",
          get   = function() return S().auto_open_panel end,
          set   = function(_, v) S().auto_open_panel = v end,
        },
        step_flash = {
          type  = "toggle",
          name  = L["SETTINGS_STEP_FLASH"],
          desc  = L["SETTINGS_STEP_FLASH_TIP"],
          order = 2,
          width = "full",
          get   = function() return S().step_flash end,
          set   = function(_, v) S().step_flash = v end,
        },
        show_tooltips = {
          type  = "toggle",
          name  = L["SETTINGS_SHOW_TOOLTIPS"],
          desc  = L["SETTINGS_SHOW_TOOLTIPS_TIP"],
          order = 3,
          width = "full",
          get   = function() return S().show_tooltips end,
          set   = function(_, v) S().show_tooltips = v end,
        },
      },
    },
    minimap_group = {
      type   = "group",
      name   = L["SETTINGS_MINIMAP"],
      inline = true,
      order  = 3,
      args   = {
        show_minimap = {
          type  = "toggle",
          name  = L["SETTINGS_MINIMAP_BTN"],
          desc  = L["SETTINGS_MINIMAP_BTN_TIP"],
          order = 1,
          width = "full",
          get   = function() return not NS.CraftSage.db.char.minimap.hide end,
          set   = function(_, v)
            NS.CraftSage.db.char.minimap.hide = not v
            local icon = LibStub("LibDBIcon-1.0", true)
            if icon then
              if v then icon:Show("CraftSage") else icon:Hide("CraftSage") end
            end
          end,
        },
      },
    },
    shopping_group = {
      type   = "group",
      name   = L["SETTINGS_SHOPPING"],
      inline = true,
      order  = 4,
      args   = {
        vendor_highlight = {
          type  = "toggle",
          name  = L["SETTINGS_VENDOR_HIGHLIGHT"],
          desc  = L["SETTINGS_VENDOR_HIGHLIGHT_TIP"],
          order = 1,
          width = "full",
          get   = function() return S().vendor_highlight end,
          set   = function(_, v)
            S().vendor_highlight = v
            if NS.ShoppingList:IsVisible() then NS.ShoppingList:Refresh() end
          end,
        },
        shopping_progress = {
          type  = "toggle",
          name  = L["SETTINGS_SHOPPING_PROGRESS"],
          desc  = L["SETTINGS_SHOPPING_PROGRESS_TIP"],
          order = 2,
          width = "full",
          get   = function() return S().shopping_progress end,
          set   = function(_, v)
            S().shopping_progress = v
            if NS.ShoppingList:IsVisible() then NS.ShoppingList:Refresh() end
          end,
        },
      },
    },
  },
}

local _regFrame = CreateFrame("Frame")
_regFrame:RegisterEvent("ADDON_LOADED")
_regFrame:SetScript("OnEvent", function(self, event, name)
  if name ~= AddonName then return end
  LibStub("AceConfig-3.0"):RegisterOptionsTable("CraftSage", options)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CraftSage", "CraftSage")
  self:UnregisterAllEvents()
end)
