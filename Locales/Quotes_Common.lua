-- AzerothVoiced/Locales/Quotes_Common.lua
-- Common quote system utilities and data structures
-- v2.0.0

------------------------------------------------------------
-- Global Quote Storage
------------------------------------------------------------

AzerothVoiced_Quotes = AzerothVoiced_Quotes or {}

-- Structure:
-- AzerothVoiced_Quotes[CLASS][LOCALE] = {
--     [CATEGORY] = {
--         { text = "...", sound = "...", spec = 1 },
--         ...
--     }
-- }

------------------------------------------------------------
-- Quote Categories Definition
------------------------------------------------------------

AzerothVoiced_Categories = {
    -- Combat Events
    { id = "init",      priority = 1,  icon = "init" },      -- Combat start
    { id = "kill",      priority = 2,  icon = "kill" },      -- Killing blow
    { id = "surv",      priority = 3,  icon = "surv" },      -- Low health
    { id = "vict",      priority = 4,  icon = "vict" },      -- Combat end/victory
    { id = "death",     priority = 5,  icon = "death" },     -- Player death
    
    -- Mid-Combat
    { id = "mid",       priority = 10, icon = "mid" },       -- Extended combat
    { id = "crit",      priority = 11, icon = "crit" },      -- Critical strike
    { id = "spell",     priority = 12, icon = "spell" },     -- Spell cast
    { id = "interrupt", priority = 13, icon = "interrupt" }, -- Successful interrupt
    
    -- Special
    { id = "rare",      priority = 20, icon = "rare" },      -- Random rare
    { id = "greet",     priority = 21, icon = "greet" },     -- Login/greeting
    { id = "taunt",     priority = 22, icon = "taunt" },     -- Taunting
    { id = "heal",      priority = 23, icon = "heal" },      -- Healing
    { id = "buff",      priority = 24, icon = "buff" },      -- Buffing allies
    { id = "pvp",       priority = 25, icon = "pvp" },       -- PvP kills
    { id = "mount",     priority = 26, icon = "mount" },     -- Mounting up
}

-- Quick lookup table
AzerothVoiced_CategoryLookup = {}
for _, cat in ipairs(AzerothVoiced_Categories) do
    AzerothVoiced_CategoryLookup[cat.id] = cat
end

------------------------------------------------------------
-- Spec Definitions by Class
------------------------------------------------------------

