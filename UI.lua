-- MageQuotes_UI.lua
-- MODERN REDESIGNED UI - Midnight 12.0.0 Compatible
-- v1.6.0 - Fixed: Add Quote, Import/Export visibility, Tab order, Triggers UI

local ADDON_VERSION = "1.9.0"

------------------------------------------------------------
-- Safe initialization
------------------------------------------------------------
local function SafeGetUIStrings()
  if MageQuotes_GetUIStrings then
    local ui, locale, locales = MageQuotes_GetUIStrings()
    return ui or {}, locale or "enUS", locales or {"enUS", "ruRU", "deDE", "itIT"}
  end
  return {}, "enUS", {"enUS", "ruRU", "deDE", "itIT"}
end

local uiStrings, activeLocale, supportedLocales = SafeGetUIStrings()

-- Translation helper
local function L(key)
  return MageQuotes_GetUIString and MageQuotes_GetUIString(key) or key
end
------------------------------------------------------------
-- Color Palette
------------------------------------------------------------
local COLORS = {
  primary = {0.4, 0.6, 1.0},
  accent = {1.0, 0.7, 0.2},
  success = {0.3, 1.0, 0.3},
  warning = {1.0, 0.7, 0.0},
  error = {1.0, 0.3, 0.3},
  
  bg_dark = {0.08, 0.08, 0.12, 0.95},
  bg_medium = {0.12, 0.12, 0.16, 0.85},
  bg_light = {0.18, 0.18, 0.22, 0.75},
  border = {0.4, 0.4, 0.5, 1.0},
  text = {0.95, 0.95, 0.98},
  text_dim = {0.7, 0.7, 0.75},
  
  arcane = {0.65, 0.80, 1.00},
  fire = {1.00, 0.45, 0.25},
  frost = {0.55, 0.90, 1.00},
}

-- Category colors for visual coding
local CAT_COLORS = {
  init = {0.4, 0.6, 1.0},
  kill = {1.0, 0.3, 0.3},
  surv = {0.3, 1.0, 0.5},
  vict = {1.0, 0.8, 0.2},
  rare = {0.8, 0.5, 1.0},
  mid = {1.0, 0.6, 0.4},
  greet = {0.5, 0.8, 1.0},
}

------------------------------------------------------------
-- Utility Functions
------------------------------------------------------------
local function SafeCall(func, ...)
  local success, result = pcall(func, ...)
  if not success then
    print("|cffff0000MageQuotes UI Error:|r " .. tostring(result))
  end
  return success, result
end

local function GetOrInitCategoryCfg(header)
  if _G.MageQuotesCore and _G.MageQuotesCore.GetOrInitCategoryCfg then
    return _G.MageQuotesCore:GetOrInitCategoryCfg(header)
  end
  MageQuotesDB.categories = MageQuotesDB.categories or {}
  local t = MageQuotesDB.categories[header]
  if not t then
    t = { enabled = true, cooldown = MageQuotesDB.quoteCooldown or 10, chance = 100 }
    MageQuotesDB.categories[header] = t
  end
  return t
end

local function RebuildCore()
  if _G.MageQuotesCore and _G.MageQuotesCore.Rebuild then
    SafeCall(_G.MageQuotesCore.Rebuild, _G.MageQuotesCore)
  else
    if MageQuotes_EventBus and MageQuotes_EventBus.TriggerEvent then
      MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_SETTINGS_CHANGED")
    end
  end
end

local function clampInt(s, lo, hi)
  local v = tonumber((s or ""):match("[-%d%.]+") or 0) or 0
  v = math.floor(v)
  if v < lo then v = lo end
  if v > hi then v = hi end
  return v
end

local function ColorText(text, color)
  if not text then text = "" end
  if not color then color = COLORS.text end
  return string.format("|cff%02x%02x%02x%s|r", 
    math.floor(color[1] * 255), 
    math.floor(color[2] * 255), 
    math.floor(color[3] * 255), 
    tostring(text))
end

------------------------------------------------------------
-- Custom UI Elements
------------------------------------------------------------
local function CreateModernButton(parent, text, width, height)
  local btn = CreateFrame("Button", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
  btn:SetSize(width or 120, height or 32)
  
  btn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
  })
  btn:SetBackdropColor(unpack(COLORS.bg_medium))
  btn:SetBackdropBorderColor(unpack(COLORS.border))
  
  local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetPoint("CENTER")
  label:SetText(text or "Button")
  btn.label = label
  
  btn:SetScript("OnEnter", function(self)
    self:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.3)
    self:SetBackdropBorderColor(unpack(COLORS.primary))
  end)
  
  btn:SetScript("OnLeave", function(self)
    self:SetBackdropColor(unpack(COLORS.bg_medium))
    self:SetBackdropBorderColor(unpack(COLORS.border))
  end)
  
  btn:SetScript("OnMouseDown", function(self)
    self:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
  end)
  
  btn:SetScript("OnMouseUp", function(self)
    self:SetBackdropColor(unpack(COLORS.bg_medium))
  end)
  
  return btn
end

local function CreateToggleSwitch(parent)
  local switch = CreateFrame("Button", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
  switch:SetSize(50, 24)
  
  switch:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
  })
  
  local knob = switch:CreateTexture(nil, "OVERLAY")
  knob:SetSize(20, 20)
  knob:SetTexture("Interface\\Buttons\\WHITE8x8")
  knob:SetVertexColor(1, 1, 1)
  
  switch.knob = knob
  switch.state = false
  
  local function UpdateSwitch()
    if switch.state then
      switch:SetBackdropColor(COLORS.success[1], COLORS.success[2], COLORS.success[3], 0.5)
      switch:SetBackdropBorderColor(unpack(COLORS.success))
      knob:SetPoint("RIGHT", switch, "RIGHT", -2, 0)
      knob:SetVertexColor(unpack(COLORS.success))
    else
      switch:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
      switch:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
      knob:SetPoint("LEFT", switch, "LEFT", 2, 0)
      knob:SetVertexColor(0.7, 0.7, 0.7)
    end
  end
  
  switch:SetScript("OnClick", function(self)
    self.state = not self.state
    UpdateSwitch()
    if self.OnValueChanged then
      self:OnValueChanged(self.state)
    end
  end)
  
  function switch:SetChecked(value)
    self.state = value
    UpdateSwitch()
  end
  
  function switch:GetChecked()
    return self.state
  end
  
  UpdateSwitch()
  return switch
end

local function CreateSectionHeader(parent, text)
  local header = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  header:SetText(text or "")
  header:SetTextColor(unpack(COLORS.primary))
  
  local line = parent:CreateTexture(nil, "ARTWORK")
  line:SetColorTexture(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.3)
  line:SetHeight(2)
  line:SetPoint("LEFT", header, "BOTTOMLEFT", 0, -4)
  line:SetPoint("RIGHT", parent, "RIGHT", -20, 0)
  
  header.line = line
  return header
end

------------------------------------------------------------
-- Main Frame
------------------------------------------------------------
local Frame = CreateFrame("Frame", "MageQuotesFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
Frame:SetSize(1050, 680)  -- Size for 8 tabs
Frame:SetPoint("CENTER")
Frame:SetClampedToScreen(true)
Frame:Hide()
Frame:EnableMouse(true)
Frame:SetMovable(true)
Frame:SetFrameStrata("HIGH")
Frame:SetFrameLevel(100)

Frame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 32, edgeSize = 16,
  insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
Frame:SetBackdropColor(unpack(COLORS.bg_dark))
Frame:SetBackdropBorderColor(unpack(COLORS.border))

------------------------------------------------------------
-- Title Bar
------------------------------------------------------------
local TitleBar = CreateFrame("Frame", nil, Frame, BackdropTemplateMixin and "BackdropTemplate")
TitleBar:SetSize(Frame:GetWidth() - 10, 50)
TitleBar:SetPoint("TOP", Frame, "TOP", 0, -5)
TitleBar:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
  insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
TitleBar:SetBackdropColor(unpack(COLORS.bg_light))
TitleBar:SetBackdropBorderColor(unpack(COLORS.border))

TitleBar:EnableMouse(true)
TitleBar:RegisterForDrag("LeftButton")
TitleBar:SetScript("OnDragStart", function() Frame:StartMoving() end)
TitleBar:SetScript("OnDragStop", function() Frame:StopMovingOrSizing() end)

local titleIcon = TitleBar:CreateTexture(nil, "ARTWORK")
titleIcon:SetSize(36, 36)
titleIcon:SetPoint("LEFT", TitleBar, "LEFT", 10, 0)
titleIcon:SetTexture(MageQuotesIcons and MageQuotesIcons.main or "Interface\\Icons\\Spell_Frost_IceStorm")

local titleText = TitleBar:CreateFontString(nil, "OVERLAY", "SystemFont_Huge1")
titleText:SetPoint("LEFT", titleIcon, "RIGHT", 10, 0)
titleText:SetText(ColorText(L("title"), COLORS.text))

local versionText = TitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
versionText:SetPoint("LEFT", titleText, "RIGHT", 8, -2)
versionText:SetText(ColorText("v" .. ADDON_VERSION, COLORS.text_dim))

local statusBadge = TitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
statusBadge:SetPoint("RIGHT", TitleBar, "RIGHT", -100, 0)

local function UpdateStatusBadge()
  if MageQuotesDB and MageQuotesDB.enabled then
    statusBadge:SetText(ColorText("[" .. L("active") .. "]", COLORS.success))
  else
    statusBadge:SetText(ColorText("[" .. L("inactive") .. "]", COLORS.text_dim))
  end
end
UpdateStatusBadge()

-- Custom close button (UIPanelCloseButton can cause issues with hiding)
local closeBtn = CreateFrame("Button", nil, TitleBar, BackdropTemplateMixin and "BackdropTemplate")
closeBtn:SetPoint("RIGHT", TitleBar, "RIGHT", -8, 0)
closeBtn:SetSize(28, 28)
closeBtn:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
closeBtn:SetBackdropColor(0.3, 0.1, 0.1, 0.8)
closeBtn:SetBackdropBorderColor(0.8, 0.2, 0.2, 1)

local closeBtnText = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
closeBtnText:SetPoint("CENTER", 0, 1)
closeBtnText:SetText("X")
closeBtnText:SetTextColor(1, 0.3, 0.3, 1)

closeBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.6, 0.1, 0.1, 1)
  self:SetBackdropBorderColor(1, 0.3, 0.3, 1)
  closeBtnText:SetTextColor(1, 1, 1, 1)
end)

closeBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.3, 0.1, 0.1, 0.8)
  self:SetBackdropBorderColor(0.8, 0.2, 0.2, 1)
  closeBtnText:SetTextColor(1, 0.3, 0.3, 1)
end)

closeBtn:SetScript("OnClick", function()
  Frame:Hide()
end)

------------------------------------------------------------
-- Tab System
------------------------------------------------------------
local TabContainer = CreateFrame("Frame", nil, Frame)
TabContainer:SetSize(Frame:GetWidth() - 20, 40)
TabContainer:SetPoint("TOP", TitleBar, "BOTTOM", 0, -10)

local tabs = {}
local tabContents = {}
local activeTab = nil

local function CreateTab(text)
  local tab = CreateFrame("Button", nil, TabContainer, BackdropTemplateMixin and "BackdropTemplate")
  tab:SetSize(118, 35)  -- Slightly wider tabs for 8 tabs in larger frame
  
  tab:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
  })
  
  local label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetPoint("CENTER")
  label:SetText(text or "Tab")
  tab.label = label
  
  tab.isActive = false
  
  local function UpdateTabVisual()
    if tab.isActive then
      tab:SetBackdropColor(unpack(COLORS.bg_medium))
      tab:SetBackdropBorderColor(unpack(COLORS.primary))
      label:SetTextColor(unpack(COLORS.primary))
    else
      tab:SetBackdropColor(COLORS.bg_dark[1], COLORS.bg_dark[2], COLORS.bg_dark[3], 0.5)
      tab:SetBackdropBorderColor(COLORS.border[1], COLORS.border[2], COLORS.border[3], 0.5)
      label:SetTextColor(unpack(COLORS.text_dim))
    end
  end
  
  tab:SetScript("OnEnter", function(self)
    if not self.isActive then
      self:SetBackdropColor(COLORS.bg_light[1], COLORS.bg_light[2], COLORS.bg_light[3], 0.7)
    end
  end)
  
  tab:SetScript("OnLeave", function(self)
    if not self.isActive then
      UpdateTabVisual()
    end
  end)
  
  tab:SetScript("OnClick", function(self)
    for _, t in ipairs(tabs) do
      t.isActive = false
      t:UpdateVisual()
    end
    self.isActive = true
    self:UpdateVisual()
    
    for _, content in ipairs(tabContents) do
      content:Hide()
    end
    if self.content then
      self.content:Show()
    end
    
    activeTab = self
  end)
  
  tab.UpdateVisual = UpdateTabVisual
  UpdateTabVisual()
  
  table.insert(tabs, tab)
  return tab
end

local tab1 = CreateTab(L("settings"))
tab1:SetPoint("LEFT", TabContainer, "LEFT", 10, 0)

local tab2 = CreateTab(L("quotes"))
tab2:SetPoint("LEFT", tab1, "RIGHT", 4, 0)

local tab3 = CreateTab(L("categories"))
tab3:SetPoint("LEFT", tab2, "RIGHT", 4, 0)

local tab4 = CreateTab(L("audio"))
tab4:SetPoint("LEFT", tab3, "RIGHT", 4, 0)

local tab5 = CreateTab(L("stats"))
tab5:SetPoint("LEFT", tab4, "RIGHT", 4, 0)

local tab6 = CreateTab(L("modules"))
tab6:SetPoint("LEFT", tab5, "RIGHT", 4, 0)

local tab7 = CreateTab(L("custom") or "Custom")
tab7:SetPoint("LEFT", tab6, "RIGHT", 4, 0)

local tab8 = CreateTab(L("debug"))
tab8:SetPoint("LEFT", tab7, "RIGHT", 4, 0)

------------------------------------------------------------
-- Content Area
------------------------------------------------------------
local ContentArea = CreateFrame("Frame", nil, Frame, BackdropTemplateMixin and "BackdropTemplate")
ContentArea:SetPoint("TOP", TabContainer, "BOTTOM", 0, -10)
ContentArea:SetPoint("BOTTOM", Frame, "BOTTOM", 0, 60)
ContentArea:SetPoint("LEFT", Frame, "LEFT", 15, 0)
ContentArea:SetPoint("RIGHT", Frame, "RIGHT", -15, 0)

ContentArea:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
  insets = { left = 1, right = 1, top = 1, bottom = 1 }
})
ContentArea:SetBackdropColor(unpack(COLORS.bg_medium))
ContentArea:SetBackdropBorderColor(unpack(COLORS.border))

-- Forward declarations for tabs and functions used outside their scope blocks
local SettingsTab, StatsTab, DebugTab, CustomTab
local UpdateStats, RefreshDebugLog, RefreshCustomQuoteList, refreshUI
local chooseTriggerBtn, currentQuoteTriggers, UpdateTriggerSummary
local MageQuotes_OpenQuoteEditor  -- Quote editor modal function

------------------------------------------------------------
-- TAB 1: Settings
------------------------------------------------------------
do -- Scope block to reduce local variable count
SettingsTab = CreateFrame("Frame", nil, ContentArea)
SettingsTab:SetAllPoints(ContentArea)
SettingsTab:Hide()
table.insert(tabContents, SettingsTab)
tab1.content = SettingsTab

local settingsScroll = CreateFrame("ScrollFrame", nil, SettingsTab, "UIPanelScrollFrameTemplate")
settingsScroll:SetPoint("TOPLEFT", SettingsTab, "TOPLEFT", 10, -10)
settingsScroll:SetPoint("BOTTOMRIGHT", SettingsTab, "BOTTOMRIGHT", -30, 10)

local settingsContent = CreateFrame("Frame", nil, settingsScroll)
settingsContent:SetSize(settingsScroll:GetWidth() - 10, 1200)
settingsScroll:SetScrollChild(settingsContent)

local yOffset = -20

local masterHeader = CreateSectionHeader(settingsContent, L("masterControl"))
masterHeader:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
yOffset = yOffset - 40

local masterEnableSwitch = CreateToggleSwitch(settingsContent)
masterEnableSwitch:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
masterEnableSwitch:SetChecked(MageQuotesDB and MageQuotesDB.enabled or false)
masterEnableSwitch.OnValueChanged = function(self, value)
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.enabled = value
  UpdateStatusBadge()
  print(ColorText(L(value and "addonEnabled" or "addonDisabled"), value and COLORS.success or COLORS.error))
