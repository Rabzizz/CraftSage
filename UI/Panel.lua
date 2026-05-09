local AddonName, NS = ...
local L = LibStub("AceLocale-3.0"):GetLocale("CraftSage")

StaticPopupDialogs["CRAFTSAGE_WOWHEAD_LINK"] = {
  text         = L["WOWHEAD_POPUP_TITLE"],
  button1      = CLOSE,
  hasEditBox   = 1,
  editBoxWidth = 260,
  OnShow = function(self, data)
    self.editBox:SetText(self.data or data or "")
    self.editBox:SetFocus()
    self.editBox:HighlightText()
  end,
  timeout      = 0,
  whileDead    = true,
  hideOnEscape = true,
}

local Panel = {}
NS.Panel = Panel

local PANEL_W = 185
local PANEL_H = 355

local frame, titleText, profText, hcText
local skillBarBg, skillBarFill, skillText
local stepsLabel, stepRows, divider
local trainerCallout, trainerLine1, trainerLine2, trainerLine3
local matsLabel, noteText, matRows, msgText
local shopBtn, resetBtn
local highlightedIndex
local _guideBtn

local function ShowAllMats(show)
  for i = 1, 6 do
    matRows[i]:SetShown(show)
  end
end

local function HideUnusedMatRows(count)
  for i = count + 1, 6 do
    matRows[i]:Hide()
  end
end

-- ── Deferred init (called at PLAYER_LOGIN so errors are visible in chat) ──────

local _initOk, _initErr

