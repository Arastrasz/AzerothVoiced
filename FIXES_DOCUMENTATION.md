# MageQuotes v1.5.5 - Bug Fixes

This document describes the fixes needed for the following issues:
1. Translation not working when switching languages
2. "Add new quote" interface missing (CustomQuotes.lua not present)
3. Blank squares before "Combat Initiation" in Custom filter
4. searchBox nil error at line 715
5. Trigger interface restoration (modal window)

---

## Issue 1: searchBox Nil Error (Line 715)

**Problem:** The variable `searchBox` is referenced at line 715 but not defined until line 747.

**Fix:** Move the searchBox definition BEFORE the dropdown click handlers.

### Location in UI.lua:
Around line 630-750 (TAB 2: Quotes Browser section)

### Original Code (BROKEN):
```lua
-- Around line 711-716
btn:SetScript("OnClick", function()
  currentQuotesFilter = opt.key
  quotesFilterLabel:SetText(opt.text)
  quotesDropdown:Hide()
  PopulateQuotes(searchBox:GetText())  -- ERROR: searchBox not defined yet!
end)

-- ... more code ...

-- Around line 747
local searchBox = CreateFrame("EditBox", nil, QuotesTab, "SearchBoxTemplate")
```

### Fixed Code:
```lua
------------------------------------------------------------
-- TAB 2: Quotes Browser (ENHANCED - Dropdown Filter)
-- FIXED: searchBox is now defined BEFORE dropdown handlers
------------------------------------------------------------
do -- Scope block for TAB 2
local QuotesTab = CreateFrame("Frame", nil, ContentArea)
QuotesTab:SetAllPoints(ContentArea)
QuotesTab:Hide()
table.insert(tabContents, QuotesTab)
tab2.content = QuotesTab

-- Create searchBox FIRST (before dropdown handlers that reference it)
local searchBox = CreateFrame("EditBox", nil, QuotesTab, "SearchBoxTemplate")
searchBox:SetSize(250, 26)
searchBox:SetAutoFocus(false)
searchBox:SetFontObject("GameFontNormal")

-- Filter dropdown
local quotesFilterFrame = CreateFrame("Frame", nil, QuotesTab, BackdropTemplateMixin and "BackdropTemplate")
-- ... rest of filter frame setup ...

-- Position searchBox after filter frame is created
searchBox:SetPoint("LEFT", quotesFilterFrame, "RIGHT", 10, 0)

-- Forward declare PopulateQuotes
local PopulateQuotes

-- Dropdown options and handlers
for i, opt in ipairs(filterOptions) do
  -- ...
  btn:SetScript("OnClick", function()
    currentQuotesFilter = opt.key
    quotesFilterLabel:SetText(opt.text)
    quotesDropdown:Hide()
    if PopulateQuotes then
      PopulateQuotes(searchBox:GetText())  -- Now works!
    end
  end)
end

-- Define PopulateQuotes later
PopulateQuotes = function(filterText)
  -- ...
end
```

---

## Issue 2: Blank Squares (Unicode Star Character)

**Problem:** The Unicode star character ★ (U+2605) doesn't render properly in some fonts, showing as blank squares.

**Fix:** Replace `★` with ASCII alternative `[*]`

### Location in UI.lua:
In the `PopulateQuotes` function, around line 873

### Original Code:
```lua
categoryLabel:SetText(ColorText("★ " .. catName .. " (" .. #quotes .. " custom)", COLORS.accent))
```

### Fixed Code:
```lua
-- Use [*] instead of Unicode star to avoid blank square issue
categoryLabel:SetText(ColorText("[*] " .. catName .. " (" .. #quotes .. " custom)", COLORS.accent))
```

Also fix the status indicators:
```lua
-- Original (may have issues)
local status = q.enabled ~= false and "|cff00ff00●|r " or "|cffff0000○|r "

-- Fixed (ASCII safe)
local status = q.enabled ~= false and "|cff00ff00[ON]|r " or "|cffff0000[OFF]|r "
```

---

## Issue 3: Translation Not Working

**Problem:** When switching locale, the UI doesn't update because:
1. The `L()` function caches strings at load time
2. The `refreshUI()` function only updates tab labels, not content

**Fix:** Multiple changes needed:

### A. Update UIStrings.lua - Make InitLocale called properly

The UIStrings.lua file should re-initialize when locale changes. Add:

```lua
-- In UIStrings.lua, update MageQuotes_SetLocale function:
function MageQuotes_SetLocale(locale)
  if MageQuotes_UIStrings[locale] then
    activeLocale = locale
    -- Save to DB
    if MageQuotesDB then
      MageQuotesDB.locale = locale
    end
    -- Fire event for other modules
    if MageQuotes_EventBus and MageQuotes_EventBus.TriggerEvent then
      MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_LOCALE_CHANGED", locale)
    end
    return true
  end
  return false
end
```

### B. In UI.lua - Show reload message

Add a message to users that they need to reload for full translation:

```lua
-- In the language button click handler (Settings tab):
btn:SetScript("OnClick", function(self)
  if MageQuotes_SetLocale then
    MageQuotes_SetLocale(locale)
    RebuildCore()
    -- Update button highlight
    for _, b in ipairs(localeButtons) do
      b:SetBackdropColor(unpack(COLORS.bg_medium))
    end
    self:SetBackdropColor(COLORS.primary[1], COLORS.primary[2], COLORS.primary[3], 0.5)
    -- Tell user to reload
    print(ColorText("MageQuotes:", COLORS.accent) .. " Language changed to " .. locale .. ". Type /reload for full UI translation.")
  end
end)
```

### C. Add visual indicator in Settings

```lua
-- Add note below language buttons
local langNotice = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
langNotice:SetPoint("TOPLEFT", settingsContent, "TOPLEFT", 10, yOffset - 5)
langNotice:SetText(ColorText("Note: Full UI translation requires /reload after changing language", COLORS.text_dim))
```

---

## Issue 4: CustomQuotes.lua Missing

The file `Modules/CustomQuotes.lua` was mentioned in the .toc but not uploaded. This file provides the import/export functionality.

Create this file with the following content (see separate CustomQuotes.lua file).

---

## Issue 5: Dropdown Arrow Character

**Problem:** The dropdown arrow ▼ (U+25BC) may not render properly.

**Fix:** Use ASCII alternative `v` and `^`

### Location in UI.lua:
```lua
-- Original
quotesFilterArrow:SetText("▼")  -- and "▲"

-- Fixed
quotesFilterArrow:SetText("v")  -- and "^"
```

---

## Summary of All Changes

1. **Move searchBox definition** - Define it at the start of TAB 2 scope, before any handlers reference it
2. **Replace Unicode symbols** - Use ASCII alternatives for ★, ●, ○, ▼, ▲
3. **Add reload notice** - Tell users to /reload after changing language
4. **Create CustomQuotes.lua** - Provide the missing module file

These fixes should resolve all reported issues without requiring a complete rewrite of the UI.
