-- MageQuotes_Core.lua
-- Core logic: saved vars, locale/caches, events, quote sending, minimap button
-- FULLY UPDATED for WoW Midnight 12.0.0.65560
-- v1.8.0 - FIXED: Custom quotes now fire correctly
-- Compatible with new API restrictions and combat log changes

local addonName = ...
local ADDON_VERSION = "1.8.0"
local Core = CreateFrame("Frame")
_G.MageQuotesCore = Core
Core.VERSION = ADDON_VERSION

------------------------------------------------------------
-- Debug & Error Logging System
------------------------------------------------------------
local debugLog = {}
local MAX_DEBUG_ENTRIES = 100

local function LogDebug(category, message, ...)
  if not MageQuotesDB or not MageQuotesDB.debugMode then return end
  
  local timestamp = date("%H:%M:%S")
  local formatted = string.format(message, ...)
  local entry = {
    time = GetTime(),
    timestamp = timestamp,
    category = category,
    message = formatted
  }
  
  table.insert(debugLog, entry)
  if #debugLog > MAX_DEBUG_ENTRIES then
    table.remove(debugLog, 1)
  end
  
  if MageQuotesDB.debugPrint then
    print(string.format("|cff00ff00[MQ Debug]|r [%s] [%s] %s", timestamp, category, formatted))
  end
end

local function LogError(context, err)
  MageQuotesDB.errors = MageQuotesDB.errors or {}
  table.insert(MageQuotesDB.errors, {
    time = date("%Y-%m-%d %H:%M:%S"),
    context = context,
    error = tostring(err)
  })
  
  if #MageQuotesDB.errors > 50 then
    table.remove(MageQuotesDB.errors, 1)
  end
end

------------------------------------------------------------
-- Event bus (MIDNIGHT COMPATIBLE - Always use local bus)
------------------------------------------------------------
local function CreateLocalBus()
  if MageQuotesLib and MageQuotesLib.CreateLocalBus then
    return MageQuotesLib.CreateLocalBus()
  end

  return {
    _cbs = {},
    RegisterCallback = function(self, event, func, owner)
      self._cbs[event] = self._cbs[event] or {}
      table.insert(self._cbs[event], { func = func, owner = owner })
    end,
    UnregisterCallback = function(self, event, func, owner)
      local list = self._cbs[event]
      if not list then return end
      for i = #list, 1, -1 do
        local cb = list[i]
        if (not func or cb.func == func) and (not owner or cb.owner == owner) then
          table.remove(list, i)
        end
      end
    end,
    TriggerEvent = function(self, event, ...)
      local list = self._cbs[event]
      if not list then return end
      for _, cb in ipairs(list) do
        local success, err = pcall(cb.func, cb.owner, ...)
        if not success then
          LogError("EventBus:" .. event, err)
        end
      end
    end,
  }
end

-- MIDNIGHT FIX: Always use our local event bus
-- The global EventRegistry may have restrictions
if not MageQuotes_EventBus then
  MageQuotes_EventBus = CreateLocalBus()
end

function Core:TriggerEvent(event, ...)
  if MageQuotes_EventBus and MageQuotes_EventBus.TriggerEvent then
    MageQuotes_EventBus:TriggerEvent(event, ...)
  end
end

------------------------------------------------------------
-- Saved Variables
------------------------------------------------------------
MageQuotesDB = MageQuotesDB or {
  version       = ADDON_VERSION,
  enabled       = true,
  quoteCooldown = 10,
  rarity        = 1.0,
  channel       = "SAY",
  minimap       = { hide = false },
  locale        = nil,
  weights       = { init = 1.0, kill = 1.0, surv = 1.0, vict = 1.0 },
  rareChance    = 0.02,
  survHPpct     = 35,
  debugMode     = false,
  debugPrint    = false,
  -- NEW: Option to test survival quotes outside combat
  testModeOutOfCombat = false,
}

MageQuotesDB.spec = MageQuotesDB.spec or {
  preview = "auto",
}

MageQuotesDB.sound = MageQuotesDB.sound or {
  enabled            = true,
  channel            = "Master",
  debug              = true,
  actors             = { "MageA", "MageB" },
  actorIndex         = 1,
  templateNoLocale   = "$ADDON\\Voices\\$ACTOR\\$FILENAME",
  templateWithLocale = "$ADDON\\Voices\\$ACTOR\\$LOCALE\\$FILENAME",
}

MageQuotes_Data = {
  sections  = nil,
  greetings = nil,
  allQuotes = nil,
  channels  = { "SAY", "YELL", "PARTY", "RAID", "INNER_WHISPER" },
  bySection = nil,
}

MageQuotesDB.majorCD = MageQuotesDB.majorCD or {
  enabled     = true,
  spamWindow  = 8,
  spamMax     = 2,
  spamLockout = 6,
}

MageQuotesDB.midCombat = MageQuotesDB.midCombat or {
  enabled = true,
  min     = 18,
  max     = 34,
  chance  = 0.40,
}

MageQuotesDB.categories = MageQuotesDB.categories or {}

local lastAnyQuoteAt = 0
local lastQuoteData = nil

------------------------------------------------------------
-- Normalization Helpers
------------------------------------------------------------
local function NormalizeEntry(entry)
  if type(entry) == "string" then
    return { text = entry }
  elseif type(entry) == "table" then
    if not entry.text then
      local first = entry[1]
      entry.text = type(first) == "string" and first or ""
    end
    return entry
  else
    return { text = "" }
  end
end

------------------------------------------------------------
-- Modern Spell Resolution (Midnight compatible)
------------------------------------------------------------
local spellNameCache = {}

local function GetSpellNameSafe(spellID)
  if type(spellID) ~= "number" then return nil end
  
  if spellNameCache[spellID] then
    return spellNameCache[spellID]
  end
  
  local name
  
  -- Primary: C_Spell API (Midnight)
  if C_Spell and C_Spell.GetSpellName then
    local success, result = pcall(C_Spell.GetSpellName, spellID)
    if success and result then
      name = result
    end
  end
  
  -- Fallback: Try spell info
  if not name and C_Spell and C_Spell.GetSpellInfo then
    local success, info = pcall(C_Spell.GetSpellInfo, spellID)
    if success and info and info.name then
      name = info.name
    end
  end
  
  if name then
    spellNameCache[spellID] = name
  end
  
  return name
end

------------------------------------------------------------
-- Locale helpers
------------------------------------------------------------
local SUPPORTED_LOCALES = { "enUS", "ruRU", "deDE", "itIT" }

local function IsSupportedLocale(loc)
  if not loc then return false end
  for _, L in ipairs(SUPPORTED_LOCALES) do
    if L == loc then return true end
  end
  return false
end

local ACTIVE_LOCALE
local L = nil

MageQuotesLocale = MageQuotesLocale or {
  enUS = {
    ui = {
      title            = "Mage Quotes",
      enable           = "Enable Mage Quotes",
      cooldownLabel    = "Quote Cooldown",
      rarityLabel      = "Quote Chance",
      channelLabel     = "Message Channel",
      availableHeader  = "Available Mage Quotes:",
      voiceActor       = "Voice Actor",
      voiceActorHint   = "Folder in Voices/<Actor>",
    },
    sections = {
      { header = "Combat Initiation", quotes = {
        "Focus the weave—attack!",
        "Ignite the battlefield!",
      }},
      { header = "Killing Blows", quotes = {
        "Frozen. Shattered.",
        "Ashes remain.",
      }},
      { header = "Survival", quotes = {
        "Barrier up—keep moving!",
        "Ice answers pain with calm.",
      }},
      { header = "Victory", quotes = {
        "The weave bends to will—done.",
        "Silence falls. We endure.",
      }},
      { header = "Rare", quotes = {
        "Magic is life, not tool.",
      }},
    },
    greetings = {
      { text = "Arcane steady; mind clearer.", file = "MageGreeting01" },
    },
  },
}

local function SectionKeyFromHeader(h)
  if not h or type(h) ~= "string" then return nil end
  local s = h:lower()

  if s:find("combat initiation") then return "init" end
  if s:find("killing")           then return "kill" end
  if s:find("survival")          then return "surv" end
  if s:find("victory")           then return "vict" end
  if s:find("rare")              then return "rare" end
  if s:find("mid%-combat")       then return "mid" end

  -- RU
  if s:find("начало боя")   then return "init" end
  if s:find("смертельн")    then return "kill" end
  if s:find("выживан")      then return "surv" end
  if s:find("побед")        then return "vict" end
  if s:find("редк")         then return "rare" end
  if s:find("в бою")        then return "mid" end

  return nil
