-- AzerothVoiced/Libs/Lib.lua
-- Internal helper library shared by Core/UI
-- v2.0.0

local ADDON_NAME = "AzerothVoiced"

AzerothVoicedLib = AzerothVoicedLib or {}
local Lib = AzerothVoicedLib

------------------------------------------------------------
-- String Utilities
------------------------------------------------------------

-- Trim whitespace from string
function Lib.Trim(s)
    if type(s) ~= "string" then return s end
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Get filename without extension from path
function Lib.BasenameNoExt(path)
    if type(path) ~= "string" then return nil end
    local name = path:gsub("\\", "/")
    name = name:match("([^/]+)$") or name
    return (name:gsub("%.%w+$", ""))
end

-- Split string by delimiter
function Lib.Split(str, delimiter)
    if type(str) ~= "string" then return {} end
    delimiter = delimiter or " "
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Check if string starts with prefix
function Lib.StartsWith(str, prefix)
    if type(str) ~= "string" or type(prefix) ~= "string" then return false end
    return str:sub(1, #prefix) == prefix
end

-- Check if string ends with suffix
function Lib.EndsWith(str, suffix)
    if type(str) ~= "string" or type(suffix) ~= "string" then return false end
    return str:sub(-#suffix) == suffix
end

------------------------------------------------------------
-- Number Utilities
------------------------------------------------------------

-- Clamp integer to range
function Lib.ClampInt(v, lo, hi)
    v = tonumber(v or 0) or 0
    v = math.floor(v)
    if lo ~= nil and v < lo then v = lo end
    if hi ~= nil and v > hi then v = hi end
    return v
end

-- Random integer in range (inclusive)
function Lib.RandRangeInt(lo, hi)
    lo = Lib.ClampInt(lo, 0, nil)
    hi = Lib.ClampInt(hi, lo, nil)
    if lo == hi then return lo end
    return math.random(lo, hi)
end

-- Round number to decimal places
function Lib.Round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

------------------------------------------------------------
-- Table Utilities
------------------------------------------------------------

-- Shallow copy table
function Lib.ShallowCopy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

-- Deep copy table
function Lib.DeepCopy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = Lib.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Count table entries
function Lib.TableCount(t)
    if type(t) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Check if table contains value
function Lib.TableContains(t, value)
    if type(t) ~= "table" then return false end
    for _, v in pairs(t) do
        if v == value then return true end
    end
    return false
end

-- Get table keys as array
function Lib.TableKeys(t)
    if type(t) ~= "table" then return {} end
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

-- Merge tables (second overwrites first)
function Lib.TableMerge(t1, t2)
    local result = Lib.ShallowCopy(t1) or {}
    if type(t2) == "table" then
        for k, v in pairs(t2) do
            result[k] = v
        end
    end
    return result
end

------------------------------------------------------------
-- Event Bus (Inter-module Communication)
------------------------------------------------------------

function Lib.CreateLocalBus()
    return {
        _callbacks = {},
        
        -- Register callback for event
        RegisterCallback = function(self, event, func, owner)
            if type(event) ~= "string" or type(func) ~= "function" then return end
            self._callbacks[event] = self._callbacks[event] or {}
            table.insert(self._callbacks[event], { 
                func = func, 
                owner = owner or "anonymous" 
            })
        end,
        
        -- Unregister callback
        UnregisterCallback = function(self, event, func, owner)
            local list = self._callbacks[event]
            if not list then return end
            for i = #list, 1, -1 do
                local cb = list[i]
                local funcMatch = (not func or cb.func == func)
                local ownerMatch = (not owner or cb.owner == owner)
                if funcMatch and ownerMatch then
                    table.remove(list, i)
                end
            end
        end,
        
        -- Unregister all callbacks for owner
        UnregisterAllCallbacks = function(self, owner)
            if not owner then return end
            for event, list in pairs(self._callbacks) do
                for i = #list, 1, -1 do
                    if list[i].owner == owner then
                        table.remove(list, i)
                    end
                end
            end
        end,
        
        -- Trigger event with arguments
        TriggerEvent = function(self, event, ...)
            local list = self._callbacks[event]
            if not list then return end
            for _, cb in ipairs(list) do
                local success, err = pcall(cb.func, cb.owner, ...)
                if not success then
                    print("|cffff0000[AzerothVoiced Event Error]|r " .. event .. ": " .. tostring(err))
                end
            end
        end,
        
        -- Get registered events
        GetRegisteredEvents = function(self)
            return Lib.TableKeys(self._callbacks)
        end,
    }
end

------------------------------------------------------------
-- Color Utilities
------------------------------------------------------------

-- Create hex color string from RGB (0-1 range)
function Lib.RGBToHex(r, g, b)
    r = Lib.ClampInt((r or 1) * 255, 0, 255)
    g = Lib.ClampInt((g or 1) * 255, 0, 255)
    b = Lib.ClampInt((b or 1) * 255, 0, 255)
    return string.format("%02x%02x%02x", r, g, b)
end

-- Wrap text in color code
function Lib.ColorText(text, r, g, b)
    if type(r) == "table" then
        -- Accept color as table {r, g, b}
        g = r[2]
        b = r[3]
        r = r[1]
    end
    local hex = Lib.RGBToHex(r, g, b)
    return "|cff" .. hex .. tostring(text or "") .. "|r"
end

------------------------------------------------------------
-- Class Utilities
------------------------------------------------------------

-- WoW class IDs
Lib.CLASS_IDS = {
    WARRIOR = 1,
    PALADIN = 2,
    HUNTER = 3,
    ROGUE = 4,
    PRIEST = 5,
    DEATHKNIGHT = 6,
    SHAMAN = 7,
    MAGE = 8,
    WARLOCK = 9,
    MONK = 10,
    DRUID = 11,
    DEMONHUNTER = 12,
    EVOKER = 13,
}

-- Class colors (official Blizzard colors)
Lib.CLASS_COLORS = {
    WARRIOR = {0.78, 0.61, 0.43},
    PALADIN = {0.96, 0.55, 0.73},
    HUNTER = {0.67, 0.83, 0.45},
    ROGUE = {1.00, 0.96, 0.41},
    PRIEST = {1.00, 1.00, 1.00},
    DEATHKNIGHT = {0.77, 0.12, 0.23},
    SHAMAN = {0.00, 0.44, 0.87},
    MAGE = {0.41, 0.80, 0.94},
    WARLOCK = {0.58, 0.51, 0.79},
    MONK = {0.00, 1.00, 0.59},
    DRUID = {1.00, 0.49, 0.04},
    DEMONHUNTER = {0.64, 0.19, 0.79},
    EVOKER = {0.20, 0.58, 0.50},
}

-- Class display names
Lib.CLASS_NAMES = {
    enUS = {
        WARRIOR = "Warrior",
        PALADIN = "Paladin",
        HUNTER = "Hunter",
        ROGUE = "Rogue",
        PRIEST = "Priest",
        DEATHKNIGHT = "Death Knight",
        SHAMAN = "Shaman",
        MAGE = "Mage",
        WARLOCK = "Warlock",
        MONK = "Monk",
        DRUID = "Druid",
        DEMONHUNTER = "Demon Hunter",
        EVOKER = "Evoker",
    },
    ruRU = {
        WARRIOR = "Воин",
        PALADIN = "Паладин",
        HUNTER = "Охотник",
        ROGUE = "Разбойник",
        PRIEST = "Жрец",
        DEATHKNIGHT = "Рыцарь смерти",
        SHAMAN = "Шаман",
        MAGE = "Маг",
        WARLOCK = "Чернокнижник",
        MONK = "Монах",
        DRUID = "Друид",
        DEMONHUNTER = "Охотник на демонов",
        EVOKER = "Пробудитель",
    },
}

-- Get class color for text
function Lib.GetClassColoredName(class, name, locale)
    locale = locale or "enUS"
    local color = Lib.CLASS_COLORS[class] or {1, 1, 1}
    local displayName = name or (Lib.CLASS_NAMES[locale] and Lib.CLASS_NAMES[locale][class]) or class
    return Lib.ColorText(displayName, color)
end

-- Get player's class
function Lib.GetPlayerClass()
    local _, class = UnitClass("player")
    return class
end

-- Get player's spec (1, 2, 3, or 4)
function Lib.GetPlayerSpec()
    local spec = GetSpecialization()
    return spec or 1
end

------------------------------------------------------------
-- Debug Utilities
------------------------------------------------------------

-- Print debug message (only if debug mode enabled)
function Lib.DebugPrint(...)
    if AzerothVoicedDB and AzerothVoicedDB.debugMode then
        print("|cff888888[AV Debug]|r", ...)
    end
end

-- Format table for debug output
function Lib.TableToString(t, indent)
    if type(t) ~= "table" then return tostring(t) end
    indent = indent or 0
    local pad = string.rep("  ", indent)
    local result = "{\n"
    for k, v in pairs(t) do
        local key = type(k) == "string" and ('["' .. k .. '"]') or ("[" .. tostring(k) .. "]")
        if type(v) == "table" then
            result = result .. pad .. "  " .. key .. " = " .. Lib.TableToString(v, indent + 1) .. ",\n"
        elseif type(v) == "string" then
            result = result .. pad .. "  " .. key .. ' = "' .. v .. '",\n'
        else
            result = result .. pad .. "  " .. key .. " = " .. tostring(v) .. ",\n"
        end
    end
    return result .. pad .. "}"
end

------------------------------------------------------------
-- Initialization Complete
------------------------------------------------------------

-- Make global event bus available
AzerothVoiced_EventBus = Lib.CreateLocalBus()

-- Print load confirmation in debug mode
if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    print("|cff00ccff[AzerothVoiced]|r Lib.lua loaded")
end