AzerothVoiced_Specs = {
    WARRIOR = {
        [1] = { id = "arms",       name = "Arms",         nameRU = "Оружие" },
        [2] = { id = "fury",       name = "Fury",         nameRU = "Неистовство" },
        [3] = { id = "protection", name = "Protection",   nameRU = "Защита" },
    },
    PALADIN = {
        [1] = { id = "holy",       name = "Holy",         nameRU = "Свет" },
        [2] = { id = "protection", name = "Protection",   nameRU = "Защита" },
        [3] = { id = "retribution",name = "Retribution",  nameRU = "Воздаяние" },
    },
    HUNTER = {
        [1] = { id = "beastmastery", name = "Beast Mastery", nameRU = "Повелитель зверей" },
        [2] = { id = "marksmanship", name = "Marksmanship",  nameRU = "Стрельба" },
        [3] = { id = "survival",     name = "Survival",      nameRU = "Выживание" },
    },
    ROGUE = {
        [1] = { id = "assassination", name = "Assassination", nameRU = "Ликвидация" },
        [2] = { id = "outlaw",        name = "Outlaw",        nameRU = "Головорез" },
        [3] = { id = "subtlety",      name = "Subtlety",      nameRU = "Скрытность" },
    },
    PRIEST = {
        [1] = { id = "discipline", name = "Discipline", nameRU = "Послушание" },
        [2] = { id = "holy",       name = "Holy",       nameRU = "Свет" },
        [3] = { id = "shadow",     name = "Shadow",     nameRU = "Тьма" },
    },
    DEATHKNIGHT = {
        [1] = { id = "blood",  name = "Blood",  nameRU = "Кровь" },
        [2] = { id = "frost",  name = "Frost",  nameRU = "Лёд" },
        [3] = { id = "unholy", name = "Unholy", nameRU = "Нечестивость" },
    },
    SHAMAN = {
        [1] = { id = "elemental",   name = "Elemental",   nameRU = "Стихии" },
        [2] = { id = "enhancement", name = "Enhancement", nameRU = "Совершенствование" },
        [3] = { id = "restoration", name = "Restoration", nameRU = "Исцеление" },
    },
    MAGE = {
        [1] = { id = "arcane", name = "Arcane", nameRU = "Тайная магия" },
        [2] = { id = "fire",   name = "Fire",   nameRU = "Огонь" },
        [3] = { id = "frost",  name = "Frost",  nameRU = "Лёд" },
    },
    WARLOCK = {
        [1] = { id = "affliction",  name = "Affliction",  nameRU = "Колдовство" },
        [2] = { id = "demonology",  name = "Demonology",  nameRU = "Демонология" },
        [3] = { id = "destruction", name = "Destruction", nameRU = "Разрушение" },
    },
    MONK = {
        [1] = { id = "brewmaster", name = "Brewmaster", nameRU = "Хмелевар" },
        [2] = { id = "mistweaver", name = "Mistweaver", nameRU = "Ткач туманов" },
        [3] = { id = "windwalker", name = "Windwalker", nameRU = "Танцующий с ветром" },
    },
    DRUID = {
        [1] = { id = "balance",     name = "Balance",     nameRU = "Баланс" },
        [2] = { id = "feral",       name = "Feral",       nameRU = "Сила зверя" },
        [3] = { id = "guardian",    name = "Guardian",    nameRU = "Страж" },
        [4] = { id = "restoration", name = "Restoration", nameRU = "Исцеление" },
    },
    DEMONHUNTER = {
        [1] = { id = "havoc",     name = "Havoc",     nameRU = "Истребление" },
        [2] = { id = "vengeance", name = "Vengeance", nameRU = "Месть" },
    },
    EVOKER = {
        [1] = { id = "devastation",  name = "Devastation",  nameRU = "Опустошение" },
        [2] = { id = "preservation", name = "Preservation", nameRU = "Сохранение" },
        [3] = { id = "augmentation", name = "Augmentation", nameRU = "Приумножение" },
    },
}

------------------------------------------------------------
-- Quote Registration API
------------------------------------------------------------

-- Register quotes for a class
-- @param class: Class token (e.g., "MAGE")
-- @param locale: Locale code (e.g., "enUS")
-- @param quotes: Table of quotes by category
function AzerothVoiced_RegisterQuotes(class, locale, quotes)
    if not class or not locale or not quotes then
        return false, "Invalid parameters"
    end
    
    AzerothVoiced_Quotes[class] = AzerothVoiced_Quotes[class] or {}
    AzerothVoiced_Quotes[class][locale] = AzerothVoiced_Quotes[class][locale] or {}
    
    -- Merge quotes by category
    for category, quoteList in pairs(quotes) do
        AzerothVoiced_Quotes[class][locale][category] = 
            AzerothVoiced_Quotes[class][locale][category] or {}
        
        for _, quote in ipairs(quoteList) do
            table.insert(AzerothVoiced_Quotes[class][locale][category], quote)
        end
    end
    
    return true
end

-- Get quotes for a class/locale/category
-- @param class: Class token
-- @param locale: Locale code (falls back to enUS)
-- @param category: Category ID (optional, returns all if nil)
-- @param spec: Spec index (optional, filters by spec)
function AzerothVoiced_GetQuotes(class, locale, category, spec)
    locale = locale or "enUS"
    
    -- Check if class quotes exist
    if not AzerothVoiced_Quotes[class] then
        return {}
    end
    
    -- Try requested locale, fall back to enUS
    local classQuotes = AzerothVoiced_Quotes[class][locale]
    if not classQuotes then
        classQuotes = AzerothVoiced_Quotes[class]["enUS"]
    end
    
    if not classQuotes then
        return {}
    end
    
    -- Return all categories if no specific one requested
    if not category then
        if not spec then
            return classQuotes
        end
        
        -- Filter all categories by spec
        local filtered = {}
        for cat, quotes in pairs(classQuotes) do
            filtered[cat] = {}
            for _, q in ipairs(quotes) do
                if not q.spec or q.spec == spec then
                    table.insert(filtered[cat], q)
                end
            end
        end
        return filtered
    end
    
    -- Return specific category
    local categoryQuotes = classQuotes[category]
    if not categoryQuotes then
        return {}
    end
    
    -- Filter by spec if provided
    if spec then
        local filtered = {}
        for _, q in ipairs(categoryQuotes) do
            if not q.spec or q.spec == spec then
                table.insert(filtered, q)
            end
        end
        return filtered
    end
    
    return categoryQuotes
