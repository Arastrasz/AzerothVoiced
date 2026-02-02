-- MageQuotes/Modules/QuotePacksUI.lua
-- OPTIONAL MODULE: Quote Packs Browser UI
-- v1.0.0 - Visual browser for installing packs
--
-- REQUIRES: QuotePacks.lua must be loaded first
-- HOW TO DISABLE: Remove this file, packs still work via /mqpacks

local MODULE_VERSION = "1.0.0"

-- Check if QuotePacks module is loaded
if not MageQuotes_QuotePacks then
  print("|cffff6666QuotePacksUI:|r QuotePacks.lua not loaded, skipping UI")
  return
end

------------------------------------------------------------
-- Colors
------------------------------------------------------------
local COLORS = {
  primary = {0.4, 0.6, 1.0},
  accent = {1.0, 0.7, 0.2},
  success = {0.3, 1.0, 0.3},
  error = {1.0, 0.3, 0.3},
  text_dim = {0.6, 0.6, 0.65},
}

local function ColorText(t, c)
  c = c or {1,1,1}
  return string.format("|cff%02x%02x%02x%s|r", c[1]*255, c[2]*255, c[3]*255, t or "")
end

------------------------------------------------------------
-- Main Browser Frame
------------------------------------------------------------
local Browser = CreateFrame("Frame", "MageQuotesPacksBrowser", UIParent, BackdropTemplateMixin and "BackdropTemplate")
Browser:SetSize(680, 520)
Browser:SetPoint("CENTER")
Browser:SetFrameStrata("FULLSCREEN_DIALOG")
Browser:SetFrameLevel(150)
Browser:EnableMouse(true)
Browser:SetMovable(true)
Browser:RegisterForDrag("LeftButton")
Browser:SetScript("OnDragStart", Browser.StartMoving)
Browser:SetScript("OnDragStop", Browser.StopMovingOrSizing)
Browser:Hide()

Browser:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 32, edgeSize = 16,
  insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
Browser:SetBackdropColor(0.08, 0.08, 0.12, 0.98)
Browser:SetBackdropBorderColor(0.6, 0.5, 0.2, 1)

-- Title Bar
local titleBar = CreateFrame("Frame", nil, Browser, BackdropTemplateMixin and "BackdropTemplate")
titleBar:SetSize(Browser:GetWidth() - 10, 38)
titleBar:SetPoint("TOP", Browser, "TOP", 0, -5)
titleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
titleBar:SetBackdropColor(0.12, 0.1, 0.06, 1)
titleBar:EnableMouse(true)
titleBar:RegisterForDrag("LeftButton")
titleBar:SetScript("OnDragStart", function() Browser:StartMoving() end)
titleBar:SetScript("OnDragStop", function() Browser:StopMovingOrSizing() end)

local titleIcon = titleBar:CreateTexture(nil, "ARTWORK")
titleIcon:SetSize(26, 26)
titleIcon:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
titleIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")

local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
titleText:SetPoint("LEFT", titleIcon, "RIGHT", 8, 0)
titleText:SetText("|cffffcc00Quote Packs Browser|r")

local closeBtn = CreateFrame("Button", nil, titleBar)
closeBtn:SetSize(24, 24)
closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -8, 0)
closeBtn:SetNormalFontObject("GameFontNormalLarge")
local closeTxt = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
closeTxt:SetPoint("CENTER")
closeTxt:SetText("|cffff6666X|r")
closeBtn:SetScript("OnClick", function() Browser:Hide() end)
closeBtn:SetScript("OnEnter", function() closeTxt:SetText("|cffff3333X|r") end)
closeBtn:SetScript("OnLeave", function() closeTxt:SetText("|cffff6666X|r") end)

-- Filter Row
local filterFrame = CreateFrame("Frame", nil, Browser)
filterFrame:SetSize(Browser:GetWidth() - 20, 28)
filterFrame:SetPoint("TOP", titleBar, "BOTTOM", 0, -8)

local filters = { "all", "installed", "enUS", "ruRU", "spec" }
local filterNames = { all = "All", installed = "Installed", enUS = "English", ruRU = "Русский", spec = "Spec" }
local filterBtns = {}
local currentFilter = "all"

local function UpdateFilters()
  for k, btn in pairs(filterBtns) do
    if k == currentFilter then
      btn:SetBackdropColor(0.4, 0.5, 0.3, 0.8)
      btn:SetBackdropBorderColor(0.6, 0.8, 0.4, 1)
    else
      btn:SetBackdropColor(0.15, 0.15, 0.2, 0.8)
      btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
    end
  end
end

for i, f in ipairs(filters) do
  local btn = CreateFrame("Button", nil, filterFrame, BackdropTemplateMixin and "BackdropTemplate")
  btn:SetSize(80, 24)
  btn:SetPoint("LEFT", filterFrame, "LEFT", (i-1) * 85, 0)
  btn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
  })
  btn:SetBackdropColor(0.15, 0.15, 0.2, 0.8)
  btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
  
  local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("CENTER")
  label:SetText(filterNames[f])
  
  btn:SetScript("OnClick", function()
    currentFilter = f
    UpdateFilters()
    MageQuotes_RefreshPacksList()
  end)
  
  filterBtns[f] = btn