end

local masterLabel = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
masterLabel:SetPoint("LEFT", masterEnableSwitch, "RIGHT", 10, 0)
masterLabel:SetText(L("enableAddon"))

yOffset = yOffset - 60

local cdHeader = CreateSectionHeader(settingsContent, L("cooldowns"))
cdHeader:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
yOffset = yOffset - 40

local cdLabel = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
cdLabel:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
cdLabel:SetText(L("globalCooldown"))

local cdSlider = CreateFrame("Slider", "MageQuotesUICDSlider", settingsContent, "OptionsSliderTemplate")
cdSlider:SetPoint("TOPLEFT", cdLabel, "BOTTOMLEFT", 0, -15)
cdSlider:SetSize(400, 20)
cdSlider:SetMinMaxValues(0, 60)
cdSlider:SetValue(MageQuotesDB and MageQuotesDB.quoteCooldown or 10)
cdSlider:SetValueStep(1)
cdSlider:SetObeyStepOnDrag(true)

_G["MageQuotesUICDSliderLow"]:SetText("0s")
_G["MageQuotesUICDSliderHigh"]:SetText("60s")
_G["MageQuotesUICDSliderText"]:SetText(string.format("%.0fs", cdSlider:GetValue()))

cdSlider:SetScript("OnValueChanged", function(self, value)
  _G["MageQuotesUICDSliderText"]:SetText(string.format("%.0fs", value))
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.quoteCooldown = value
  if MageQuotes_ResetRuntimeCooldowns then
    MageQuotes_ResetRuntimeCooldowns()
  end
end)

yOffset = yOffset - 80

local channelHeader = CreateSectionHeader(settingsContent, L("messageChannel"))
channelHeader:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
yOffset = yOffset - 40

-- MIDNIGHT COMPATIBILITY NOTE
-- In WoW Midnight 12.0+, SendChatMessage is a protected function
-- that addons cannot use. All quotes are displayed via Inner Whisper only.
local channelNote = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
channelNote:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
channelNote:SetPoint("RIGHT", settingsContent, "RIGHT", -20, 0)
channelNote:SetJustifyH("LEFT")
channelNote:SetText(ColorText("Inner Whisper Only", COLORS.accent) .. " " .. 
  ColorText("(WoW Midnight restriction - other channels blocked by Blizzard)", COLORS.text_dim))

yOffset = yOffset - 30

-- Force channel to INNER_WHISPER
MageQuotesDB = MageQuotesDB or {}
MageQuotesDB.channel = "INNER_WHISPER"

-- Keep the buttons array for refresh compatibility, but only show Inner Whisper
local channelButtons = {}
local channels = {"INNER_WHISPER"}

for i, channel in ipairs(channels) do
  local btn = CreateModernButton(settingsContent, "Inner Whisper (Active)", 200, 30)
  btn:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
  btn:SetBackdropColor(COLORS.success[1], COLORS.success[2], COLORS.success[3], 0.5)
  btn:SetBackdropBorderColor(unpack(COLORS.success))
  
  -- Disable click - this is the only option
  btn:SetScript("OnClick", function(self)
    print(ColorText("Mage Quotes:", COLORS.accent) .. " Inner Whisper is the only available channel in WoW Midnight.")
  end)
  
  table.insert(channelButtons, btn)
end

yOffset = yOffset - 60

local specHeader = CreateSectionHeader(settingsContent, L("specFilter"))
specHeader:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
yOffset = yOffset - 40

local specs = {
  {key="auto", text=L("specAuto")},
  {key="all", text=L("specAll")},
  {key="arcane", text=L("specArcane")},
  {key="fire", text=L("specFire")},
  {key="frost", text=L("specFrost")},
}

local specButtons = {}
for i, spec in ipairs(specs) do
  local btn = CreateModernButton(settingsContent, spec.text, 140, 30)
  if i == 1 then
    btn:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
  elseif i == 4 then
    yOffset = yOffset - 40
    btn:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
  else
    btn:SetPoint("LEFT", specButtons[i-1], "RIGHT", 8, 0)
  end
  
  btn:SetScript("OnClick", function(self)
    MageQuotesDB = MageQuotesDB or {}
    MageQuotesDB.spec = MageQuotesDB.spec or {}
    MageQuotesDB.spec.preview = spec.key
    RebuildCore()
    for _, b in ipairs(specButtons) do
      b:SetBackdropColor(unpack(COLORS.bg_medium))
    end
    self:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
  end)
  
  if MageQuotesDB and MageQuotesDB.spec and MageQuotesDB.spec.preview == spec.key then
    btn:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
  end
  
  table.insert(specButtons, btn)
end

yOffset = yOffset - 60

local localeHeader = CreateSectionHeader(settingsContent, L("language"))
localeHeader:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
yOffset = yOffset - 40

local locales = {"enUS", "ruRU", "deDE", "itIT"}
local localeButtons = {}

for i, locale in ipairs(locales) do
  local btn = CreateModernButton(settingsContent, locale, 100, 30)
  if i == 1 then
    btn:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset)
  else
    btn:SetPoint("LEFT", localeButtons[i-1], "RIGHT", 8, 0)
  end
  
  btn:SetScript("OnClick", function(self)
    if MageQuotes_SetLocale then
      MageQuotes_SetLocale(locale)
      RebuildCore()
      -- Update button highlights
      for _, b in ipairs(localeButtons) do
        b:SetBackdropColor(unpack(COLORS.bg_medium))
      end
      self:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
      -- FIXED: Notify user to reload for full translation
      print(ColorText("MageQuotes:", COLORS.accent) .. " Language changed to " .. locale .. ". Type " .. ColorText("/reload", COLORS.primary) .. " for full UI translation.")
    end
  end)
  
  -- Get current active locale dynamically
  local currentLocale = MageQuotes_GetCurrentUILocale and MageQuotes_GetCurrentUILocale() or activeLocale
  if currentLocale == locale then
    btn:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
  end
  
  table.insert(localeButtons, btn)
end

-- Add note about reload requirement
local langNote = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
langNote:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset - 40)
langNote:SetText(ColorText("Note: Full UI translation requires /reload after changing language", COLORS.text_dim))

end -- End TAB 1 scope

------------------------------------------------------------
-- TAB 2: Quotes Browser (ENHANCED - Dropdown Filter)
-- FIXED v1.5.5: searchBox is now defined BEFORE dropdown handlers
------------------------------------------------------------
do -- Scope block for TAB 2
local QuotesTab = CreateFrame("Frame", nil, ContentArea)
QuotesTab:SetAllPoints(ContentArea)
QuotesTab:Hide()
table.insert(tabContents, QuotesTab)
tab2.content = QuotesTab

-- FIXED: Create searchBox FIRST (before dropdown handlers that reference it)
local searchBox = CreateFrame("EditBox", nil, QuotesTab, "SearchBoxTemplate")
searchBox:SetSize(250, 26)
searchBox:SetAutoFocus(false)
searchBox:SetFontObject("GameFontNormal")

-- Forward declare PopulateQuotes so dropdown handlers can call it
local PopulateQuotes

-- Filter dropdown
local quotesFilterFrame = CreateFrame("Frame", nil, QuotesTab, BackdropTemplateMixin and "BackdropTemplate")
quotesFilterFrame:SetSize(150, 26)
quotesFilterFrame:SetPoint("TOPLEFT", QuotesTab, "TOPLEFT", 15, -15)
quotesFilterFrame:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
quotesFilterFrame:SetBackdropColor(unpack(COLORS.bg_medium))
quotesFilterFrame:SetBackdropBorderColor(unpack(COLORS.border))

local quotesFilterLabel = quotesFilterFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
quotesFilterLabel:SetPoint("LEFT", quotesFilterFrame, "LEFT", 8, 0)
quotesFilterLabel:SetText(L("filterAllQuotes") or "All Quotes")

local quotesFilterArrow = quotesFilterFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
quotesFilterArrow:SetPoint("RIGHT", quotesFilterFrame, "RIGHT", -8, 0)
quotesFilterArrow:SetText("v")

local currentQuotesFilter = "all" -- "all", "standard", "custom", or category key

-- FIXED: Position searchBox after filter frame
searchBox:SetPoint("LEFT", quotesFilterFrame, "RIGHT", 10, 0)

-- Dropdown menu
local quotesDropdown = CreateFrame("Frame", "MageQuotesQuotesFilterDropdown", quotesFilterFrame, BackdropTemplateMixin and "BackdropTemplate")
quotesDropdown:SetPoint("TOPLEFT", quotesFilterFrame, "BOTTOMLEFT", 0, -2)
quotesDropdown:SetSize(180, 200)
quotesDropdown:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
quotesDropdown:SetBackdropColor(0.1, 0.1, 0.15, 0.98)
quotesDropdown:SetBackdropBorderColor(unpack(COLORS.border))
quotesDropdown:SetFrameStrata("DIALOG")
quotesDropdown:Hide()

local filterOptions = {
  { key = "all", text = L("filterAllQuotes") or "All Quotes" },
  { key = "standard", text = L("filterStandard") or "Standard" },
  { key = "custom", text = L("filterCustom") or "Custom Only" },
  { key = "---", text = "─────────" },
  { key = "init", text = L("catInit") or "Combat Initiation" },
  { key = "kill", text = L("catKill") or "Killing Blow" },
  { key = "surv", text = L("catSurv") or "Survival" },
  { key = "vict", text = L("catVict") or "Victory" },
  { key = "rare", text = L("catRare") or "Rare/Random" },
  { key = "mid", text = L("catMid") or "Mid-Combat" },
  { key = "greet", text = L("catGreet") or "Greetings" },
}

local dropdownScroll = CreateFrame("ScrollFrame", nil, quotesDropdown, "UIPanelScrollFrameTemplate")
dropdownScroll:SetPoint("TOPLEFT", 5, -5)
dropdownScroll:SetPoint("BOTTOMRIGHT", -25, 5)

local dropdownContent = CreateFrame("Frame", nil, dropdownScroll)
dropdownContent:SetSize(150, #filterOptions * 22)
dropdownScroll:SetScrollChild(dropdownContent)

for i, opt in ipairs(filterOptions) do
  local btn = CreateFrame("Button", nil, dropdownContent)
  btn:SetSize(145, 20)
  btn:SetPoint("TOPLEFT", dropdownContent, "TOPLEFT", 0, -(i-1) * 22)
  
  local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  btnText:SetPoint("LEFT", btn, "LEFT", 5, 0)
  btnText:SetText(opt.text)
  
  if opt.key == "---" then
    btnText:SetTextColor(0.5, 0.5, 0.5, 1)
    btn:Disable()
  else
    btn:SetHighlightTexture("Interface\\Buttons\\WHITE8x8")
    btn:GetHighlightTexture():SetVertexColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.3)
    
    btn:SetScript("OnClick", function()
      currentQuotesFilter = opt.key
      quotesFilterLabel:SetText(opt.text)
      quotesDropdown:Hide()
      -- FIXED: Use forward-declared PopulateQuotes and searchBox is now defined above
      if PopulateQuotes then
        PopulateQuotes(searchBox:GetText())
      end
    end)
  end
end

quotesFilterFrame:SetScript("OnMouseDown", function()
  if quotesDropdown:IsShown() then
    quotesDropdown:Hide()
  else
    quotesDropdown:Show()
  end
end)

quotesDropdown:SetScript("OnShow", function()
  quotesFilterArrow:SetText("^")
end)

quotesDropdown:SetScript("OnHide", function()
  quotesFilterArrow:SetText("v")
end)

-- Hide dropdown when clicking elsewhere
quotesDropdown:SetScript("OnUpdate", function(self)
  if self:IsShown() then
    if not (quotesFilterFrame:IsMouseOver() or self:IsMouseOver()) then
      if IsMouseButtonDown("LeftButton") then
        self:Hide()
      end
    end
  end
end)

-- searchBox was moved to the top of TAB 2 scope (before dropdown handlers)

local quotesScroll = CreateFrame("ScrollFrame", nil, QuotesTab, "UIPanelScrollFrameTemplate")
quotesScroll:SetPoint("TOPLEFT", quotesFilterFrame, "BOTTOMLEFT", 0, -10)
quotesScroll:SetPoint("BOTTOMRIGHT", QuotesTab, "BOTTOMRIGHT", -30, 15)

local quotesContent = CreateFrame("Frame", nil, quotesScroll)
quotesContent:SetWidth(quotesScroll:GetWidth() - 10)
quotesScroll:SetScrollChild(quotesContent)

-- Object pool to prevent overlapping
local quotePool = {}
local function GetQuoteLabel()
  for _, label in ipairs(quotePool) do
    if not label:IsShown() then
      return label
    end
  end
  
  local label = quotesContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetJustifyH("LEFT")
  label:SetWordWrap(true)
  table.insert(quotePool, label)
  return label
end