end

-- Get random quote from category
-- @param class: Class token
-- @param locale: Locale code
-- @param category: Category ID
-- @param spec: Spec index (optional)
-- @param excludeRecent: Table of recently used quote texts to exclude
function AzerothVoiced_GetRandomQuote(class, locale, category, spec, excludeRecent)
    local quotes = AzerothVoiced_GetQuotes(class, locale, category, spec)
    
    if not quotes or #quotes == 0 then
        return nil
    end
    
    -- Filter out recently used
    local available = quotes
    if excludeRecent and #excludeRecent > 0 then
        available = {}
        for _, q in ipairs(quotes) do
            local isRecent = false
            for _, recent in ipairs(excludeRecent) do
                if q.text == recent then
                    isRecent = true
                    break
                end
            end
            if not isRecent then
                table.insert(available, q)
            end
        end
        
        -- If all quotes were recently used, use full list
        if #available == 0 then
            available = quotes
        end
    end
    
    -- Return random quote
    local index = math.random(1, #available)
    return available[index]
end

-- Count quotes for a class
-- @param class: Class token
-- @param locale: Locale code (optional)
function AzerothVoiced_CountQuotes(class, locale)
    if not AzerothVoiced_Quotes[class] then
        return 0
    end
    
    local count = 0
    
    if locale then
        -- Count for specific locale
        local localeQuotes = AzerothVoiced_Quotes[class][locale]
        if localeQuotes then
            for _, categoryQuotes in pairs(localeQuotes) do
                count = count + #categoryQuotes
            end
        end
    else
        -- Count all locales
        for _, localeQuotes in pairs(AzerothVoiced_Quotes[class]) do
            for _, categoryQuotes in pairs(localeQuotes) do
                count = count + #categoryQuotes
            end
        end
    end
    
    return count
end

-- Get all registered classes
function AzerothVoiced_GetRegisteredClasses()
    local classes = {}
    for class in pairs(AzerothVoiced_Quotes) do
        table.insert(classes, class)
    end
    table.sort(classes)
    return classes
end

-- Check if class has quotes
function AzerothVoiced_HasQuotes(class, locale)
    if not AzerothVoiced_Quotes[class] then
        return false
    end
    
    if locale then
        return AzerothVoiced_Quotes[class][locale] ~= nil
    end
    
    return true
end

------------------------------------------------------------
-- Quote Validation
------------------------------------------------------------

-- Validate a quote object
function AzerothVoiced_ValidateQuote(quote)
    if type(quote) ~= "table" then
        return false, "Quote must be a table"
    end
    
    if not quote.text or type(quote.text) ~= "string" or quote.text == "" then
        return false, "Quote must have text"
    end
    
    if quote.spec and type(quote.spec) ~= "number" then
        return false, "Spec must be a number"
    end
    
    if quote.sound and type(quote.sound) ~= "string" then
        return false, "Sound must be a string"
    end
    
    return true
end

------------------------------------------------------------
-- Debug Utilities
------------------------------------------------------------

-- Print quote statistics
function AzerothVoiced_PrintQuoteStats()
    print("|cff00ccff[Azeroth Voiced]|r Quote Statistics:")
    
    local totalQuotes = 0
    local classes = AzerothVoiced_GetRegisteredClasses()
    
    for _, class in ipairs(classes) do
        local count = AzerothVoiced_CountQuotes(class)
        totalQuotes = totalQuotes + count
        
        local color = AzerothVoicedLib and AzerothVoicedLib.CLASS_COLORS[class] or {1, 1, 1}
        local hex = string.format("%02x%02x%02x", color[1]*255, color[2]*255, color[3]*255)
        print(string.format("  |cff%s%s|r: %d quotes", hex, class, count))
    end
    
    print(string.format("  |cffffffffTotal: %d quotes|r", totalQuotes))
end

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    print("|cff00ccff[AzerothVoiced]|r Quotes_Common.lua loaded")
end