local function _initialize()
  frame = CreateFrame("Frame", "CraftSagePanelFrame", UIParent, "BackdropTemplate")
  frame:SetSize(PANEL_W, PANEL_H)
  frame:Hide()
  frame:SetFrameStrata("HIGH")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)
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

  -- stepRows[1]: active step — Frame with mouse interaction
  local activeStepRow = CreateFrame("Frame", nil, frame)
  activeStepRow:SetPoint("TOPLEFT",  frame, "TOPLEFT",  10, -95)
  activeStepRow:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -95)
  activeStepRow:SetHeight(16)
  activeStepRow:EnableMouse(true)
  activeStepRow.text = activeStepRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  activeStepRow.text:SetPoint("LEFT", activeStepRow, "LEFT", 0, 0)
  activeStepRow.text:SetWidth(PANEL_W - 20)
  activeStepRow.text:SetJustifyH("LEFT")
  activeStepRow:SetScript("OnEnter", function(self)
    if not self._recipeIndex then return end
    local link = GetTradeSkillRecipeLink(self._recipeIndex)
    if not link then return end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetHyperlink(link)
    GameTooltip:Show()
  end)
  activeStepRow:SetScript("OnLeave", function() GameTooltip:Hide() end)
  activeStepRow:SetScript("OnMouseDown", function(self, button)
    if button ~= "LeftButton" or not IsControlKeyDown() then return end
    if not self._recipeIndex then return end
    local link    = GetTradeSkillRecipeLink(self._recipeIndex)
    local spellId = link and link:match("|Hspell:(%d+)|h")
    if spellId then
      StaticPopup_Show("CRAFTSAGE_WOWHEAD_LINK", nil, nil,
        "https://www.wowhead.com/classic/spell=" .. spellId)
    end
  end)
  stepRows[1] = activeStepRow

  -- stepRows[2] and [3]: dimmed upcoming steps — plain FontStrings
  for i = 2, 3 do
    local r = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -95 - (i - 1) * 16)
    r:SetWidth(PANEL_W - 20)
    r:SetJustifyH("LEFT")
    stepRows[i] = r
  end

  trainerCallout = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  trainerCallout:SetPoint("TOPLEFT",  frame, "TOPLEFT",  8, -93)
  trainerCallout:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -93)
  trainerCallout:SetHeight(46)
  trainerCallout:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "", tile = false, tileSize = 0, edgeSize = 0,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })
  trainerCallout:SetBackdropColor(0.1, 0.07, 0, 0.85)
  trainerCallout:Hide()

  local trainerBorder = trainerCallout:CreateTexture(nil, "ARTWORK")
  trainerBorder:SetPoint("TOPLEFT",    trainerCallout, "TOPLEFT",    0, 0)
  trainerBorder:SetPoint("BOTTOMLEFT", trainerCallout, "BOTTOMLEFT", 0, 0)
  trainerBorder:SetWidth(3)
  trainerBorder:SetColorTexture(1, 0.67, 0, 1)

  trainerLine1 = trainerCallout:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  trainerLine1:SetPoint("TOPLEFT",  trainerCallout, "TOPLEFT",  8, -4)
  trainerLine1:SetPoint("TOPRIGHT", trainerCallout, "TOPRIGHT", -4, -4)
  trainerLine1:SetJustifyH("LEFT")
  trainerLine1:SetTextColor(1, 0.67, 0, 1)

  trainerLine2 = trainerCallout:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  trainerLine2:SetPoint("TOPLEFT",  trainerLine1, "BOTTOMLEFT",  0, -2)
  trainerLine2:SetPoint("TOPRIGHT", trainerLine1, "BOTTOMRIGHT", 0, -2)
  trainerLine2:SetJustifyH("LEFT")
  trainerLine2:SetTextColor(0.8, 0.53, 0, 1)

  trainerLine3 = trainerCallout:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  trainerLine3:SetPoint("TOPLEFT",  trainerLine2, "BOTTOMLEFT",  0, -2)
  trainerLine3:SetPoint("TOPRIGHT", trainerLine2, "BOTTOMRIGHT", 0, -2)
  trainerLine3:SetJustifyH("LEFT")
  trainerLine3:SetTextColor(0.6, 0.4, 0, 1)

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
    local r = CreateFrame("Frame", nil, frame)
    r:SetPoint("TOPLEFT",  frame, "TOPLEFT",  10, yOff)
    r:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, yOff)
    r:SetHeight(14)
    r:EnableMouse(true)

    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.name:SetPoint("LEFT", r, "LEFT", 0, 0)
    r.name:SetWidth(110)
    r.name:SetJustifyH("LEFT")

    r.buyTag = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.buyTag:SetPoint("LEFT", r.name, "RIGHT", 2, 0)
    r.buyTag:SetTextColor(1, 0.8, 0.2, 1)
    r.buyTag:Hide()

    r.count = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.count:SetPoint("RIGHT", r, "RIGHT", 0, 0)
    r.count:SetJustifyH("RIGHT")

    r:SetScript("OnEnter", function(self)
      if not self._itemId then return end
      local _, link = GetItemInfo(self._itemId)
      if not link then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetHyperlink(link)
      GameTooltip:Show()
    end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r:SetScript("OnMouseDown", function(self, button)
      if button == "LeftButton" and IsControlKeyDown() and self._itemId then
        StaticPopup_Show("CRAFTSAGE_WOWHEAD_LINK", nil, nil,
          "https://www.wowhead.com/classic/item=" .. self._itemId)
      end
    end)

    matRows[i] = r
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

  table.insert(UISpecialFrames, "CraftSagePanelFrame")

  frame:SetScript("OnShow", function() Panel:UpdateGuideBtnLabel() end)
  frame:SetScript("OnHide", function() Panel:UpdateGuideBtnLabel() end)

  highlightedIndex = nil

  -- ── API ───────────────────────────────────────────────────────────────────

  function Panel:Refresh(profName, skillLevel, maxSkillLevel, data, activeStepIndex, stepChanged)
    if not frame then return end
    if not frame:IsShown() then
      frame:ClearAllPoints()
      if TradeSkillFrame and TradeSkillFrame:IsShown() then
        frame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, 0)
      else
        frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
      end
      frame:Show()
    end

    profText:SetText(profName or "")
    if data and data.hc_recommended then hcText:Show() else hcText:Hide() end

    if not profName then
      msgText:SetText(L["NO_PROFESSION_OPEN"])
      msgText:Show()
      stepsLabel:Hide(); divider:Hide(); matsLabel:Hide(); noteText:Hide()
      ShowAllMats(false)
      skillBarFill:SetWidth(1)
      skillText:SetText("")
      stepRows[1].text:SetText(""); stepRows[2]:SetText(""); stepRows[3]:SetText("")
      return
    end

    if not data then
      msgText:SetText(L["NO_GUIDE"])
      msgText:Show()
      stepsLabel:Hide(); divider:Hide(); matsLabel:Hide(); noteText:Hide()
      ShowAllMats(false)
      skillBarFill:SetWidth(1)
      skillText:SetText("")
      stepRows[1].text:SetText(""); stepRows[2]:SetText(""); stepRows[3]:SetText("")
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
      stepRows[1].text:SetText(""); stepRows[2]:SetText(""); stepRows[3]:SetText("")
      matsLabel:Hide(); noteText:Hide()
      ShowAllMats(false)
      return
    end

    local step = data.steps[activeStepIndex]

    if step.step_type == "trainer" then
      trainerCallout:Show()
      stepRows[1]:Hide()
      trainerLine1:SetText(string.format(L["TRAINER_STEP_PREFIX"], step.skill_up_to))
      trainerLine2:SetText(step.recipe)
      if step.trainer_note then
        local faction = UnitFactionGroup("player")
        local tbl  = step.trainer_note
        local note = (faction == "Alliance" and tbl.alliance) or tbl.horde or tbl.alliance
        trainerLine3:SetText(note or "")
        trainerLine3:SetShown(note ~= nil)
      else
        trainerLine3:Hide()
      end
      for i = 2, 3 do
        local idx = activeStepIndex + (i - 1)
        local s   = data.steps[idx]
        if s then
          if s.step_type == "trainer" then
            stepRows[i]:SetText(string.format("|cff555555%d. [Trainer] %s|r", idx, s.recipe))
          else
            stepRows[i]:SetText(string.format("|cff555555%d. %s (to %d)|r", idx, s.recipe, s.skill_up_to))
          end
        else
          stepRows[i]:SetText("")
        end
      end
      matsLabel:Hide()
      noteText:Hide()
      ShowAllMats(false)
      return
    end

    trainerCallout:Hide()
    stepRows[1]:Show()

    for i = 1, 3 do
      local idx  = activeStepIndex + (i - 1)
      local s    = data.steps[idx]
      if s then
        if i == 1 then
          stepRows[1].text:SetText(string.format("|cff88ff88> %s (to %d)|r", s.recipe, s.skill_up_to))
        else
          if s.step_type == "trainer" then
            stepRows[i]:SetText(string.format("|cff555555%d. [Trainer] %s|r", idx, s.recipe))
          else
            stepRows[i]:SetText(string.format("|cff555555%d. %s (to %d)|r", idx, s.recipe, s.skill_up_to))
          end
        end
      else
        if i == 1 then
          stepRows[1].text:SetText("")
        else
          stepRows[i]:SetText("")
        end
      end
    end
    local stepStart = activeStepIndex > 1 and data.steps[activeStepIndex - 1].skill_up_to or 1
    local remaining = math.max(1, math.ceil(
      step.qty * (step.skill_up_to - skillLevel) / (step.skill_up_to - stepStart)
    ))

    if step.note then noteText:SetText(step.note); noteText:Show()
    else noteText:Hide() end

    for i, mat in ipairs(step.mats) do
      if i > 6 then break end
      local r    = matRows[i]
      local have = GetItemCount(mat.item) or 0
      local need = mat.count * remaining
      local name = GetItemInfo(mat.item) or ("Item:" .. mat.item)
      r._itemId = mat.item
      r:Show()
      if mat.source == "vendor" then
        r.name:SetText(name)
        r.name:SetTextColor(1, 0.8, 0.2, 1)
        r.buyTag:SetText(L["MAT_SOURCE_VENDOR"])
        r.buyTag:Show()
      else
        r.name:SetText(name)
        r.name:SetTextColor(0.85, 0.85, 0.85, 1)
        r.buyTag:Hide()
      end
      if have >= need then
        r.count:SetText(string.format("%d / %d", have, need))
        r.count:SetTextColor(0.3, 1, 0.3, 1)
      else
        r.count:SetText(string.format("|cffffff44%d|r / %d", have, need))
        r.count:SetTextColor(1, 0.3, 0.3, 1)
      end
    end
    HideUnusedMatRows(#step.mats)
  end

  function Panel:Hide()  frame:Hide() end
  function Panel:IsVisible() return frame:IsShown() end
  function Panel:SetHighlightedRecipeIndex(idx)
    highlightedIndex = idx
    if stepRows and stepRows[1] then
      stepRows[1]._recipeIndex = idx
    end
  end
end

function Panel:Toggle()
  if not frame then return end
  if frame:IsShown() then
    frame:Hide()
  else
    local cs = NS.CraftSage
    Panel:Refresh(cs.currentProf, cs.currentSkill, cs.currentMaxSkill,
      cs.currentData, cs.activeStepIndex)
  end
end

function Panel:UpdateGuideBtnLabel()
  if not _guideBtn then return end
  _guideBtn:SetText(frame and frame:IsShown() and "< Guide" or "Guide >")
end

local _guideBtnReady = false
function Panel:EnsureGuideBtn()
  if _guideBtnReady then return end
  _guideBtnReady = true

  -- Close panel whenever the profession window hides (more reliable than TRADE_SKILL_HIDE event)
  TradeSkillFrame:HookScript("OnHide", function()
    NS.CraftSage.currentProf = nil
    if frame then frame:Hide() end
  end)

  local btn = CreateFrame("Button", nil, TradeSkillFrame, "UIPanelButtonTemplate")
  btn:SetSize(72, 18)
  -- Anchor left of the frame's X close button; fall back to TOPRIGHT offset
  local closeBtn = _G["TradeSkillFrameCloseButton"]
  if closeBtn then
    btn:SetPoint("RIGHT", closeBtn, "LEFT", -4, 0)
  else
    btn:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -25, -3)
  end
  btn:SetScript("OnClick", function() Panel:Toggle() end)
  _guideBtn = btn
  Panel:UpdateGuideBtnLabel()
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