end

local function pickLocale()
  -- First try to get locale from UIStrings module (source of truth)
  if MageQuotes_GetUIStrings then
    local _, activeLocale = MageQuotes_GetUIStrings()
    if activeLocale and IsSupportedLocale(activeLocale) then
      return activeLocale
    end
  end
  -- Fallback to DB or client locale
  local fromDB = MageQuotesDB.locale
  local candidate = fromDB or GetLocale() or "enUS"
  if not IsSupportedLocale(candidate) then candidate = "enUS" end
  return candidate
end

local function _basenameNoExt(path)
  if MageQuotesLib and MageQuotesLib.BasenameNoExt then 
    return MageQuotesLib.BasenameNoExt(path) 
  end
  if type(path) ~= "string" then return nil end
  local name = path:gsub("\\\\", "/")
  name = name:match("([^/]+)$") or name
  return (name:gsub("%.%w+$",""))
end

local function _trim(s)
  if MageQuotesLib and MageQuotesLib.Trim then 
    return MageQuotesLib.Trim(s) 
  end
  if type(s) ~= "string" then return s end
  return (s:gsub("^%s+",""):gsub("%s+$",""))
end

local HeaderByKey = {}

local function ValidateLocale(localeCode)
  local locale = MageQuotesLocale[localeCode]
  if not locale then 
    return false, "Locale not found: " .. tostring(localeCode)
  end
  
  local required = {"ui", "sections"}
  for _, key in ipairs(required) do
    if not locale[key] then
      return false, "Missing required key: " .. key
    end
  end
  
  return true
end

------------------------------------------------------------
-- Specialization helpers
------------------------------------------------------------
local function _specKeyFromSpecID(id)
  if id == 62 then return "arcane"
  elseif id == 63 then return "fire"
  elseif id == 64 then return "frost"
  end
  return "arcane"
end

local function MageQuotes_GetActiveSpecKey()
  local mode = (MageQuotesDB.spec and MageQuotesDB.spec.preview) or "auto"
  if mode == "all" or mode == "arcane" or mode == "fire" or mode == "frost" then
    return mode
  end
  
  if GetSpecialization then
    local idx = GetSpecialization()
    if idx then
      local success, id1, id2, id3, id4, id5, specID = pcall(GetSpecializationInfo, idx)
      if success and specID then
        return _specKeyFromSpecID(specID)
      end
    end
  end
  return "arcane"
end

------------------------------------------------------------
-- Spam Prevention
------------------------------------------------------------
local _cdSpamTimes = {}
local _cdSpamMutedUntil = 0

local function MajorCdSpamGate()
  local cfg = MageQuotesDB.majorCD or {}
  if cfg.enabled == false then return true end

  local now     = GetTime()
  local window  = tonumber(cfg.spamWindow)  or 8
  local maxHits = tonumber(cfg.spamMax)     or 2
  local lockout = tonumber(cfg.spamLockout) or 6

  if now < _cdSpamMutedUntil then
    LogDebug("SpamGate", "Muted until %.1f", _cdSpamMutedUntil)
    return false
  end

  for i = #_cdSpamTimes, 1, -1 do
    if (now - _cdSpamTimes[i]) > window then
      table.remove(_cdSpamTimes, i)
    end
  end

  if #_cdSpamTimes >= maxHits then
    _cdSpamMutedUntil = now + lockout
    LogDebug("SpamGate", "Spam limit reached, muted for %ds", lockout)
    return false
  end

  table.insert(_cdSpamTimes, now)
  return true
end

------------------------------------------------------------
-- Forward declarations
------------------------------------------------------------
local EmitFromBucketKey
local EmitFromBucketKey_NoCD
local rebuildCaches

------------------------------------------------------------
-- MIDNIGHT-COMPATIBLE Spell Trigger System
-- Uses UNIT_SPELLCAST events instead of combat log
-- Extended for ALL quote categories
------------------------------------------------------------
local MageQuotes_SpellTriggers = {
  ------------------------------------------------------------
  -- COMBAT INITIATION (init) - Major offensive cooldowns
  ------------------------------------------------------------
  [12042]  = { category = "init", noCD = true, spamGate = true },  -- Arcane Power
  [12472]  = { category = "init", noCD = true, spamGate = true },  -- Icy Veins
  [190319] = { category = "init", noCD = true, spamGate = true },  -- Combustion
  [80353]  = { category = "init", noCD = true, spamGate = true },  -- Time Warp
  [365350] = { category = "init", noCD = true, spamGate = true },  -- Arcane Surge
  [382440] = { category = "init", noCD = true, spamGate = true },  -- Shifting Power
  [205025] = { category = "init", noCD = true, spamGate = true },  -- Presence of Mind
  [321507] = { category = "init", noCD = true, spamGate = true },  -- Touch of the Magi
  
  ------------------------------------------------------------
  -- SURVIVAL (surv) - Defensive abilities
  ------------------------------------------------------------
  [45438]  = { category = "surv", noCD = true },  -- Ice Block
  [11426]  = { category = "surv" },               -- Ice Barrier (Frost)
  [235313] = { category = "surv" },               -- Blazing Barrier (Fire)
  [235450] = { category = "surv" },               -- Prismatic Barrier (Arcane)
  [110959] = { category = "surv" },               -- Greater Invisibility
  [342246] = { category = "surv" },               -- Alter Time
  [108978] = { category = "surv" },               -- Alter Time (legacy)
  [55342]  = { category = "surv" },               -- Mirror Image
  [414660] = { category = "surv" },               -- Mass Barrier
  [414658] = { category = "surv" },               -- Ice Cold
  
  ------------------------------------------------------------
  -- MID-COMBAT (mid) - Control, utility and interrupt spells
  ------------------------------------------------------------
  [31661]  = { category = "mid" },                -- Dragon's Breath
  [113724] = { category = "mid" },                -- Ring of Frost
  [157981] = { category = "mid" },                -- Blast Wave
  [157997] = { category = "mid" },                -- Ice Nova
  [122]    = { category = "mid" },                -- Frost Nova
  [120]    = { category = "mid" },                -- Cone of Cold
  [2139]   = { category = "mid" },                -- Counterspell
  [118]    = { category = "mid" },                -- Polymorph
  [1953]   = { category = "mid" },                -- Blink
  [212653] = { category = "mid" },                -- Shimmer
  [475]    = { category = "mid" },                -- Remove Curse
  [30449]  = { category = "mid" },                -- Spellsteal
  [383121] = { category = "mid" },                -- Mass Polymorph
  
  ------------------------------------------------------------
  -- KILL (kill) - Big damage finishers / execute spells
  ------------------------------------------------------------
  [153561] = { category = "kill" },               -- Meteor
  [257542] = { category = "kill" },               -- Phoenix Flames
  [44457]  = { category = "kill" },               -- Living Bomb (proc explosion)
  [84721]  = { category = "kill" },               -- Frozen Orb
  [190356] = { category = "kill" },               -- Blizzard
  [153595] = { category = "kill" },               -- Comet Storm
  [44425]  = { category = "kill" },               -- Arcane Barrage
  [153626] = { category = "kill" },               -- Arcane Orb
  [2948]   = { category = "kill" },               -- Scorch (execute range)
  
  ------------------------------------------------------------
  -- RARE (rare) - Utility, out-of-combat, situational
  ------------------------------------------------------------
  [190336] = { category = "rare" },               -- Conjure Refreshment
  [42955]  = { category = "rare" },               -- Conjure Refreshment Table
  [66]     = { category = "rare" },               -- Invisibility
  [1459]   = { category = "rare" },               -- Arcane Intellect
  [130]    = { category = "rare" },               -- Slow Fall
  [759]    = { category = "rare" },               -- Conjure Mana Gem
  [389713] = { category = "rare" },               -- Displacement
}

-- Defensive auras to monitor (survival category) - backup detection via buff
local SURVIVAL_AURAS = {
  45438,   -- Ice Block
  11426,   -- Ice Barrier (Frost)
  235313,  -- Blazing Barrier (Fire)
  235450,  -- Prismatic Barrier (Arcane)
  110959,  -- Greater Invisibility
  342246,  -- Alter Time (buff)
  108978,  -- Alter Time (legacy)
  55342,   -- Mirror Image
}