-- FIXED: Now defined as forward-declared function (PopulateQuotes was declared at top of scope)
PopulateQuotes = function(filterText)
  -- Hide all existing labels
  for _, label in ipairs(quotePool) do
    label:Hide()
    label:ClearAllPoints()
  end
  
  filterText = (filterText or ""):lower()
  local y = -10
  local totalCount = 0
  
  -- Standard quotes (from MageQuotes_Data)
  local showStandard = (currentQuotesFilter == "all" or currentQuotesFilter == "standard" or 
                        (currentQuotesFilter ~= "custom" and currentQuotesFilter ~= "all" and currentQuotesFilter ~= "standard"))
  
  if showStandard then
    for _, sec in ipairs((MageQuotes_Data and MageQuotes_Data.sections) or {}) do
      local header = sec.header or ""
      local sectionKey = sec.key or header:lower():gsub("%s+", ""):sub(1, 4)
      
      -- Category filter check
      local showThisCategory = (currentQuotesFilter == "all" or currentQuotesFilter == "standard" or 
                                currentQuotesFilter == sectionKey)
      
      if showThisCategory then
        local matchingQuotes = {}
        
        for _, q in ipairs(sec.quotes or {}) do
          local text = type(q) == "string" and q or (q.text or "")
          if text ~= "" and (filterText == "" or text:lower():find(filterText, 1, true)) then
            table.insert(matchingQuotes, text)
          end
        end
        
        if #matchingQuotes > 0 then
          -- Category header
          local categoryLabel = GetQuoteLabel()
          categoryLabel:SetFontObject("GameFontHighlightLarge")
          categoryLabel:SetPoint("TOPLEFT", quotesContent, "TOPLEFT", 10, y)
          categoryLabel:SetPoint("RIGHT", quotesContent, "RIGHT", -20, 0)
          categoryLabel:SetText(ColorText(header .. " (" .. #matchingQuotes .. ")", COLORS.primary))
          categoryLabel:Show()
          y = y - 30
          totalCount = totalCount + #matchingQuotes
          
          -- Individual quotes
          for _, text in ipairs(matchingQuotes) do
            local quoteLabel = GetQuoteLabel()
            quoteLabel:SetFontObject("GameFontNormal")
            quoteLabel:SetPoint("TOPLEFT", quotesContent, "TOPLEFT", 30, y)
            quoteLabel:SetPoint("RIGHT", quotesContent, "RIGHT", -20, 0)
            quoteLabel:SetText("  " .. text)
            quoteLabel:Show()
            
            local height = quoteLabel:GetStringHeight()
            y = y - (height + 8)
          end
          y = y - 15
        end
      end
    end
  end
  
  -- Custom quotes
  local showCustom = (currentQuotesFilter == "all" or currentQuotesFilter == "custom")
  if showCustom and MageQuotes_GetCustomQuotes then
    local customQuotes = MageQuotes_GetCustomQuotes()
    local customByCategory = {}
    
    for _, q in ipairs(customQuotes or {}) do
      local cat = q.category or "init"
      if not customByCategory[cat] then
        customByCategory[cat] = {}
      end
      if filterText == "" or (q.text or ""):lower():find(filterText, 1, true) then
        table.insert(customByCategory[cat], q)
      end
    end
    
    for cat, quotes in pairs(customByCategory) do
      if #quotes > 0 then
        -- Header for custom category
        local catName = (L("catInit") or "Custom") 
        if cat == "init" then catName = L("catInit") or "Combat Initiation"
        elseif cat == "kill" then catName = L("catKill") or "Killing Blow"
        elseif cat == "surv" then catName = L("catSurv") or "Survival"
        elseif cat == "vict" then catName = L("catVict") or "Victory"
        elseif cat == "rare" then catName = L("catRare") or "Rare"
        elseif cat == "mid" then catName = L("catMid") or "Mid-Combat"
        elseif cat == "greet" then catName = L("catGreet") or "Greetings"
        end
        
        local categoryLabel = GetQuoteLabel()
        categoryLabel:SetFontObject("GameFontHighlightLarge")
        categoryLabel:SetPoint("TOPLEFT", quotesContent, "TOPLEFT", 10, y)
        categoryLabel:SetPoint("RIGHT", quotesContent, "RIGHT", -20, 0)
        -- FIXED: Use [*] instead of Unicode star to avoid blank square display issues
        categoryLabel:SetText(ColorText("[*] " .. catName .. " (" .. #quotes .. " custom)", COLORS.accent))
        categoryLabel:Show()
        y = y - 30
        totalCount = totalCount + #quotes
        
        for _, q in ipairs(quotes) do
          local quoteLabel = GetQuoteLabel()
          quoteLabel:SetFontObject("GameFontNormal")
          quoteLabel:SetPoint("TOPLEFT", quotesContent, "TOPLEFT", 30, y)
          quoteLabel:SetPoint("RIGHT", quotesContent, "RIGHT", -20, 0)
          -- FIXED: Use [ON]/[OFF] instead of Unicode circles
          local status = q.enabled ~= false and "|cff00ff00[ON]|r " or "|cffff0000[OFF]|r "
          quoteLabel:SetText("  " .. status .. (q.text or ""))
          quoteLabel:Show()
          
          local height = quoteLabel:GetStringHeight()
          y = y - (height + 8)
        end
        y = y - 15
      end
    end
  end
  
  if totalCount == 0 then
    local noResults = GetQuoteLabel()
    noResults:SetFontObject("GameFontDisable")
    noResults:SetPoint("TOP", quotesContent, "TOP", 0, -50)
    noResults:SetText(L("noQuotesFound") or L("noResults"))
    noResults:Show()
    y = -100
  end
  
  quotesContent:SetHeight(math.max(math.abs(y), 100))
end

searchBox:SetScript("OnTextChanged", function(self)
  PopulateQuotes(self:GetText())
end)

PopulateQuotes()

end -- End TAB 2 scope

------------------------------------------------------------
-- TAB 3: Categories
------------------------------------------------------------
do -- Scope block for TAB 3
local CategoriesTab = CreateFrame("Frame", nil, ContentArea)
CategoriesTab:SetAllPoints(ContentArea)
CategoriesTab:Hide()
table.insert(tabContents, CategoriesTab)
tab3.content = CategoriesTab

local catScroll = CreateFrame("ScrollFrame", nil, CategoriesTab, "UIPanelScrollFrameTemplate")
catScroll:SetPoint("TOPLEFT", CategoriesTab, "TOPLEFT", 10, -10)
catScroll:SetPoint("BOTTOMRIGHT", CategoriesTab, "BOTTOMRIGHT", -30, 50)

local catContent = CreateFrame("Frame", nil, catScroll)
catContent:SetSize(catScroll:GetWidth() - 10, 800)
catScroll:SetScrollChild(catContent)

local catY = -20

local catHeader = CreateSectionHeader(catContent, L("categorySettings"))
catHeader:SetPoint("TOPLEFT", catContent, "TOPLEFT", 10, catY)
catY = catY - 40

local catHelp = catContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
catHelp:SetPoint("TOPLEFT", catContent, "TOPLEFT", 10, catY)
catHelp:SetPoint("RIGHT", catContent, "RIGHT", -20, 0)
catHelp:SetJustifyH("LEFT")
catHelp:SetText(ColorText(L("categoryHelp"), COLORS.text_dim))
catY = catY - 50

-- Category column headers
local catHeaderRow = catContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
catHeaderRow:SetPoint("TOPLEFT", catContent, "TOPLEFT", 10, catY)
catHeaderRow:SetText(
  ColorText(L("enableCategory"), COLORS.accent) .. "      " ..
  ColorText(L("categoryCooldown"), COLORS.accent) .. "      " ..
  ColorText(L("categoryChance"), COLORS.accent)
)
catY = catY - 30

-- Category draft storage
local categoryDraft = {}
local categoryWidgets = {}

local function RebuildCategoryRows()
  for _, w in pairs(categoryWidgets) do
    if w.cb then w.cb:Hide() end
    if w.cd then w.cd:Hide() end
    if w.ch then w.ch:Hide() end
    if w.lbl then w.lbl:Hide() end
  end
  wipe(categoryWidgets)

  local rowY = catY
  for _, sec in ipairs((MageQuotes_Data and MageQuotes_Data.sections) or {}) do
    local header = sec.header or ""
    local cfg = GetOrInitCategoryCfg(header)
    categoryDraft[header] = { 
      enabled = cfg.enabled, 
      cooldown = cfg.cooldown, 
      chance = cfg.chance 
    }

    -- Enable toggle
    local cb = CreateToggleSwitch(catContent)
    cb:SetPoint("TOPLEFT", catContent, "TOPLEFT", 10, rowY)
    cb:SetChecked(cfg.enabled)
    cb.OnValueChanged = function(self, value)
      categoryDraft[header].enabled = value
    end

    -- Category name label
    local lbl = catContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lbl:SetPoint("LEFT", cb, "RIGHT", 10, 0)
    lbl:SetText(header)

    -- Cooldown input
    local cd = CreateFrame("EditBox", nil, catContent, "InputBoxTemplate")
    cd:SetAutoFocus(false)
    cd:SetSize(70, 20)
    cd:SetPoint("LEFT", lbl, "RIGHT", 80, 0)
    cd:SetText(tostring(cfg.cooldown or MageQuotesDB.quoteCooldown or 10))
    cd:SetMaxLetters(6)

    -- Chance input
    local ch = CreateFrame("EditBox", nil, catContent, "InputBoxTemplate")
    ch:SetAutoFocus(false)
    ch:SetSize(50, 20)
    ch:SetPoint("LEFT", cd, "RIGHT", 40, 0)
    ch:SetText(tostring(cfg.chance or 100))
    ch:SetMaxLetters(3)

    cd:SetScript("OnEnterPressed", function(self)
      local v = clampInt(self:GetText(), 0, 3600)
      categoryDraft[header].cooldown = v
      self:SetText(tostring(v))
      self:ClearFocus()
    end)
    cd:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    ch:SetScript("OnEnterPressed", function(self)
      local v = clampInt(self:GetText(), 0, 100)
      categoryDraft[header].chance = v
      self:SetText(tostring(v))
      self:ClearFocus()
    end)
    ch:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    categoryWidgets[header] = { cb = cb, cd = cd, ch = ch, lbl = lbl }
    rowY = rowY - 35
  end
end

RebuildCategoryRows()

-- Apply button
local catApplyBtn = CreateModernButton(CategoriesTab, L("applySettings"), 150, 32)
catApplyBtn:SetPoint("BOTTOMLEFT", CategoriesTab, "BOTTOMLEFT", 15, 10)
catApplyBtn:SetScript("OnClick", function()
  for header, draft in pairs(categoryDraft) do
    local cfg = GetOrInitCategoryCfg(header)
    cfg.enabled  = draft.enabled
    cfg.cooldown = draft.cooldown
    cfg.chance   = draft.chance
  end
  
  RebuildCore()
  if MageQuotes_ResetRuntimeCooldowns then
    MageQuotes_ResetRuntimeCooldowns()
  end

  print(ColorText(L("categoriesApplied"), COLORS.success))
end)

-- Reset button
local catResetBtn = CreateModernButton(CategoriesTab, L("resetDefaults"), 150, 32)
catResetBtn:SetPoint("LEFT", catApplyBtn, "RIGHT", 10, 0)
catResetBtn:SetScript("OnClick", function()
  for header, _ in pairs(categoryDraft) do
    local cfg = GetOrInitCategoryCfg(header)
    cfg.enabled = true
    cfg.cooldown = 10
    cfg.chance = 100
  end
  RebuildCategoryRows()
  print(ColorText("Categories reset to defaults", COLORS.success))
end)

end -- End TAB 3 scope

------------------------------------------------------------
-- TAB 4: Audio Settings
------------------------------------------------------------
do -- Scope block for TAB 4
local AudioTab = CreateFrame("Frame", nil, ContentArea)
AudioTab:SetAllPoints(ContentArea)
AudioTab:Hide()
table.insert(tabContents, AudioTab)
tab4.content = AudioTab

local audioScroll = CreateFrame("ScrollFrame", nil, AudioTab, "UIPanelScrollFrameTemplate")
audioScroll:SetPoint("TOPLEFT", AudioTab, "TOPLEFT", 10, -10)
audioScroll:SetPoint("BOTTOMRIGHT", AudioTab, "BOTTOMRIGHT", -30, 10)

local audioContent = CreateFrame("Frame", nil, audioScroll)
audioContent:SetSize(audioScroll:GetWidth() - 10, 600)
audioScroll:SetScrollChild(audioContent)

local audioY = -20

local audioHeader = CreateSectionHeader(audioContent, L("voiceSettings"))
audioHeader:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
audioY = audioY - 40

local audioSwitch = CreateToggleSwitch(audioContent)
audioSwitch:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
audioSwitch:SetChecked(MageQuotesDB and MageQuotesDB.sound and MageQuotesDB.sound.enabled or false)
audioSwitch.OnValueChanged = function(self, value)
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.sound = MageQuotesDB.sound or {}
  MageQuotesDB.sound.enabled = value
end

local audioEnableLabel = audioContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
audioEnableLabel:SetPoint("LEFT", audioSwitch, "RIGHT", 10, 0)
audioEnableLabel:SetText(L("enableVoice"))

audioY = audioY - 50

local channelSoundHeader = CreateSectionHeader(audioContent, L("audioChannel"))
channelSoundHeader:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
audioY = audioY - 40

local soundChannels = {"Master", "SFX", "Music", "Ambience", "Dialog"}
local soundChannelButtons = {}

for i, channel in ipairs(soundChannels) do
  local btn = CreateModernButton(audioContent, channel, 120, 30)
  if i == 1 then
    btn:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
  else
    btn:SetPoint("LEFT", soundChannelButtons[i-1], "RIGHT", 8, 0)
  end
  
  btn:SetScript("OnClick", function(self)
    MageQuotesDB = MageQuotesDB or {}
    MageQuotesDB.sound = MageQuotesDB.sound or {}
    MageQuotesDB.sound.channel = channel
    for _, b in ipairs(soundChannelButtons) do
      b:SetBackdropColor(unpack(COLORS.bg_medium))
    end
    self:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
  end)
  
  if MageQuotesDB and MageQuotesDB.sound and MageQuotesDB.sound.channel == channel then
    btn:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
  end
  
  table.insert(soundChannelButtons, btn)
end

audioY = audioY - 60

local actorHeader = CreateSectionHeader(audioContent, L("voiceActor"))
actorHeader:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
audioY = audioY - 40

local actorLabel = audioContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
actorLabel:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
actorLabel:SetText(L("currentVoice"))

local actorCycleBtn = CreateModernButton(audioContent, L("nextActor"), 150, 32)
actorCycleBtn:SetPoint("LEFT", actorLabel, "RIGHT", 15, 0)
actorCycleBtn:SetScript("OnClick", function()
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.sound = MageQuotesDB.sound or {}
  MageQuotesDB.sound.actors = MageQuotesDB.sound.actors or {"MageA", "MageB"}
  MageQuotesDB.sound.actorIndex = MageQuotesDB.sound.actorIndex or 1
  
  MageQuotesDB.sound.actorIndex = (MageQuotesDB.sound.actorIndex % #MageQuotesDB.sound.actors) + 1
  local newActor = MageQuotesDB.sound.actors[MageQuotesDB.sound.actorIndex] or "MageA"
  actorCycleBtn.label:SetText("Actor: " .. newActor)
  print(ColorText(L("voiceActorChanged") .. " " .. newActor, COLORS.accent))
end)

if MageQuotesDB and MageQuotesDB.sound and MageQuotesDB.sound.actors then
  local idx = MageQuotesDB.sound.actorIndex or 1
  local actor = MageQuotesDB.sound.actors[idx] or "MageA"
  actorCycleBtn.label:SetText("Actor: " .. actor)
end

audioY = audioY - 60

local testHeader = CreateSectionHeader(audioContent, L("testAudio"))
testHeader:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
audioY = audioY - 40

local testSoundBtn = CreateModernButton(audioContent, L("testVoice"), 200, 40)
testSoundBtn:SetPoint("TOPLEFT", audioContent, "TOPLEFT", 10, audioY)
testSoundBtn:SetScript("OnClick", function()
  if MageQuotesAPI and MageQuotesAPI.TriggerManualQuote then
    MageQuotesAPI.TriggerManualQuote("init")
    print(ColorText(L("playingTest"), COLORS.success))
  end
end)

end -- End TAB 4 scope

------------------------------------------------------------
-- TAB 5: Statistics
------------------------------------------------------------
do -- Scope block for TAB 5
StatsTab = CreateFrame("Frame", nil, ContentArea)
StatsTab:SetAllPoints(ContentArea)
StatsTab:Hide()
table.insert(tabContents, StatsTab)
tab5.content = StatsTab

local statsText = StatsTab:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
statsText:SetPoint("TOPLEFT", StatsTab, "TOPLEFT", 20, -20)
statsText:SetJustifyH("LEFT")

UpdateStats = function()
  local api = MageQuotesAPI
  if not api then 
    statsText:SetText(ColorText("Stats API not available", COLORS.error))
    return 
  end
  
  local state = api.GetCombatState and api.GetCombatState() or {}
  local lastQuote = api.GetLastQuote and api.GetLastQuote() or {}
  
  local totalQuotes = #(MageQuotes_Data and MageQuotes_Data.allQuotes or {})
  local combatState = state.inCombat and ColorText(L("inCombat"), COLORS.warning) or ColorText(L("outOfCombat"), COLORS.success)
  local kills = tostring(state.recentKills or 0)
  local lastQuoteText = lastQuote.text or L("noneYet")
  
  local text = ColorText(L("sessionStats") .. "\n\n", COLORS.primary) ..
    L("totalQuotes") .. " " .. ColorText(tostring(totalQuotes), COLORS.accent) .. "\n" ..
    L("combatState") .. " " .. combatState .. "\n" ..
    L("killsThisCombat") .. " " .. ColorText(kills, COLORS.accent) .. "\n\n" ..
    ColorText(L("lastQuote") .. "\n", COLORS.text_dim) ..
    string.format('"%s"', lastQuoteText)
  
  statsText:SetText(text)
end

StatsTab:SetScript("OnShow", UpdateStats)

local statsRefreshBtn = CreateModernButton(StatsTab, L("refresh"), 120, 32)
statsRefreshBtn:SetPoint("TOPRIGHT", StatsTab, "TOPRIGHT", -15, -15)
statsRefreshBtn:SetScript("OnClick", UpdateStats)

end -- End TAB 5 scope

------------------------------------------------------------
-- TAB 6: Modules
------------------------------------------------------------
do -- Scope block for TAB 6
local ModulesTab = CreateFrame("Frame", nil, ContentArea)
ModulesTab:SetAllPoints(ContentArea)
ModulesTab:Hide()
table.insert(tabContents, ModulesTab)
tab6.content = ModulesTab

local modScroll = CreateFrame("ScrollFrame", nil, ModulesTab, "UIPanelScrollFrameTemplate")
modScroll:SetPoint("TOPLEFT", ModulesTab, "TOPLEFT", 10, -10)
modScroll:SetPoint("BOTTOMRIGHT", ModulesTab, "BOTTOMRIGHT", -30, 10)

local modContent = CreateFrame("Frame", nil, modScroll)
modContent:SetSize(modScroll:GetWidth() - 10, 600)
modScroll:SetScrollChild(modContent)

local modY = -20

local modHeader = CreateSectionHeader(modContent, L("addonModules"))
modHeader:SetPoint("TOPLEFT", modContent, "TOPLEFT", 10, modY)
modY = modY - 40

-- Module list
local modules = {
  {
    name = L("moduleCore"),
    desc = L("coreDesc"),
    check = function() return _G.MageQuotesCore ~= nil end,
    version = function() return _G.MageQuotesCore and _G.MageQuotesCore.VERSION or "N/A" end
  },
  {
    name = L("moduleDracthyr"),
    desc = L("dracthyrDesc"),
    check = function() return _G.MageQuotes_DracthyrAPI ~= nil end,
    version = function() 
      return _G.MageQuotes_DracthyrAPI and _G.MageQuotes_DracthyrAPI.GetVersion and _G.MageQuotes_DracthyrAPI.GetVersion() or "N/A" 
    end
  },
  {
    name = L("moduleCustomQuotes") or "Custom Quotes",
    desc = L("customQuotesDesc") or "User-created quotes with import/export support",
    check = function() return _G.MageQuotes_CustomQuotesAPI ~= nil end,
    version = function() return _G.MageQuotes_CustomQuotesAPI and _G.MageQuotes_CustomQuotesAPI.VERSION or "N/A" end
  },
  {
    name = L("moduleAPI"),
    desc = L("apiDesc"),
    check = function() return _G.MageQuotesAPI ~= nil end,
    version = function() return _G.MageQuotesAPI and _G.MageQuotesAPI.VERSION or "N/A" end
  },
  {
    name = L("moduleEventBus"),
    desc = L("eventBusDesc"),
    check = function() return _G.MageQuotes_EventBus ~= nil end,
    version = function() return "1.0" end
  },
}

for i, mod in ipairs(modules) do
  local modFrame = CreateFrame("Frame", nil, modContent, BackdropTemplateMixin and "BackdropTemplate")
  modFrame:SetSize(modContent:GetWidth() - 20, 80)
  modFrame:SetPoint("TOPLEFT", modContent, "TOPLEFT", 10, modY)
  
  modFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
  })
  modFrame:SetBackdropColor(unpack(COLORS.bg_light))
  modFrame:SetBackdropBorderColor(unpack(COLORS.border))
  
  local isEnabled = mod.check()
  local statusColor = isEnabled and COLORS.success or COLORS.error
  
  -- Status indicator
  local statusIcon = modFrame:CreateTexture(nil, "ARTWORK")
  statusIcon:SetSize(16, 16)
  statusIcon:SetPoint("TOPLEFT", modFrame, "TOPLEFT", 10, -10)
  statusIcon:SetTexture("Interface\\Buttons\\WHITE8x8")
  statusIcon:SetVertexColor(unpack(statusColor))
  
  -- Module name
  local modName = modFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  modName:SetPoint("LEFT", statusIcon, "RIGHT", 8, 0)
  modName:SetText(mod.name)
  
  -- Status text
  local statusText = modFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  statusText:SetPoint("RIGHT", modFrame, "RIGHT", -10, 8)
  statusText:SetText(ColorText(isEnabled and L("moduleEnabled") or L("moduleNotInstalled"), statusColor))
  
  -- Version
  local versionLabel = modFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  versionLabel:SetPoint("RIGHT", modFrame, "RIGHT", -10, -8)
  versionLabel:SetText(ColorText("v" .. mod.version(), COLORS.text_dim))
  
  -- Description
  local modDesc = modFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  modDesc:SetPoint("TOPLEFT", modFrame, "TOPLEFT", 34, -30)
  modDesc:SetPoint("RIGHT", modFrame, "RIGHT", -10, 0)
  modDesc:SetJustifyH("LEFT")
  modDesc:SetWordWrap(true)
  modDesc:SetText(ColorText(mod.desc, COLORS.text_dim))
  
  modY = modY - 90
end

end -- End TAB 6 scope

------------------------------------------------------------
-- TAB 7: Debug Console
------------------------------------------------------------
do -- Scope block for TAB 7
DebugTab = CreateFrame("Frame", nil, ContentArea)
DebugTab:SetAllPoints(ContentArea)
DebugTab:Hide()
table.insert(tabContents, DebugTab)
-- NOTE: tab7 is now "Custom" in UI, so we assign Debug content to tab8
tab8.content = DebugTab

local debugControlsRow = CreateFrame("Frame", nil, DebugTab)
debugControlsRow:SetSize(DebugTab:GetWidth() - 30, 40)
debugControlsRow:SetPoint("TOPLEFT", DebugTab, "TOPLEFT", 15, -15)

local debugToggle = CreateToggleSwitch(debugControlsRow)
debugToggle:SetPoint("LEFT", debugControlsRow, "LEFT", 0, 0)
debugToggle:SetChecked(MageQuotesDB and MageQuotesDB.debugMode or false)

local debugLabel = debugControlsRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
debugLabel:SetPoint("LEFT", debugToggle, "RIGHT", 10, 0)
debugLabel:SetText(L("enableDebugMode"))

local clearBtn = CreateModernButton(debugControlsRow, L("clearLog"), 120, 28)
clearBtn:SetPoint("RIGHT", debugControlsRow, "RIGHT", -120, 0)

local refreshBtn = CreateModernButton(debugControlsRow, L("refresh"), 100, 28)
refreshBtn:SetPoint("RIGHT", clearBtn, "LEFT", -8, 0)

local debugScroll = CreateFrame("ScrollFrame", nil, DebugTab, "UIPanelScrollFrameTemplate")
debugScroll:SetPoint("TOPLEFT", debugControlsRow, "BOTTOMLEFT", 0, -10)
debugScroll:SetPoint("BOTTOMRIGHT", DebugTab, "BOTTOMRIGHT", -30, 15)

local debugContent = CreateFrame("Frame", nil, debugScroll)
debugContent:SetWidth(debugScroll:GetWidth() - 10)
debugScroll:SetScrollChild(debugContent)

local debugText = debugContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
debugText:SetPoint("TOPLEFT", debugContent, "TOPLEFT", 10, -10)
debugText:SetPoint("TOPRIGHT", debugContent, "TOPRIGHT", -10, -10)
debugText:SetJustifyH("LEFT")
debugText:SetMaxLines(10000)

RefreshDebugLog = function()
  if not MageQuotesAPI or not MageQuotesAPI.GetDebugLog then
    debugText:SetText(ColorText(L("debugNotAvailable"), COLORS.error))
    debugContent:SetHeight(100)
    return
  end
  
  local log = MageQuotesAPI.GetDebugLog()
  
  if #log == 0 then
    debugText:SetText(ColorText(L("noDebugEntries"), COLORS.text_dim))
    debugContent:SetHeight(100)
    return
  end
  
  local lines = {}
  local categoryColors = {
    Error = COLORS.error,
    Emit = COLORS.success,
    Combat = COLORS.warning,
    Trigger = COLORS.primary,
    Aura = {0.8, 0.4, 1.0},
    Init = {0.5, 0.9, 0.9},
    SpamGate = {1.0, 0.6, 0.2},
    Kill = {1.0, 0.3, 0.3},
    Greeting = {0.3, 1.0, 0.8},
    Rare = {1.0, 0.8, 0.0},
    MidCombat = {0.7, 0.7, 1.0},
  }
  
  for i = #log, math.max(1, #log - 200), -1 do
    local entry = log[i]
    local catColor = categoryColors[entry.category] or COLORS.text_dim
    
    local timestamp = ColorText("[" .. (entry.timestamp or "??:??:??") .. "]", COLORS.text_dim)
    local category = ColorText("[" .. (entry.category or "Unknown") .. "]", catColor)
    local message = tostring(entry.message or "")
    
    table.insert(lines, string.format("%s %s %s", timestamp, category, message))
  end
  
  local fullText = table.concat(lines, "\n")
  debugText:SetText(fullText)
  
  local textHeight = debugText:GetStringHeight()
  debugContent:SetHeight(math.max(textHeight + 20, debugScroll:GetHeight()))
  
  C_Timer.After(0.1, function()
    if debugScroll:IsVisible() then
      debugScroll:SetVerticalScroll(debugScroll:GetVerticalScrollRange())
    end
  end)
end

debugToggle.OnValueChanged = function(self, value)
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.debugMode = value
  MageQuotesDB.debugPrint = value
  RefreshDebugLog()
end

clearBtn:SetScript("OnClick", function()
  if MageQuotesAPI and MageQuotesAPI.GetDebugLog then
    local log = MageQuotesAPI.GetDebugLog()
    wipe(log)
    RefreshDebugLog()
  end
end)

refreshBtn:SetScript("OnClick", RefreshDebugLog)

local debugUpdateFrame = CreateFrame("Frame")
debugUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
  self.elapsed = (self.elapsed or 0) + elapsed
  if self.elapsed >= 2 then
    self.elapsed = 0
    if DebugTab:IsVisible() and MageQuotesDB and MageQuotesDB.debugMode then
      RefreshDebugLog()
    end
  end
end)

DebugTab:SetScript("OnShow", RefreshDebugLog)

end -- End TAB 7 scope

------------------------------------------------------------
-- TAB 8: Custom Quote Editor
------------------------------------------------------------
do -- Scope block for TAB 8
CustomTab = CreateFrame("Frame", nil, ContentArea)
CustomTab:SetAllPoints(ContentArea)
CustomTab:Hide()
table.insert(tabContents, CustomTab)
-- NOTE: tab7 is now "Custom" in UI, so we assign Custom content to tab7
tab7.content = CustomTab

-- Split into two panes: Editor (left) and List (right)
local editorPane = CreateFrame("Frame", nil, CustomTab, BackdropTemplateMixin and "BackdropTemplate")
editorPane:SetPoint("TOPLEFT", CustomTab, "TOPLEFT", 10, -10)
editorPane:SetPoint("BOTTOMLEFT", CustomTab, "BOTTOMLEFT", 10, 10)
editorPane:SetWidth(440)  -- INCREASED from 380 to fit Import/Export
editorPane:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
editorPane:SetBackdropColor(COLORS.bg_light[1], COLORS.bg_light[2], COLORS.bg_light[3], 0.5)
editorPane:SetBackdropBorderColor(unpack(COLORS.border))

local listPane = CreateFrame("Frame", nil, CustomTab, BackdropTemplateMixin and "BackdropTemplate")
listPane:SetPoint("TOPLEFT", editorPane, "TOPRIGHT", 10, 0)
listPane:SetPoint("BOTTOMRIGHT", CustomTab, "BOTTOMRIGHT", -10, 10)
listPane:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
listPane:SetBackdropColor(COLORS.bg_light[1], COLORS.bg_light[2], COLORS.bg_light[3], 0.5)
listPane:SetBackdropBorderColor(unpack(COLORS.border))

-- Editor Pane Header
local editorHeader = CreateSectionHeader(editorPane, L("addNewQuote") or "Add New Quote")
editorHeader:SetPoint("TOPLEFT", editorPane, "TOPLEFT", 15, -15)

-- Quote Text Input
local quoteTextLabel = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
quoteTextLabel:SetPoint("TOPLEFT", editorHeader, "BOTTOMLEFT", 0, -20)
quoteTextLabel:SetText(L("quoteText") or "Quote Text:")

local quoteTextBox = CreateFrame("EditBox", nil, editorPane, BackdropTemplateMixin and "BackdropTemplate")
quoteTextBox:SetPoint("TOPLEFT", quoteTextLabel, "BOTTOMLEFT", 0, -5)
quoteTextBox:SetSize(410, 70)  -- INCREASED width
quoteTextBox:SetMultiLine(true)
quoteTextBox:SetAutoFocus(false)
quoteTextBox:SetFontObject(GameFontHighlight)
quoteTextBox:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
quoteTextBox:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
quoteTextBox:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
quoteTextBox:SetTextInsets(8, 8, 8, 8)
quoteTextBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

-- Category Dropdown
local categoryLabel = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
categoryLabel:SetPoint("TOPLEFT", quoteTextBox, "BOTTOMLEFT", 0, -15)
categoryLabel:SetText(L("category") or "Category:")

local categoryButtons = {}
local selectedCategory = "init"
local categoryFrame = CreateFrame("Frame", nil, editorPane)
categoryFrame:SetPoint("TOPLEFT", categoryLabel, "BOTTOMLEFT", 0, -8)
categoryFrame:SetSize(350, 70)

local categories = {
  { key = "init", name = "Combat Init" },
  { key = "kill", name = "Killing Blow" },
  { key = "surv", name = "Survival" },
  { key = "vict", name = "Victory" },
  { key = "rare", name = "Rare" },
  { key = "mid", name = "Mid-Combat" },
  { key = "greet", name = "Greeting" },
}

local function UpdateCategorySelection()
  for key, btn in pairs(categoryButtons) do
    if key == selectedCategory then
      btn:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.6)
      btn:SetBackdropBorderColor(unpack(COLORS.primary))
    else
      btn:SetBackdropColor(unpack(COLORS.bg_medium))
      btn:SetBackdropBorderColor(unpack(COLORS.border))
    end
  end
end

for i, cat in ipairs(categories) do
  local btn = CreateFrame("Button", nil, categoryFrame, BackdropTemplateMixin and "BackdropTemplate")
  btn:SetSize(80, 28)
  
  local row = math.floor((i - 1) / 4)
  local col = (i - 1) % 4
  btn:SetPoint("TOPLEFT", categoryFrame, "TOPLEFT", col * 86, -row * 34)
  
  btn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
  })
  btn:SetBackdropColor(unpack(COLORS.bg_medium))
  btn:SetBackdropBorderColor(unpack(COLORS.border))
  
  local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("CENTER")
  label:SetText(cat.name)
  
  btn:SetScript("OnClick", function()
    selectedCategory = cat.key
    UpdateCategorySelection()
  end)
  
  btn:SetScript("OnEnter", function(self)
    self:SetBackdropBorderColor(unpack(COLORS.primary))
  end)
  
  btn:SetScript("OnLeave", function(self)
    if selectedCategory ~= cat.key then
      self:SetBackdropBorderColor(unpack(COLORS.border))
    end
  end)
  
  categoryButtons[cat.key] = btn
