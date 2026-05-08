local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

local Panel = {}
NS.Panel = Panel

local PANEL_W = 185
local PANEL_H = 355

local frame, titleText, profText, hcText
local skillBarBg, skillBarFill, skillText
local stepsLabel, stepRows, divider
local matsLabel, noteText, matRows, msgText
local shopBtn, resetBtn, toggleBtn
local highlightedIndex

local function ShowAllMats(show)
  for i = 1, 6 do
    matRows[i].name:SetShown(show)
    matRows[i].count:SetShown(show)
  end
end

local function HideUnusedMatRows(count)
  for i = count + 1, 6 do
    matRows[i].name:Hide()
    matRows[i].count:Hide()
  end
end

-- ── Deferred init (called at PLAYER_LOGIN so errors are visible in chat) ──────

local _initOk, _initErr

local function _initialize()
  frame = CreateFrame("Frame", "CraftSagePanelFrame", UIParent, "BackdropTemplate")
  frame:SetSize(PANEL_W, PANEL_H)
  frame:Hide()
  frame:SetFrameStrata("HIGH")
  frame:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  frame:SetBackdropColor(0.05, 0.1, 0.05, 0.97)
  frame:SetBackdropBorderColor(0.2, 0.6, 0.2, 1)

  -- Title
  local titleBg = frame:CreateTexture(nil, "BACKGROUND")
  titleBg:SetPoint("TOPLEFT",  frame, "TOPLEFT",  5, -5)
  titleBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
  titleBg:SetHeight(20)
  titleBg:SetColorTexture(0.1, 0.3, 0.1, 0.8)

  titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  titleText:SetPoint("TOP", frame, "TOP", 0, -11)
  titleText:SetText(L["PANEL_TITLE"])
  titleText:SetTextColor(0.5, 1, 0.5, 1)

  profText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  profText:SetPoint("TOP", frame, "TOP", 0, -31)
  profText:SetTextColor(1, 0.82, 0, 1)

  hcText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  hcText:SetPoint("TOP", profText, "BOTTOM", 0, -2)
  hcText:SetTextColor(1, 0.5, 0.1, 1)
  hcText:SetText(L["HC_BADGE"])
  hcText:Hide()

  skillBarBg = frame:CreateTexture(nil, "BACKGROUND")
  skillBarBg:SetPoint("TOPLEFT",  frame, "TOPLEFT",  10, -58)
  skillBarBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -58)
  skillBarBg:SetHeight(8)
  skillBarBg:SetColorTexture(0, 0, 0, 0.7)

  skillBarFill = frame:CreateTexture(nil, "ARTWORK")
  skillBarFill:SetPoint("TOPLEFT", skillBarBg, "TOPLEFT", 1, -1)
  skillBarFill:SetHeight(6)
  skillBarFill:SetColorTexture(0.2, 0.8, 0.2, 1)
  skillBarFill:SetWidth(1)

  skillText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  skillText:SetPoint("TOP", skillBarBg, "BOTTOM", 0, -3)
  skillText:SetTextColor(0.8, 0.8, 0.8, 1)

  stepsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  stepsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -82)
  stepsLabel:SetTextColor(0.5, 0.5, 0.5, 1)
  stepsLabel:SetText(L["GUIDE_STEPS"])

  stepRows = {}
  for i = 1, 3 do
    local r = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -95 - (i - 1) * 16)
    r:SetWidth(PANEL_W - 20)
    r:SetJustifyH("LEFT")
    stepRows[i] = r
  end

  divider = frame:CreateTexture(nil, "ARTWORK")
  divider:SetPoint("TOPLEFT",  frame, "TOPLEFT",  5, -148)
  divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -148)
  divider:SetHeight(1)
  divider:SetColorTexture(0.2, 0.5, 0.2, 0.5)

  matsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  matsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -154)
  matsLabel:SetTextColor(0.5, 0.5, 0.5, 1)
  matsLabel:SetText(L["STEP_MATS"])

  noteText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  noteText:SetPoint("TOPLEFT",  frame, "TOPLEFT",  10, -167)
  noteText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -167)
  noteText:SetJustifyH("LEFT")
  noteText:SetTextColor(0.6, 0.6, 0.4, 1)
  noteText:Hide()

  matRows = {}
  for i = 1, 6 do
    local yOff = -170 - (i - 1) * 14
    local nm = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    nm:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOff)
    nm:SetWidth(120)
    nm:SetJustifyH("LEFT")
    nm:SetTextColor(0.85, 0.85, 0.85, 1)

    local ct = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ct:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, yOff)
    ct:SetJustifyH("RIGHT")

    matRows[i] = { name = nm, count = ct }
  end

  msgText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  msgText:SetPoint("CENTER", frame, "CENTER", 0, 20)
  msgText:SetTextColor(1, 0.82, 0, 1)
  msgText:Hide()

  shopBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  shopBtn:SetSize(110, 20)
  shopBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
  shopBtn:SetText(L["SHOPPING_LIST_BTN"])
  shopBtn:SetScript("OnClick", function() NS.ShoppingList:Toggle() end)

  resetBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  resetBtn:SetSize(55, 20)
  resetBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
  resetBtn:SetText(L["RESET_BTN"])
  resetBtn:SetScript("OnClick", function() NS.CraftSage:SlashCommand("reset") end)

  local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  closeBtn:SetSize(18, 18)
  closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
  closeBtn:SetScript("OnClick", function() frame:Hide() end)

  toggleBtn = CreateFrame("Button", nil, TradeSkillFrame, "UIPanelButtonTemplate")
  toggleBtn:SetSize(72, 16)
  toggleBtn:SetText(L["PANEL_TITLE"])
  toggleBtn:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -42, -6)
  toggleBtn:SetScript("OnClick", function()
    if frame:IsShown() then
      frame:Hide()
    else
      frame:ClearAllPoints()
      frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
      frame:Show()
    end
  end)

  table.insert(UISpecialFrames, "CraftSagePanelFrame")

  highlightedIndex = nil

  -- ── API ───────────────────────────────────────────────────────────────────

  function Panel:Refresh(profName, skillLevel, maxSkillLevel, data, activeStepIndex, stepChanged)
    if not frame then return end
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
    frame:Show()

    profText:SetText(profName or "")
    if data and data.hc_recommended then hcText:Show() else hcText:Hide() end

    if not data then
      msgText:SetText(L["NO_GUIDE"])
      msgText:Show()
      stepsLabel:Hide(); divider:Hide(); matsLabel:Hide(); noteText:Hide()
      ShowAllMats(false)
      skillBarFill:SetWidth(1)
      skillText:SetText("")
      for i = 1, 3 do stepRows[i]:SetText("") end
      return
    end

    msgText:Hide()
    stepsLabel:Show(); divider:Show(); matsLabel:Show()

    local max = maxSkillLevel or 300
    local pct = math.max(0, math.min(1, skillLevel / max))
    skillBarFill:SetWidth(math.max(1, (PANEL_W - 22) * pct))
    skillText:SetText(string.format(L["SKILL_FMT"], skillLevel, max))

    if not activeStepIndex then
      msgText:SetText(L["MAXED"])
      msgText:Show()
      for i = 1, 3 do stepRows[i]:SetText("") end
      matsLabel:Hide(); noteText:Hide()
      ShowAllMats(false)
      return
    end

    for i = 1, 3 do
      local idx  = activeStepIndex + (i - 1)
      local step = data.steps[idx]
      if step then
        if i == 1 then
          stepRows[i]:SetText(string.format("|cff88ff88> %s (to %d)|r", step.recipe, step.skill_up_to))
        else
          stepRows[i]:SetText(string.format("|cff555555%d. %s (to %d)|r", idx, step.recipe, step.skill_up_to))
        end
      else
        stepRows[i]:SetText("")
      end
    end

    local step      = data.steps[activeStepIndex]
    local stepStart = activeStepIndex > 1 and data.steps[activeStepIndex - 1].skill_up_to or 1
    local remaining = math.max(1, math.ceil(
      step.qty * (step.skill_up_to - skillLevel) / (step.skill_up_to - stepStart)
    ))

    if step.note then noteText:SetText(step.note); noteText:Show()
    else noteText:Hide() end

    for i, mat in ipairs(step.mats) do
      if i > 6 then break end
      local have = GetItemCount(mat.item) or 0
      local need = mat.count * remaining
      local name = GetItemInfo(mat.item) or ("Item:" .. mat.item)
      matRows[i].name:SetText(name)
      matRows[i].name:Show()
      if have >= need then
        matRows[i].count:SetText(string.format("%d / %d", have, need))
        matRows[i].count:SetTextColor(0.3, 1, 0.3, 1)
      else
        matRows[i].count:SetText(string.format("|cffffff44%d|r / %d", have, need))
        matRows[i].count:SetTextColor(1, 0.3, 0.3, 1)
      end
      matRows[i].count:Show()
    end
    HideUnusedMatRows(#step.mats)
  end

  function Panel:Hide()  frame:Hide() end
  function Panel:IsVisible() return frame:IsShown() end
  function Panel:SetHighlightedRecipeIndex(idx) highlightedIndex = idx end
end

_initOk, _initErr = pcall(_initialize)
if not _initOk then
  local _watcher = CreateFrame("Frame")
  _watcher:RegisterEvent("PLAYER_LOGIN")
  _watcher:SetScript("OnEvent", function()
    DEFAULT_CHAT_FRAME:AddMessage("|cffff4444[CraftSage Panel] INIT FAILED: " .. tostring(_initErr) .. "|r")
    _watcher:UnregisterAllEvents()
  end)
end
