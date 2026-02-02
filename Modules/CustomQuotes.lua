-- MageQuotes_CustomQuotes.lua
-- Custom Quote Editor & Import/Export System
-- v1.8.0 - Midnight 12.0.0 Compatible
-- FIXED: Proper event bus integration, cache rebuild on changes

local ADDON_VERSION = "1.8.0"
local MODULE_NAME = "MageQuotes_CustomQuotes"

------------------------------------------------------------
-- Safe initialization
------------------------------------------------------------
local Core = _G.MageQuotesCore
local initAttempts = 0
local MAX_INIT_ATTEMPTS = 10

local function SafeInit()
  Core = _G.MageQuotesCore
  if not Core or not MageQuotesDB then
    initAttempts = initAttempts + 1
    if initAttempts < MAX_INIT_ATTEMPTS then
      C_Timer.After(0.5, SafeInit)
    end
    return false
  end
  return true
end

if not Core or not MageQuotesDB then
  C_Timer.After(0.5, SafeInit)
end

------------------------------------------------------------
-- Debug System
------------------------------------------------------------
local function LogDebug(category, message, ...)
  if not MageQuotesDB or not MageQuotesDB.debugMode then return end
  
  local formatted = string.format(message, ...)
  local timestamp = date("%H:%M:%S")
  
  if MageQuotesAPI and MageQuotesAPI.GetDebugLog then
    local debugLog = MageQuotesAPI.GetDebugLog()
    if debugLog then
      table.insert(debugLog, {
        time = GetTime(),
        timestamp = timestamp,
        category = "Custom:" .. category,
        message = formatted
      })
      while #debugLog > 100 do
        table.remove(debugLog, 1)
      end
    end
  end
  
  if MageQuotesDB.debugPrint then
    print(string.format("|cffffaa00[MQ Custom]|r [%s] [%s] %s", 
      timestamp, category, formatted))
  end
end

------------------------------------------------------------
-- Data Structures
------------------------------------------------------------
local function EnsureDB()
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.customQuotes = MageQuotesDB.customQuotes or {}
  MageQuotesDB.libraries = MageQuotesDB.libraries or {}
  MageQuotesDB.spellTriggers = MageQuotesDB.spellTriggers or {}
end

------------------------------------------------------------
-- Notify Core of changes (CRITICAL)
------------------------------------------------------------
local function NotifyCustomQuotesChanged()
  LogDebug("Event", "Notifying custom quotes changed...")
  
  -- Method 1: Use event bus
  if MageQuotes_EventBus and MageQuotes_EventBus.TriggerEvent then
    LogDebug("Event", "Triggering MAGE_QUOTES_CUSTOM_UPDATED via EventBus")
    MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_CUSTOM_UPDATED")
  end
  
  -- Method 2: Direct API call (belt and suspenders)
  -- Give event bus time to propagate first
  C_Timer.After(0.1, function()
    if MageQuotesAPI and MageQuotesAPI.RebuildCaches then
      LogDebug("Event", "Calling RebuildCaches via API")
      MageQuotesAPI.RebuildCaches()
    elseif Core and Core.Rebuild then
      LogDebug("Event", "Calling Core:Rebuild directly")
      Core:Rebuild()
    end
  end)
end

------------------------------------------------------------
-- Hex-based Serialization (v2 format - supports ALL characters)
------------------------------------------------------------

local function StringToHex(str)
  if not str then return "" end
  return (str:gsub('.', function(c)
    return string.format('%02X', string.byte(c))
  end))
end

local function HexToString(hex)
  if not hex then return "" end
  return (hex:gsub('..', function(cc)
    return string.char(tonumber(cc, 16) or 32)
  end))
end

local function SerializeQuote(quote)
  if not quote then return nil end
  
  local parts = {
    StringToHex(quote.text or ""),
    StringToHex(quote.category or "init"),
    StringToHex(quote.sound or ""),
    StringToHex(quote.spec or "all"),
    quote.enabled ~= false and "1" or "0"
  }
  
  return table.concat(parts, "|")
end