end
UpdateFilters()

-- Scroll Area
local scroll = CreateFrame("ScrollFrame", nil, Browser, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", filterFrame, "BOTTOMLEFT", 0, -8)
scroll:SetPoint("BOTTOMRIGHT", Browser, "BOTTOMRIGHT", -28, 50)

local content = CreateFrame("Frame", nil, scroll)
content:SetWidth(scroll:GetWidth() - 10)
scroll:SetScrollChild(content)

local packCards = {}

------------------------------------------------------------
-- Create Pack Card
------------------------------------------------------------
local function CreatePackCard(parent, pack, yOffset)
  local card = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
  card:SetSize(parent:GetWidth() - 15, 90)
  card:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -yOffset)
  
  local color = pack.color or COLORS.primary
  local installed = MageQuotes_IsPackInstalled(pack.id)
  
  card:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 2,
  })
  card:SetBackdropColor(0.1, 0.1, 0.14, 0.95)
  card:SetBackdropBorderColor(color[1]*0.5, color[2]*0.5, color[3]*0.5, 0.8)
  
  card:EnableMouse(true)
  card:SetScript("OnEnter", function(self)
    self:SetBackdropColor(color[1]*0.15, color[2]*0.15, color[3]*0.15, 1)
    self:SetBackdropBorderColor(color[1], color[2], color[3], 1)
  end)
  card:SetScript("OnLeave", function(self)
    self:SetBackdropColor(0.1, 0.1, 0.14, 0.95)
    self:SetBackdropBorderColor(color[1]*0.5, color[2]*0.5, color[3]*0.5, 0.8)
  end)
  
  -- Icon
  local icon = card:CreateTexture(nil, "ARTWORK")
  icon:SetSize(50, 50)
  icon:SetPoint("TOPLEFT", card, "TOPLEFT", 10, -10)
  icon:SetTexture(pack.icon or "Interface\\Icons\\INV_Misc_Book_09")
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  
  -- Name
  local name = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 0)
  name:SetText(ColorText(pack.name, color))
  
  -- Author
  local author = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  author:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
  author:SetText(ColorText("by " .. (pack.author or "Unknown"), COLORS.text_dim))
  
  -- Description
  local desc = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  desc:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -4)
  desc:SetPoint("RIGHT", card, "RIGHT", -110, 0)
  desc:SetJustifyH("LEFT")
  local d = pack.description or ""
  if #d > 80 then d = d:sub(1,77) .. "..." end
  desc:SetText(d)
  
  -- Quote count
  local countBg = CreateFrame("Frame", nil, card, BackdropTemplateMixin and "BackdropTemplate")
  countBg:SetSize(55, 18)
  countBg:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 10, 8)
  countBg:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
  countBg:SetBackdropColor(0.2, 0.2, 0.25, 0.9)
  countBg:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)
  
  local countTxt = countBg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  countTxt:SetPoint("CENTER")
  countTxt:SetText(#(pack.quotes or {}) .. " quotes")
  
  -- Locale badge
  if pack.locale == "ruRU" then
    local localeBg = CreateFrame("Frame", nil, card, BackdropTemplateMixin and "BackdropTemplate")
    localeBg:SetSize(30, 18)
    localeBg:SetPoint("LEFT", countBg, "RIGHT", 5, 0)
    localeBg:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    localeBg:SetBackdropColor(0.3, 0.2, 0.2, 0.9)
    localeBg:SetBackdropBorderColor(0.6, 0.4, 0.4, 0.8)
    local lt = localeBg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lt:SetPoint("CENTER")
    lt:SetText("RU")
  end
  
  -- Spec badge
  if pack.spec then
    local specColors = { fire = {1, 0.4, 0.2}, frost = {0.4, 0.8, 1}, arcane = {0.6, 0.7, 1} }
    local sc = specColors[pack.spec] or {0.7, 0.7, 0.7}
    local specBg = CreateFrame("Frame", nil, card, BackdropTemplateMixin and "BackdropTemplate")
    specBg:SetSize(50, 18)
    specBg:SetPoint("LEFT", countBg, "RIGHT", pack.locale == "ruRU" and 40 or 5, 0)
    specBg:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    specBg:SetBackdropColor(sc[1]*0.2, sc[2]*0.2, sc[3]*0.2, 0.9)
    specBg:SetBackdropBorderColor(sc[1], sc[2], sc[3], 0.8)
    local st = specBg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    st:SetPoint("CENTER")
    st:SetText(pack.spec:upper())
    st:SetTextColor(sc[1], sc[2], sc[3])
  end
  
  -- Action Button
  local actionBtn = CreateFrame("Button", nil, card, BackdropTemplateMixin and "BackdropTemplate")
  actionBtn:SetSize(85, 28)
  actionBtn:SetPoint("RIGHT", card, "RIGHT", -10, 0)
  actionBtn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
  
  local actionTxt = actionBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  actionTxt:SetPoint("CENTER")
  
  if installed then
    actionBtn:SetBackdropColor(0.4, 0.15, 0.15, 0.9)
    actionBtn:SetBackdropBorderColor(0.7, 0.3, 0.3, 1)
    actionTxt:SetText("|cffff8888Uninstall|r")
    actionBtn:SetScript("OnClick", function()
      local ok, r = MageQuotes_UninstallPack(pack.id)
      print((ok and "|cff00ff00" or "|cffff0000") .. "MageQuotes: " .. r .. "|r")
      MageQuotes_RefreshPacksList()
    end)
    actionBtn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.6, 0.2, 0.2, 1) end)
    actionBtn:SetScript("OnLeave", function(self) self:SetBackdropColor(0.4, 0.15, 0.15, 0.9) end)
    
    -- Installed badge
    local instTxt = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    instTxt:SetPoint("TOPRIGHT", card, "TOPRIGHT", -10, -8)
    instTxt:SetText("|cff00ff00✓ INSTALLED|r")
  else
    actionBtn:SetBackdropColor(0.15, 0.4, 0.25, 0.9)
    actionBtn:SetBackdropBorderColor(0.3, 0.7, 0.4, 1)
    actionTxt:SetText("|cff88ff88Install|r")
    actionBtn:SetScript("OnClick", function()
      local ok, r = MageQuotes_InstallPack(pack.id)
      print((ok and "|cff00ff00" or "|cffff0000") .. "MageQuotes: " .. r .. "|r")
      MageQuotes_RefreshPacksList()
    end)
    actionBtn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.2, 0.5, 0.3, 1) end)
    actionBtn:SetScript("OnLeave", function(self) self:SetBackdropColor(0.15, 0.4, 0.25, 0.9) end)
  end
  
  return card