end
UpdateCategorySelection()

-- Sound File (Optional)
local soundLabel = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
soundLabel:SetPoint("TOPLEFT", categoryFrame, "BOTTOMLEFT", 0, -15)
soundLabel:SetText((L("soundFile") or "Sound File") .. " " .. ColorText("(optional)", COLORS.text_dim))

local soundBox = CreateFrame("EditBox", nil, editorPane, BackdropTemplateMixin and "BackdropTemplate")
soundBox:SetPoint("TOPLEFT", soundLabel, "BOTTOMLEFT", 0, -5)
soundBox:SetSize(410, 28)  -- INCREASED width
soundBox:SetAutoFocus(false)
soundBox:SetFontObject(GameFontHighlight)
soundBox:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
soundBox:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
soundBox:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
soundBox:SetTextInsets(8, 0, 0, 0)
soundBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
soundBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

-- Spec Filter
local customSpecLabel = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
customSpecLabel:SetPoint("TOPLEFT", soundBox, "BOTTOMLEFT", 0, -15)
customSpecLabel:SetText(L("specFilter") or "Spec Filter:")

local customSpecButtons = {}
local selectedSpec = "all"
local customSpecFrame = CreateFrame("Frame", nil, editorPane)
customSpecFrame:SetPoint("TOPLEFT", customSpecLabel, "BOTTOMLEFT", 0, -8)
customSpecFrame:SetSize(350, 30)

local customSpecs = { "all", "arcane", "fire", "frost" }
local customSpecNames = { all = "All", arcane = "Arcane", fire = "Fire", frost = "Frost" }

local function UpdateCustomSpecSelection()
  for key, btn in pairs(customSpecButtons) do
    if key == selectedSpec then
      btn:SetBackdropColor(COLORS.accent[1], COLORS.accent[2], COLORS.accent[3], 0.6)
      btn:SetBackdropBorderColor(unpack(COLORS.accent))
    else
      btn:SetBackdropColor(unpack(COLORS.bg_medium))
      btn:SetBackdropBorderColor(unpack(COLORS.border))
    end
  end
end

for i, spec in ipairs(customSpecs) do
  local btn = CreateFrame("Button", nil, customSpecFrame, BackdropTemplateMixin and "BackdropTemplate")
  btn:SetSize(80, 26)
  btn:SetPoint("LEFT", customSpecFrame, "LEFT", (i - 1) * 86, 0)
  
  btn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
  })
  btn:SetBackdropColor(unpack(COLORS.bg_medium))
  btn:SetBackdropBorderColor(unpack(COLORS.border))
  
  local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("CENTER")
  label:SetText(customSpecNames[spec])
  
  btn:SetScript("OnClick", function()
    selectedSpec = spec
    UpdateCustomSpecSelection()
  end)
  
  customSpecButtons[spec] = btn
end
UpdateCustomSpecSelection()

-- Trigger Selection (Optional Step 5)
local triggerSectionLabel = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
triggerSectionLabel:SetPoint("TOPLEFT", customSpecFrame, "BOTTOMLEFT", 0, -20)
triggerSectionLabel:SetText((L("triggers") or "Triggers") .. " " .. ColorText("(" .. (L("optional") or "optional") .. ")", COLORS.text_dim))

