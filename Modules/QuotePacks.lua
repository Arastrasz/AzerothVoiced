-- MageQuotes/Modules/QuotePacks.lua
-- OPTIONAL MODULE: Curated Quote Packs
-- v1.0.0 - Can be removed without breaking MageQuotes
--
-- HOW TO DISABLE: Remove this file or comment out in .toc
-- MageQuotes will work perfectly without it.

local MODULE_NAME = "QuotePacks"
local MODULE_VERSION = "1.0.0"

------------------------------------------------------------
-- Built-in Curated Quote Packs
------------------------------------------------------------
local CuratedPacks = {
  -- CLASSIC MAGE LINES
  {
    id = "classic_mage",
    name = "Classic Mage Lines",
    author = "MageQuotes Team",
    description = "Timeless quotes capturing the essence of being a mage.",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Spell_Fire_MasterOfElements",
    color = {0.4, 0.6, 1.0},
    quotes = {
      { text = "You dare challenge a master of the arcane?", category = "init" },
      { text = "Let me show you real power!", category = "init" },
      { text = "Your fate was sealed the moment you faced me.", category = "init" },
      { text = "I've forgotten more magic than you'll ever know.", category = "init" },
      { text = "Time to put my studies to practical use.", category = "init" },
      { text = "Stand still... this won't take long.", category = "init" },
      { text = "Another lesson in humility for you.", category = "init" },
      { text = "The elements bend to MY will!", category = "init" },
      { text = "As I predicted.", category = "kill" },
      { text = "You were never a match for me.", category = "kill" },
      { text = "Knowledge is power. You had neither.", category = "kill" },
      { text = "Return to the dust from whence you came.", category = "kill" },
      { text = "A fitting end for a fool.", category = "kill" },
      { text = "The arcane claims another.", category = "kill" },
      { text = "You'll have to do better than that!", category = "surv" },
      { text = "I've survived worse!", category = "surv" },
      { text = "Nice try.", category = "surv" },
      { text = "My shields hold strong!", category = "surv" },
      { text = "You cannot break what you cannot touch.", category = "surv" },
      { text = "Was there ever any doubt?", category = "vict" },
      { text = "Another victory for the archives.", category = "vict" },
      { text = "Intellect triumphs once again.", category = "vict" },
      { text = "That was almost too easy.", category = "vict" },
      { text = "Feel the burn!", category = "mid" },
      { text = "Chill out!", category = "mid" },
      { text = "The arcane surges through me!", category = "mid" },
    }
  },

  -- KHADGAR REFERENCES
  {
    id = "khadgar",
    name = "Khadgar References",
    author = "MageQuotes Team",
    description = "Inspired by Archmage Khadgar. Dad jokes included!",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Achievement_Boss_Khadgar",
    color = {0.8, 0.6, 1.0},
    quotes = {
      { text = "Hmm, this looks dangerous. I love it!", category = "init" },
      { text = "Time for some practical magic!", category = "init" },
      { text = "I didn't become Archmage by being careful!", category = "init" },
      { text = "Watch and learn, champions!", category = "init" },
      { text = "And THAT'S how it's done!", category = "kill" },
      { text = "I'm not just a pretty face, you know.", category = "kill" },
      { text = "Medivh would be proud. Maybe.", category = "kill" },
      { text = "Another one for the history books!", category = "kill" },
      { text = "Whoa! That was close!", category = "surv" },
      { text = "I've still got a few tricks up my sleeve!", category = "surv" },
      { text = "Good thing I studied defensive magic!", category = "surv" },
      { text = "Victory! Now, who wants refreshments?", category = "vict" },
      { text = "Another crisis averted!", category = "vict" },
      { text = "I need about 4000 Apexis Crystals for this.", category = "rare" },
      { text = "Trust me, I'm an Archmage.", category = "rare" },
    }
  },

  -- JAINA PROUDMOORE
  {
    id = "jaina",
    name = "Jaina Proudmoore",
    author = "MageQuotes Team",
    description = "Channel the Lady of Theramore.",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Achievement_Boss_Jaina",
    color = {0.5, 0.8, 1.0},
    quotes = {
      { text = "I will NOT be a victim!", category = "init" },
      { text = "Enough! I'll handle this myself.", category = "init" },
      { text = "Theramore will be avenged!", category = "init" },
      { text = "I tried peace. Now I choose war.", category = "init" },
      { text = "Winter is coming... for YOU.", category = "init" },
      { text = "Justice has been served.", category = "kill" },
      { text = "The cold claims another.", category = "kill" },
      { text = "For Theramore. For the Alliance.", category = "kill" },
      { text = "Frozen... forever.", category = "kill" },
      { text = "I will NOT fall here!", category = "surv" },
      { text = "The ice protects me!", category = "surv" },
      { text = "It's done. Finally.", category = "vict" },
      { text = "Beware the Daughter of the Sea.", category = "rare" },
    }
  },

  -- FIRE MAGE
  {
    id = "fire_specialist",
    name = "Fire Mage Specialist",
    author = "MageQuotes Team", 
    description = "For those who like it HOT!",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Spell_Fire_FlameBolt",
    color = {1.0, 0.45, 0.25},
    spec = "fire",
    quotes = {
      { text = "BURN!", category = "init", spec = "fire" },
      { text = "Let's heat things up!", category = "init", spec = "fire" },
      { text = "Fire solves everything!", category = "init", spec = "fire" },
      { text = "Combustion primed!", category = "init", spec = "fire" },
      { text = "Reduced to ashes!", category = "kill", spec = "fire" },
      { text = "Burn, baby, burn!", category = "kill", spec = "fire" },
      { text = "Extra crispy.", category = "kill", spec = "fire" },
      { text = "The flames shield me!", category = "surv", spec = "fire" },
      { text = "Everything burns in the end.", category = "vict", spec = "fire" },
      { text = "HOT STREAK!", category = "mid", spec = "fire" },
      { text = "Pyroblast incoming!", category = "mid", spec = "fire" },
    }
  },

  -- FROST MAGE
  {
    id = "frost_specialist",
    name = "Frost Mage Specialist",
    author = "MageQuotes Team",
    description = "Cool, calm, and deadly.",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Spell_Frost_FrostBolt02",
    color = {0.55, 0.90, 1.00},
    spec = "frost",
    quotes = {
      { text = "Winter has come for you.", category = "init", spec = "frost" },
      { text = "The cold never bothered me anyway.", category = "init", spec = "frost" },
      { text = "Ice to meet you.", category = "init", spec = "frost" },
      { text = "Shattered!", category = "kill", spec = "frost" },
      { text = "Ice cold.", category = "kill", spec = "frost" },
      { text = "Chill out... permanently.", category = "kill", spec = "frost" },
      { text = "Frozen barrier holds!", category = "surv", spec = "frost" },
      { text = "The cold claims victory.", category = "vict", spec = "frost" },
      { text = "Brain Freeze!", category = "mid", spec = "frost" },
      { text = "Blizzard incoming!", category = "mid", spec = "frost" },
    }
  },

  -- ARCANE MAGE
  {
    id = "arcane_specialist",
    name = "Arcane Mage Specialist",
    author = "MageQuotes Team",
    description = "Pure magical power.",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Spell_Holy_MagicalSentry",
    color = {0.65, 0.80, 1.00},
    spec = "arcane",
    quotes = {
      { text = "Witness true magical mastery!", category = "init", spec = "arcane" },
      { text = "The arcane answers my call!", category = "init", spec = "arcane" },
      { text = "Raw power, unleashed!", category = "init", spec = "arcane" },
      { text = "Arcane obliteration complete.", category = "kill", spec = "arcane" },
      { text = "Erased from existence.", category = "kill", spec = "arcane" },
      { text = "My barriers are impenetrable!", category = "surv", spec = "arcane" },
      { text = "Arcane supremacy confirmed.", category = "vict", spec = "arcane" },
      { text = "Clearcasting!", category = "mid", spec = "arcane" },
    }
  },

  -- RUSSIAN
  {
    id = "russian_classic",
    name = "Классические Фразы Мага",
    author = "MageQuotes Team",
    description = "Цитаты на русском языке.",
    version = "1.0",
    locale = "ruRU",
    icon = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
    color = {0.8, 0.4, 0.4},
    quotes = {
      { text = "Ты осмелился бросить вызов мастеру магии?", category = "init" },
      { text = "Позволь показать тебе истинную силу!", category = "init" },
      { text = "Твоя судьба была предрешена.", category = "init" },
      { text = "Как я и предсказывал.", category = "kill" },
      { text = "Ты никогда не был мне ровней.", category = "kill" },
      { text = "Придётся постараться!", category = "surv" },
      { text = "Мои щиты крепки!", category = "surv" },
      { text = "А были ли сомнения?", category = "vict" },
      { text = "Почувствуй жар!", category = "mid" },
      { text = "Остынь!", category = "mid" },
    }
  },

  -- PVP
  {
    id = "pvp_trash_talk",
    name = "PvP Trash Talk",
    author = "MageQuotes Team",
    description = "Arena and BG banter.",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\Achievement_Arena_2v2_7",
    color = {1.0, 0.3, 0.3},
    quotes = {
      { text = "Free honor!", category = "init" },
      { text = "Let's dance!", category = "init" },
      { text = "GG EZ", category = "kill" },
      { text = "Skill issue.", category = "kill" },
      { text = "Outplayed!", category = "kill" },
      { text = "Nice try.", category = "surv" },
      { text = "Missed me!", category = "surv" },
      { text = "Thanks for the points!", category = "vict" },
    }
  },

  -- ROLEPLAY
  {
    id = "roleplay_immersive",
    name = "Roleplay Immersive",
    author = "MageQuotes Team",
    description = "Lore-friendly for roleplayers.",
    version = "1.0",
    locale = "enUS",
    icon = "Interface\\Icons\\INV_Misc_Book_09",
    color = {0.6, 0.5, 0.4},
    quotes = {
      { text = "By the light of the Kirin Tor!", category = "init" },
      { text = "In the name of Dalaran!", category = "init" },
      { text = "The ley lines guide my hand.", category = "init" },
      { text = "Return to the Twisting Nether.", category = "kill" },
      { text = "The arcane has passed judgment.", category = "kill" },
      { text = "My wards hold firm!", category = "surv" },
      { text = "Balance is restored.", category = "vict" },
      { text = "Well met, traveler.", category = "greet" },
      { text = "Greetings from Dalaran.", category = "greet" },
    }
  },
}

