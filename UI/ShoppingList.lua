local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local ShoppingList = {}
NS.ShoppingList = ShoppingList

local SL_W = 225
local SL_H = 390

-- ── Frame ────────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "CraftSageShoppingListFrame", UIParent)
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
  ["Peacebloom"]="Herbs",["Silverleaf"]="Herbs",["Briarthorn"]="Herbs",
  ["Bruiseweed"]="Herbs",["Mageroyal"]="Herbs",["Swiftthistle"]="Herbs",
  ["Stranglekelp"]="Herbs",["Kingsblood"]="Herbs",["Liferoot"]="Herbs",
  ["Goldthorn"]="Herbs",["Sungrass"]="Herbs",["Blindweed"]="Herbs",
  ["Golden Sansam"]="Herbs",["Mountain Silversage"]="Herbs",
  ["Rough Stone"]="Metals",["Coarse Stone"]="Metals",["Heavy Stone"]="Metals",
  ["Solid Stone"]="Metals",["Dense Stone"]="Metals",
  ["Copper Bar"]="Metals",["Bronze Bar"]="Metals",["Iron Bar"]="Metals",
  ["Gold Bar"]="Metals",["Mithril Bar"]="Metals",["Thorium Bar"]="Metals",
  ["Truesilver Bar"]="Metals",["Weak Flux"]="Metals",
  ["Light Leather"]="Leather",["Medium Leather"]="Leather",
  ["Heavy Leather"]="Leather",["Thick Leather"]="Leather",
  ["Rugged Leather"]="Leather",["Cured Medium Hide"]="Leather",
  ["Toughened Leather"]="Leather",
  ["Linen Cloth"]="Cloth",["Wool Cloth"]="Cloth",["Silk Cloth"]="Cloth",
  ["Mageweave Cloth"]="Cloth",["Runecloth"]="Cloth",
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
    r.name:SetWidth(148)
    r.name:SetJustifyH("LEFT")

    r.qty = r.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.qty:SetPoint("RIGHT", r.frame, "RIGHT", -4, 0)

    r.frame:SetScript("OnMouseDown", function(self)
      local item = self._item
      if not item then return end
      local prof   = NS.CraftSage.currentProf
      local checks = NS.CraftSage.db.char.checkmarks
      if not checks[prof] then checks[prof] = {} end
      checks[prof][item] = not checks[prof][item]
      NS.ShoppingList:Refresh()
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
  local totals = {}
  local stepStart = fromIdx > 1 and data.steps[fromIdx - 1].skill_up_to or 1

  for i = fromIdx, #data.steps do
    local step = data.steps[i]
    local qty  = step.qty
    if i == fromIdx then
      qty = math.ceil(qty * (step.skill_up_to - skillLevel) / (step.skill_up_to - stepStart))
      qty = math.max(0, qty)
    end
    for _, mat in ipairs(step.mats) do
      totals[mat.item] = (totals[mat.item] or 0) + mat.count * qty
    end
  end

  local groups = {}
  for _, cat in ipairs(CAT_ORDER) do groups[cat] = {} end
  for item, qty in pairs(totals) do
    local cat = CAT[item] or "Other"
    table.insert(groups[cat], { item = item, qty = qty })
  end
  for _, cat in ipairs(CAT_ORDER) do
    table.sort(groups[cat], function(a, b) return a.item < b.item end)
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
        else
          r.check:SetText("|cff666666o|r")
          r.name:SetTextColor(0.85, 0.85, 0.85, 1)
          r.qty:SetTextColor(0.7, 0.7, 1, 1)
        end
        r.name:SetText(entry.item)
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
        table.insert(parts, entry.item .. " x" .. entry.qty)
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