-- Store current quote triggers
currentQuoteTriggers = { situations = {}, spells = {} }

local triggerSummaryText = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
triggerSummaryText:SetPoint("TOPLEFT", triggerSectionLabel, "BOTTOMLEFT", 0, -5)
triggerSummaryText:SetWidth(250)
triggerSummaryText:SetJustifyH("LEFT")
triggerSummaryText:SetText(ColorText("No triggers configured", COLORS.text_dim))

UpdateTriggerSummary = function()
  local parts = {}
  local sitCount = 0
  for _ in pairs(currentQuoteTriggers.situations or {}) do
    sitCount = sitCount + 1
  end
  if sitCount > 0 then
    table.insert(parts, sitCount .. " situation(s)")
  end
  local spellCount = #(currentQuoteTriggers.spells or {})
  if spellCount > 0 then
    table.insert(parts, spellCount .. " spell(s)")
  end
  if #parts > 0 then
    triggerSummaryText:SetText(ColorText("✓ " .. table.concat(parts, ", "), COLORS.success))
  else
    triggerSummaryText:SetText(ColorText("No triggers configured", COLORS.text_dim))
  end
end

chooseTriggerBtn = CreateModernButton(editorPane, L("triggers") or "Triggers", 100, 26)
chooseTriggerBtn:SetPoint("LEFT", triggerSectionLabel, "RIGHT", 10, 0)
chooseTriggerBtn:SetBackdropColor(COLORS.accent[1], COLORS.accent[2], COLORS.accent[3], 0.4)
chooseTriggerBtn:SetBackdropBorderColor(unpack(COLORS.accent))

local clearTriggersBtn = CreateModernButton(editorPane, "Clear", 50, 26)
clearTriggersBtn:SetPoint("LEFT", chooseTriggerBtn, "RIGHT", 5, 0)
clearTriggersBtn:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
clearTriggersBtn:SetScript("OnClick", function()
  currentQuoteTriggers = { situations = {}, spells = {} }
  UpdateTriggerSummary()
end)

-- Add Button (moved down)
local addQuoteBtn = CreateModernButton(editorPane, L("addQuote") or "Add Quote", 150, 35)
addQuoteBtn:SetPoint("TOPLEFT", triggerSummaryText, "BOTTOMLEFT", 0, -15)
addQuoteBtn:SetBackdropColor(COLORS.success[1], COLORS.success[2], COLORS.success[3], 0.6)
addQuoteBtn:SetBackdropBorderColor(unpack(COLORS.success))

local editorStatusText = editorPane:CreateFontString(nil, "OVERLAY", "GameFontNormal")
editorStatusText:SetPoint("LEFT", addQuoteBtn, "RIGHT", 15, 0)
editorStatusText:SetText("")

-- Import/Export Section
local importExportHeader = CreateSectionHeader(editorPane, L("importExport") or "Import / Export")
importExportHeader:SetPoint("TOPLEFT", addQuoteBtn, "BOTTOMLEFT", 0, -20)

local exportBtn = CreateModernButton(editorPane, L("exportAll") or "Export All", 100, 30)
exportBtn:SetPoint("TOPLEFT", importExportHeader, "BOTTOMLEFT", 0, -15)

local importBtn = CreateModernButton(editorPane, L("import") or "Import", 100, 30)
importBtn:SetPoint("LEFT", exportBtn, "RIGHT", 10, 0)

local clearAllBtn = CreateModernButton(editorPane, L("clearAll") or "Clear All", 100, 30)
clearAllBtn:SetPoint("LEFT", importBtn, "RIGHT", 10, 0)
clearAllBtn:SetBackdropColor(COLORS.error[1], COLORS.error[2], COLORS.error[3], 0.4)

-- Import Box (hidden by default)
local importFrame = CreateFrame("Frame", nil, editorPane, BackdropTemplateMixin and "BackdropTemplate")
importFrame:SetPoint("TOPLEFT", exportBtn, "BOTTOMLEFT", 0, -10)
importFrame:SetSize(410, 80)  -- INCREASED width
importFrame:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
importFrame:SetBackdropColor(0.15, 0.15, 0.2, 0.9)
importFrame:SetBackdropBorderColor(unpack(COLORS.accent))
importFrame:Hide()

local importBox = CreateFrame("EditBox", nil, importFrame, BackdropTemplateMixin and "BackdropTemplate")
importBox:SetPoint("TOPLEFT", importFrame, "TOPLEFT", 5, -5)
importBox:SetPoint("BOTTOMRIGHT", importFrame, "BOTTOMRIGHT", -70, 5)
importBox:SetMultiLine(true)
importBox:SetAutoFocus(false)
importBox:SetFontObject(GameFontHighlightSmall)
importBox:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
})
importBox:SetBackdropColor(0.05, 0.05, 0.05, 1)
importBox:SetTextInsets(5, 5, 5, 5)

local doImportBtn = CreateModernButton(importFrame, "Go", 55, 30)
doImportBtn:SetPoint("RIGHT", importFrame, "RIGHT", -8, 0)
doImportBtn:SetBackdropColor(COLORS.success[1], COLORS.success[2], COLORS.success[3], 0.6)

-- List Pane Header
local listHeader = CreateSectionHeader(listPane, L("customQuotes") or "Custom Quotes")
listHeader:SetPoint("TOPLEFT", listPane, "TOPLEFT", 15, -15)

-- Browse Packs Button (only shows if QuotePacks module is loaded)
local browsePacksBtn = CreateModernButton(listPane, "Browse Packs", 100, 26)
browsePacksBtn:SetPoint("TOPRIGHT", listPane, "TOPRIGHT", -15, -10)
browsePacksBtn:SetBackdropColor(0.6, 0.45, 0.1, 0.8)
browsePacksBtn:SetBackdropBorderColor(1.0, 0.7, 0.2, 1)
browsePacksBtn.label:SetTextColor(1, 0.85, 0.5)
browsePacksBtn.label:SetFont(browsePacksBtn.label:GetFont(), 11)

-- Hide by default, show only if module loads
browsePacksBtn:Hide()

browsePacksBtn:SetScript("OnClick", function()
  if MageQuotes_OpenPacksBrowser then
    MageQuotes_OpenPacksBrowser()
  elseif MageQuotes_QuotePacks then
    -- Module loaded but UI not available, use slash command
    print("|cffffaa00MageQuotes:|r Use |cff88bbff/mqpacks list|r to see packs")
    print("|cffffaa00MageQuotes:|r Use |cff88bbff/mqpacks install <id>|r to install")
  end
end)

browsePacksBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.7, 0.55, 0.15, 1)
  self:SetBackdropBorderColor(1.0, 0.8, 0.3, 1)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine("Browse Quote Packs", 1, 0.85, 0.5)
  GameTooltip:AddLine("Install curated quote collections!", 0.8, 0.8, 0.8, true)
  if not MageQuotes_OpenPacksBrowser then
    GameTooltip:AddLine("(UI not loaded - will use /mqpacks)", 0.6, 0.6, 0.6)
  end
  GameTooltip:Show()
end)

browsePacksBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.6, 0.45, 0.1, 0.8)
  self:SetBackdropBorderColor(1.0, 0.7, 0.2, 1)
  GameTooltip:Hide()
end)

-- Check if QuotePacks module is loaded and show button
local function CheckPacksModule()
  if MageQuotes_QuotePacks or MageQuotes_GetAvailablePacks then
    browsePacksBtn:Show()
  end
end

-- Check on tab show and after short delay for load order
CustomTab:HookScript("OnShow", CheckPacksModule)
C_Timer.After(1, CheckPacksModule)

local quoteCountText = listPane:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
quoteCountText:SetPoint("RIGHT", browsePacksBtn, "LEFT", -10, 0)

-- Scroll Frame for Quote List
local listScroll = CreateFrame("ScrollFrame", nil, listPane, "UIPanelScrollFrameTemplate")
listScroll:SetPoint("TOPLEFT", listHeader, "BOTTOMLEFT", 0, -15)
listScroll:SetPoint("BOTTOMRIGHT", listPane, "BOTTOMRIGHT", -30, 10)

local listContent = CreateFrame("Frame", nil, listScroll)
listContent:SetWidth(listScroll:GetWidth() - 10)
listScroll:SetScrollChild(listContent)

local quoteRows = {}

RefreshCustomQuoteList = function()
  -- Clear existing rows
  for _, row in ipairs(quoteRows) do
    row:Hide()
    row:SetParent(nil)
  end
  wipe(quoteRows)
  
  local quotes = MageQuotes_GetCustomQuotes and MageQuotes_GetCustomQuotes() or {}
  quoteCountText:SetText(ColorText(#quotes .. " quotes", COLORS.text_dim))
  
  local yOffset = 0
  for i, quote in ipairs(quotes) do
    local row = CreateFrame("Button", nil, listContent, BackdropTemplateMixin and "BackdropTemplate")
    row:SetSize(listContent:GetWidth() - 10, 55)
    row:SetPoint("TOPLEFT", listContent, "TOPLEFT", 5, -yOffset)
    
    row:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Buttons\\WHITE8x8",
      edgeSize = 1,
    })
    
    local isEnabled = quote.enabled ~= false
    local catColor = CAT_COLORS[quote.category] or COLORS.text_dim
    local bgColor = isEnabled and {0.12, 0.12, 0.16, 0.9} or {0.18, 0.12, 0.12, 0.9}
    row:SetBackdropColor(unpack(bgColor))
    row:SetBackdropBorderColor(catColor[1] * 0.5, catColor[2] * 0.5, catColor[3] * 0.5, 0.7)
    
    -- Store index for click handler
    row.quoteIndex = i
    
    -- Click to edit
    row:SetScript("OnClick", function(self)
      if MageQuotes_OpenQuoteEditor then
        MageQuotes_OpenQuoteEditor(self.quoteIndex)
      end
    end)
    
    row:SetScript("OnEnter", function(self)
      self:SetBackdropColor(catColor[1] * 0.25, catColor[2] * 0.25, catColor[3] * 0.25, 0.95)
      self:SetBackdropBorderColor(catColor[1], catColor[2], catColor[3], 1)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click to Edit", 1, 1, 1)
      GameTooltip:AddLine(quote.text or "", 0.8, 0.8, 0.8, true)
      GameTooltip:Show()
    end)
    
    row:SetScript("OnLeave", function(self)
      self:SetBackdropColor(unpack(bgColor))
      self:SetBackdropBorderColor(catColor[1] * 0.5, catColor[2] * 0.5, catColor[3] * 0.5, 0.7)
      GameTooltip:Hide()
    end)
    
    -- Quote number
    local numText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    numText:SetPoint("TOPLEFT", row, "TOPLEFT", 8, -6)
    numText:SetText(ColorText("#" .. i, COLORS.text_dim))
    
    -- Category badge with color
    local catBadge = CreateFrame("Frame", nil, row, BackdropTemplateMixin and "BackdropTemplate")
    catBadge:SetSize(48, 16)
    catBadge:SetPoint("LEFT", numText, "RIGHT", 6, 0)
    catBadge:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Buttons\\WHITE8x8",
      edgeSize = 1,
    })
    catBadge:SetBackdropColor(catColor[1] * 0.3, catColor[2] * 0.3, catColor[3] * 0.3, 0.9)
    catBadge:SetBackdropBorderColor(catColor[1], catColor[2], catColor[3], 0.8)
    
    local catText = catBadge:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    catText:SetPoint("CENTER")
    catText:SetText(quote.category or "?")
    catText:SetTextColor(catColor[1], catColor[2], catColor[3])
    
    -- Quote text (truncated)
    local quoteText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    quoteText:SetPoint("TOPLEFT", numText, "BOTTOMLEFT", 0, -4)
    quoteText:SetPoint("RIGHT", row, "RIGHT", -110, 0)
    quoteText:SetJustifyH("LEFT")
    local displayText = quote.text or ""
    if #displayText > 50 then
      displayText = displayText:sub(1, 47) .. "..."
    end
    quoteText:SetText(displayText)
    
    -- Spec indicator
    if quote.spec and quote.spec ~= "all" then
      local specColor = ({
        arcane = COLORS.arcane,
        fire = COLORS.fire,
        frost = COLORS.frost,
      })[quote.spec] or COLORS.text_dim
      
      local specText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
      specText:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 8, 6)
      specText:SetText(quote.spec:upper())
      specText:SetTextColor(specColor[1], specColor[2], specColor[3])
    end
    
    -- Sound indicator
    if quote.sound and quote.sound ~= "" then
      local soundIcon = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
      soundIcon:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", quote.spec and quote.spec ~= "all" and 55 or 8, 6)
      soundIcon:SetText(ColorText("[sound]", COLORS.text_dim))
    end
    
    -- Toggle Button
    local toggleBtn = CreateFrame("Button", nil, row, BackdropTemplateMixin and "BackdropTemplate")
    toggleBtn:SetSize(42, 20)
    toggleBtn:SetPoint("RIGHT", row, "RIGHT", -48, 0)
    toggleBtn:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Buttons\\WHITE8x8",
      edgeSize = 1,
    })
    
    local toggleState = isEnabled
    toggleBtn:SetBackdropColor(toggleState and 0.15 or 0.25, toggleState and 0.35 or 0.12, toggleState and 0.15 or 0.12, 0.9)
    toggleBtn:SetBackdropBorderColor(unpack(toggleState and COLORS.success or COLORS.error))
    
    local toggleLabel = toggleBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    toggleLabel:SetPoint("CENTER")
    toggleLabel:SetText(toggleState and "ON" or "OFF")
    toggleLabel:SetTextColor(unpack(toggleState and COLORS.success or COLORS.error))
    
    -- Store index for toggle
    toggleBtn.quoteIndex = i
    toggleBtn.currentState = toggleState
    
    toggleBtn:SetScript("OnClick", function(self)
      if MageQuotes_ToggleCustomQuote then
        MageQuotes_ToggleCustomQuote(self.quoteIndex, not self.currentState)
        RefreshCustomQuoteList()
      end
    end)
    
    -- Prevent row hover when over toggle
    toggleBtn:SetScript("OnEnter", function(self)
      self:GetParent():SetBackdropColor(unpack(bgColor))
      GameTooltip:Hide()
    end)
    
    -- Delete Button
    local deleteBtn = CreateFrame("Button", nil, row, BackdropTemplateMixin and "BackdropTemplate")
    deleteBtn:SetSize(32, 20)
    deleteBtn:SetPoint("RIGHT", row, "RIGHT", -8, 0)
    deleteBtn:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Buttons\\WHITE8x8",
      edgeSize = 1,
    })
    deleteBtn:SetBackdropColor(0.35, 0.1, 0.1, 0.9)
    deleteBtn:SetBackdropBorderColor(unpack(COLORS.error))
    
    local deleteLabel = deleteBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    deleteLabel:SetPoint("CENTER")
    deleteLabel:SetText("X")
    deleteLabel:SetTextColor(unpack(COLORS.error))
    
    -- Store index for delete
    deleteBtn.quoteIndex = i
    
    deleteBtn:SetScript("OnClick", function(self)
      if MageQuotes_DeleteCustomQuote then
        MageQuotes_DeleteCustomQuote(self.quoteIndex)
        RefreshCustomQuoteList()
      end
    end)
    
    deleteBtn:SetScript("OnEnter", function(self)
      self:SetBackdropColor(0.55, 0.15, 0.15, 1)
      self:GetParent():SetBackdropColor(unpack(bgColor))
      GameTooltip:Hide()
    end)
    
    deleteBtn:SetScript("OnLeave", function(self)
      self:SetBackdropColor(0.35, 0.1, 0.1, 0.9)
    end)
    
    table.insert(quoteRows, row)
    yOffset = yOffset + 58
  end
  
  listContent:SetHeight(math.max(yOffset + 20, listScroll:GetHeight()))
end

-- Button Scripts
addQuoteBtn:SetScript("OnClick", function()
  local text = quoteTextBox:GetText()
  if not text or text == "" then
    editorStatusText:SetText(ColorText("Enter quote text!", COLORS.error))
    return
  end
  
  local sound = soundBox:GetText()
  if sound == "" then sound = nil end
  
  if MageQuotes_AddCustomQuote then
    local success, msg, quoteIndex = MageQuotes_AddCustomQuote(text, selectedCategory, sound, selectedSpec)
    if success then
      -- Save spell triggers if any were configured
      if currentQuoteTriggers.spells and #currentQuoteTriggers.spells > 0 and quoteIndex then
        for _, spell in ipairs(currentQuoteTriggers.spells) do
          if MageQuotes_AddSpellTrigger then
            MageQuotes_AddSpellTrigger(spell.id, { quoteIndex })
          end
        end
      end
      
      editorStatusText:SetText(ColorText("Quote added!", COLORS.success))
      quoteTextBox:SetText("")
      soundBox:SetText("")
      -- Reset triggers for next quote
      currentQuoteTriggers = { situations = {}, spells = {} }
      UpdateTriggerSummary()
      RefreshCustomQuoteList()
    else
      editorStatusText:SetText(ColorText(msg or "Failed!", COLORS.error))
    end
  else
    editorStatusText:SetText(ColorText("Module not loaded!", COLORS.error))
  end
end)