------------------------------------------------------------
-- Module API
------------------------------------------------------------
local QuotePacksModule = {
  version = MODULE_VERSION,
  packs = CuratedPacks,
}

function QuotePacksModule:GetAvailablePacks()
  return self.packs
end

function QuotePacksModule:GetPackById(packId)
  for _, pack in ipairs(self.packs) do
    if pack.id == packId then return pack end
  end
  return nil
end

function QuotePacksModule:IsPackInstalled(packId)
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.installedPacks = MageQuotesDB.installedPacks or {}
  return MageQuotesDB.installedPacks[packId] == true
end

function QuotePacksModule:InstallPack(packId)
  local pack = self:GetPackById(packId)
  if not pack then return false, "Pack not found" end
  if self:IsPackInstalled(packId) then return false, "Already installed" end
  
  MageQuotesDB = MageQuotesDB or {}
  MageQuotesDB.customQuotes = MageQuotesDB.customQuotes or {}
  MageQuotesDB.installedPacks = MageQuotesDB.installedPacks or {}
  
  local added, skipped = 0, 0
  for _, q in ipairs(pack.quotes or {}) do
    local dup = false
    for _, e in ipairs(MageQuotesDB.customQuotes) do
      if e.text == q.text and e.category == q.category then dup = true break end
    end
    if not dup then
      table.insert(MageQuotesDB.customQuotes, {
        text = q.text, category = q.category or "init",
        spec = q.spec or pack.spec or "all", sound = "",
        enabled = true, packId = packId, packName = pack.name,
      })
      added = added + 1
    else skipped = skipped + 1 end
  end
  
  MageQuotesDB.installedPacks[packId] = true
  if MageQuotes_EventBus then MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_CUSTOM_UPDATED") end
  
  local r = string.format("'%s': %d added", pack.name, added)
  if skipped > 0 then r = r .. string.format(" (%d skipped)", skipped) end
  return true, r