local function DeserializeQuote(str)
  if not str then return nil end
  
  local parts = { strsplit("|", str) }
  if #parts < 4 then return nil end
  
  return {
    text = HexToString(parts[1]),
    category = HexToString(parts[2]),
    sound = HexToString(parts[3]),
    spec = HexToString(parts[4]),
    enabled = parts[5] ~= "0"
  }
end

------------------------------------------------------------
-- Category normalization helper
------------------------------------------------------------
local VALID_CATEGORIES = {
  init = true, kill = true, surv = true, vict = true, 
  rare = true, mid = true, greet = true
}

local CATEGORY_ALIASES = {
  survival = "surv",
  victory = "vict",
  combat = "init",
  initiation = "init",
  killing = "kill",
  kb = "kill",
  greeting = "greet",
  midcombat = "mid",
  ["mid-combat"] = "mid",
}

local function NormalizeCategory(category)
  if not category or category == "" then
    return "init"
  end
  
  local cat = category:lower()
  
  -- Check aliases first
  if CATEGORY_ALIASES[cat] then
    return CATEGORY_ALIASES[cat]
  end
  
  -- Check valid categories
  if VALID_CATEGORIES[cat] then
    return cat
  end
  
  -- Default to init
  return "init"
end

------------------------------------------------------------
-- Export Functions
------------------------------------------------------------
local EXPORT_SIGNATURE = "MQP2"

