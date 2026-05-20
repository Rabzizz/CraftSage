local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local AltTracker = {}
NS.AltTracker = AltTracker

StaticPopupDialogs["CRAFTSAGE_CONFIRM_DELETE_ALT"] = {
  text         = L["ALT_CONFIRM_DELETE"],
  button1      = ACCEPT,
  button2      = CANCEL,
  OnAccept     = function(self, data)
    NS.CraftSage.db.global.alts[data] = nil
    NS.AltTracker:Render()
  end,
  timeout      = 0,
  whileDead    = true,
  hideOnEscape = true,
  showAlert    = true,
}

local AT_W, AT_H = 260, 320

-- ── Frame ────────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "CraftSageAltTrackerFrame", UIParent, "BackdropTemplate")
frame:SetSize(AT_W, AT_H)
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

table.insert(UISpecialFrames, "CraftSageAltTrackerFrame")

-- Close button
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-- Title
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -12)

-- ── Filter bar ───────────────────────────────────────────────────────────────

local activeFilter = "all"

local FILTER_OPTS = {
  { value = "all",      label = L["ALT_FILTER_ALL"]      },
  { value = "alliance", label = L["ALT_FILTER_ALLIANCE"] },
  { value = "horde",    label = L["ALT_FILTER_HORDE"]    },
}
local filterBtns = {}

local filterBar = CreateFrame("Frame", nil, frame)
filterBar:SetPoint("TOPLEFT",  frame, "TOPLEFT",  8,  -30)
filterBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -26, -30)
filterBar:SetHeight(24)

local bw = math.floor((AT_W - 36) / 3)
for i, opt in ipairs(FILTER_OPTS) do
  local btn = CreateFrame("Button", nil, filterBar, "BackdropTemplate")
  btn:SetSize(bw, 20)
  btn:SetPoint("TOPLEFT", filterBar, "TOPLEFT", (i - 1) * (bw + 1), -2)
  btn:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  btn:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
  btn:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
  local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  txt:SetAllPoints()
  txt:SetText(opt.label)
  txt:SetTextColor(0.6, 0.6, 0.6, 1)
  btn._value = opt.value
  btn._txt   = txt
  filterBtns[i]         = btn
  filterBtns[opt.value] = btn
  local v = opt.value
  btn:SetScript("OnClick", function() NS.AltTracker:SetFilter(v) end)
end

local function UpdateFilterButtons()
  for _, opt in ipairs(FILTER_OPTS) do
    local btn = filterBtns[opt.value]
    if opt.value == activeFilter then
      btn:SetBackdropBorderColor(1, 0.82, 0, 1)
      btn._txt:SetTextColor(1, 0.82, 0, 1)
    else
      btn:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
      btn._txt:SetTextColor(0.6, 0.6, 0.6, 1)
    end
  end
end

-- ── Scroll frame ─────────────────────────────────────────────────────────────

local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT",     frame, "TOPLEFT",     8,  -58)
scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -26,  8)
scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript("OnMouseWheel", function(self, delta)
  local cur = self:GetVerticalScroll()
  local max = self:GetVerticalScrollRange()
  self:SetVerticalScroll(math.max(0, math.min(max, cur - delta * 20)))
end)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetWidth(AT_W - 34)
scrollChild:SetHeight(1)
scrollFrame:SetScrollChild(scrollChild)

-- Empty state
local emptyText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
emptyText:SetPoint("TOP", scrollChild, "TOP", 0, -20)
emptyText:SetTextColor(0.6, 0.6, 0.6, 1)
emptyText:SetJustifyH("CENTER")
emptyText:Hide()

-- ── Widget pools ─────────────────────────────────────────────────────────────

local _nameLabels  = {}
local _classIcons  = {}
local _profIcons   = {}
local _profLabels  = {}

local function GetNameLabel(i)
  if not _nameLabels[i] then
    _nameLabels[i] = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  end
  return _nameLabels[i]
end

local function GetProfIcon(i)
  if not _profIcons[i] then
    local tex = scrollChild:CreateTexture(nil, "ARTWORK")
    tex:SetSize(14, 14)
    _profIcons[i] = tex
  end
  return _profIcons[i]
end

local function GetProfLabel(i)
  if not _profLabels[i] then
    _profLabels[i] = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  end
  return _profLabels[i]
end

local _blockFrames = {}

local function GetBlockFrame(i)
  if not _blockFrames[i] then
    local bf = CreateFrame("Frame", nil, scrollChild)
    bf:EnableMouse(true)

    local xBtn = CreateFrame("Button", nil, bf)
    xBtn:SetSize(16, 16)
    xBtn:RegisterForClicks("LeftButtonUp")
    xBtn:SetPoint("TOPRIGHT", bf, "TOPRIGHT", -2, -2)
    local xTxt = xBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    xTxt:SetPoint("CENTER")
    xTxt:SetText("|cffff4444x|r")
    xBtn:Hide()

    bf:SetScript("OnEnter", function(self)
      if self._canDelete then self.xBtn:Show() end
    end)
    bf:SetScript("OnLeave", function(self)
      if not MouseIsOver(self.xBtn) then
        self.xBtn:Hide()
      end
    end)
    xBtn:SetScript("OnLeave", function(self)
      self:Hide()
    end)
    xBtn:SetScript("OnClick", function(self)
      local p = self:GetParent()
      StaticPopup_Show("CRAFTSAGE_CONFIRM_DELETE_ALT", p._altName, nil, p._altKey)
    end)

    bf.xBtn = xBtn
    _blockFrames[i] = bf
  end
  return _blockFrames[i]
