-- AzerothVoiced_Dracthyr.lua
-- Dracthyr Visage ↔ Dragon voice switching (Midnight 12.0.0 compatible)
-- Class-agnostic: Works for any race/class with form-shifting mechanics

local ADDON_VERSION = "1.3.0"
local MODULE_NAME = "AzerothVoiced_Dracthyr"

-- Safe initialization - wait for Core and DB
local Core = _G.AzerothVoicedCore
local initAttempts = 0
local MAX_INIT_ATTEMPTS = 10

local function SafeInit()
  Core = _G.AzerothVoicedCore
  if not Core or not AzerothVoicedDB then
    initAttempts = initAttempts + 1
    if initAttempts < MAX_INIT_ATTEMPTS then
      C_Timer.After(0.5, SafeInit)
    end
    return false
  end
  return true
end

-- Early exit if dependencies missing (will retry)
if not Core or not AzerothVoicedDB then
  C_Timer.After(0.5, SafeInit)
end

------------------------------------------------------------
-- Debug System (integrates with Core's debug log)
------------------------------------------------------------
local function LogDebug(category, message, ...)
  if not AzerothVoicedDB or not AzerothVoicedDB.debugMode then return end
  
  local formatted = string.format(message, ...)
  local timestamp = date("%H:%M:%S")
  
  -- Add to Core's debug log if available
  if AzerothVoicedAPI and AzerothVoicedAPI.GetDebugLog then
    local debugLog = AzerothVoicedAPI.GetDebugLog()
    if debugLog then
      table.insert(debugLog, {
        time = GetTime(),
        timestamp = timestamp,
        category = "Dracthyr:" .. category,
        message = formatted
      })
      -- Trim log if too large
      while #debugLog > 100 do
        table.remove(debugLog, 1)
      end
    end
  end
  
  if AzerothVoicedDB.debugPrint then
    print(string.format("|cff88ccff[MQ Dracthyr]|r [%s] [%s] %s", 
      timestamp, category, formatted))
  end
end

------------------------------------------------------------
-- Constants
------------------------------------------------------------
local VISAGE_FORM_SPELL_ID = 372014
local CACHE_DURATION = 0.5 -- Cache aura checks for 500ms to reduce API calls

-- Voice actor mapping (must exist in AzerothVoicedDB.sound.actors)
local ACTORS = {
  humanoid = "VoiceA", -- Visage / humanoid form
  draconic = "VoiceB", -- Dragon / true form
}

-- State tracking
local lastFormState = nil
local lastCheckTime = 0
local auraCache = {}

------------------------------------------------------------
-- Modern Spell Name Resolution (Midnight-compatible)
------------------------------------------------------------
local spellNameCache = {}

local function GetSpellNameSafe(spellID)
  if type(spellID) ~= "number" then return nil end
  
  -- Check cache first
  if spellNameCache[spellID] then
    return spellNameCache[spellID]
  end
  
  local name
  
  -- Primary: Modern C_Spell API (Midnight/TWW)
  if C_Spell and C_Spell.GetSpellName then
    local success, result = pcall(C_Spell.GetSpellName, spellID)
    if success and result then
      name = result
      LogDebug("SpellCache", "Cached spell %d: %s (C_Spell.GetSpellName)", spellID, name)
    end
  end
  
  -- Fallback: C_Spell.GetSpellInfo (DF/Midnight)
  if not name and C_Spell and C_Spell.GetSpellInfo then
    local success, info = pcall(C_Spell.GetSpellInfo, spellID)
    if success and info and info.name then
      name = info.name
      LogDebug("SpellCache", "Cached spell %d: %s (C_Spell.GetSpellInfo)", spellID, name)
    end
  end
  
  -- Legacy fallback (SL and earlier)
  if not name and _G.GetSpellInfo then
    local success, result = pcall(_G.GetSpellInfo, spellID)
    if success and result then
      name = result
      LogDebug("SpellCache", "Cached spell %d: %s (GetSpellInfo)", spellID, name)
    end
  end
  
  if name then
    spellNameCache[spellID] = name
  else
    LogDebug("SpellCache", "Failed to resolve spell ID: %d", spellID)
  end
  
  return name
end

------------------------------------------------------------
-- Modern Aura Detection (Midnight-compatible)
------------------------------------------------------------
local function HasVisageForm()
  local now = GetTime()
  
  -- Use cached result if recent
  if auraCache.hasVisage ~= nil and (now - lastCheckTime) < CACHE_DURATION then
    return auraCache.hasVisage
  end
  
  lastCheckTime = now
  local hasAura = false
  
  -- Method 1: Modern C_UnitAuras API (Midnight/TWW preferred)
  if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
    local success, auraData = pcall(C_UnitAuras.GetPlayerAuraBySpellID, VISAGE_FORM_SPELL_ID)
    if success and auraData then
      hasAura = true
      LogDebug("Aura", "Visage detected via C_UnitAuras.GetPlayerAuraBySpellID")
    end
  end
  
  -- Method 2: AuraUtil by spell ID (DF/Midnight)
  if not hasAura and AuraUtil and AuraUtil.FindAuraBySpellID then
    local success, aura = pcall(AuraUtil.FindAuraBySpellID, VISAGE_FORM_SPELL_ID, "player", "HELPFUL")
    if success and aura then
      hasAura = true
      LogDebug("Aura", "Visage detected via AuraUtil.FindAuraBySpellID")
    end
  end
  
  -- Method 3: Fallback to spell name lookup
  if not hasAura then
    local spellName = GetSpellNameSafe(VISAGE_FORM_SPELL_ID)
    if spellName and AuraUtil and AuraUtil.FindAuraByName then
      local success, aura = pcall(AuraUtil.FindAuraByName, spellName, "player", "HELPFUL")
      if success and aura then
        hasAura = true
        LogDebug("Aura", "Visage detected via AuraUtil.FindAuraByName (%s)", spellName)
      end
    end
  end
  
  -- Cache result
  auraCache.hasVisage = hasAura
  return hasAura
end

------------------------------------------------------------
-- Voice Actor Management
------------------------------------------------------------
local function SetActor(actorName)
  local snd = AzerothVoicedDB.sound
  if not snd or not snd.actors then 
    LogDebug("Actor", "Sound config not initialized")
    return 
  end

  -- Find actor index
  local targetIndex = nil
  for i, name in ipairs(snd.actors) do
    if name == actorName then
      targetIndex = i
      break
    end
  end
  
  if not targetIndex then
    LogDebug("Actor", "Actor not found in config: %s", actorName)
    if snd.debug then
      print("|cffff0000Azeroth Voiced Dracthyr:|r Actor '" .. actorName .. "' not found in voice actors list")
    end
    return
  end
  
  -- Only switch if changed
  if snd.actorIndex ~= targetIndex then
    local oldActor = snd.actors[snd.actorIndex] or "unknown"
    snd.actorIndex = targetIndex
    
    LogDebug("Actor", "Voice switched: %s → %s", oldActor, actorName)
    
    if snd.debug then
      print("|cff88ccffAzeroth Voiced Dracthyr:|r Voice switched → " .. actorName)
    end
    
    -- Trigger event for other modules
    if AzerothVoiced_EventBus and AzerothVoiced_EventBus.TriggerEvent then
      AzerothVoiced_EventBus:TriggerEvent("MAGE_QUOTES_VOICE_CHANGED", actorName)
    end
  end
end

------------------------------------------------------------
-- Core Update Logic
------------------------------------------------------------
local updateThrottle = 0
local THROTTLE_INTERVAL = 0.1 -- 100ms throttle

local function UpdateDracthyrVoice(force)
  -- Throttling (except on force update)
  if not force then
    local now = GetTime()
    if (now - updateThrottle) < THROTTLE_INTERVAL then
      return
    end
    updateThrottle = now
  end
  
  local hasVisage = HasVisageForm()
  
  -- Determine target form
  local targetActor = hasVisage and ACTORS.humanoid or ACTORS.draconic
  
  -- Only update if state changed (or forced)
  if force or lastFormState ~= hasVisage then
    lastFormState = hasVisage
    SetActor(targetActor)
    
    LogDebug("Form", "Form state: %s (Visage: %s)", 
      targetActor, hasVisage and "yes" or "no")
  end
end

------------------------------------------------------------
-- Event Management
------------------------------------------------------------
local eventFrame = CreateFrame("Frame", "AzerothVoicedDracthyrFrame")

-- Midnight-compatible unit event registration
eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

-- Handle spec changes that might affect available forms
if PlayerUtil and PlayerUtil.GetSpecialization then
  eventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
end

eventFrame:SetScript("OnEvent", function(self, event, unit)
  LogDebug("Event", "Received: %s (unit: %s)", event, tostring(unit))
  
  -- Filter UNIT_AURA events to player only
  if event == "UNIT_AURA" and unit ~= "player" then
    return
  end
  
  -- Force update on world enter
  local forceUpdate = (event == "PLAYER_ENTERING_WORLD")
  
  UpdateDracthyrVoice(forceUpdate)
end)

------------------------------------------------------------
-- Initialization
------------------------------------------------------------
local initialized = false

local function Initialize()
  if initialized then return end
  if not AzerothVoicedDB then return end
  
  LogDebug("Init", "Dracthyr voice module v%s loading...", ADDON_VERSION)
  
  -- Ensure sound config exists
  AzerothVoicedDB.sound = AzerothVoicedDB.sound or {}
  AzerothVoicedDB.sound.actors = AzerothVoicedDB.sound.actors or { "VoiceA", "VoiceB" }
  AzerothVoicedDB.sound.actorIndex = AzerothVoicedDB.sound.actorIndex or 1
  
  -- Validate actor names
  local hasHumanoid = false
  local hasDraconic = false
  for _, actor in ipairs(AzerothVoicedDB.sound.actors) do
    if actor == ACTORS.humanoid then hasHumanoid = true end
    if actor == ACTORS.draconic then hasDraconic = true end
  end
  
  if not hasHumanoid or not hasDraconic then
    LogDebug("Init", "WARNING: Required actors not found in config")
    print("|cffff8800Azeroth Voiced Dracthyr:|r Voice actors '" .. ACTORS.humanoid .. 
          "' and '" .. ACTORS.draconic .. "' must be configured")
  end
  
  -- Register with event bus for settings changes
  if AzerothVoiced_EventBus and AzerothVoiced_EventBus.RegisterCallback then
    -- Listen for locale changes
    AzerothVoiced_EventBus:RegisterCallback("AZEROTH_VOICED_LOCALE_CHANGED", function()
      LogDebug("Event", "Locale changed, refreshing state")
    end, MODULE_NAME)
    
    -- Listen for settings changes
    AzerothVoiced_EventBus:RegisterCallback("MAGE_QUOTES_SETTINGS_CHANGED", function()
      LogDebug("Event", "Settings changed, checking voice config")
      -- Re-validate actors after settings change
      local actors = AzerothVoicedDB.sound and AzerothVoicedDB.sound.actors or {}
      local found = false
      for _, actor in ipairs(actors) do
        if actor == ACTORS.humanoid or actor == ACTORS.draconic then
          found = true
          break
        end
      end
      if not found then
        LogDebug("Event", "Voice actors may have changed, current actors: %s", 
          table.concat(actors, ", "))
      end
    end, MODULE_NAME)
    
    LogDebug("Init", "Registered with event bus")
  end
  
  -- Delayed initial check (auras may not be ready immediately)
  C_Timer.After(1.5, function()
    LogDebug("Init", "Running delayed initialization...")
    UpdateDracthyrVoice(true)
  end)
  
  initialized = true
  LogDebug("Init", "Dracthyr voice module initialized")
end

-- Safe initialization - only run if dependencies are ready
if AzerothVoicedDB then
  Initialize()
end

------------------------------------------------------------
-- Public API
------------------------------------------------------------
AzerothVoiced_DracthyrAPI = {
  GetCurrentForm = function()
    return lastFormState and "visage" or "dragon"
  end,
  
  ForceUpdate = function()
    if not initialized then
      Initialize()
    end
    UpdateDracthyrVoice(true)
  end,
  
  GetVersion = function()
    return ADDON_VERSION
  end,
  
  IsInitialized = function()
    return initialized
  end,
}

------------------------------------------------------------
-- Slash Command
------------------------------------------------------------
SLASH_MQDRACTHYR1 = "/avdragon"
SlashCmdList["MQDRACTHYR"] = function(msg)
  msg = (msg or ""):lower():trim()
  
  if not AzerothVoicedDB then
    print("|cffff0000Azeroth Voiced Dracthyr:|r Core not loaded yet")
    return
  end
  
  if msg == "status" then
    local form = AzerothVoiced_DracthyrAPI.GetCurrentForm()
    local actor = (AzerothVoicedDB.sound and AzerothVoicedDB.sound.actors and 
                   AzerothVoicedDB.sound.actors[AzerothVoicedDB.sound.actorIndex]) or "unknown"
    print("|cff88ccffAzeroth Voiced Dracthyr:|r")
    print("  Initialized: " .. (initialized and "Yes" or "No"))
    print("  Current form: " .. form)
    print("  Active voice: " .. actor)
    print("  Visage spell ID: " .. VISAGE_FORM_SPELL_ID)
    print("  Has visage aura: " .. tostring(HasVisageForm()))
    
  elseif msg == "refresh" or msg == "update" then
    print("|cff88ccffAzeroth Voiced Dracthyr:|r Forcing voice update...")
    auraCache = {} -- Clear cache
    UpdateDracthyrVoice(true)
    
  elseif msg == "test" then
    print("|cff88ccffAzeroth Voiced Dracthyr:|r Testing voice switch...")
    if not AzerothVoicedDB.sound or not AzerothVoicedDB.sound.actors then
      print("|cffff0000  Sound config not initialized|r")
      return
    end
    local current = AzerothVoicedDB.sound.actorIndex or 1
    local actors = AzerothVoicedDB.sound.actors
    local next = (current % #actors) + 1
    AzerothVoicedDB.sound.actorIndex = next
    print("  Switched to: " .. actors[next])
    
  else
    print("|cff88ccffAzeroth Voiced Dracthyr v" .. ADDON_VERSION .. "|r")
    print("  /avdragon status  - Show current state")
    print("  /avdragon refresh - Force voice update")
    print("  /avdragon test    - Test voice switching")
  end
end

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
  LogDebug("Init", "Dracthyr module loaded successfully")
end