local function HandleSpellCast(spellID)
  if not spellID then return false end
  
  local trigger = MageQuotes_SpellTriggers[spellID]
  if not trigger then return false end
  
  LogDebug("Trigger", "Spell cast: %d (%s) -> category: %s", 
    spellID, GetSpellNameSafe(spellID) or "unknown", trigger.category)
  
  if trigger.spamGate and not MajorCdSpamGate() then
    return true
  end
  
  if trigger.noCD then
    EmitFromBucketKey_NoCD(trigger.category)
  else
    EmitFromBucketKey(trigger.category)
  end
  
  return true
end

------------------------------------------------------------
-- INNER WHISPER
------------------------------------------------------------
local SPEC_WHISPER_COLORS = {
  arcane = { r = 0.65, g = 0.80, b = 1.00 },
  fire   = { r = 1.00, g = 0.45, b = 0.25 },
  frost  = { r = 0.55, g = 0.90, b = 1.00 },
}

local function GetInnerWhisperPrefix()
  local name = UnitName("player") or "Mage"
  local fullName = name

  local titleIndex = GetCurrentTitle and GetCurrentTitle()
  if titleIndex and titleIndex > 0 then
    local title = GetTitleName and GetTitleName(titleIndex)
    if title and title ~= "" then
      if title:find("%%s") then
        local ok, out = pcall(string.format, title, name)
        if ok and out and out ~= "" then
          fullName = out
        end
      else
        local lower = title:lower()
        local isSuffix =
          lower:match("^the%s") or
          lower:match("^of%s")  or
          lower:match("^из%s")  or
          lower:match("^von%s") or
          lower:match("^van%s") or
          lower:match("^der%s") or
          lower:match("^den%s")

        if isSuffix then
          fullName = name .. " " .. title
        else
          fullName = title .. " " .. name
        end
      end
    end
  end

  return "|cffc77dff«" .. fullName .. "»|r "
end

function MageQuotes_SendInnerWhisper(text, spec)
  if not text or text == "" then return end

  local sk = spec or (MageQuotes_GetActiveSpecKey and MageQuotes_GetActiveSpecKey()) or "arcane"
  local c  = SPEC_WHISPER_COLORS[sk] or { r = 0.9, g = 0.6, b = 1.0 }

  DEFAULT_CHAT_FRAME:AddMessage(
    GetInnerWhisperPrefix() .. text,
    c.r, c.g, c.b
  )
end