end

local function ClassIconPath(classFile)
  if not classFile then return nil end
  return "Interface\\Icons\\ClassIcon_"
    .. classFile:sub(1, 1):upper() .. classFile:sub(2):lower()
end

local function GetClassIcon(i)
  if not _classIcons[i] then
    local tex = scrollChild:CreateTexture(nil, "ARTWORK")
    tex:SetSize(20, 20)
    _classIcons[i] = tex
  end
  return _classIcons[i]
end

local function HideAll()
  for _, v in ipairs(_nameLabels)  do v:Hide() end
  for _, v in ipairs(_classIcons)  do v:Hide() end
  for _, v in ipairs(_profIcons)   do v:Hide() end
  for _, v in ipairs(_profLabels)  do v:Hide() end
  for _, v in ipairs(_blockFrames) do v:Hide(); v.xBtn:Hide() end
end

-- ── Render ───────────────────────────────────────────────────────────────────

function AltTracker:Render()
  HideAll()
  emptyText:Hide()

  local db    = NS.CraftSage.db.global.alts
  local myKey = UnitName("player") .. "-" .. GetRealmName()

  local chars = {}
  local filter = activeFilter or "all"
  for k, v in pairs(db) do
    if v.professions and #v.professions > 0 then
      local isCurrent = (k == myKey)
      local match = (filter == "all")
        or (filter == "alliance" and v.faction == "Alliance")
        or (filter == "horde"    and v.faction == "Horde")
      if match then
        table.insert(chars, { key = k, data = v, isCurrent = isCurrent })
      end
    end
  end
  table.sort(chars, function(a, b)
    if a.isCurrent ~= b.isCurrent then return a.isCurrent end
    return a.data.name < b.data.name
  end)

  if #chars == 0 then
    emptyText:SetText(L["ALT_TRACKER_EMPTY"])
    emptyText:Show()
    scrollChild:SetHeight(80)
    return
  end

  local y        = -6
  local nameIdx  = 1
  local profIdx  = 1
  local blockIdx = 1

  for _, entry in ipairs(chars) do
    local blockStartY = y
    -- Class icon
    local ci = GetClassIcon(nameIdx)
    ci:SetTexture(ClassIconPath(entry.data.class))
    ci:ClearAllPoints()
    ci:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 6, y)
    ci:Show()

    -- Character name header
    local label = GetNameLabel(nameIdx)
    nameIdx = nameIdx + 1
    local displayName = entry.data.name
    if entry.isCurrent then
      displayName = displayName .. " |cffaaaaaa(" .. L["ALT_TRACKER_YOU"] .. ")|r"
    end
    label:SetText(displayName)
    label:SetTextColor(1, 0.82, 0, 1)
    label:ClearAllPoints()
    label:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 30, y - 3)
    label:Show()
    y = y - 26

    -- Profession rows
    for _, prof in ipairs(entry.data.professions) do
      local icon = GetProfIcon(profIdx)
      icon:SetTexture(prof.icon)
      icon:ClearAllPoints()
      icon:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, y + 1)
      icon:Show()

      local pl = GetProfLabel(profIdx)
      pl:SetText(string.format(
        "%s |cff4dff6e%d|r|cff555555/%d|r",
        prof.name, prof.rank, prof.maxRank
      ))
      pl:ClearAllPoints()
      pl:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 34, y)
      pl:Show()

      profIdx = profIdx + 1
      y = y - 18
    end

    -- Block frame (mouse zone for hover-reveal delete)
    local bf = GetBlockFrame(blockIdx)
    blockIdx = blockIdx + 1
    bf:ClearAllPoints()
    bf:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, blockStartY)
    bf:SetSize(AT_W - 34, math.abs(y - blockStartY))
    bf._canDelete = not entry.isCurrent
    bf._altKey    = entry.key
    bf._altName   = entry.data.name
    bf:Show()

    y = y - 10
  end

  scrollChild:SetHeight(math.abs(y) + 8)
end

-- ── Public API ───────────────────────────────────────────────────────────────

function AltTracker:SetFilter(value)
  activeFilter = value
  NS.CraftSage.db.global.settings.alt_filter = value
  UpdateFilterButtons()
  self:Render()
end

function AltTracker:ApplyTheme(name)
  local t = NS.THEMES[name] or NS.THEMES["default"]
  frame:SetBackdrop({
    bgFile   = t.bgFile,
    edgeFile = t.edgeFile,
    tile     = true,
    tileSize = t.tileSize,
    edgeSize = t.edgeSize,
    insets   = t.insets,
  })
  frame:SetBackdropColor(t.slBg[1], t.slBg[2], t.slBg[3], 0.97)
  frame:SetBackdropBorderColor(unpack(t.slBorder))
  titleText:SetText(L["ALT_TRACKER_TITLE"])
  titleText:SetTextColor(unpack(t.slTitle))
end

function AltTracker:Toggle()
  if frame:IsShown() then
    frame:Hide()
  else
    self:ApplyTheme(NS.CraftSage.db.global.settings.theme)
    activeFilter = NS.CraftSage.db.global.settings.alt_filter or "all"
    UpdateFilterButtons()
    self:Render()
    frame:Show()
  end
end
