local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local ShoppingList = {}
NS.ShoppingList = ShoppingList

local SL_W = 225
local SL_H = 390

-- ── Frame ────────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "CraftSageShoppingListFrame", UIParent, "BackdropTemplate")
frame:SetSize(SL_W, SL_H)
frame:SetPoint("CENTER")
frame:Hide()
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)
frame:SetFrameStrata("DIALOG")
frame:SetBackdrop({
  bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:SetBackdropColor(0.05, 0.05, 0.12, 0.97)
frame:SetBackdropBorderColor(0.3, 0.3, 0.8, 1)

local slCloseBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
slCloseBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
slCloseBtn:SetScript("OnClick", function() frame:Hide() end)

table.insert(UISpecialFrames, "CraftSageShoppingListFrame")

-- Title
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOP", frame, "TOP", 0, -12)
titleText:SetTextColor(0.6, 0.6, 1, 1)
titleText:SetText(L["SHOPPING_TITLE"])

-- Subtitle
local subtitleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
subtitleText:SetPoint("TOP", titleText, "BOTTOM", 0, -4)
subtitleText:SetTextColor(0.6, 0.6, 0.6, 1)

-- Scroll frame
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT",     frame, "TOPLEFT",     8,  -46)
scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 50)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(SL_W - 36, 1)
scrollFrame:SetScrollChild(scrollChild)

-- Progress
local progressText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
progressText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 33)
progressText:SetTextColor(0.6, 0.6, 0.6, 1)

local _slThemeRefs = {
  frame        = frame,
  titleText    = titleText,
  subtitleText = subtitleText,
  progressText = progressText,
}

function ShoppingList:ApplyTheme(name)
  local t = NS.THEMES[name] or NS.THEMES["default"]
  frame:SetBackdrop({
    bgFile   = t.bgFile,
    edgeFile = t.edgeFile,
    tile     = true,
    tileSize = t.tileSize,
    edgeSize = t.edgeSize,
    insets   = t.insets,
  })
  local cs = NS.CraftSage
  local opacity = (cs and cs.db and cs.db.global.settings.panel_opacity) or 0.97
  frame:SetBackdropColor(t.slBg[1], t.slBg[2], t.slBg[3], opacity)
  frame:SetBackdropBorderColor(unpack(t.slBorder))
  _slThemeRefs.titleText:SetTextColor(unpack(t.slTitle))
  _slThemeRefs.subtitleText:SetTextColor(unpack(t.slSubtitle))
  _slThemeRefs.progressText:SetTextColor(unpack(t.slSubtitle))
end

-- Buttons
local clearBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
clearBtn:SetSize(100, 20)
clearBtn:SetPoint("BOTTOMLEFT",  frame, "BOTTOMLEFT",  8, 8)
clearBtn:SetText(L["CLEAR_CHECKS"])

local copyBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
copyBtn:SetSize(100, 20)
copyBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
copyBtn:SetText(L["COPY_TO_CHAT"])

-- ── Category map ─────────────────────────────────────────────────────────────

local CAT = {
  -- Herbs
  [2447]="Herbs",[765]="Herbs",[2450]="Herbs",[2453]="Herbs",
  [785]="Herbs",[3355]="Herbs",[3820]="Herbs",[3356]="Herbs",
  [3357]="Herbs",[3358]="Herbs",[3821]="Herbs",[4625]="Herbs",
  [8831]="Herbs",[8836]="Herbs",[8838]="Herbs",[8839]="Herbs",
  [13464]="Herbs",[13465]="Herbs",
  -- Metals / Stone
  [2835]="Metals",[2836]="Metals",[2838]="Metals",[7912]="Metals",[12365]="Metals",
  [2840]="Metals",[2841]="Metals",[2842]="Metals",[3575]="Metals",[3577]="Metals",
  [3859]="Metals",[3860]="Metals",[12359]="Metals",
  [2880]="Metals",[3470]="Metals",[3478]="Metals",[3486]="Metals",[7966]="Metals",
  [11184]="Metals",[11185]="Metals",[11186]="Metals",[7910]="Metals",
  -- Leather
  [2318]="Leather",[2319]="Leather",[4234]="Leather",[4304]="Leather",[8170]="Leather",
  [4233]="Leather",[4236]="Leather",
  -- Cloth
  [2589]="Cloth",[2592]="Cloth",[4306]="Cloth",[4338]="Cloth",[14047]="Cloth",
}
local CAT_ORDER = { "Herbs", "Metals", "Leather", "Cloth", "Other" }

