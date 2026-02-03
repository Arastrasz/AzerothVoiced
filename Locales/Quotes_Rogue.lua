-- AzerothVoiced/Locales/Quotes_Rogue.lua
-- Rogue Class Quotes
-- v2.0.0

------------------------------------------------------------
-- ENGLISH QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("ROGUE", "enUS", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "Surprise!" },
        { text = "You never saw me coming!" },
        { text = "From the shadows!" },
        { text = "Nothing personal... just business." },
        { text = "Your pockets look heavy. Let me help!" },
        { text = "Time to collect my payment... in blood!" },
        { text = "The shadows serve me!" },
        { text = "Say goodbye to your valuables... and your life!" },
        { text = "Did you miss me? I was right behind you!" },
        { text = "Stealth? What stealth? I was always here!" },
        
        -- Assassination Spec
        { text = "Poison-tipped and ready!", spec = 1 },
        { text = "Let the venom do its work!", spec = 1 },
        { text = "Mutilate! Feel the burn!", spec = 1 },
        { text = "Death by a thousand cuts... or just two!", spec = 1 },
        
        -- Outlaw Spec
        { text = "Avast! Prepare to be boarded!", spec = 2 },
        { text = "Roll the Bones! Fortune favors the bold!", spec = 2 },
        { text = "Yarr! Your gold or your life!", spec = 2 },
        { text = "Time for some swashbuckling!", spec = 2 },
        { text = "Blade Flurry! Everyone gets some!", spec = 2 },
        
        -- Subtlety Spec
        { text = "Shadow Dance begins!", spec = 3 },
        { text = "I am one with the darkness!", spec = 3 },
        { text = "Shadowstrike from nowhere!", spec = 3 },
        { text = "The shadows consume all!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Contract complete!" },
        { text = "Too easy!" },
        { text = "Another satisfied customer... wait." },
        { text = "You've been... eliminated." },
        { text = "The shadows claim another!" },
        { text = "Clean hit!" },
        { text = "That's how a professional does it!" },
        { text = "Rest now. Permanently." },
        
        -- Assassination Spec
        { text = "Envenom finishes the job!", spec = 1 },
        { text = "Poison took care of the rest!", spec = 1 },
        { text = "Death by assassination!", spec = 1 },
        
        -- Outlaw Spec
        { text = "Dispatched with style!", spec = 2 },
        { text = "Between the Eyes! Critical finish!", spec = 2 },
        { text = "That's some fine piracy!", spec = 2 },
        
        -- Subtlety Spec
        { text = "Eviscerate! From the shadows!", spec = 3 },
        { text = "Shadow-powered execution!", spec = 3 },
        { text = "They never knew what hit them!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival (Low Health)
    ------------------------------------------------------------
    surv = {
        -- General
        { text = "Vanish! Can't hit what you can't see!" },
        { text = "Cloak of Shadows! Try that again!" },
        { text = "Evasion! Too fast for you!" },
        { text = "Time to disappear!" },
        { text = "Crimson Vial! Quick healing!" },
        { text = "This wasn't part of the plan!" },
        { text = "Need to restealth!" },
        
        -- Assassination Spec
        { text = "Leeching Poison, do your thing!", spec = 1 },
        
        -- Outlaw Spec
        { text = "Riposte! I'm not done yet!", spec = 2 },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        -- General
        { text = "Job's done. Pay up." },
        { text = "Clean work. No witnesses." },
        { text = "The shadows always win!" },
        { text = "Professional results, as always!" },
        { text = "Time to collect my fee!" },
        { text = "Another name crossed off the list!" },
        { text = "Now, about my payment..." },
        
        -- Outlaw Spec
        { text = "Ahoy! Victory at sea... I mean, land!", spec = 2 },
        { text = "The loot is mine!", spec = 2 },
    },
    
    ------------------------------------------------------------
    -- Mid-Combat
    ------------------------------------------------------------
    mid = {
        -- General
        { text = "Building combo points!" },
        { text = "Can't touch this!" },
        { text = "Dance, puppet, dance!" },
        
        -- Assassination Spec
        { text = "Rupture! Bleed out!", spec = 1 },
        { text = "Garrote! No screaming!", spec = 1 },
        
        -- Outlaw Spec
        { text = "Sinister Strike! Again!", spec = 2 },
        { text = "Pistol Shot! Bang!", spec = 2 },
        { text = "Adrenaline Rush! Maximum speed!", spec = 2 },
        
        -- Subtlety Spec
        { text = "Symbols of Death! Power surge!", spec = 3 },
        { text = "Shuriken Storm! Throwing stars!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced loaded. Shh... quietly." },
        { text = "Ready for business. Shady business." },
        { text = "The shadows welcome you... and your gold." },
        { text = "Contract accepted. Let's work!" },
        { text = "Daggers sharp, pockets ready. Let's go!" },
    },
    
    ------------------------------------------------------------
    -- Rare/Random
    ------------------------------------------------------------
    rare = {
        { text = "I wonder what's in that chest..." },
        { text = "Lockpicking skill: Still got it!" },
        { text = "Gold doesn't grow on trees. It grows in pockets!" },
        { text = "That guy looks like he has nice stuff..." },
        { text = "Stealth is a way of life, not just an ability." },
        { text = "I could pickpocket that guy, but I won't... probably." },
        { text = "My daggers need naming. How about 'Stabby' and 'Stabitha'?" },
    },
    
    ------------------------------------------------------------
    -- Interrupt
    ------------------------------------------------------------
    interrupt = {
        { text = "Kick! No magic for you!" },
        { text = "Silenced! Keep your spells!" },
        { text = "Interrupted from the shadows!" },
        { text = "Blind! Can't cast what you can't see!", spec = 1 },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "Should have... vanished sooner..." },
        { text = "The shadows... release me..." },
        { text = "Outplayed... this time..." },
        { text = "My contract... unfulfilled..." },
        { text = "They got... lucky..." },
    },
    
    ------------------------------------------------------------
    -- Critical Strike
    ------------------------------------------------------------
    crit = {
        { text = "Critical backstab!" },
        { text = "Vital organs located!" },
        { text = "Massive sneak attack!" },
        
        -- Assassination Spec
        { text = "Mutilate CRITS! Toxic!", spec = 1 },
        
        -- Outlaw Spec
        { text = "Run Through CRITICAL!", spec = 2 },
        
        -- Subtlety Spec
        { text = "Shadowstrike CRITS from nowhere!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- PvP Kills
    ------------------------------------------------------------
    pvp = {
        { text = "Another player ganked!" },
        { text = "You shouldn't have flagged PvP!" },
        { text = "Stealth kills are the best kills!" },
        { text = "That's what you get for not checking your back!" },
        { text = "World PvP is my specialty!" },
    },
})

