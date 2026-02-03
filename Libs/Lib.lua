-- AzerothVoiced_Lib.lua
-- Small internal helper "library" shared by Core/UI.
-- Avoids hard dependency on external libs.

local addonName = ...
AzerothVoicedLib = AzerothVoicedLib or {}

local Lib = AzerothVoicedLib

function Lib.Trim(s)
  if type(s) ~= "string" then return s end
  return (s:gsub("^%s+",""):gsub("%s+$",""))
end

function Lib.BasenameNoExt(path)
  if type(path) ~= "string" then return nil end
  local name = path:gsub("\\", "/")
  name = name:match("([^/]+)$") or name
  return (name:gsub("%.%w+$",""))
end

function Lib.ClampInt(v, lo, hi)
  v = tonumber(v or 0) or 0
  v = math.floor(v)
  if lo ~= nil and v < lo then v = lo end
  if hi ~= nil and v > hi then v = hi end
  return v
end

function Lib.RandRangeInt(lo, hi)
  lo = Lib.ClampInt(lo, 0, nil)
  hi = Lib.ClampInt(hi, lo, nil)
  return math.random(lo, hi)
end

function Lib.CreateLocalBus()
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
        cb.func(cb.owner, ...)
      end
    end,
  }
end