-- ── Row pool ─────────────────────────────────────────────────────────────────

local rowPool    = {}
local headerPool = {}
local activeRows = {}

local function AcquireRow(n)
  if not rowPool[n] then
    local r = {}
    r.frame = CreateFrame("Frame", nil, scrollChild)
    r.frame:SetHeight(16)
    r.frame:EnableMouse(true)

    r.check = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.check:SetPoint("LEFT", r.frame, "LEFT", 2, 0)
    r.check:SetWidth(14)

    r.name = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.name:SetPoint("LEFT", r.frame, "LEFT", 18, 0)
    r.name:SetWidth(110)
    r.name:SetJustifyH("LEFT")

    r.buyTag = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.buyTag:SetPoint("LEFT", r.name, "RIGHT", 2, 0)
    r.buyTag:SetTextColor(1, 0.8, 0.2, 1)
    r.buyTag:Hide()

    r.qty = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.qty:SetPoint("RIGHT", r.frame, "RIGHT", -4, 0)

    r.frame:SetScript("OnEnter", function(self)
      local cs = NS.CraftSage
      if not cs or not cs.db or not cs.db.global.settings.show_tooltips then return end
      local item = self._item
      if not item then return end
      local _, link = GetItemInfo(item)
      if not link then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetHyperlink(link)
      GameTooltip:Show()
    end)
    r.frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r.frame:SetScript("OnMouseDown", function(self, button)
      local item = self._item
      if not item then return end
      if button == "LeftButton" then
        if IsControlKeyDown() then
          NS.wowheadUrl = "https://www.wowhead.com/classic/item=" .. item
          StaticPopup_Show("CRAFTSAGE_WOWHEAD_LINK")
        else
          local prof   = NS.CraftSage.currentProf
          local checks = NS.CraftSage.db.char.checkmarks
          if not checks[prof] then checks[prof] = {} end
          checks[prof][item] = not checks[prof][item]
          NS.ShoppingList:Refresh()
        end
      end
    end)

    rowPool[n] = r
  end
  return rowPool[n]
end

local function AcquireHeader(n)
  if not headerPool[n] then
    local h = CreateFrame("Frame", nil, scrollChild)
    h:SetHeight(18)
    h.label = h:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    h.label:SetPoint("LEFT", h, "LEFT", 2, 0)
    h.label:SetTextColor(0.55, 0.55, 0.55, 1)
    h.line = h:CreateTexture(nil, "ARTWORK")
    h.line:SetPoint("BOTTOMLEFT",  h, "BOTTOMLEFT",  0, 2)
    h.line:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 2)
    h.line:SetHeight(1)
    h.line:SetColorTexture(0.2, 0.2, 0.5, 0.6)
    headerPool[n] = h
  end
  return headerPool[n]
end

-- ── Aggregation ───────────────────────────────────────────────────────────────

local function AggregateMats(data, fromIdx, skillLevel)
  local totals  = {}
  local stepStart = fromIdx > 1 and data.steps[fromIdx - 1].skill_up_to or 1
  local firstCraftSeen = false

  for i = fromIdx, #data.steps do
    local step = data.steps[i]
    if not step.mats then  -- trainer step: no mats, skip
      -- continue
    else
      local qty = step.qty
      if not firstCraftSeen then
        firstCraftSeen = true
        qty = math.ceil(qty * (step.skill_up_to - skillLevel) / (step.skill_up_to - stepStart))
        qty = math.max(0, qty)
      end
      for _, mat in ipairs(step.mats) do
        local existing = totals[mat.item]
        if existing then
          existing.qty = existing.qty + mat.count * qty
        else
          totals[mat.item] = { qty = mat.count * qty, source = mat.source or "gather" }
        end
      end
    end
  end

  local groups = {}
  for _, cat in ipairs(CAT_ORDER) do groups[cat] = {} end
  for item, entry in pairs(totals) do
    local cat = CAT[item] or "Other"
    table.insert(groups[cat], { item = item, qty = entry.qty, source = entry.source })
  end
  for _, cat in ipairs(CAT_ORDER) do
    table.sort(groups[cat], function(a, b)
      local na = GetItemInfo(a.item) or tostring(a.item)
      local nb = GetItemInfo(b.item) or tostring(b.item)
      return na < nb
    end)
  end
  return groups
end

-- ── Refresh ───────────────────────────────────────────────────────────────────