------------------------------------------------------------
-- RUSSIAN QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("ROGUE", "ruRU", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        { text = "Сюрприз!" },
        { text = "Ты меня не видел!" },
        { text = "Из теней!" },
        { text = "Ничего личного... просто работа." },
        { text = "Твои карманы выглядят тяжёлыми. Дай помогу!" },
        { text = "Время получить оплату... кровью!" },
        { text = "Тени служат мне!" },
        
        -- Assassination Spec
        { text = "Ядовитые клинки готовы!", spec = 1 },
        { text = "Пусть яд сделает своё дело!", spec = 1 },
        
        -- Outlaw Spec
        { text = "На абордаж!", spec = 2 },
        { text = "Кости судьбы! Фортуна любит смелых!", spec = 2 },
        
        -- Subtlety Spec
        { text = "Танец теней начинается!", spec = 3 },
        { text = "Я един с тьмой!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        { text = "Контракт выполнен!" },
        { text = "Слишком легко!" },
        { text = "Ещё один довольный клиент... стоп." },
        { text = "Ты был... устранён." },
        { text = "Тени забирают ещё одного!" },
        { text = "Чистая работа!" },
        { text = "Вот как работают профессионалы!" },
    },
    
    ------------------------------------------------------------
    -- Survival
    ------------------------------------------------------------
    surv = {
        { text = "Исчезновение! Не попадёшь в невидимку!" },
        { text = "Плащ теней! Попробуй ещё раз!" },
        { text = "Уклонение! Слишком быстр для тебя!" },
        { text = "Пора исчезнуть!" },
        { text = "Это не было частью плана!" },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        { text = "Работа сделана. Плати." },
        { text = "Чистая работа. Нет свидетелей." },
        { text = "Тени всегда побеждают!" },
        { text = "Профессиональный результат, как всегда!" },
        { text = "Время собрать гонорар!" },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced загружен. Тсс... тихо." },
        { text = "Готов к делу. Тёмному делу." },
        { text = "Тени приветствуют тебя... и твоё золото." },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "Надо было... исчезнуть раньше..." },
        { text = "Тени... отпускают меня..." },
        { text = "Переиграли... в этот раз..." },
    },
})

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    local count = AzerothVoiced_CountQuotes and AzerothVoiced_CountQuotes("ROGUE") or 0
    print("|cff00ccff[AzerothVoiced]|r Quotes_Rogue.lua loaded (" .. count .. " quotes)")
end