end

function QuotePacksModule:UninstallPack(packId)
  if not self:IsPackInstalled(packId) then return false, "Not installed" end
  local pack = self:GetPackById(packId)
  
  local new, removed = {}, 0
  for _, q in ipairs(MageQuotesDB.customQuotes or {}) do
    if q.packId ~= packId then table.insert(new, q) else removed = removed + 1 end
  end
  
  MageQuotesDB.customQuotes = new
  MageQuotesDB.installedPacks[packId] = nil
  if MageQuotes_EventBus then MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_CUSTOM_UPDATED") end
  
  return true, string.format("'%s': %d removed", pack and pack.name or packId, removed)
end

------------------------------------------------------------
-- Register Global API
------------------------------------------------------------
MageQuotes_QuotePacks = QuotePacksModule

function MageQuotes_GetAvailablePacks() return QuotePacksModule:GetAvailablePacks() end
function MageQuotes_GetPackById(id) return QuotePacksModule:GetPackById(id) end
function MageQuotes_IsPackInstalled(id) return QuotePacksModule:IsPackInstalled(id) end
function MageQuotes_InstallPack(id) return QuotePacksModule:InstallPack(id) end
function MageQuotes_UninstallPack(id) return QuotePacksModule:UninstallPack(id) end

------------------------------------------------------------
-- Slash Command
------------------------------------------------------------
SLASH_MQPACKS1 = "/mqpacks"
SlashCmdList["MQPACKS"] = function(msg)
  local cmd, arg = msg:match("^(%S*)%s*(.*)$")
  cmd = (cmd or ""):lower()
  
  if cmd == "" or cmd == "help" then
    print("|cffffaa00MageQuotes Packs v" .. MODULE_VERSION .. "|r")
    print("  /mqpacks list | install <id> | uninstall <id> | installed | ui")
  elseif cmd == "list" then
    print("|cffffaa00Available Packs:|r")
    for _, p in ipairs(CuratedPacks) do
      local s = QuotePacksModule:IsPackInstalled(p.id) and " |cff00ff00[OK]|r" or ""
      print(string.format("  |cff88bbff%s|r %s (%d)%s", p.id, p.name, #p.quotes, s))
    end
  elseif cmd == "install" and arg ~= "" then
    local ok, r = QuotePacksModule:InstallPack(arg)
    print((ok and "|cff00ff00" or "|cffff0000") .. r .. "|r")
  elseif cmd == "uninstall" and arg ~= "" then
    local ok, r = QuotePacksModule:UninstallPack(arg)
    print((ok and "|cff00ff00" or "|cffff0000") .. r .. "|r")
  elseif cmd == "installed" then
    print("|cffffaa00Installed:|r")
    local c = 0
    for id in pairs(MageQuotesDB.installedPacks or {}) do
      local p = QuotePacksModule:GetPackById(id)
      print("  " .. (p and p.name or id))
      c = c + 1
    end
    if c == 0 then print("  (none)") end
  elseif cmd == "ui" then
    if MageQuotes_OpenPacksBrowser then MageQuotes_OpenPacksBrowser()
    else print("|cffff6666UI not loaded|r") end
  end
end

print("|cffffaa00MageQuotes QuotePacks v" .. MODULE_VERSION .. "|r - /mqpacks")