exportBtn:SetScript("OnClick", function()
  if MageQuotes_ExportCustomQuotes then
    local exportStr, err = MageQuotes_ExportCustomQuotes("My Quote Pack")
    if exportStr then
      importFrame:Show()
      importBox:SetText(exportStr)
      importBox:HighlightText()
      importBox:SetFocus()
      editorStatusText:SetText(ColorText("Exported! Copy the string above.", COLORS.success))
    else
      editorStatusText:SetText(ColorText(err or "Export failed!", COLORS.error))
    end
  end
end)

importBtn:SetScript("OnClick", function()
  importFrame:Show()
  importBox:SetText("")
  importBox:SetFocus()
  editorStatusText:SetText(ColorText("Paste import string and click Go", COLORS.accent))
end)

doImportBtn:SetScript("OnClick", function()
  local importStr = importBox:GetText()
  if importStr and importStr ~= "" then
    if MageQuotes_ImportQuotePack then
      local success, msg = MageQuotes_ImportQuotePack(importStr, true)
      if success then
        editorStatusText:SetText(ColorText(msg, COLORS.success))
        importFrame:Hide()
        RefreshCustomQuoteList()
      else
        editorStatusText:SetText(ColorText(msg or "Import failed!", COLORS.error))
      end
    end
  end
end)

clearAllBtn:SetScript("OnClick", function()
  StaticPopup_Show("MAGEQUOTES_CONFIRM_CLEAR_CUSTOM")
end)

CustomTab:SetScript("OnShow", function()
  RefreshCustomQuoteList()
  editorStatusText:SetText("")
  importFrame:Hide()
end)

-- Register for updates from the module
if MageQuotes_EventBus and MageQuotes_EventBus.RegisterCallback then
  MageQuotes_EventBus:RegisterCallback("MAGE_QUOTES_CUSTOM_UPDATED", function()
    if CustomTab:IsVisible() then
      RefreshCustomQuoteList()
    end
  end, "MageQuotes_UI")
end

end -- End TAB 8 scope

------------------------------------------------------------
-- QUOTE EDITOR MODAL - Opens when clicking a quote to edit
------------------------------------------------------------
local QuoteEditorModal = CreateFrame("Frame", "MageQuotesQuoteEditorModal", UIParent, BackdropTemplateMixin and "BackdropTemplate")
QuoteEditorModal:SetSize(480, 400)
QuoteEditorModal:SetPoint("CENTER")
QuoteEditorModal:SetFrameStrata("FULLSCREEN_DIALOG")
QuoteEditorModal:SetFrameLevel(200)
QuoteEditorModal:EnableMouse(true)
QuoteEditorModal:SetMovable(true)
QuoteEditorModal:RegisterForDrag("LeftButton")
QuoteEditorModal:SetScript("OnDragStart", QuoteEditorModal.StartMoving)
QuoteEditorModal:SetScript("OnDragStop", QuoteEditorModal.StopMovingOrSizing)
QuoteEditorModal:Hide()

QuoteEditorModal:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 32, edgeSize = 16,
  insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
QuoteEditorModal:SetBackdropColor(0.1, 0.1, 0.15, 0.98)
QuoteEditorModal:SetBackdropBorderColor(0.7, 0.55, 0.2, 1)

-- Modal Title Bar
local editorModalTitleBar = CreateFrame("Frame", nil, QuoteEditorModal, BackdropTemplateMixin and "BackdropTemplate")
editorModalTitleBar:SetSize(QuoteEditorModal:GetWidth() - 10, 36)
editorModalTitleBar:SetPoint("TOP", QuoteEditorModal, "TOP", 0, -5)
editorModalTitleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
editorModalTitleBar:SetBackdropColor(0.15, 0.12, 0.08, 1)
editorModalTitleBar:EnableMouse(true)
editorModalTitleBar:RegisterForDrag("LeftButton")
editorModalTitleBar:SetScript("OnDragStart", function() QuoteEditorModal:StartMoving() end)
editorModalTitleBar:SetScript("OnDragStop", function() QuoteEditorModal:StopMovingOrSizing() end)

local editorModalTitleText = editorModalTitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
editorModalTitleText:SetPoint("LEFT", editorModalTitleBar, "LEFT", 15, 0)
editorModalTitleText:SetText("|cffffcc00Edit Quote|r")

local editorModalCloseBtn = CreateFrame("Button", nil, editorModalTitleBar)
editorModalCloseBtn:SetSize(24, 24)
editorModalCloseBtn:SetPoint("RIGHT", editorModalTitleBar, "RIGHT", -8, 0)
local editorModalCloseTxt = editorModalCloseBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
editorModalCloseTxt:SetPoint("CENTER")
editorModalCloseTxt:SetText("|cffff6666X|r")
editorModalCloseBtn:SetScript("OnClick", function() QuoteEditorModal:Hide() end)
editorModalCloseBtn:SetScript("OnEnter", function() editorModalCloseTxt:SetText("|cffff3333X|r") end)
editorModalCloseBtn:SetScript("OnLeave", function() editorModalCloseTxt:SetText("|cffff6666X|r") end)

-- Modal Content
local editorModalContent = CreateFrame("Frame", nil, QuoteEditorModal)
editorModalContent:SetPoint("TOPLEFT", editorModalTitleBar, "BOTTOMLEFT", 10, -10)
editorModalContent:SetPoint("BOTTOMRIGHT", QuoteEditorModal, "BOTTOMRIGHT", -10, 55)

local editingQuoteIndex = nil

-- Edit Text
local editTextLabel = editorModalContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
editTextLabel:SetPoint("TOPLEFT", editorModalContent, "TOPLEFT", 0, 0)
editTextLabel:SetText("|cffffffffQuote Text:|r")

local editTextBox = CreateFrame("EditBox", nil, editorModalContent, BackdropTemplateMixin and "BackdropTemplate")
editTextBox:SetPoint("TOPLEFT", editTextLabel, "BOTTOMLEFT", 0, -5)
editTextBox:SetSize(440, 60)
editTextBox:SetMultiLine(true)
editTextBox:SetAutoFocus(false)
editTextBox:SetFontObject(GameFontHighlight)
editTextBox:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
editTextBox:SetBackdropColor(0.08, 0.08, 0.1, 1)
editTextBox:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
editTextBox:SetTextInsets(8, 8, 8, 8)
editTextBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

-- Edit Category
local editCatLabel = editorModalContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
editCatLabel:SetPoint("TOPLEFT", editTextBox, "BOTTOMLEFT", 0, -12)
editCatLabel:SetText("|cffffffffCategory:|r")

local editCategoryButtons = {}
local editSelectedCategory = "init"
local editCatFrame = CreateFrame("Frame", nil, editorModalContent)
editCatFrame:SetPoint("TOPLEFT", editCatLabel, "BOTTOMLEFT", 0, -5)
editCatFrame:SetSize(440, 28)

local editCategories = {
  { key = "init", name = "Combat", color = CAT_COLORS.init },
  { key = "kill", name = "Kill", color = CAT_COLORS.kill },
  { key = "surv", name = "Survival", color = CAT_COLORS.surv },
  { key = "vict", name = "Victory", color = CAT_COLORS.vict },
  { key = "rare", name = "Rare", color = CAT_COLORS.rare },
  { key = "mid", name = "Mid", color = CAT_COLORS.mid },
  { key = "greet", name = "Greet", color = CAT_COLORS.greet },
}

local function UpdateEditCategorySelection()
  for _, cat in ipairs(editCategories) do
    local btn = editCategoryButtons[cat.key]
    if btn then
      if cat.key == editSelectedCategory then
        btn:SetBackdropColor(cat.color[1], cat.color[2], cat.color[3], 0.5)
        btn:SetBackdropBorderColor(cat.color[1], cat.color[2], cat.color[3], 1)
      else
        btn:SetBackdropColor(0.15, 0.15, 0.2, 0.8)
        btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
      end
    end
  end
end

for i, cat in ipairs(editCategories) do
  local btn = CreateFrame("Button", nil, editCatFrame, BackdropTemplateMixin and "BackdropTemplate")
  btn:SetSize(60, 24)
  btn:SetPoint("LEFT", editCatFrame, "LEFT", (i-1) * 63, 0)
  btn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
  })
  btn:SetBackdropColor(0.15, 0.15, 0.2, 0.8)
  btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
  
  local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("CENTER")
  label:SetText(cat.name)
  label:SetTextColor(cat.color[1], cat.color[2], cat.color[3])
  
  btn:SetScript("OnClick", function()
    editSelectedCategory = cat.key
    UpdateEditCategorySelection()
  end)
  
  editCategoryButtons[cat.key] = btn
end

-- Edit Spec
local editSpecLabel = editorModalContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
editSpecLabel:SetPoint("TOPLEFT", editCatFrame, "BOTTOMLEFT", 0, -12)
editSpecLabel:SetText("|cffffffffSpec:|r")

local editSpecButtons = {}
local editSelectedSpec = "all"
local editSpecFrame = CreateFrame("Frame", nil, editorModalContent)
editSpecFrame:SetPoint("LEFT", editSpecLabel, "RIGHT", 10, 0)
editSpecFrame:SetSize(300, 24)

local editSpecs = {
  { key = "all", name = "All", color = {0.7, 0.7, 0.7} },
  { key = "arcane", name = "Arcane", color = COLORS.arcane },
  { key = "fire", name = "Fire", color = COLORS.fire },
  { key = "frost", name = "Frost", color = COLORS.frost },
}

local function UpdateEditSpecSelection()
  for _, spec in ipairs(editSpecs) do
    local btn = editSpecButtons[spec.key]
    if btn then
      if spec.key == editSelectedSpec then
        btn:SetBackdropColor(spec.color[1], spec.color[2], spec.color[3], 0.4)
        btn:SetBackdropBorderColor(spec.color[1], spec.color[2], spec.color[3], 1)
      else
        btn:SetBackdropColor(0.15, 0.15, 0.2, 0.8)
        btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
      end
    end
  end
end

for i, spec in ipairs(editSpecs) do
  local btn = CreateFrame("Button", nil, editSpecFrame, BackdropTemplateMixin and "BackdropTemplate")
  btn:SetSize(65, 22)
  btn:SetPoint("LEFT", editSpecFrame, "LEFT", (i-1) * 70, 0)
  btn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
  })
  btn:SetBackdropColor(0.15, 0.15, 0.2, 0.8)
  btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
  
  local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("CENTER")
  label:SetText(spec.name)
  label:SetTextColor(spec.color[1], spec.color[2], spec.color[3])
  
  btn:SetScript("OnClick", function()
    editSelectedSpec = spec.key
    UpdateEditSpecSelection()
  end)
  
  editSpecButtons[spec.key] = btn
end

-- Edit Sound
local editSoundLabel = editorModalContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
editSoundLabel:SetPoint("TOPLEFT", editSpecLabel, "BOTTOMLEFT", 0, -12)
editSoundLabel:SetText("|cffffffffSound:|r " .. ColorText("(optional)", COLORS.text_dim))

local editSoundBox = CreateFrame("EditBox", nil, editorModalContent, BackdropTemplateMixin and "BackdropTemplate")
editSoundBox:SetPoint("TOPLEFT", editSoundLabel, "BOTTOMLEFT", 0, -5)
editSoundBox:SetSize(300, 24)
editSoundBox:SetAutoFocus(false)
editSoundBox:SetFontObject(GameFontHighlightSmall)
editSoundBox:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
editSoundBox:SetBackdropColor(0.08, 0.08, 0.1, 1)
editSoundBox:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
editSoundBox:SetTextInsets(6, 6, 0, 0)
editSoundBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

-- Modal Footer
local editorModalFooter = CreateFrame("Frame", nil, QuoteEditorModal, BackdropTemplateMixin and "BackdropTemplate")
editorModalFooter:SetSize(QuoteEditorModal:GetWidth() - 10, 45)
editorModalFooter:SetPoint("BOTTOM", QuoteEditorModal, "BOTTOM", 0, 5)
editorModalFooter:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
editorModalFooter:SetBackdropColor(0.12, 0.12, 0.15, 1)

-- Delete Button
local editDeleteBtn = CreateModernButton(editorModalFooter, "Delete", 90, 32)
editDeleteBtn:SetPoint("LEFT", editorModalFooter, "LEFT", 15, 0)
editDeleteBtn:SetBackdropColor(0.5, 0.15, 0.15, 0.9)
editDeleteBtn:SetBackdropBorderColor(1.0, 0.3, 0.3, 1)
editDeleteBtn.label:SetTextColor(1, 0.5, 0.5)

editDeleteBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.7, 0.2, 0.2, 1)
end)
editDeleteBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.5, 0.15, 0.15, 0.9)
end)

-- Cancel Button
local editCancelBtn = CreateModernButton(editorModalFooter, "Cancel", 90, 32)
editCancelBtn:SetPoint("RIGHT", editorModalFooter, "CENTER", -10, 0)
editCancelBtn:SetScript("OnClick", function() QuoteEditorModal:Hide() end)

-- Save Button
local editSaveBtn = CreateModernButton(editorModalFooter, "Save", 100, 32)
editSaveBtn:SetPoint("LEFT", editorModalFooter, "CENTER", 10, 0)
editSaveBtn:SetBackdropColor(0.2, 0.5, 0.3, 0.9)
editSaveBtn:SetBackdropBorderColor(0.3, 0.8, 0.4, 1)
editSaveBtn.label:SetTextColor(0.8, 1, 0.8)

editSaveBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.25, 0.6, 0.35, 1)
end)
editSaveBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.2, 0.5, 0.3, 0.9)
end)

-- Copy/Export Button
local editExportBtn = CreateModernButton(editorModalFooter, "Copy", 70, 32)
editExportBtn:SetPoint("RIGHT", editorModalFooter, "RIGHT", -15, 0)
editExportBtn:SetBackdropColor(0.2, 0.3, 0.5, 0.8)

-- Quote Editor Functions
MageQuotes_OpenQuoteEditor = function(quoteIndex)
  if not quoteIndex then return end
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.customQuotes = MageQuotesDB.customQuotes or {}
  
  local quote = MageQuotesDB.customQuotes[quoteIndex]
  if not quote then return end
  
  editingQuoteIndex = quoteIndex
  
  -- Populate fields
  editTextBox:SetText(quote.text or "")
  editSoundBox:SetText(quote.sound or "")
  editSelectedCategory = quote.category or "init"
  editSelectedSpec = quote.spec or "all"
  
  -- Update UI
  UpdateEditCategorySelection()
  UpdateEditSpecSelection()
  
  editorModalTitleText:SetText("|cffffcc00Edit Quote #" .. quoteIndex .. "|r")
  QuoteEditorModal:Show()
end

-- Save button handler
editSaveBtn:SetScript("OnClick", function()
  if not editingQuoteIndex then return end
  
  local newText = editTextBox:GetText()
  if not newText or newText == "" then
    print("|cffff6666MageQuotes:|r Quote text cannot be empty!")
    return
  end
  
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.customQuotes = MageQuotesDB.customQuotes or {}
  
  if MageQuotesDB.customQuotes[editingQuoteIndex] then
    local quote = MageQuotesDB.customQuotes[editingQuoteIndex]
    quote.text = newText
    quote.category = editSelectedCategory
    quote.spec = editSelectedSpec
    quote.sound = editSoundBox:GetText() or ""
    
    -- Trigger cache rebuild
    if MageQuotes_EventBus and MageQuotes_EventBus.TriggerEvent then
      MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_CUSTOM_UPDATED")
    end
    
    print("|cff00ff00MageQuotes:|r Quote #" .. editingQuoteIndex .. " saved!")
  end
  
  QuoteEditorModal:Hide()
  if RefreshCustomQuoteList then RefreshCustomQuoteList() end
end)