------------------------------------------------------------
-- Rebuild caches (CRITICAL FOR CUSTOM QUOTES)
------------------------------------------------------------
rebuildCaches = function()
  ACTIVE_LOCALE = pickLocale()
  
  local valid, err = ValidateLocale(ACTIVE_LOCALE)
  if not valid then
    LogError("Locale", err)
    print("|cffff0000Mage Quotes:|r " .. err)
    ACTIVE_LOCALE = "enUS"
  end
  
  local source = MageQuotesLocale or {}
  L = source[ACTIVE_LOCALE] or source["enUS"] or MageQuotesLocale.enUS

  MageQuotes_Data.sections  = {}
  MageQuotes_Data.greetings = {}
  MageQuotes_Data.allQuotes = {}
  MageQuotes_Data.bySection = { init = {}, kill = {}, surv = {}, mid = {}, vict = {}, rare = {}, greet = {} }
  HeaderByKey = {}

  local activeSpecKey = MageQuotes_GetActiveSpecKey()

  local function _isSpecAllowed(qspec)
    if not qspec or qspec == "" or qspec == "all" then return true end
    if activeSpecKey == "all" then return true end
    return qspec == activeSpecKey
  end

  -- Load built-in quotes from locale
  for _, sec in ipairs(L.sections or {}) do
    local normSec = { header = sec.header or "", quotes = {} }
    local skey = SectionKeyFromHeader(normSec.header)
    if skey and not HeaderByKey[skey] then 
      HeaderByKey[skey] = normSec.header 
    end

    for _, q in ipairs(sec.quotes or {}) do
      local obj = NormalizeEntry(q)
      if _isSpecAllowed(obj.spec) then
        if type(obj.sound) == "string" and not obj.soundKey then
          obj.soundKey = _basenameNoExt(obj.sound)
        end
        if not obj.file and obj.soundKey then
          obj.file = obj.soundKey
        end
        if obj.text and obj.text ~= "" then
          obj._section = skey
          obj.custom = false
          table.insert(normSec.quotes, obj)
          table.insert(MageQuotes_Data.allQuotes, obj)
          if skey and MageQuotes_Data.bySection[skey] then
            table.insert(MageQuotes_Data.bySection[skey], obj)
          end
        end
      end
    end
    table.insert(MageQuotes_Data.sections, normSec)
  end

  -- Load built-in greetings
  for _, g in ipairs(L.greetings or {}) do
    local obj = NormalizeEntry(g)
    if _isSpecAllowed(obj.spec) then
      if type(obj.sound) == "string" and not obj.soundKey then
        obj.soundKey = _basenameNoExt(obj.sound)
      end
      if not obj.file and obj.soundKey then
        obj.file = obj.soundKey
      end
      if obj.text and obj.text ~= "" then
        obj.custom = false
        table.insert(MageQuotes_Data.greetings, obj)
        table.insert(MageQuotes_Data.bySection.greet, obj)
      end
    end
  end

  ------------------------------------------------------------
  -- CRITICAL FIX: Load Custom Quotes into bySection buckets
  -- This is what allows custom quotes to actually fire!
  ------------------------------------------------------------
  local customQuoteCount = 0
  local customQuotesByCategory = {}
  
  -- Method 1: Direct access to MageQuotesDB.customQuotes
  if MageQuotesDB and MageQuotesDB.customQuotes then
    for _, cq in ipairs(MageQuotesDB.customQuotes) do
      if cq.enabled ~= false and _isSpecAllowed(cq.spec) then
        -- Normalize category key (handle variations)
        local catKey = (cq.category or "init"):lower()
        -- Map common variations
        if catKey == "survival" then catKey = "surv" end
        if catKey == "victory" then catKey = "vict" end
        if catKey == "combat" or catKey == "initiation" then catKey = "init" end
        if catKey == "killing" or catKey == "kb" then catKey = "kill" end
        if catKey == "greeting" then catKey = "greet" end
        if catKey == "midcombat" or catKey == "mid-combat" then catKey = "mid" end
        
        local obj = {
          text = cq.text,
          sound = cq.sound,
          soundKey = cq.sound,
          file = cq.sound,
          spec = cq.spec or "all",
          custom = true,
          _section = catKey,
          _customIndex = customQuoteCount + 1,
        }
        
        -- Add to allQuotes
        table.insert(MageQuotes_Data.allQuotes, obj)
        customQuoteCount = customQuoteCount + 1
        
        -- Add to bySection bucket
        if MageQuotes_Data.bySection[catKey] then
          table.insert(MageQuotes_Data.bySection[catKey], obj)
          customQuotesByCategory[catKey] = (customQuotesByCategory[catKey] or 0) + 1
          LogDebug("Cache", "Custom quote added to '%s': %s", catKey, cq.text:sub(1, 40))
        else
          LogDebug("Cache", "WARNING: Unknown category '%s' for custom quote, defaulting to 'init'", catKey)
          table.insert(MageQuotes_Data.bySection.init, obj)
          customQuotesByCategory.init = (customQuotesByCategory.init or 0) + 1
        end
        
        -- Handle greetings specially
        if catKey == "greet" then
          table.insert(MageQuotes_Data.greetings, obj)
        end
      end
    end
  end
  
  -- Method 2: Also try the API if available (belt and suspenders)
  if MageQuotes_CustomQuotesAPI and MageQuotes_CustomQuotesAPI.IsEnabled and 
     MageQuotes_CustomQuotesAPI.IsEnabled() and MageQuotes_GetCustomQuotes then
    -- Already handled above via direct DB access
    -- This is kept for compatibility with future changes
  end

  -- Log summary
  local bucketSummary = {}
  for k, v in pairs(MageQuotes_Data.bySection) do
    if #v > 0 then
      table.insert(bucketSummary, k .. "=" .. #v)
    end
  end
  
  LogDebug("Cache", "Rebuilt: %d sections, %d total quotes (%d custom)", 
    #MageQuotes_Data.sections, #MageQuotes_Data.allQuotes, customQuoteCount)
  LogDebug("Cache", "Buckets: %s", table.concat(bucketSummary, ", "))
  
  if customQuoteCount > 0 then
    local catList = {}
    for cat, count in pairs(customQuotesByCategory) do
      table.insert(catList, cat .. ":" .. count)
    end
    LogDebug("Cache", "Custom quotes by category: %s", table.concat(catList, ", "))
  end
  
  MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_LOCALE_CHANGED", ACTIVE_LOCALE)
end

------------------------------------------------------------
-- Public APIs
------------------------------------------------------------
-- NOTE: MageQuotes_GetUIStrings() and MageQuotes_SetLocale() are now defined
-- in MageQuotes_UIStrings.lua for UI translations. The Core only needs to
-- rebuild quote caches when locale changes.

-- Hook into locale changes from UIStrings module
local _originalSetLocale = MageQuotes_SetLocale
if _originalSetLocale then
  MageQuotes_SetLocale = function(loc)
    -- Call original (from UIStrings.lua) first
    _originalSetLocale(loc)
    -- Then rebuild quote caches
    rebuildCaches()
    LogDebug("Locale", "Locale changed to %s, caches rebuilt", loc)
  end
end

-- Provide a fallback if UIStrings didn't load
if not MageQuotes_GetUIStrings then
  function MageQuotes_GetUIStrings()
    if not L then rebuildCaches() end
    return (L and L.ui or {}), ACTIVE_LOCALE, SUPPORTED_LOCALES
  end
end

if not MageQuotes_SetLocale then
  function MageQuotes_SetLocale(loc)
    if not IsSupportedLocale(loc) then
      print("|cffffd700Mage Quotes:|r Unsupported locale:", tostring(loc))
      return
    end
    MageQuotesDB.locale = loc
    rebuildCaches()
    print("|cffffd700Mage Quotes:|r Locale set to", loc)
  end
end

-- Provide MageQuotes_GetUIString if not available from UIStrings
if not MageQuotes_GetUIString then
  function MageQuotes_GetUIString(key, locale)
    locale = locale or ACTIVE_LOCALE or pickLocale()
    local strings = MageQuotes_UIStrings and MageQuotes_UIStrings[locale]
    if strings and strings[key] then
      return strings[key]
    end
    -- Fallback to English
    if MageQuotes_UIStrings and MageQuotes_UIStrings["enUS"] then
      return MageQuotes_UIStrings["enUS"][key] or key
    end
    return key
  end
end

local function _catKey(header) 
  return tostring(header or "") 
end

local function GetOrInitCategoryCfg(header)
  local key = _catKey(header)
  local cat = MageQuotesDB.categories[key]
  if not cat then
    cat = { 
      enabled = true, 
      cooldown = MageQuotesDB.quoteCooldown or 10, 
      chance = 100 
    }
    MageQuotesDB.categories[key] = cat
  end
  return cat
end

function Core:GetOrInitCategoryCfg(header) 
  return GetOrInitCategoryCfg(header) 
end

------------------------------------------------------------
-- Chat helpers (MIDNIGHT COMPATIBLE - Inner Whisper ONLY)
------------------------------------------------------------
-- IMPORTANT: In WoW Midnight 12.0, SendChatMessage is a protected
-- function that addons CANNOT use. All quotes are now displayed
-- via Inner Whisper (local chat frame messages only).
------------------------------------------------------------

-- No longer needed - all channels now use Inner Whisper
local function GetEffectiveChannel()
  return "INNER_WHISPER"
end

-- Simplified - no queue needed since Inner Whisper always works
local function SendChatMsg(msg, qspec)
  if not msg or msg == "" then return end
  
  -- ALL messages now go through Inner Whisper
  -- This is the ONLY safe method in Midnight
  MageQuotes_SendInnerWhisper(msg, qspec)
end

------------------------------------------------------------
-- Sound resolution
------------------------------------------------------------
local function CurrentActor()
  local snd  = MageQuotesDB.sound or {}
  local list = snd.actors or { "MageA", "MageB" }
  local idx  = snd.actorIndex or 1
  local name = list[idx] or list[1] or "MageA"
  return _trim(name)
end

local function BuildPath_Actor_NoLocale(filename)
  if not filename or filename == "" then return nil end
  filename = _trim(filename)
  local base  = "Interface\\AddOns\\" .. (addonName or "MageQuotes")
  local actor = CurrentActor()
  local tmpl  = (MageQuotesDB.sound and MageQuotesDB.sound.templateNoLocale)
                or "$ADDON\\Voices\\$ACTOR\\$FILENAME"
  local p = tmpl
    :gsub("%%","%%%%")
    :gsub("%$ADDON", base)
    :gsub("%$ACTOR", actor)
    :gsub("%$FILENAME", filename)
  return _trim(p)
end

local function BuildPath_Actor_WithLocale(filename)
  if not filename or filename == "" then return nil end
  filename = _trim(filename)
  local base  = "Interface\\AddOns\\" .. (addonName or "MageQuotes")
  local actor = CurrentActor()
  local loc   = ACTIVE_LOCALE or GetLocale() or "enUS"
  local tmpl  = (MageQuotesDB.sound and MageQuotesDB.sound.templateWithLocale)
                or "$ADDON\\Voices\\$ACTOR\\$LOCALE\\$FILENAME"
  local p = tmpl
    :gsub("%%","%%%%")
    :gsub("%$ADDON", base)
    :gsub("%$ACTOR", actor)
    :gsub("%$LOCALE", loc)
    :gsub("%$FILENAME", filename)
  return _trim(p)
end

local function _slashVariants(p)
  local fwd = p:gsub("\\", "/")
  local bwd = p:gsub("/", "\\")
  if fwd == bwd then return { bwd } end
  return { bwd, fwd }
end

local function _tryCandidates(chan, candidates, tried)
  local seen = {}
  for _, raw in ipairs(candidates) do
    for _, p in ipairs(_slashVariants(raw)) do
      if not seen[p] then
        seen[p] = true
        table.insert(tried, p)
        local ok, willPlay = pcall(PlaySoundFile, p, chan)
        if ok and (willPlay == true or willPlay == 1 or type(willPlay) == "userdata") then
          return true
        end
      end
    end
  end
  return false
end

local function BuildActorCandidatesFromEntry(entry)
  local cands = {}
  if type(entry.sound) == "string" and entry.sound:find("[/\\]") then
    table.insert(cands, _trim(entry.sound))
  end
  
  local function addBothLayouts(stem)
    if not stem or stem == "" then return end
    stem = _trim(stem)
    local ext = stem:match("%.(%w+)$")
    if ext then
      local base = stem:sub(1, #stem - (#ext + 1))
      local extL = ext:lower()
      local extU = ext:upper()
      table.insert(cands, BuildPath_Actor_NoLocale(base .. "." .. extL))
      table.insert(cands, BuildPath_Actor_NoLocale(base .. "." .. extU))
      table.insert(cands, BuildPath_Actor_WithLocale(base .. "." .. extL))
      table.insert(cands, BuildPath_Actor_WithLocale(base .. "." .. extU))
      return
    end
    local exts = { "ogg", "mp3", "wav" }
    for _, e in ipairs(exts) do
      table.insert(cands, BuildPath_Actor_NoLocale(stem .. "." .. e))
      table.insert(cands, BuildPath_Actor_WithLocale(stem .. "." .. e))
      table.insert(cands, BuildPath_Actor_NoLocale(stem .. "." .. e:upper()))
      table.insert(cands, BuildPath_Actor_WithLocale(stem .. "." .. e:upper()))
    end
  end
  
  if type(entry.file) == "string" and entry.file ~= "" then
    addBothLayouts(entry.file)
  elseif type(entry.soundKey) == "string" and entry.soundKey ~= "" then
    addBothLayouts(entry.soundKey)
  end
  return cands
end

local function PlayEntrySound(entry)
  if not (MageQuotesDB.sound and MageQuotesDB.sound.enabled) then return end
  if not entry then return end

  local chan  = MageQuotesDB.sound.channel or "Master"
  local tried = {}
  local candidates = BuildActorCandidatesFromEntry(entry)
  
  if #candidates == 0 then return end
  
  local success, err = pcall(function()
    local ok = _tryCandidates(chan, candidates, tried)
    if not ok and MageQuotesDB.sound.debug then
      print("|cffffd700Mage Quotes:|r Couldn't play sound. Tried:")
      for _, p in ipairs(tried) do 
        print(" - " .. p) 
      end
    end
  end)
  
  if not success then
    LogError("PlaySound", err)
  end
end

------------------------------------------------------------
-- Quote emit helpers
------------------------------------------------------------
local lastCategoryTime = {}

function MageQuotes_ResetRuntimeCooldowns()
  wipe(lastCategoryTime)
  lastAnyQuoteAt = 0
  LogDebug("Cooldown", "Runtime cooldowns reset")
end

local function _headerForKey(key)
  return HeaderByKey[key] or key or ""
end

EmitFromBucketKey = function(key)
  if not MageQuotesDB.enabled then 
    LogDebug("Emit", "Blocked: addon disabled")
    return false 
  end
  if not MageQuotes_Data.bySection then 
    LogDebug("Emit", "Blocked: bySection not initialized")
    return false 
  end

  local now = GetTime()

  local globalCD = tonumber(MageQuotesDB.quoteCooldown or 0)
  if globalCD > 0 and (now - lastAnyQuoteAt) < globalCD then
    LogDebug("Emit", "Blocked by global CD (%.1fs remaining)", globalCD - (now - lastAnyQuoteAt))
    return false
  end

  local header = _headerForKey(key)
  local cfg    = GetOrInitCategoryCfg(header)
  if not cfg.enabled then 
    LogDebug("Emit", "Category %s disabled", header)
    return false 
  end

  -- CRITICAL FIX: Survival ignores category cooldown (allows rapid defensive responses)
  if key ~= "surv" then
    local lastC = lastCategoryTime[header] or 0
    local catCD = math.max(0, tonumber(cfg.cooldown or 0))
    if (now - lastC) < catCD then
      LogDebug("Emit", "Category %s on cooldown (%.1fs remaining)", header, catCD - (now - lastC))
      return false
    end
  end

  local bucket = MageQuotes_Data.bySection[key]
  if not bucket or #bucket == 0 then 
    LogDebug("Emit", "No quotes in bucket: %s (count=%d)", key, bucket and #bucket or 0)
    return false 
  end

  local entry = bucket[math.random(#bucket)]

  lastAnyQuoteAt = now
  lastCategoryTime[header] = now
  lastQuoteData = {
    key = key,
    text = entry.text,
    spec = entry.spec,
    time = now,
    custom = entry.custom or false
  }

  LogDebug("Emit", "Quote from %s%s: %s", key, entry.custom and " (CUSTOM)" or "", entry.text:sub(1, 50))
  
  SendChatMsg(entry.text, entry.spec)
  PlayEntrySound(entry)

  return true
end

EmitFromBucketKey_NoCD = function(key)
  if not MageQuotesDB.enabled then 
    LogDebug("Emit", "NoCD blocked: addon disabled")
    return false 
  end
  local buckets = MageQuotes_Data.bySection
  if not buckets then 
    LogDebug("Emit", "NoCD blocked: bySection not initialized")
    return false 
  end
  local bucket = buckets[key]
  if not bucket or #bucket == 0 then 
    LogDebug("Emit", "NoCD blocked: no quotes in bucket %s", key)
    return false 
  end
  
  local entry = bucket[math.random(#bucket)]
  
  lastQuoteData = {
    key = key,
    text = entry.text,
    spec = entry.spec,
    time = GetTime(),
    bypassedCD = true,
    custom = entry.custom or false
  }
  
  LogDebug("Emit", "Quote (No CD) from %s%s: %s", key, entry.custom and " (CUSTOM)" or "", entry.text:sub(1, 50))
  
  SendChatMsg(entry.text, entry.spec)
  PlayEntrySound(entry)
  return true
end

------------------------------------------------------------
-- GREETING
------------------------------------------------------------
local lastGreetTime = 0

local function SendGreeting()
  if not MageQuotesDB.enabled then return end
  local now = GetTime()
  if (now - lastGreetTime) < 120 then return end
  lastGreetTime = now

  local g = MageQuotes_Data.greetings
  if not g or #g == 0 then return end
  local obj = g[math.random(#g)]
  
  LogDebug("Greeting", "Sent: %s", obj.text)
  SendChatMsg(obj.text)
  PlayEntrySound(obj)
end

------------------------------------------------------------
-- Combat state tracking
------------------------------------------------------------
local inCombat = false
local didInitThisCombat    = false
local didVictoryThisCombat = false
local didKillThisCombat    = false
local lowHPArmed           = true
local lastSurvivalAt       = 0
local combatGen = 0
local recentKills = 0

local playerGUID

------------------------------------------------------------
-- Combat loops
------------------------------------------------------------
local rareLoopActive = false

local function RareLoopTick()
  if not rareLoopActive then return end
  
  if MageQuotesDB.enabled and MageQuotes_Data.bySection then
    local rareBucket = MageQuotes_Data.bySection.rare or {}
    if #rareBucket > 0 then
      if math.random() < (MageQuotesDB.rareChance or 0.02) then
        EmitFromBucketKey("rare")
      end
    end
  end
  
  local nextIn = math.random(90, 210)
  C_Timer.After(nextIn, RareLoopTick)
end

local function StartRareLoop()
  if rareLoopActive then return end
  rareLoopActive = true
  LogDebug("Rare", "Loop started")
  C_Timer.After(math.random(20, 40), RareLoopTick)
end

local function StopRareLoop()
  rareLoopActive = false
  LogDebug("Rare", "Loop stopped")
end

local midLoopActive = false

local function MidCombatLoopTick(gen)
  if not midLoopActive then return end
  if not inCombat then return end
  if gen ~= combatGen then return end

  local cfg = MageQuotesDB.midCombat or {}
  if cfg.enabled ~= false then
    local chance = tonumber(cfg.chance or 0.40) or 0.40
    if math.random() < chance then
      EmitFromBucketKey("mid")
    end
  end

  local minS = tonumber(cfg.min or 18) or 18
  local maxS = tonumber(cfg.max or 34) or 34
  if maxS < minS then maxS = minS end
  
  C_Timer.After(math.random(minS, maxS), function() 
    MidCombatLoopTick(gen) 
  end)
end

local function StartMidCombatLoop()
  if midLoopActive then return end
  midLoopActive = true
  local gen = combatGen
  local cfg = MageQuotesDB.midCombat or {}
  local minS = tonumber(cfg.min or 18) or 18
  local maxS = tonumber(cfg.max or 34) or 34
  if maxS < minS then maxS = minS end
  
  LogDebug("MidCombat", "Loop started (gen=%d)", gen)
  C_Timer.After(math.random(minS, maxS), function() 
    MidCombatLoopTick(gen) 
  end)
end

local function StopMidCombatLoop()
  midLoopActive = false
  LogDebug("MidCombat", "Loop stopped")
end

------------------------------------------------------------
-- Health tracking
------------------------------------------------------------
local function PlayerHealthPct()
  -- Method 1: Try modern API first (WoW 10.0+)
  if UnitHealthPercent then
    local success, pct = pcall(UnitHealthPercent, "player")
    if success and type(pct) == "number" then
      return pct
    end
  end
  
  -- Method 2: Safe arithmetic with secret value handling
  local hp = UnitHealth("player")
  local maxhp = UnitHealthMax("player")
  
  -- Check if values are valid numbers (not "secret")
  if type(hp) ~= "number" or type(maxhp) ~= "number" then
    return 100 -- Assume full health if restricted
  end
  
  if maxhp and maxhp > 0 then
    return (hp / maxhp) * 100
  end
  
  return 100
end

------------------------------------------------------------
-- Victory scheduling
------------------------------------------------------------
local function ScheduleVictoryForThisCombat(thisCombatGen)
  if didVictoryThisCombat then return end

  local now = GetTime()
  local killHeader = _headerForKey("kill")
  local killCfg    = GetOrInitCategoryCfg(killHeader)
  local lastKillC  = lastCategoryTime[killHeader] or 0
  local killCD     = math.max(0, tonumber(killCfg.cooldown or 0))

  local wait = 0
  if didKillThisCombat then
    local readyAt = lastKillC + killCD
    wait = math.max(0, readyAt - now)
  end
  if wait == 0 then wait = 0.05 end

  local scheduledGen = thisCombatGen
  
  LogDebug("Victory", "Scheduled in %.1fs (combat gen=%d)", wait, scheduledGen)
  
  C_Timer.After(wait, function()
    if inCombat then return end
    if scheduledGen ~= combatGen then return end
    if didVictoryThisCombat then return end
    EmitFromBucketKey("vict")
    didVictoryThisCombat = true
  end)
end

------------------------------------------------------------
-- MIDNIGHT-COMPATIBLE Aura Monitoring (BACKUP - spell cast is primary)
-- Polls defensive auras as backup detection
------------------------------------------------------------
Core._auraCache = {}
Core._lastAuraCheck = 0
local AURA_CHECK_INTERVAL = 0.15  -- 150ms polling rate

local function CheckDefensiveAuras()
  local now = GetTime()
  
  -- Throttle checks
  if (now - Core._lastAuraCheck) < AURA_CHECK_INTERVAL then
    return
  end
  Core._lastAuraCheck = now
  
  for _, spellID in ipairs(SURVIVAL_AURAS) do
    local hasAura = false
    
    -- Method 1: Modern C_UnitAuras API (Midnight preferred)
    if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
      local success, auraData = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
      if success and auraData then
        hasAura = true
      end
    end
    
    -- Method 2: AuraUtil fallback
    if not hasAura and AuraUtil and AuraUtil.FindAuraBySpellID then
      local success, aura = pcall(AuraUtil.FindAuraBySpellID, spellID, "player", "HELPFUL")
      if success and aura then
        hasAura = true
      end
    end
    
    -- Method 3: Name-based search (last resort)
    if not hasAura then
      local spellName = GetSpellNameSafe(spellID)
      if spellName and AuraUtil and AuraUtil.FindAuraByName then
        local success, found = pcall(AuraUtil.FindAuraByName, spellName, "player", "HELPFUL")
        if success and found then
          hasAura = true
        end
      end
    end
    
    -- New aura detected (wasn't there before)
    -- NOTE: This is BACKUP detection - primary is via UNIT_SPELLCAST_SUCCEEDED
    if hasAura and not Core._auraCache[spellID] then
      Core._auraCache[spellID] = true
      LogDebug("Aura", "NEW defensive aura (backup): %s (%d)", 
        GetSpellNameSafe(spellID) or "unknown", spellID)
      
      -- Don't emit here - spell cast already did it
      -- This is just for tracking
      return
    elseif not hasAura and Core._auraCache[spellID] then
      -- Aura faded
      Core._auraCache[spellID] = nil
      LogDebug("Aura", "Aura faded: %s (%d)", 
        GetSpellNameSafe(spellID) or "unknown", spellID)
    end
  end
end

-- Enhanced polling frame (optional backup)
Core._auraFrame = Core._auraFrame or CreateFrame("Frame")
Core._auraFrame:SetScript("OnUpdate", function(self, elapsed)
  self.elapsed = (self.elapsed or 0) + elapsed
  if self.elapsed >= AURA_CHECK_INTERVAL then
    self.elapsed = 0
    
    -- Only check auras when in combat (spell cast handles out of combat)
    if inCombat then
      CheckDefensiveAuras()
    end
  end
end)

------------------------------------------------------------
-- Event Registration (Midnight compatible with error handling)
------------------------------------------------------------
local function SafeRegisterEvent(frame, event)
  local success, err = pcall(function()
    frame:RegisterEvent(event)
  end)
  if not success then
    LogDebug("Event", "Failed to register %s: %s", event, tostring(err))
  end
end

local function SafeRegisterUnitEvent(frame, event, unit)
  local success, err = pcall(function()
    frame:RegisterUnitEvent(event, unit)
  end)
  if not success then
    -- Fallback to regular event registration
    LogDebug("Event", "RegisterUnitEvent failed for %s, trying RegisterEvent", event)
    SafeRegisterEvent(frame, event)
  end
end

SafeRegisterEvent(Core, "PLAYER_REGEN_DISABLED")
SafeRegisterEvent(Core, "PLAYER_REGEN_ENABLED")
SafeRegisterEvent(Core, "UNIT_HEALTH")
SafeRegisterEvent(Core, "UNIT_MAXHEALTH")
SafeRegisterUnitEvent(Core, "UNIT_AURA", "player")
SafeRegisterEvent(Core, "PLAYER_ENTERING_WORLD")
SafeRegisterEvent(Core, "GROUP_JOINED")
SafeRegisterEvent(Core, "GROUP_LEFT")
SafeRegisterEvent(Core, "PLAYER_SPECIALIZATION_CHANGED")

-- MIDNIGHT: Use UNIT_SPELLCAST instead of combat log when possible
SafeRegisterUnitEvent(Core, "UNIT_SPELLCAST_SUCCEEDED", "player")
SafeRegisterUnitEvent(Core, "UNIT_SPELLCAST_INTERRUPTED", "player")

-- MIDNIGHT: Kill detection via XP/Honor (more reliable than combat log)
SafeRegisterEvent(Core, "CHAT_MSG_COMBAT_XP_GAIN")
SafeRegisterEvent(Core, "CHAT_MSG_COMBAT_HONOR_GAIN")

-- Optional: Combat log support (may be restricted in some contexts)
-- Only register if available and not causing issues
local function TryRegisterCombatLog()
  local success = pcall(function()
    Core:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  end)
  if success then
    LogDebug("Event", "Combat log registered (optional)")
  else
    LogDebug("Event", "Combat log registration skipped (restricted)")
  end
end
TryRegisterCombatLog()

------------------------------------------------------------
-- Event Handler (FIXED - Proper structure)
------------------------------------------------------------
Core:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    playerGUID = UnitGUID("player")
    SendGreeting()
    StartRareLoop()
    LogDebug("Init", "Player entered world, GUID=%s", tostring(playerGUID))
    return

  elseif event == "GROUP_JOINED" then
    StartRareLoop()
    return

  elseif event == "GROUP_LEFT" then
    return

  elseif event == "UNIT_AURA" then
    local unit = ...
    if unit == "player" then
      -- Immediate aura check (backup detection)
      CheckDefensiveAuras()
    end
    return

  elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
    if MageQuotesDB.spec and MageQuotesDB.spec.preview == "auto" then
      rebuildCaches()
      LogDebug("Spec", "Specialization changed, caches rebuilt")
    end
    return

  elseif event == "PLAYER_REGEN_DISABLED" then
    inCombat = true
    combatGen = combatGen + 1
    didVictoryThisCombat = false
    didInitThisCombat    = false
    didKillThisCombat    = false
    lowHPArmed           = true
    recentKills          = 0

    LogDebug("Combat", "Combat started (gen=%d)", combatGen)
    StartMidCombatLoop()

    if EmitFromBucketKey("init") then
      didInitThisCombat = true
    end
    return

  elseif event == "PLAYER_REGEN_ENABLED" then
    inCombat = false
    LogDebug("Combat", "Combat ended (gen=%d, kills=%d)", combatGen, recentKills)
    StopMidCombatLoop()
    
    -- No queue processing needed - Inner Whisper works anytime
    
    -- Trigger kill quote if we got kills
    if recentKills > 0 and not didKillThisCombat then
      if EmitFromBucketKey("kill") then
        didKillThisCombat = true
      end
    end
    
    ScheduleVictoryForThisCombat(combatGen)
    didInitThisCombat = false
    lowHPArmed        = true
    return

  elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
    local unit, _, spellID = ...
    if unit == "player" and spellID then
      -- This is the PRIMARY way survival quotes fire
      -- HandleSpellCast checks if the spell is in MageQuotes_SpellTriggers
      HandleSpellCast(spellID)
    end
    return
    
  elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
    local unit = ...
    if unit == "player" then
      EmitFromBucketKey("mid")
    end
    return

  elseif event == "CHAT_MSG_COMBAT_XP_GAIN" or event == "CHAT_MSG_COMBAT_HONOR_GAIN" then
    if inCombat then
      recentKills = recentKills + 1
      LogDebug("Kill", "Kill detected via %s (total: %d)", event, recentKills)
    end
    return

  elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
    local unit = ...
    if unit ~= "player" then return end
    if not inCombat then return end
    
    local threshold = tonumber(MageQuotesDB.survHPpct or 35) or 35
    local pct = PlayerHealthPct()
    
    if lowHPArmed and pct <= threshold then
      if (GetTime() - lastSurvivalAt) > 4 then
        if EmitFromBucketKey("surv") then
          lastSurvivalAt = GetTime()
          lowHPArmed = false
          LogDebug("Health", "Survival triggered at %.1f%% HP", pct)
        end
      end
    elseif pct > (threshold + 5) then
      lowHPArmed = true
    end
    return

  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    -- MIDNIGHT FIX: CombatLogGetCurrentEventInfo is restricted
    -- Only use if absolutely necessary and wrap in protection
    if not CombatLogGetCurrentEventInfo then return end
    
    local success, timestamp, subEvent, hideCaster, srcGUID = pcall(CombatLogGetCurrentEventInfo)
    if not success then 
      -- Combat log access is restricted, silently ignore
      return 
    end
    
    -- Additional safety check
    if not subEvent or not srcGUID then return end
    if srcGUID ~= playerGUID then return end
    
    -- Only handle specific events we care about
    if subEvent == "SPELL_INTERRUPT" then
      EmitFromBucketKey("mid")
    elseif subEvent == "SPELL_DISPEL" or subEvent == "SPELL_STOLEN" then
      EmitFromBucketKey("mid")
    end
    
    return
  end
end)

------------------------------------------------------------
-- Minimap / LDB (with LibStub safety checks) - MIDNIGHT COMPATIBLE
------------------------------------------------------------
local iconPath = (MageQuotesIcons and MageQuotesIcons.main) or "Interface\\Icons\\Spell_Frost_IceStorm"

-- Safely check for LibStub and required libraries
local function TryGetLib(libName)
  if type(_G.LibStub) ~= "function" then
    return nil
  end
  
  local success, lib = pcall(_G.LibStub, libName, true)
  if success and lib then
    return lib
  end
  return nil
end

-- MIDNIGHT FIX: Defer library loading to avoid early taint
local LDB, DBIcon

local function InitializeLibraries()
  if InCombatLockdown() then
    C_Timer.After(1, InitializeLibraries)
    return
  end
  
  LDB = TryGetLib("LibDataBroker-1.1")
  DBIcon = TryGetLib("LibDBIcon-1.0")
  
  if LDB then
    local success, err = pcall(function()
      local dataObj = LDB:NewDataObject("MageQuotes", {
        type = "data source",
        text = "Mage Quotes",
        icon = iconPath,
        OnClick = function(_, button)
          if InCombatLockdown() then
            print("|cffffd700Mage Quotes:|r Cannot open during combat")
            return
          end
          if button == "LeftButton" then
            if MageQuotesFrame then
              if MageQuotesFrame:IsShown() then
                MageQuotesFrame:Hide()
              else
                if MageQuotesFrame.ShowAndRefresh then
                  MageQuotesFrame:ShowAndRefresh()
                else
                  MageQuotesFrame:Show()
                end
              end
            end
          elseif button == "RightButton" then
            MageQuotesDB.enabled = not MageQuotesDB.enabled
            print("|cffffd700Mage Quotes:|r " .. (MageQuotesDB.enabled and "Enabled" or "Disabled"))
          end
        end,
        OnTooltipShow = function(tt)
          tt:AddLine("Mage Quotes v" .. ADDON_VERSION)
          tt:AddLine("Left-click: Open window", 1, 1, 1)
          tt:AddLine("Right-click: Toggle", 1, 1, 1)
        end,
      })
      
      if DBIcon then
        DBIcon:Register("MageQuotes", dataObj, MageQuotesDB.minimap or {})
        LogDebug("Init", "Minimap icon registered successfully")
      else
        LogDebug("Init", "LibDBIcon not available - minimap icon disabled")
      end
    end)
    
    if not success then
      LogDebug("Init", "LDB setup failed: %s", tostring(err))
    end
  else
    LogDebug("Init", "LibDataBroker not available - minimap icon disabled")
  end
end

-- Start library initialization
C_Timer.After(0.5, InitializeLibraries)

-- Alternative: Manual minimap button (if LibDBIcon unavailable)
-- This will be created after library init completes if DBIcon is not available
C_Timer.After(1.5, function()
  if DBIcon then return end  -- LibDBIcon is handling it
  if not MageQuotesDB.minimap or MageQuotesDB.minimap.hide then return end
  
  -- MIDNIGHT FIX: Create minimap button only outside combat
  local function CreateMinimapButton()
    if InCombatLockdown() then
      -- Defer creation until out of combat
      C_Timer.After(1, CreateMinimapButton)
      return
    end
    
    -- Check if already created
    if _G.MageQuotesMinimapButton then return end
    
    local minimapButton = CreateFrame("Button", "MageQuotesMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(8)
    minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
    
    local btnIcon = minimapButton:CreateTexture(nil, "BACKGROUND")
    btnIcon:SetSize(20, 20)
    btnIcon:SetPoint("CENTER", 0, 1)
    btnIcon:SetTexture(iconPath)
    
    local border = minimapButton:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("TOPLEFT", 0, 0)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    minimapButton:SetScript("OnClick", function(_, button)
      -- MIDNIGHT FIX: Don't try to show frames during combat lockdown
      if InCombatLockdown() then
        print("|cffffd700Mage Quotes:|r Cannot open during combat")
        return
      end
      
      if button == "LeftButton" then
        if MageQuotesFrame then
          if MageQuotesFrame:IsShown() then
            MageQuotesFrame:Hide()
          else
            if MageQuotesFrame.ShowAndRefresh then
              MageQuotesFrame:ShowAndRefresh()
            else
              MageQuotesFrame:Show()
            end
          end
        end
      elseif button == "RightButton" then
        MageQuotesDB.enabled = not MageQuotesDB.enabled
        print("|cffffd700Mage Quotes:|r " .. (MageQuotesDB.enabled and "Enabled" or "Disabled"))
      end
    end)
    
    minimapButton:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT")
      GameTooltip:AddLine("Mage Quotes v" .. ADDON_VERSION)
      GameTooltip:AddLine("Left-click: Open window", 1,1,1)
      GameTooltip:AddLine("Right-click: Toggle", 1,1,1)
      GameTooltip:Show()
    end)
    
    minimapButton:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)
    
    LogDebug("Init", "Fallback minimap button created")
  end
  
  -- Start creation process
  CreateMinimapButton()
end)

------------------------------------------------------------
-- Slash commands
------------------------------------------------------------
SLASH_MAGEQUOTES1 = "/mq"
SlashCmdList["MAGEQUOTES"] = function(msg)
  local function _t(s) return (s or ""):gsub("^%s+",""):gsub("%s+$","") end
  msg = _t(msg or "")
  
  if msg == "" then
    print("|cffffd700MQ:|r Mage Quotes v" .. ADDON_VERSION .. " (Midnight)")
    print("|cffffd700MQ:|r /mq sound <file>    - test sound")
    print("|cffffd700MQ:|r /mq actor next      - switch actor")
    print("|cffffd700MQ:|r /mq debug [on|off]  - toggle debug")
    print("|cffffd700MQ:|r /mq spec <type>     - set spec filter")
    print("|cffffd700MQ:|r /mq cdspam ...      - anti-spam settings")
    print("|cffffd700MQ:|r /mq status          - show status")
    print("|cffffd700MQ:|r /mq auras           - check defensive auras")
    print("|cffffd700MQ:|r /mq test <category> - test quote emission")
    print("|cffffd700MQ:|r /mq rebuild         - rebuild quote caches")
    print("|cff888888MQ:|r Note: Chat channels disabled in Midnight (Inner Whisper only)")
    return
  end
  
  local cmd, rest = msg:match("^(%S+)%s*(.*)$")
  
  if cmd == "status" then
    print("|cffffd700MQ Status:|r")
    print("  Version:", ADDON_VERSION, "(Midnight Compatible)")
    print("  Enabled:", MageQuotesDB.enabled and "Yes" or "No")
    print("  Locale:", ACTIVE_LOCALE or "Unknown")
    print("  Channel: Inner Whisper (Midnight restriction)")
    print("  Spec Filter:", MageQuotesDB.spec.preview or "auto")
    print("  In Combat:", inCombat and "Yes" or "No")
    print("  Debug Mode:", MageQuotesDB.debugMode and "Yes" or "No")
    print("  Total Quotes:", #(MageQuotes_Data.allQuotes or {}))
    -- Show bucket counts
    if MageQuotes_Data.bySection then
      local buckets = {}
      for k, v in pairs(MageQuotes_Data.bySection) do
        if #v > 0 then
          table.insert(buckets, k .. "=" .. #v)
        end
      end
      print("  Buckets:", table.concat(buckets, ", "))
    end
    return
    
  elseif cmd == "rebuild" then
    rebuildCaches()
    print("|cffffd700MQ:|r Caches rebuilt. Total quotes:", #(MageQuotes_Data.allQuotes or {}))
    return
    
  elseif cmd == "test" then
    local category = _t(rest):lower()
    if category == "" then
      print("|cffffd700MQ:|r Usage: /mq test <category>")
      print("|cffffd700MQ:|r Categories: init, kill, surv, vict, rare, mid, greet")
      return
    end
    -- Map common names
    if category == "survival" then category = "surv" end
    if category == "victory" then category = "vict" end
    if category == "combat" then category = "init" end
    if category == "greeting" then category = "greet" end
    
    local bucket = MageQuotes_Data.bySection and MageQuotes_Data.bySection[category]
    if not bucket then
      print("|cffff0000MQ:|r Unknown category:", category)
      return
    end
    
    print("|cffffd700MQ:|r Testing category '" .. category .. "' (" .. #bucket .. " quotes)")
    if #bucket > 0 then
      EmitFromBucketKey_NoCD(category)
    else
      print("|cffff0000MQ:|r No quotes in this category!")
    end
    return
    
  elseif cmd == "sound" and rest and rest ~= "" then
    local entry = { file = rest }
    local tried = {}
    local ok = _tryCandidates(MageQuotesDB.sound.channel or "Master", BuildActorCandidatesFromEntry(entry), tried)
    if ok then
      print("|cffffd700MQ:|r Played:", tried[#tried])
    else
      print("|cffff0000MQ:|r Failed. Tried:")
      for _, p in ipairs(tried) do print(" - " .. p) end
    end
    
  elseif cmd == "actor" and rest == "next" then
    MageQuotesDB.sound.actorIndex = (MageQuotesDB.sound.actorIndex or 1) + 1
    local list = MageQuotesDB.sound.actors or { "MageA", "MageB" }
    if MageQuotesDB.sound.actorIndex > #list then 
      MageQuotesDB.sound.actorIndex = 1 
    end
    print("|cffffd700MQ:|r Actor:", CurrentActor())
    
  elseif cmd == "debug" then
    if rest == "on" then
      MageQuotesDB.debugMode = true
      MageQuotesDB.debugPrint = true
    elseif rest == "off" then
      MageQuotesDB.debugMode = false
      MageQuotesDB.debugPrint = false
    else
      MageQuotesDB.debugMode = not MageQuotesDB.debugMode
      MageQuotesDB.debugPrint = MageQuotesDB.debugMode
    end
    print("|cffffd700MQ:|r Debug mode:", MageQuotesDB.debugMode and "on" or "off")
    
  elseif cmd == "channel" then
    -- Channel selection disabled in Midnight
    print("|cffffd700MQ:|r Channel selection is disabled in WoW Midnight.")
    print("|cffffd700MQ:|r SendChatMessage is now a protected Blizzard-only function.")
    print("|cffffd700MQ:|r All quotes are displayed via Inner Whisper (local only).")
    
  elseif cmd == "spec" and rest and rest ~= "" then
    rest = _t(rest):lower()
    local ok = ({auto=true, all=true, arcane=true, fire=true, frost=true})[rest]
    if ok then
      MageQuotesDB.spec = MageQuotesDB.spec or {}
      MageQuotesDB.spec.preview = rest
      rebuildCaches()
      print("|cffffd700MQ:|r Spec preview:", rest)
    else
      print("|cffff0000MQ:|r Unknown spec. Use: auto/all/arcane/fire/frost")
    end

  elseif cmd == "auras" or cmd == "aura" then
    print("|cffffd700MQ Defensive Auras:|r")
    for _, spellID in ipairs(SURVIVAL_AURAS) do
      local name = GetSpellNameSafe(spellID)
      local hasAura = false
      
      if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
        local success, data = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
        hasAura = (success and data ~= nil)
      end
      
      local status = hasAura and "|cff00ff00ACTIVE|r" or "|cff888888inactive|r"
      print(string.format("  [%d] %s - %s", spellID, name or "unknown", status))
    end
    print("|cffffd700MQ:|r Survival spells now trigger on CAST (not just buff)")
    
  elseif cmd == "cdspam" then
    local arg1, arg2 = rest:match("^(%S+)%s*(.*)$")
    arg1 = (arg1 or ""):lower()
    MageQuotesDB.majorCD = MageQuotesDB.majorCD or {}

    if arg1 == "on" or arg1 == "enable" then
      MageQuotesDB.majorCD.enabled = true
      print("|cffffd700MQ:|r Major-CD anti-spam: ON")
    elseif arg1 == "off" or arg1 == "disable" then
      MageQuotesDB.majorCD.enabled = false
      print("|cffffd700MQ:|r Major-CD anti-spam: OFF")
    elseif arg1 == "window" and tonumber(arg2) then
      MageQuotesDB.majorCD.spamWindow = tonumber(arg2)
      print("|cffffd700MQ:|r Anti-spam window =", MageQuotesDB.majorCD.spamWindow, "sec")
    elseif arg1 == "max" and tonumber(arg2) then
      MageQuotesDB.majorCD.spamMax = tonumber(arg2)
      print("|cffffd700MQ:|r Anti-spam max casts =", MageQuotesDB.majorCD.spamMax)
    elseif arg1 == "lockout" and tonumber(arg2) then
      MageQuotesDB.majorCD.spamLockout = tonumber(arg2)
      print("|cffffd700MQ:|r Anti-spam lockout =", MageQuotesDB.majorCD.spamLockout, "sec")
    else
      print("|cffffd700MQ:|r /mq cdspam on|off|window <sec>|max <n>|lockout <sec>")
    end
    
  else
    print("|cffff0000MQ:|r Unknown command. Try /mq for help")
  end
end

------------------------------------------------------------
-- Public API
------------------------------------------------------------
MageQuotesAPI = {
  VERSION = ADDON_VERSION,
  
  GetLastQuote = function()
    return lastQuoteData or {}
  end,
  
  TriggerManualQuote = function(category)
    return EmitFromBucketKey(category)
  end,
  
  TriggerManualQuoteNoCD = function(category)
    return EmitFromBucketKey_NoCD(category)
  end,
  
  IsEnabled = function()
    return MageQuotesDB.enabled
  end,
  
  GetCombatState = function()
    return {
      inCombat = inCombat,
      didInit = didInitThisCombat,
      didKill = didKillThisCombat,
      didVictory = didVictoryThisCombat,
      combatGen = combatGen,
      recentKills = recentKills
    }
  end,
  
  GetDebugLog = function()
    return debugLog
  end,
  
  GetVersion = function()
    return ADDON_VERSION
  end,
  
  -- Force rebuild caches (for when custom quotes are added/removed)
  RebuildCaches = function()
    rebuildCaches()
  end,
  
  -- Get bucket contents (for debugging)
  GetBucket = function(key)
    return MageQuotes_Data.bySection and MageQuotes_Data.bySection[key] or {}
  end,
  
  -- Get all buckets summary
  GetBucketSummary = function()
    local summary = {}
    if MageQuotes_Data.bySection then
      for k, v in pairs(MageQuotes_Data.bySection) do
        summary[k] = #v
      end
    end
    return summary
  end
}

------------------------------------------------------------
-- Listen for Custom Quotes Updates (CRITICAL FIX)
------------------------------------------------------------
-- When custom quotes are added/removed/toggled, we need to rebuild the cache
-- so they appear in the bySection buckets and can actually fire
C_Timer.After(0.5, function()
  if MageQuotes_EventBus and MageQuotes_EventBus.RegisterCallback then
    MageQuotes_EventBus:RegisterCallback("MAGE_QUOTES_CUSTOM_UPDATED", function()
      LogDebug("Event", "Custom quotes updated, rebuilding caches...")
      rebuildCaches()
    end, Core)
    LogDebug("Init", "Registered listener for MAGE_QUOTES_CUSTOM_UPDATED")
  end
end)

------------------------------------------------------------
-- Cleanup & Initialization
------------------------------------------------------------
function Core:Rebuild()
  rebuildCaches()
end

function Core:OnDisable()
  rareLoopActive = false
  midLoopActive = false
  combatGen = combatGen + 1
  wipe(_cdSpamTimes)
  LogDebug("Shutdown", "Addon disabled, timers cancelled")
end

-- Initialize
LogDebug("Init", "Mage Quotes v%s (Midnight) loading...", ADDON_VERSION)
print("|cffffd700Mage Quotes v" .. ADDON_VERSION .. "|r loaded (Midnight compatible)")
rebuildCaches()
StartRareLoop()
LogDebug("Init", "Initialization complete")