local function ExportQuotePack(packName)
  EnsureDB()
  local quotes = MageQuotesDB.customQuotes
  
  if not quotes or #quotes == 0 then
    return nil, "No quotes to export"
  end
  
  local serialized = {}
  for _, quote in ipairs(quotes) do
    local s = SerializeQuote(quote)
    if s then
      table.insert(serialized, s)
    end
  end
  
  if #serialized == 0 then
    return nil, "Failed to serialize quotes"
  end
  
  local joined = table.concat(serialized, "~")
  local result = EXPORT_SIGNATURE .. ":" .. joined
  
  LogDebug("Export", "Exported %d quotes (%d bytes)", #serialized, #result)
  return result
end

------------------------------------------------------------
-- Import Functions
------------------------------------------------------------
local function ImportQuotePack(importString, merge)
  if not importString or importString == "" then
    return false, "Empty import string"
  end
  
  importString = importString:match("^%s*(.-)%s*$")
  
  if importString:match("^MQPACK:") then
    return false, "Legacy format (MQPACK) not supported. Please ask sender to re-export."
  end
  
  if not importString:match("^MQP2:") then
    return false, "Invalid format. Expected MQP2 signature."
  end
  
  local data = importString:sub(6)
  if not data or data == "" then
    return false, "Empty data after signature"
  end
  
  local parts = { strsplit("~", data) }
  
  local imported = {}
  for _, part in ipairs(parts) do
    if part and part ~= "" then
      local quote = DeserializeQuote(part)
      if quote and quote.text and quote.text ~= "" then
        -- Normalize category
        quote.category = NormalizeCategory(quote.category)
        table.insert(imported, quote)
      end
    end
  end
  
  if #imported == 0 then
    return false, "No valid quotes found"
  end
  
  EnsureDB()
  
  if not merge then
    MageQuotesDB.customQuotes = {}
  end
  
  local duplicates = 0
  local added = 0
  
  for _, quote in ipairs(imported) do
    local isDuplicate = false
    for _, existing in ipairs(MageQuotesDB.customQuotes) do
      if existing.text == quote.text and existing.category == quote.category then
        isDuplicate = true
        duplicates = duplicates + 1
        break
      end
    end
    
    if not isDuplicate then
      table.insert(MageQuotesDB.customQuotes, quote)
      added = added + 1
    end
  end
  
  LogDebug("Import", "Imported %d quotes (%d duplicates skipped)", added, duplicates)
  
  -- CRITICAL: Notify core to rebuild caches
  NotifyCustomQuotesChanged()
  
  local result = string.format("Imported %d quotes", added)
  if duplicates > 0 then
    result = result .. string.format(" (%d duplicates skipped)", duplicates)
  end
  
  return true, result
end

------------------------------------------------------------
-- Quote Management Functions
------------------------------------------------------------

-- FIXED: Support both table argument AND separate arguments
-- UI.lua calls: MageQuotes_AddCustomQuote(text, category, sound, spec)
local function AddCustomQuote(textOrTable, category, sound, spec)
  EnsureDB()
  
  local quote
  
  -- Support both calling conventions
  if type(textOrTable) == "table" then
    -- Called with table: MageQuotes_AddCustomQuote({text=..., category=...})
    quote = textOrTable
  else
    -- Called with separate args: MageQuotes_AddCustomQuote(text, category, sound, spec)
    quote = {
      text = textOrTable,
      category = category,
      sound = sound,
      spec = spec,
    }
  end
  
  if not quote.text or quote.text == "" then
    return false, "Quote text is required"
  end
  
  -- Normalize category
  quote.category = NormalizeCategory(quote.category)
  
  local newQuote = {
    text = quote.text,
    category = quote.category,
    sound = quote.sound or "",
    spec = quote.spec or "all",
    enabled = quote.enabled ~= false,
    created = time(),
  }
  
  table.insert(MageQuotesDB.customQuotes, newQuote)
  local quoteIndex = #MageQuotesDB.customQuotes
  
  LogDebug("Add", "Added quote #%d to '%s': %s", quoteIndex, newQuote.category, newQuote.text:sub(1, 30))
  
  -- CRITICAL: Notify core to rebuild caches
  NotifyCustomQuotesChanged()
  
  return true, "Quote added to '" .. newQuote.category .. "'!", quoteIndex
end

local function DeleteCustomQuote(index)
  EnsureDB()
  
  if not index or index < 1 or index > #MageQuotesDB.customQuotes then
    return false, "Invalid quote index"
  end
  
  local removed = table.remove(MageQuotesDB.customQuotes, index)
  
  LogDebug("Delete", "Deleted quote: %s", removed and removed.text:sub(1, 30) or "?")
  
  -- CRITICAL: Notify core to rebuild caches
  NotifyCustomQuotesChanged()
  
  return true
end

local function ToggleCustomQuote(index, enabled)
  EnsureDB()
  
  if not index or index < 1 or index > #MageQuotesDB.customQuotes then
    return false, "Invalid quote index"
  end
  
  MageQuotesDB.customQuotes[index].enabled = enabled
  
  LogDebug("Toggle", "Quote %d: %s", index, enabled and "enabled" or "disabled")
  
  -- CRITICAL: Notify core to rebuild caches
  NotifyCustomQuotesChanged()
  
  return true
end

local function GetCustomQuotes()
  EnsureDB()
  return MageQuotesDB.customQuotes
end

local function ClearAllCustomQuotes()
  EnsureDB()
  local count = #MageQuotesDB.customQuotes
  MageQuotesDB.customQuotes = {}
  
  LogDebug("Clear", "Cleared %d quotes", count)
  
  -- CRITICAL: Notify core to rebuild caches
  NotifyCustomQuotesChanged()
  
  return count
end

------------------------------------------------------------
-- Spell Trigger Functions
------------------------------------------------------------
local function AddSpellTrigger(spellID, quoteIndices)
  EnsureDB()
  
  if type(spellID) ~= "number" then
    return false, "Invalid spell ID"
  end
  
  MageQuotesDB.spellTriggers[spellID] = quoteIndices or {}
  
  LogDebug("Trigger", "Added spell trigger: %d", spellID)
  
  return true
end

local function GetSpellTriggers()
  EnsureDB()
  return MageQuotesDB.spellTriggers
end

------------------------------------------------------------
-- Global API Functions (Called by UI.lua)
------------------------------------------------------------

-- IMPORTANT: These match what UI.lua expects to call

function MageQuotes_AddCustomQuote(textOrTable, category, sound, spec)
  return AddCustomQuote(textOrTable, category, sound, spec)
end

function MageQuotes_DeleteCustomQuote(index)
  return DeleteCustomQuote(index)
end

function MageQuotes_ToggleCustomQuote(index, enabled)
  return ToggleCustomQuote(index, enabled)
end

function MageQuotes_GetCustomQuotes()
  return GetCustomQuotes()
end

function MageQuotes_ClearAllCustomQuotes()
  return ClearAllCustomQuotes()
end

function MageQuotes_ExportCustomQuotes(packName)
  return ExportQuotePack(packName)
end

function MageQuotes_ImportQuotePack(importString, merge)
  return ImportQuotePack(importString, merge)
end

function MageQuotes_AddSpellTrigger(spellID, quoteIndices)
  return AddSpellTrigger(spellID, quoteIndices)
end

------------------------------------------------------------
-- Public API Table
------------------------------------------------------------
MageQuotes_CustomQuotesAPI = {
  VERSION = ADDON_VERSION,
  
  AddQuote = AddCustomQuote,
  DeleteQuote = DeleteCustomQuote,
  ToggleQuote = ToggleCustomQuote,
  GetQuotes = GetCustomQuotes,
  ClearAll = ClearAllCustomQuotes,
  
  Export = ExportQuotePack,
  Import = ImportQuotePack,
  
  AddSpellTrigger = AddSpellTrigger,
  GetSpellTriggers = GetSpellTriggers,
  
  -- Category helpers
  NormalizeCategory = NormalizeCategory,
  GetValidCategories = function() return VALID_CATEGORIES end,
  
  IsEnabled = function() return true end,
  GetVersion = function() return ADDON_VERSION end,
}

------------------------------------------------------------
-- Static Popup for Clear Confirmation
------------------------------------------------------------
StaticPopupDialogs["MAGEQUOTES_CONFIRM_CLEAR_CUSTOM"] = {
  text = "Are you sure you want to delete ALL custom quotes?\n\nThis cannot be undone!",
  button1 = "Yes, Delete All",
  button2 = "Cancel",
  OnAccept = function()
    local count = MageQuotes_ClearAllCustomQuotes()
    print("|cffffaa00MageQuotes:|r Cleared " .. count .. " custom quotes.")
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

------------------------------------------------------------
-- Slash Commands
------------------------------------------------------------
SLASH_MQCUSTOM1 = "/mqc"
SlashCmdList["MQCUSTOM"] = function(msg)
  local args = {}
  for word in (msg or ""):gmatch("%S+") do
    table.insert(args, word)
  end
  
  local cmd = (args[1] or ""):lower()
  
  if cmd == "help" or cmd == "" then
    print("|cffffaa00MageQuotes Custom v" .. ADDON_VERSION .. "|r")
    print("  /mqc help - Show this help")
    print("  /mqc add <category> <text> - Add a quote")
    print("  /mqc list - List all custom quotes")
    print("  /mqc delete <index> - Delete a quote")
    print("  /mqc toggle <index> - Toggle quote on/off")
    print("  /mqc export - Export all quotes")
    print("  /mqc import <string> - Import quotes")
    print("  /mqc clear - Clear all custom quotes")
    print("  /mqc status - Show status and bucket counts")
    print("")
    print("  Categories: init, kill, surv, vict, rare, mid, greet")
    print("  Aliases: survival->surv, victory->vict, combat->init")
    
  elseif cmd == "add" then
    if #args < 3 then
      print("|cffff0000Usage:|r /mqc add <category> <text>")
      print("|cff888888Categories: init, kill, surv, vict, rare, mid, greet|r")
      return
    end
    local category = args[2]:lower()
    local text = table.concat(args, " ", 3)
    
    local success, msg, index = AddCustomQuote(text, category)
    if success then
      local normalizedCat = NormalizeCategory(category)
      print("|cff00ff00Quote #" .. (index or "?") .. " added!|r Category: " .. normalizedCat)
      print("|cff888888Use '/mq test " .. normalizedCat .. "' to test it|r")
    else
      print("|cffff0000Error:|r " .. (msg or "Unknown error"))
    end
    
  elseif cmd == "list" then
    EnsureDB()
    local quotes = MageQuotesDB.customQuotes
    if #quotes == 0 then
      print("|cffffaa00No custom quotes.|r")
      return
    end
    
    print("|cffffaa00Custom Quotes (" .. #quotes .. "):|r")
    for i, q in ipairs(quotes) do
      local status = q.enabled ~= false and "|cff00ff00[ON]|r" or "|cffff0000[OFF]|r"
      local display = q.text:sub(1, 40)
      if #q.text > 40 then display = display .. "..." end
      print(string.format("  %d. %s [%s] %s", i, status, q.category, display))
    end
    
  elseif cmd == "status" then
    EnsureDB()
    local quotes = MageQuotesDB.customQuotes
    print("|cffffaa00MageQuotes Custom Status:|r")
    print("  Custom quotes:", #quotes)
    
    -- Count by category
    local byCategory = {}
    for _, q in ipairs(quotes) do
      if q.enabled ~= false then
        local cat = q.category or "init"
        byCategory[cat] = (byCategory[cat] or 0) + 1
      end
    end
    
    if next(byCategory) then
      local parts = {}
      for cat, count in pairs(byCategory) do
        table.insert(parts, cat .. "=" .. count)
      end
      print("  By category (enabled):", table.concat(parts, ", "))
    end
    
    -- Show bucket counts from Core
    if MageQuotesAPI and MageQuotesAPI.GetBucketSummary then
      local summary = MageQuotesAPI.GetBucketSummary()
      local parts = {}
      for k, v in pairs(summary) do
        if v > 0 then
          table.insert(parts, k .. "=" .. v)
        end
      end
      print("  Core buckets:", table.concat(parts, ", "))
    end
    
  elseif cmd == "delete" or cmd == "remove" then
    local index = tonumber(args[2])
    if not index then
      print("|cffff0000Usage:|r /mqc delete <index>")
      return
    end
    
    local success, msg = DeleteCustomQuote(index)
    if success then
      print("|cff00ff00Quote deleted!|r")
    else
      print("|cffff0000Error:|r " .. (msg or "Unknown error"))
    end
    
  elseif cmd == "toggle" then
    local index = tonumber(args[2])
    if not index then
      print("|cffff0000Usage:|r /mqc toggle <index>")
      return
    end
    
    EnsureDB()
    local quote = MageQuotesDB.customQuotes[index]
    if not quote then
      print("|cffff0000Invalid index|r")
      return
    end
    
    local newState = not (quote.enabled ~= false)
    ToggleCustomQuote(index, newState)
    print("|cffffaa00Quote " .. index .. " " .. (newState and "enabled" or "disabled") .. "|r")
    
  elseif cmd == "export" then
    local result, err = ExportQuotePack("MyQuotes")
    if result then
      print("|cff00ff00Export successful!|r Copy this string:")
      print(result)
    else
      print("|cffff0000Export failed:|r " .. (err or "Unknown error"))
    end
    
  elseif cmd == "import" then
    if #args < 2 then
      print("|cffff0000Usage:|r /mqc import <string>")
      return
    end
    local importString = table.concat(args, " ", 2)
    
    local success, result = ImportQuotePack(importString, true)
    if success then
      print("|cff00ff00" .. result .. "|r")
    else
      print("|cffff0000Import failed:|r " .. (result or "Unknown error"))
    end
    
  elseif cmd == "clear" then
    StaticPopup_Show("MAGEQUOTES_CONFIRM_CLEAR_CUSTOM")
    
  else
    print("|cffff0000Unknown command:|r " .. cmd .. " - Use /mqc help")
  end
end

------------------------------------------------------------
-- Initialization
------------------------------------------------------------
local function Initialize()
  EnsureDB()
  LogDebug("Init", "CustomQuotes module v%s loaded with %d quotes", 
           ADDON_VERSION, #MageQuotesDB.customQuotes)
  
  -- Initial cache rebuild to include custom quotes
  C_Timer.After(1, function()
    if #MageQuotesDB.customQuotes > 0 then
      LogDebug("Init", "Triggering initial cache rebuild for %d custom quotes", 
               #MageQuotesDB.customQuotes)
      NotifyCustomQuotesChanged()
    end
  end)
end

if MageQuotesDB then
  Initialize()
else
  C_Timer.After(1, Initialize)
end

if MageQuotes_EventBus and MageQuotes_EventBus.RegisterCallback then
  MageQuotes_EventBus:RegisterCallback("MAGE_QUOTES_LOCALE_CHANGED", function()
    LogDebug("Event", "Locale changed, custom quotes will be re-integrated")
  end, MODULE_NAME)
end

print("|cffffaa00MageQuotes CustomQuotes v" .. ADDON_VERSION .. " loaded|r - /mqc help")