-- Delete button handler
editDeleteBtn:SetScript("OnClick", function()
  if not editingQuoteIndex then return end
  
  if MageQuotes_DeleteCustomQuote then
    MageQuotes_DeleteCustomQuote(editingQuoteIndex)
    print("|cffff9900MageQuotes:|r Quote deleted!")
  end
  
  QuoteEditorModal:Hide()
  if RefreshCustomQuoteList then RefreshCustomQuoteList() end
end)

-- Copy/Export button handler
editExportBtn:SetScript("OnClick", function()
  if not editingQuoteIndex then return end
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.customQuotes = MageQuotesDB.customQuotes or {}
  
  local quote = MageQuotesDB.customQuotes[editingQuoteIndex]
  if quote then
    local cmd = "/mqc add " .. (quote.category or "init") .. " " .. (quote.text or "")
    print("|cffffcc00MageQuotes Export:|r Copy this command:")
    print("|cff88bbff" .. cmd .. "|r")
  end
end)

------------------------------------------------------------
-- MODERN TRIGGER PICKER MODAL
-- Redesigned with card-based UI, smooth animations, and better UX
------------------------------------------------------------
local TriggerPickerModal = CreateFrame("Frame", "MageQuotesTriggerPicker", UIParent, BackdropTemplateMixin and "BackdropTemplate")
TriggerPickerModal:SetSize(500, 520)
TriggerPickerModal:SetPoint("CENTER")
TriggerPickerModal:SetFrameStrata("DIALOG")
TriggerPickerModal:SetFrameLevel(100)
TriggerPickerModal:EnableMouse(true)
TriggerPickerModal:SetMovable(true)
TriggerPickerModal:RegisterForDrag("LeftButton")
TriggerPickerModal:SetScript("OnDragStart", TriggerPickerModal.StartMoving)
TriggerPickerModal:SetScript("OnDragStop", TriggerPickerModal.StopMovingOrSizing)

-- Modern gradient-style backdrop
TriggerPickerModal:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 2,
  insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
TriggerPickerModal:SetBackdropColor(0.08, 0.08, 0.12, 0.98)
TriggerPickerModal:SetBackdropBorderColor(0.5, 0.65, 1.0, 0.8)
TriggerPickerModal:Hide()

-- Glow effect border
local modalGlow = TriggerPickerModal:CreateTexture(nil, "BACKGROUND", nil, -1)
modalGlow:SetPoint("TOPLEFT", -4, 4)
modalGlow:SetPoint("BOTTOMRIGHT", 4, -4)
modalGlow:SetTexture("Interface\\Buttons\\WHITE8x8")
modalGlow:SetVertexColor(0.4, 0.6, 1.0, 0.15)

-- Make closable with ESC
tinsert(UISpecialFrames, "MageQuotesTriggerPicker")

-- Header bar
local modalHeader = CreateFrame("Frame", nil, TriggerPickerModal, BackdropTemplateMixin and "BackdropTemplate")
modalHeader:SetSize(TriggerPickerModal:GetWidth() - 4, 44)
modalHeader:SetPoint("TOP", TriggerPickerModal, "TOP", 0, -2)
modalHeader:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
})
modalHeader:SetBackdropColor(0.12, 0.14, 0.2, 1)

-- Header icon
local headerIcon = modalHeader:CreateTexture(nil, "ARTWORK")
headerIcon:SetSize(24, 24)
headerIcon:SetPoint("LEFT", modalHeader, "LEFT", 16, 0)
headerIcon:SetTexture("Interface\\Icons\\Spell_Nature_Lightning")
headerIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

-- Modal Title
local modalTitle = modalHeader:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
modalTitle:SetPoint("LEFT", headerIcon, "RIGHT", 10, 0)
modalTitle:SetText("|cff99bbffTriggers|r")

-- Subtitle
local modalSubtitle = modalHeader:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
modalSubtitle:SetPoint("LEFT", modalTitle, "RIGHT", 10, 0)
modalSubtitle:SetText("|cff888888Configure when this quote fires|r")

-- Close Button (Modern X)
local modalCloseBtn = CreateFrame("Button", nil, modalHeader, BackdropTemplateMixin and "BackdropTemplate")
modalCloseBtn:SetSize(28, 28)
modalCloseBtn:SetPoint("RIGHT", modalHeader, "RIGHT", -10, 0)
modalCloseBtn:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
modalCloseBtn:SetBackdropColor(0.3, 0.1, 0.1, 0.6)
modalCloseBtn:SetBackdropBorderColor(0.6, 0.2, 0.2, 0.8)

local closeX = modalCloseBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
closeX:SetPoint("CENTER", 0, 1)
closeX:SetText("X")
closeX:SetTextColor(1, 0.5, 0.5, 1)

modalCloseBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.5, 0.15, 0.15, 0.9)
  self:SetBackdropBorderColor(1, 0.3, 0.3, 1)
end)
modalCloseBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.3, 0.1, 0.1, 0.6)
  self:SetBackdropBorderColor(0.6, 0.2, 0.2, 0.8)
end)
modalCloseBtn:SetScript("OnClick", function()
  TriggerPickerModal:Hide()
end)

-- Store selections
local modalSelectedTriggers = { situations = {}, spells = {} }
local modalCallback = nil

-- Content area
local modalContent = CreateFrame("Frame", nil, TriggerPickerModal)
modalContent:SetPoint("TOPLEFT", modalHeader, "BOTTOMLEFT", 16, -16)
modalContent:SetPoint("BOTTOMRIGHT", TriggerPickerModal, "BOTTOMRIGHT", -16, 60)

-- ===== SECTION 1: Situations Card =====
local situationsCard = CreateFrame("Frame", nil, modalContent, BackdropTemplateMixin and "BackdropTemplate")
situationsCard:SetSize(modalContent:GetWidth(), 140)
situationsCard:SetPoint("TOPLEFT", modalContent, "TOPLEFT", 0, 0)
situationsCard:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
situationsCard:SetBackdropColor(0.1, 0.1, 0.14, 0.8)
situationsCard:SetBackdropBorderColor(0.3, 0.3, 0.4, 0.8)

-- Situations header with icon
local sitIcon = situationsCard:CreateTexture(nil, "ARTWORK")
sitIcon:SetSize(20, 20)
sitIcon:SetPoint("TOPLEFT", situationsCard, "TOPLEFT", 12, -10)
sitIcon:SetTexture("Interface\\Icons\\Ability_Rogue_Sprint")
sitIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local situationsHeader = situationsCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
situationsHeader:SetPoint("LEFT", sitIcon, "RIGHT", 8, 0)
situationsHeader:SetText("|cffffcc66Game Events|r")

local sitDesc = situationsCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
sitDesc:SetPoint("TOPLEFT", sitIcon, "BOTTOMLEFT", 0, -8)
sitDesc:SetText("|cff888888Trigger on combat events|r")

local situationOptions = {
  { key = "combat_enter", text = "Enter Combat", icon = "Interface\\Icons\\Ability_Warrior_Charge", desc = "When you start fighting" },
  { key = "combat_leave", text = "Leave Combat", icon = "Interface\\Icons\\Spell_Nature_Sleep", desc = "When combat ends" },
  { key = "cast_success", text = "Spell Cast", icon = "Interface\\Icons\\Spell_Fire_Fireball02", desc = "After casting a spell" },
  { key = "interrupt", text = "Interrupt", icon = "Interface\\Icons\\Ability_Kick", desc = "When you interrupt an enemy" },
}

local situationCheckboxes = {}
local sitY = -55

for i, sit in ipairs(situationOptions) do
  local row = CreateFrame("Frame", nil, situationsCard, BackdropTemplateMixin and "BackdropTemplate")
  row:SetSize(220, 26)
  
  local col = (i - 1) % 2
  local rowNum = math.floor((i - 1) / 2)
  row:SetPoint("TOPLEFT", situationsCard, "TOPLEFT", 12 + col * 228, sitY - rowNum * 30)
  
  row:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
  })
  row:SetBackdropColor(0.15, 0.15, 0.2, 0.6)
  row:SetBackdropBorderColor(0.25, 0.25, 0.35, 0.6)
  
  local cb = CreateFrame("CheckButton", nil, row)
  cb:SetSize(20, 20)
  cb:SetPoint("LEFT", row, "LEFT", 6, 0)
  
  -- Custom checkbox textures
  local cbBg = cb:CreateTexture(nil, "BACKGROUND")
  cbBg:SetAllPoints()
  cbBg:SetTexture("Interface\\Buttons\\WHITE8x8")
  cbBg:SetVertexColor(0.1, 0.1, 0.15, 1)
  
  local cbCheck = cb:CreateTexture(nil, "ARTWORK")
  cbCheck:SetSize(14, 14)
  cbCheck:SetPoint("CENTER")
  cbCheck:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
  cbCheck:Hide()
  cb.checkMark = cbCheck
  
  local cbBorder = cb:CreateTexture(nil, "OVERLAY")
  cbBorder:SetPoint("TOPLEFT", -1, 1)
  cbBorder:SetPoint("BOTTOMRIGHT", 1, -1)
  cbBorder:SetTexture("Interface\\Buttons\\WHITE8x8")
  cbBorder:SetVertexColor(0.4, 0.4, 0.5, 1)
  cb.border = cbBorder
  
  local icon = row:CreateTexture(nil, "ARTWORK")
  icon:SetSize(18, 18)
  icon:SetPoint("LEFT", cb, "RIGHT", 6, 0)
  icon:SetTexture(sit.icon)
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  
  local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("LEFT", icon, "RIGHT", 6, 0)
  label:SetText(sit.text)
  label:SetTextColor(0.9, 0.9, 0.95, 1)
  
  cb.sitKey = sit.key
  
  local function UpdateCheckVisual()
    if cb:GetChecked() then
      cbCheck:Show()
      cbBorder:SetVertexColor(0.4, 0.7, 1.0, 1)
      row:SetBackdropColor(0.2, 0.25, 0.35, 0.8)
      row:SetBackdropBorderColor(0.4, 0.5, 0.7, 0.8)
    else
      cbCheck:Hide()
      cbBorder:SetVertexColor(0.4, 0.4, 0.5, 1)
      row:SetBackdropColor(0.15, 0.15, 0.2, 0.6)
      row:SetBackdropBorderColor(0.25, 0.25, 0.35, 0.6)
    end
  end
  
  cb:SetScript("OnClick", function(self)
    modalSelectedTriggers.situations = modalSelectedTriggers.situations or {}
    if self:GetChecked() then
      modalSelectedTriggers.situations[sit.key] = true
    else
      modalSelectedTriggers.situations[sit.key] = nil
    end
    UpdateCheckVisual()
  end)
  
  row:SetScript("OnMouseDown", function()
    cb:SetChecked(not cb:GetChecked())
    cb:GetScript("OnClick")(cb)
  end)
  
  row:SetScript("OnEnter", function(self)
    if not cb:GetChecked() then
      self:SetBackdropColor(0.18, 0.18, 0.25, 0.8)
    end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(sit.text, 1, 1, 1)
    GameTooltip:AddLine(sit.desc, 0.7, 0.7, 0.7, true)
    GameTooltip:Show()
  end)
  
  row:SetScript("OnLeave", function(self)
    UpdateCheckVisual()
    GameTooltip:Hide()
  end)
  
  cb.UpdateVisual = UpdateCheckVisual
  situationCheckboxes[sit.key] = cb
end

-- ===== SECTION 2: Spell Triggers Card =====
local spellsCard = CreateFrame("Frame", nil, modalContent, BackdropTemplateMixin and "BackdropTemplate")
spellsCard:SetSize(modalContent:GetWidth(), 260)
spellsCard:SetPoint("TOPLEFT", situationsCard, "BOTTOMLEFT", 0, -12)
spellsCard:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
spellsCard:SetBackdropColor(0.1, 0.1, 0.14, 0.8)
spellsCard:SetBackdropBorderColor(0.3, 0.3, 0.4, 0.8)

-- Spells header with icon
local spellIcon = spellsCard:CreateTexture(nil, "ARTWORK")
spellIcon:SetSize(20, 20)
spellIcon:SetPoint("TOPLEFT", spellsCard, "TOPLEFT", 12, -10)
spellIcon:SetTexture("Interface\\Icons\\Spell_Nature_WispSplode")
spellIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local spellsHeader = spellsCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
spellsHeader:SetPoint("LEFT", spellIcon, "RIGHT", 8, 0)
spellsHeader:SetText("|cff66ff99Spell Triggers|r")

local spellDesc = spellsCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
spellDesc:SetPoint("TOPLEFT", spellIcon, "BOTTOMLEFT", 0, -6)
spellDesc:SetText("|cff888888Fire quote when you cast specific spells|r")

-- Spell input container
local spellInputContainer = CreateFrame("Frame", nil, spellsCard, BackdropTemplateMixin and "BackdropTemplate")
spellInputContainer:SetSize(spellsCard:GetWidth() - 24, 60)
spellInputContainer:SetPoint("TOPLEFT", spellDesc, "BOTTOMLEFT", 0, -10)
spellInputContainer:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
spellInputContainer:SetBackdropColor(0.06, 0.06, 0.08, 0.9)
spellInputContainer:SetBackdropBorderColor(0.2, 0.2, 0.3, 0.8)

-- Spell icon drop target (larger, more prominent)
local modalSpellIcon = CreateFrame("Button", nil, spellInputContainer, BackdropTemplateMixin and "BackdropTemplate")
modalSpellIcon:SetSize(48, 48)
modalSpellIcon:SetPoint("LEFT", spellInputContainer, "LEFT", 8, 0)
modalSpellIcon:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 2,
})
modalSpellIcon:SetBackdropColor(0.1, 0.1, 0.15, 1)
modalSpellIcon:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)

local modalSpellIconTexture = modalSpellIcon:CreateTexture(nil, "ARTWORK")
modalSpellIconTexture:SetPoint("TOPLEFT", 3, -3)
modalSpellIconTexture:SetPoint("BOTTOMRIGHT", -3, 3)
modalSpellIconTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
modalSpellIconTexture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

-- Drop hint overlay
local dropHint = modalSpellIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
dropHint:SetPoint("CENTER")
dropHint:SetText("|cff666666DROP|r")

-- Spell ID input
local spellIdLabel = spellInputContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
spellIdLabel:SetPoint("TOPLEFT", modalSpellIcon, "TOPRIGHT", 12, -4)
spellIdLabel:SetText("|cffaaaaaaSpell ID:|r")

local modalSpellIdBox = CreateFrame("EditBox", nil, spellInputContainer, BackdropTemplateMixin and "BackdropTemplate")
modalSpellIdBox:SetSize(90, 22)
modalSpellIdBox:SetPoint("LEFT", spellIdLabel, "RIGHT", 8, 0)
modalSpellIdBox:SetAutoFocus(false)
modalSpellIdBox:SetFontObject(GameFontHighlight)
modalSpellIdBox:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
modalSpellIdBox:SetBackdropColor(0.08, 0.08, 0.1, 1)
modalSpellIdBox:SetBackdropBorderColor(0.35, 0.35, 0.45, 1)
modalSpellIdBox:SetTextInsets(8, 8, 0, 0)

local modalSpellNameDisplay = spellInputContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
modalSpellNameDisplay:SetPoint("BOTTOMLEFT", modalSpellIcon, "BOTTOMRIGHT", 12, 4)
modalSpellNameDisplay:SetText("|cff666666No spell selected|r")
modalSpellNameDisplay:SetWidth(250)
modalSpellNameDisplay:SetJustifyH("LEFT")

-- Add Spell button (modern)
local addSpellBtn = CreateFrame("Button", nil, spellInputContainer, BackdropTemplateMixin and "BackdropTemplate")
addSpellBtn:SetSize(60, 40)
addSpellBtn:SetPoint("RIGHT", spellInputContainer, "RIGHT", -8, 0)
addSpellBtn:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
addSpellBtn:SetBackdropColor(0.2, 0.5, 0.3, 0.8)
addSpellBtn:SetBackdropBorderColor(0.3, 0.7, 0.4, 1)

local addBtnText = addSpellBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addBtnText:SetPoint("CENTER")
addBtnText:SetText("|cffffffff+ Add|r")

addSpellBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.25, 0.6, 0.35, 1)
end)
addSpellBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.2, 0.5, 0.3, 0.8)
end)

local modalCurrentSpellId = nil
local modalCurrentSpellName = nil

