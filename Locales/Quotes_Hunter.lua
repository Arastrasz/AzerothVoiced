-- AzerothVoiced/Locales/Quotes_Hunter.lua
-- Hunter Class Quotes
-- v2.0.0

------------------------------------------------------------
-- ENGLISH QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("HUNTER", "enUS", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "The hunt begins!" },
        { text = "You're now the prey!" },
        { text = "My sights are on you!" },
        { text = "Nowhere to run, nowhere to hide!" },
        { text = "Let's see how fast you can run!" },
        { text = "You've wandered into my territory!" },
        { text = "Time to earn some pelts!" },
        { text = "The wilderness claims another!" },
        { text = "My aim is true!" },
        { text = "Nature's fury is upon you!" },
        
        -- Beast Mastery Spec
        { text = "Go for the throat, pet!", spec = 1 },
        { text = "My beasts hunger for battle!", spec = 1 },
        { text = "Kill Command! Attack!", spec = 1 },
        { text = "The pack hunts as one!", spec = 1 },
        { text = "Bestial Wrath! UNLEASH THE BEAST!", spec = 1 },
        
        -- Marksmanship Spec
        { text = "One shot, one kill!", spec = 2 },
        { text = "You're already in my crosshairs!", spec = 2 },
        { text = "Aimed Shot charging...", spec = 2 },
        { text = "Perfect range. You're done.", spec = 2 },
        { text = "Trueshot activated. Every shot counts!", spec = 2 },
        
        -- Survival Spec
        { text = "Up close and personal!", spec = 3 },
        { text = "Survival of the fittest!", spec = 3 },
        { text = "My spear will find your heart!", spec = 3 },
        { text = "The hunt is on, and I'm the predator!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Bullseye!" },
        { text = "Target eliminated!" },
        { text = "That's another trophy for the wall!" },
        { text = "The hunt is complete!" },
        { text = "You should have stayed hidden!" },
        { text = "Clean kill!" },
        { text = "Nature reclaims what's hers!" },
        { text = "Right between the eyes!" },
        
        -- Beast Mastery Spec
        { text = "Good boy/girl! Excellent kill!", spec = 1 },
        { text = "My pet feasts tonight!", spec = 1 },
        { text = "The pack is satisfied!", spec = 1 },
        
        -- Marksmanship Spec
        { text = "Headshot. Perfect.", spec = 2 },
        { text = "Kill Shot delivered!", spec = 2 },
        { text = "Rapid Fire finished them!", spec = 2 },
        
        -- Survival Spec
        { text = "Impaled and finished!", spec = 3 },
        { text = "Mongoose Bite for the kill!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival (Low Health)
    ------------------------------------------------------------
    surv = {
        -- General
        { text = "Feign Death! Play dead!" },
        { text = "Disengage! I need distance!" },
        { text = "Aspect of the Turtle! Shell up!" },
        { text = "Fall back! Reposition!" },
        { text = "Laying a trap! Don't follow!" },
        { text = "Exhilaration! Patch me up!" },
        { text = "The hunter becomes the hunted?!" },
        
        -- Beast Mastery Spec
        { text = "Pet, protect me!", spec = 1 },
        { text = "Mend Pet! We both need healing!", spec = 1 },
        
        -- Survival Spec
        { text = "Harpoon out! I'm retreating!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        -- General
        { text = "Another successful hunt!" },
        { text = "The prey has fallen!" },
        { text = "Nature's balance is restored!" },
        { text = "That was some fine shooting!" },
        { text = "Time to collect the loot... I mean, trophies!" },
        { text = "The wilderness provides!" },
        { text = "Another day, another hunt!" },
        
        -- Beast Mastery Spec
        { text = "Good hunting, my friends!", spec = 1 },
        { text = "Treats for everyone! You've earned it!", spec = 1 },
        
        -- Marksmanship Spec
        { text = "Every shot landed. Perfection.", spec = 2 },
    },
    
    ------------------------------------------------------------
    -- Mid-Combat
    ------------------------------------------------------------
    mid = {
        -- General
        { text = "Keep the pressure on!" },
        { text = "Don't let them escape!" },
        { text = "More arrows incoming!" },
        { text = "Steady... steady..." },
        
        -- Beast Mastery Spec
        { text = "Barbed Shot! Keep attacking!", spec = 1 },
        { text = "Dire Beast! Join the hunt!", spec = 1 },
        
        -- Marksmanship Spec
        { text = "Volley incoming!", spec = 2 },
        { text = "Double Tap! Twice the damage!", spec = 2 },
        
        -- Survival Spec
        { text = "Wildfire Bomb away!", spec = 3 },
        { text = "Carve through them!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced loaded. Time to hunt!" },
        { text = "The wilderness calls. Let's answer!" },
        { text = "Arrows sharp, pet fed. Ready for anything!" },
        { text = "A good day for hunting!" },
        { text = "My pet and I are ready for action!" },
    },
    
    ------------------------------------------------------------
    -- Rare/Random
    ------------------------------------------------------------
    rare = {
        { text = "I wonder if that rare spawn is up..." },
        { text = "My pet collection could always use more..." },
        { text = "Who's a good boy? You are! Yes, you are!" },
        { text = "I should really clean my gun/bow." },
        { text = "Pets don't count toward the mount limit, right?" },
        { text = "I saw a spirit beast once. ONCE." },
        { text = "Hunters do it from range. Mostly." },
    },
    
    ------------------------------------------------------------
    -- Interrupt
    ------------------------------------------------------------
    interrupt = {
        { text = "Counter Shot! Silenced!" },
        { text = "No casting while I'm hunting!" },
        { text = "Interrupted! My aim is perfect!" },
        { text = "Muzzle! Keep quiet!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "The hunt... ends here..." },
        { text = "Avenge me... pet..." },
        { text = "I should have... stayed at range..." },
        { text = "The wilderness... will remember me..." },
        { text = "Tell my pets... I loved them..." },
    },
    
    ------------------------------------------------------------
    -- Critical Strike
    ------------------------------------------------------------
    crit = {
        { text = "Critical hit! Bullseye!" },
        { text = "Right in the weak spot!" },
        { text = "MASSIVE damage!" },
        
        -- Beast Mastery Spec
        { text = "Kill Command CRITS!", spec = 1 },
        
        -- Marksmanship Spec
        { text = "Aimed Shot CRITICAL! Devastating!", spec = 2 },
        { text = "Careful Aim pays off!", spec = 2 },
        
        -- Survival Spec
        { text = "Raptor Strike CRITS!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- PvP Kills
    ------------------------------------------------------------
    pvp = {
        { text = "Player down! Easy target!" },
        { text = "You can't hide from a hunter!" },
        { text = "Outranged and outplayed!" },
        { text = "That's what you get for standing still!" },
        { text = "My tracking never fails!" },
    },
})

------------------------------------------------------------
-- RUSSIAN QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("HUNTER", "ruRU", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "Охота начинается!" },
        { text = "Теперь ты — добыча!" },
        { text = "Ты у меня на прицеле!" },
        { text = "Некуда бежать, негде спрятаться!" },
        { text = "Посмотрим, как быстро ты бегаешь!" },
        { text = "Ты забрёл на мою территорию!" },
        
        -- Beast Mastery Spec
        { text = "Вцепись ему в горло, питомец!", spec = 1 },
        { text = "Мои звери жаждут битвы!", spec = 1 },
        { text = "Команда: Убить! Атака!", spec = 1 },
        
        -- Marksmanship Spec
        { text = "Один выстрел — одно убийство!", spec = 2 },
        { text = "Ты уже на прицеле!", spec = 2 },
        
        -- Survival Spec
        { text = "Лицом к лицу!", spec = 3 },
        { text = "Выживает сильнейший!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "В яблочко!" },
        { text = "Цель уничтожена!" },
        { text = "Ещё один трофей на стену!" },
        { text = "Охота завершена!" },
        { text = "Надо было лучше прятаться!" },
        { text = "Чистое убийство!" },
        
        -- Beast Mastery Spec
        { text = "Молодец! Отличная работа!", spec = 1 },
        { text = "Мой питомец сегодня пирует!", spec = 1 },
    },
    
    ------------------------------------------------------------
    -- Survival
    ------------------------------------------------------------
    surv = {
        { text = "Притворяюсь мёртвым!" },
        { text = "Отступление! Нужна дистанция!" },
        { text = "Дух черепахи! Защита!" },
        { text = "Отход! Перегруппировка!" },
        { text = "Ставлю ловушку! Не преследуй!" },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        { text = "Ещё одна успешная охота!" },
        { text = "Добыча повержена!" },
        { text = "Баланс природы восстановлен!" },
        { text = "Отличная стрельба!" },
        { text = "Дикая местность обеспечивает!" },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced загружен. Время охотиться!" },
        { text = "Дикая местность зовёт. Ответим!" },
        { text = "Стрелы наточены, питомец накормлен. Готов!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "Охота... заканчивается здесь..." },
        { text = "Отомсти за меня... питомец..." },
        { text = "Надо было... держать дистанцию..." },
    },
})

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    local count = AzerothVoiced_CountQuotes and AzerothVoiced_CountQuotes("HUNTER") or 0
    print("|cff00ccff[AzerothVoiced]|r Quotes_Hunter.lua loaded (" .. count .. " quotes)")
end