function ShoppingList:Refresh()
  local prof      = NS.CraftSage.currentProf
  local data      = NS.CraftSage.currentData
  local activeIdx = NS.CraftSage.activeStepIndex
  local skill     = NS.CraftSage.currentSkill or 0

  subtitleText:SetText(string.format(L["SHOPPING_RANGE_FMT"], prof or "?", skill))

  for _, r in ipairs(activeRows) do
    if r.Hide then r:Hide()
    elseif r.frame then r.frame:Hide() end
  end
  activeRows = {}

  if not data or not activeIdx then return end

  local groups  = AggregateMats(data, activeIdx, skill)
  local checks  = NS.CraftSage.db.char.checkmarks[prof] or {}
  local scrollY = 0
  local total   = 0
  local checked = 0
  local rowN    = 0
  local hdrN    = 0

  for _, cat in ipairs(CAT_ORDER) do
    local items = groups[cat]
    if #items > 0 then
      hdrN = hdrN + 1
      local h = AcquireHeader(hdrN)
      h:SetPoint("TOPLEFT",  scrollChild, "TOPLEFT",  0, -scrollY)
      h:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, -scrollY)
      h.label:SetText(L[cat] or cat)
      h:Show()
      table.insert(activeRows, h)
      scrollY = scrollY + 18

      for _, entry in ipairs(items) do
        rowN  = rowN + 1
        total = total + 1
        local r = AcquireRow(rowN)
        r.frame:SetPoint("TOPLEFT",  scrollChild, "TOPLEFT",  0, -scrollY)
        r.frame:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, -scrollY)
        r.frame._item = entry.item

        local isChecked = checks[entry.item]
        if isChecked then
          checked = checked + 1
          r.check:SetText("|cff44aa44v|r")
          r.name:SetTextColor(0.4, 0.4, 0.4, 1)
          r.qty:SetTextColor(0.4, 0.4, 0.4, 1)
          r.buyTag:Hide()
        else
          r.check:SetText("|cff666666o|r")
          local _t  = NS.THEMES[NS.CraftSage.db.global.settings.theme] or NS.THEMES["default"]
          local vhl = NS.CraftSage.db.global.settings.vendor_highlight
          if entry.source == "vendor" and vhl then
            r.name:SetTextColor(unpack(_t.vendor))
            r.buyTag:SetText(L["MAT_SOURCE_VENDOR"])
            r.buyTag:Show()
          else
            r.name:SetTextColor(unpack(_t.matText))
            r.buyTag:Hide()
          end
          r.qty:SetTextColor(unpack(_t.activeStep))
        end
        r.name:SetText(GetItemInfo(entry.item) or ("Item:" .. entry.item))
        r.qty:SetText("x" .. entry.qty)
        r.frame:Show()
        table.insert(activeRows, r.frame)
        scrollY = scrollY + 16
      end
    end
  end

  scrollChild:SetHeight(math.max(scrollY, 1))
  local pct = total > 0 and math.floor(checked / total * 100) or 0
  progressText:SetText(string.format(L["GATHERED_FMT"], checked, total, pct))
  progressText:SetShown(NS.CraftSage.db.global.settings.shopping_progress)
end

function ShoppingList:Toggle()
  if frame:IsShown() then
    frame:Hide()
  else
    self:Refresh()
    frame:Show()
  end
end

function ShoppingList:IsVisible()
  return frame:IsShown()
end

-- ── Button handlers ───────────────────────────────────────────────────────────

clearBtn:SetScript("OnClick", function()
  local prof = NS.CraftSage.currentProf
  if prof then
    NS.CraftSage.db.char.checkmarks[prof] = nil
    NS.ShoppingList:Refresh()
  end
end)

copyBtn:SetScript("OnClick", function()
  local data      = NS.CraftSage.currentData
  local activeIdx = NS.CraftSage.activeStepIndex
  local prof      = NS.CraftSage.currentProf
  local skill     = NS.CraftSage.currentSkill or 0
  if not data or not activeIdx then return end

  local checks  = NS.CraftSage.db.char.checkmarks[prof] or {}
  local groups  = AggregateMats(data, activeIdx, skill)
  local parts   = {}

  for _, cat in ipairs(CAT_ORDER) do
    for _, entry in ipairs(groups[cat]) do
      if not checks[entry.item] then
        local name = GetItemInfo(entry.item) or ("Item:" .. entry.item)
        table.insert(parts, name .. " x" .. entry.qty)
      end
    end
  end

  if #parts == 0 then return end

  local editBox = ChatEdit_GetActiveWindow()
  if editBox then
    editBox:SetText(table.concat(parts, ", "))
    editBox:SetFocus()
  end
end)