end

------------------------------------------------------------
-- Refresh Packs List
------------------------------------------------------------
function MageQuotes_RefreshPacksList()
  for _, card in ipairs(packCards) do
    card:Hide()
    card:SetParent(nil)
  end
  wipe(packCards)
  
  local packs = MageQuotes_GetAvailablePacks()
  local y = 5
  local visible = 0
  
  for _, pack in ipairs(packs) do
    local show = false
    if currentFilter == "all" then show = true
    elseif currentFilter == "installed" then show = MageQuotes_IsPackInstalled(pack.id)
    elseif currentFilter == "enUS" then show = (pack.locale == "enUS" or not pack.locale)
    elseif currentFilter == "ruRU" then show = (pack.locale == "ruRU")
    elseif currentFilter == "spec" then show = (pack.spec ~= nil)
    end
    
    if show then
      local card = CreatePackCard(content, pack, y)
      table.insert(packCards, card)
      y = y + 98
      visible = visible + 1
    end
  end
  
  if visible == 0 then
    local empty = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    empty:SetPoint("CENTER", content, "CENTER", 0, 50)
    empty:SetText(ColorText("No packs match this filter.", COLORS.text_dim))
    local emptyFrame = CreateFrame("Frame", nil, content)
    emptyFrame.text = empty
    table.insert(packCards, emptyFrame)
    y = 150
  end
  
  content:SetHeight(math.max(y + 10, scroll:GetHeight()))
end

-- Footer
local footer = CreateFrame("Frame", nil, Browser, BackdropTemplateMixin and "BackdropTemplate")
footer:SetSize(Browser:GetWidth() - 10, 42)
footer:SetPoint("BOTTOM", Browser, "BOTTOM", 0, 5)
footer:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
footer:SetBackdropColor(0.1, 0.1, 0.12, 1)

local footerTip = footer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
footerTip:SetPoint("LEFT", footer, "LEFT", 12, 0)
footerTip:SetText(ColorText("Tip: Quotes are added to Custom Quotes. Uninstall removes them.", COLORS.text_dim))

local closeFooterBtn = CreateFrame("Button", nil, footer, BackdropTemplateMixin and "BackdropTemplate")
closeFooterBtn:SetSize(80, 28)
closeFooterBtn:SetPoint("RIGHT", footer, "RIGHT", -12, 0)
closeFooterBtn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
closeFooterBtn:SetBackdropColor(0.2, 0.2, 0.25, 0.9)
closeFooterBtn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
local closeFTxt = closeFooterBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
closeFTxt:SetPoint("CENTER")
closeFTxt:SetText("Close")
closeFooterBtn:SetScript("OnClick", function() Browser:Hide() end)

------------------------------------------------------------
-- Public API
------------------------------------------------------------
function MageQuotes_OpenPacksBrowser()
  MageQuotes_RefreshPacksList()
  Browser:Show()
end

Browser:SetScript("OnShow", MageQuotes_RefreshPacksList)
tinsert(UISpecialFrames, "MageQuotesPacksBrowser")

print("|cffffaa00MageQuotes QuotePacksUI loaded|r - Browser ready")