-- Spell info fetcher
local function GetSpellInfoRobust(spellId)
  spellId = tonumber(spellId)
  if not spellId or spellId <= 0 then return nil, nil end
  
  local spellName, spellIcon
  
  if C_Spell and C_Spell.GetSpellInfo then
    local success, info = pcall(C_Spell.GetSpellInfo, spellId)
    if success and info then
      spellName = info.name
      spellIcon = info.iconID
    end
  end
  
  if not spellName and C_Spell then
    if C_Spell.GetSpellName then
      local success, name = pcall(C_Spell.GetSpellName, spellId)
      if success and name then spellName = name end
    end
    if C_Spell.GetSpellTexture then
      local success, tex = pcall(C_Spell.GetSpellTexture, spellId)
      if success and tex then spellIcon = tex end
    end
  end
  
  if not spellName and GetSpellInfo then
    local success, name, _, icon = pcall(GetSpellInfo, spellId)
    if success and name then
      spellName = name
      spellIcon = icon
    end
  end
  
  return spellName, spellIcon
end

local function UpdateModalSpellInfo(spellId)
  spellId = tonumber(spellId)
  if not spellId or spellId <= 0 then
    modalSpellIconTexture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    modalSpellNameDisplay:SetText("|cff666666No spell selected|r")
    dropHint:Show()
    modalCurrentSpellId = nil
    modalCurrentSpellName = nil
    return
  end
  
  local spellName, spellIcon = GetSpellInfoRobust(spellId)
  
  if spellName then
    modalSpellIconTexture:SetTexture(spellIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
    modalSpellNameDisplay:SetText("|cffffffff" .. spellName .. "|r")
    dropHint:Hide()
    modalCurrentSpellId = spellId
    modalCurrentSpellName = spellName
    modalSpellIcon:SetBackdropBorderColor(0.4, 0.7, 1.0, 1)
  else
    modalSpellIconTexture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    modalSpellNameDisplay:SetText("|cffff6666Unknown spell (ID: " .. spellId .. ")|r")
    dropHint:Hide()
    modalCurrentSpellId = spellId
    modalCurrentSpellName = nil
    modalSpellIcon:SetBackdropBorderColor(0.7, 0.3, 0.3, 1)
  end
end

modalSpellIdBox:SetScript("OnTextChanged", function(self)
  UpdateModalSpellInfo(self:GetText())
end)
modalSpellIdBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
modalSpellIdBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

-- Drag & drop handler
local function HandleSpellDrop()
  local infoType, data, subType, spellId = GetCursorInfo()
  
  if infoType == "spell" then
    local finalSpellId = nil
    
    if spellId and type(spellId) == "number" and spellId > 0 then
      finalSpellId = spellId
    elseif data and type(data) == "number" and data > 0 then
      finalSpellId = data
    elseif subType and type(subType) == "number" and subType > 0 then
      finalSpellId = subType
    end
    
    if not finalSpellId and data and C_SpellBook and C_SpellBook.GetSpellBookItemInfo then
      local success, info = pcall(C_SpellBook.GetSpellBookItemInfo, data, Enum.SpellBookSpellBank.Player)
      if success and info and info.spellID then
        finalSpellId = info.spellID
      end
    end
    
    if finalSpellId then
      modalSpellIdBox:SetText(tostring(finalSpellId))
      UpdateModalSpellInfo(finalSpellId)
    end
    
    ClearCursor()
    return true
  end
  return false
end

modalSpellIcon:SetScript("OnReceiveDrag", HandleSpellDrop)
modalSpellIcon:SetScript("OnClick", HandleSpellDrop)
spellInputContainer:SetScript("OnReceiveDrag", HandleSpellDrop)
spellInputContainer:SetScript("OnMouseDown", HandleSpellDrop)

-- Spell list (below input)
local modalSpellListFrame = CreateFrame("Frame", nil, spellsCard, BackdropTemplateMixin and "BackdropTemplate")
modalSpellListFrame:SetSize(spellsCard:GetWidth() - 24, 110)
modalSpellListFrame:SetPoint("TOPLEFT", spellInputContainer, "BOTTOMLEFT", 0, -8)
modalSpellListFrame:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
modalSpellListFrame:SetBackdropColor(0.05, 0.05, 0.07, 0.9)
modalSpellListFrame:SetBackdropBorderColor(0.2, 0.2, 0.3, 0.6)

local spellListLabel = modalSpellListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
spellListLabel:SetPoint("TOPLEFT", modalSpellListFrame, "TOPLEFT", 8, -6)
spellListLabel:SetText("|cff888888Added Spells:|r")

local modalSpellListScroll = CreateFrame("ScrollFrame", nil, modalSpellListFrame, "UIPanelScrollFrameTemplate")
modalSpellListScroll:SetPoint("TOPLEFT", 5, -22)
modalSpellListScroll:SetPoint("BOTTOMRIGHT", -25, 5)

local modalSpellListContent = CreateFrame("Frame", nil, modalSpellListScroll)
modalSpellListContent:SetSize(400, 80)
modalSpellListScroll:SetScrollChild(modalSpellListContent)

local modalSpellRows = {}

local function RefreshModalSpellList()
  for _, row in ipairs(modalSpellRows) do
    row:Hide()
  end
  
  local spells = modalSelectedTriggers.spells or {}
  local y = 0
  
  for i, spell in ipairs(spells) do
    local row = modalSpellRows[i]
    if not row then
      row = CreateFrame("Frame", nil, modalSpellListContent, BackdropTemplateMixin and "BackdropTemplate")
      row:SetSize(380, 28)
      row:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
      })
      row:SetBackdropColor(0.12, 0.12, 0.16, 0.9)
      row:SetBackdropBorderColor(0.25, 0.25, 0.35, 0.8)
      
      row.icon = row:CreateTexture(nil, "ARTWORK")
      row.icon:SetSize(22, 22)
      row.icon:SetPoint("LEFT", 4, 0)
      row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      
      row.nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      row.nameText:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
      row.nameText:SetWidth(280)
      row.nameText:SetJustifyH("LEFT")
      
      row.removeBtn = CreateFrame("Button", nil, row, BackdropTemplateMixin and "BackdropTemplate")
      row.removeBtn:SetSize(22, 22)
      row.removeBtn:SetPoint("RIGHT", row, "RIGHT", -4, 0)
      row.removeBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
      })
      row.removeBtn:SetBackdropColor(0.4, 0.15, 0.15, 0.8)
      row.removeBtn:SetBackdropBorderColor(0.6, 0.25, 0.25, 1)
      
      local removeX = row.removeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
      removeX:SetPoint("CENTER")
      removeX:SetText("X")
      removeX:SetTextColor(1, 0.6, 0.6, 1)
      
      row.removeBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.6, 0.2, 0.2, 1)
      end)
      row.removeBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.4, 0.15, 0.15, 0.8)
      end)
      
      table.insert(modalSpellRows, row)
    end
    
    row:SetPoint("TOPLEFT", modalSpellListContent, "TOPLEFT", 0, -y)
    
    local spellName, spellIcon = GetSpellInfoRobust(spell.id)
    row.icon:SetTexture(spellIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
    row.nameText:SetText((spellName or spell.name or "Unknown") .. " |cff666666(ID: " .. spell.id .. ")|r")
    
    row.removeBtn:SetScript("OnClick", function()
      table.remove(modalSelectedTriggers.spells, i)
      RefreshModalSpellList()
    end)
    
    row:Show()
    y = y + 30
  end
  
  modalSpellListContent:SetHeight(math.max(y, 30))
  
  if #spells == 0 then
    if not modalSpellListFrame.emptyText then
      modalSpellListFrame.emptyText = modalSpellListContent:CreateFontString(nil, "OVERLAY", "GameFontDisable")
      modalSpellListFrame.emptyText:SetPoint("CENTER", modalSpellListContent, "CENTER", 0, 0)
      modalSpellListFrame.emptyText:SetText("|cff555555No spells added yet|r")
    end
    modalSpellListFrame.emptyText:Show()
  elseif modalSpellListFrame.emptyText then
    modalSpellListFrame.emptyText:Hide()
  end
end

addSpellBtn:SetScript("OnClick", function()
  if modalCurrentSpellId then
    modalSelectedTriggers.spells = modalSelectedTriggers.spells or {}
    for _, existing in ipairs(modalSelectedTriggers.spells) do
      if existing.id == modalCurrentSpellId then return end
    end
    table.insert(modalSelectedTriggers.spells, {
      id = modalCurrentSpellId,
      name = modalCurrentSpellName,
    })
    RefreshModalSpellList()
    modalSpellIdBox:SetText("")
    UpdateModalSpellInfo(nil)
  end
end)

-- Footer buttons
local footerBar = CreateFrame("Frame", nil, TriggerPickerModal, BackdropTemplateMixin and "BackdropTemplate")
footerBar:SetSize(TriggerPickerModal:GetWidth() - 4, 50)
footerBar:SetPoint("BOTTOM", TriggerPickerModal, "BOTTOM", 0, 2)
footerBar:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
})
footerBar:SetBackdropColor(0.1, 0.1, 0.14, 1)

local modalCancelBtn = CreateFrame("Button", nil, footerBar, BackdropTemplateMixin and "BackdropTemplate")
modalCancelBtn:SetSize(120, 36)
modalCancelBtn:SetPoint("LEFT", footerBar, "CENTER", 10, 0)
modalCancelBtn:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
modalCancelBtn:SetBackdropColor(0.25, 0.25, 0.3, 0.9)
modalCancelBtn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)

local cancelText = modalCancelBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
cancelText:SetPoint("CENTER")
cancelText:SetText("Cancel")

modalCancelBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.35, 0.35, 0.4, 1)
end)
modalCancelBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.25, 0.25, 0.3, 0.9)
end)
modalCancelBtn:SetScript("OnClick", function()
  TriggerPickerModal:Hide()
end)

local modalConfirmBtn = CreateFrame("Button", nil, footerBar, BackdropTemplateMixin and "BackdropTemplate")
modalConfirmBtn:SetSize(120, 36)
modalConfirmBtn:SetPoint("RIGHT", footerBar, "CENTER", -10, 0)
modalConfirmBtn:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
})
modalConfirmBtn:SetBackdropColor(0.2, 0.45, 0.3, 0.9)
modalConfirmBtn:SetBackdropBorderColor(0.3, 0.7, 0.4, 1)

local confirmText = modalConfirmBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
confirmText:SetPoint("CENTER")
confirmText:SetText("|cffffffffConfirm|r")

modalConfirmBtn:SetScript("OnEnter", function(self)
  self:SetBackdropColor(0.25, 0.55, 0.35, 1)
end)
modalConfirmBtn:SetScript("OnLeave", function(self)
  self:SetBackdropColor(0.2, 0.45, 0.3, 0.9)
end)
modalConfirmBtn:SetScript("OnClick", function()
  if modalCallback then
    modalCallback(modalSelectedTriggers)
  end
  TriggerPickerModal:Hide()
end)

-- Public function to open the trigger picker
function MageQuotes_OpenTriggerPicker(existingTriggers, callback)
  modalSelectedTriggers = existingTriggers or { situations = {}, spells = {} }
  modalCallback = callback
  
  for key, cb in pairs(situationCheckboxes) do
    local isChecked = modalSelectedTriggers.situations and modalSelectedTriggers.situations[key]
    cb:SetChecked(isChecked)
    if cb.UpdateVisual then cb.UpdateVisual() end
  end
  
  modalSpellIdBox:SetText("")
  UpdateModalSpellInfo(nil)
  RefreshModalSpellList()
  
  TriggerPickerModal:Show()
end

-- Connect chooseTriggerBtn to open the modal
C_Timer.After(0.1, function()
  if chooseTriggerBtn then
    chooseTriggerBtn:SetScript("OnClick", function()
      MageQuotes_OpenTriggerPicker(currentQuoteTriggers, function(triggers)
        currentQuoteTriggers = triggers or { situations = {}, spells = {} }
        UpdateTriggerSummary()
      end)
    end)
  end
end)

------------------------------------------------------------
-- Bottom Action Bar
------------------------------------------------------------
local ActionBar = CreateFrame("Frame", nil, Frame, BackdropTemplateMixin and "BackdropTemplate")
ActionBar:SetSize(Frame:GetWidth() - 10, 45)
ActionBar:SetPoint("BOTTOM", Frame, "BOTTOM", 0, 5)

ActionBar:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Buttons\\WHITE8x8",
  edgeSize = 1,
  insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
ActionBar:SetBackdropColor(unpack(COLORS.bg_light))
ActionBar:SetBackdropBorderColor(unpack(COLORS.border))

local quickTestBtn = CreateModernButton(ActionBar, L("quickTest"), 120, 32)
quickTestBtn:SetPoint("LEFT", ActionBar, "LEFT", 10, 0)
quickTestBtn:SetScript("OnClick", function()
  if MageQuotesAPI and MageQuotesAPI.TriggerManualQuote then
    local categories = {"init", "kill", "surv", "vict"}
    local random = categories[math.random(#categories)]
    MageQuotesAPI.TriggerManualQuote(random)
  end
end)

local reloadBtn = CreateModernButton(ActionBar, L("reloadUI"), 120, 32)
reloadBtn:SetPoint("LEFT", quickTestBtn, "RIGHT", 8, 0)
reloadBtn:SetScript("OnClick", function()
  ReloadUI()
end)

local helpBtn = CreateModernButton(ActionBar, L("help"), 100, 32)
helpBtn:SetPoint("RIGHT", ActionBar, "RIGHT", -10, 0)
helpBtn:SetScript("OnClick", function()
  print(ColorText("=== Mage Quotes Help ===", COLORS.primary))
  print(ColorText("/mq", COLORS.accent) .. " - Show all commands")
  print(ColorText("/mq status", COLORS.accent) .. " - Show addon status")
  print(ColorText("/mq debug on/off", COLORS.accent) .. " - Toggle debug mode")
  print(ColorText("/mq auras", COLORS.accent) .. " - Check defensive auras")
  print(ColorText("/mq channel <type>", COLORS.accent) .. " - Set message channel")
end)

------------------------------------------------------------
-- Main UI Refresh Function
------------------------------------------------------------
refreshUI = function()
  -- Re-fetch locale strings
  uiStrings, activeLocale, supportedLocales = SafeGetUIStrings()
  
  -- Update title bar (these are in outer scope)
  if titleText then
    titleText:SetText(ColorText(L("title"), COLORS.text))
  end
  UpdateStatusBadge()
  
  -- Update tab labels (tabs are in outer scope) - FIXED ORDER: Custom is tab7, Debug is tab8
  if tab1 and tab1.label then tab1.label:SetText(L("settings")) end
  if tab2 and tab2.label then tab2.label:SetText(L("quotes")) end
  if tab3 and tab3.label then tab3.label:SetText(L("categories")) end
  if tab4 and tab4.label then tab4.label:SetText(L("audio")) end
  if tab5 and tab5.label then tab5.label:SetText(L("stats")) end
  if tab6 and tab6.label then tab6.label:SetText(L("modules")) end
  if tab7 and tab7.label then tab7.label:SetText(L("custom") or "Custom") end
  if tab8 and tab8.label then tab8.label:SetText(L("debug")) end
  
  -- Update Stats tab if visible
  if StatsTab and StatsTab:IsVisible() and UpdateStats then
    UpdateStats()
  end
  
  -- Note: Full UI refresh requires /reload due to scoped variables
  -- The locale change is saved, so reopening or /reload will show new language
end

function Frame:ShowAndRefresh()
  if InCombatLockdown() then
    print(ColorText(L("cannotOpenInCombat"), COLORS.error))
    return
  end
  refreshUI()
  Frame:Show()
end

Frame:SetScript("OnShow", function(self)
  if InCombatLockdown() then
    self:Hide()
    print(ColorText(L("cannotOpenInCombat"), COLORS.error))
    return
  end
  if refreshUI then refreshUI() end
end)

------------------------------------------------------------
-- Initialization
------------------------------------------------------------
tab1.isActive = true
tab1:UpdateVisual()
SettingsTab:Show()
activeTab = tab1

local combatUpdateFrame = CreateFrame("Frame")
combatUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
  self.elapsed = (self.elapsed or 0) + elapsed
  if self.elapsed >= 1 then
    self.elapsed = 0
    if Frame:IsVisible() then
      UpdateStatusBadge()
      if StatsTab:IsVisible() then
        UpdateStats()
      end
    end
  end
end)

if MageQuotes_EventBus and MageQuotes_EventBus.RegisterCallback then
  MageQuotes_EventBus:RegisterCallback("MAGE_QUOTES_LOCALE_CHANGED", function()
    if Frame:IsShown() then refreshUI() end
  end, Frame)
end

print(ColorText(L("title") .. " UI v" .. ADDON_VERSION .. " loaded", COLORS.success) .. " - Type " .. ColorText("/mq", COLORS.accent) .. " for commands")