-- AzerothVoiced/Locales/Quotes_Warrior.lua
-- Warrior Class Quotes
-- v2.0.0

------------------------------------------------------------
-- ENGLISH QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("WARRIOR", "enUS", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "FOR GLORY!" },
        { text = "CHARGE!" },
        { text = "Your skull will make a fine trophy!" },
        { text = "Steel meets flesh!" },
        { text = "Come and face me, coward!" },
        { text = "I've been waiting for a real fight!" },
        { text = "Let the battle begin!" },
        { text = "You'll regret crossing my path!" },
        { text = "Time to earn some honor!" },
        { text = "My blade thirsts for blood!" },
        { text = "No retreat! No surrender!" },
        { text = "Feel the fury of a true warrior!" },
        
        -- Arms Spec
        { text = "One strike is all I need!", spec = 1 },
        { text = "My blade knows only victory!", spec = 1 },
        { text = "Mortal Strike incoming!", spec = 1 },
        { text = "Precision and power!", spec = 1 },
        
        -- Fury Spec
        { text = "RAAAAGE!", spec = 2 },
        { text = "My fury knows no bounds!", spec = 2 },
        { text = "Two blades, twice the carnage!", spec = 2 },
        { text = "I will tear you apart!", spec = 2 },
        { text = "Bloodthirst! I NEED MORE!", spec = 2 },
        
        -- Protection Spec
        { text = "You want them? Go through ME!", spec = 3 },
        { text = "I am the wall that never breaks!", spec = 3 },
        { text = "My shield is your doom!", spec = 3 },
        { text = "Stand behind me!", spec = 3 },
        { text = "None shall pass!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Another one falls!" },
        { text = "Too easy!" },
        { text = "Is that the best you could do?" },
        { text = "Victory is mine!" },
        { text = "You fought poorly!" },
        { text = "That's how a warrior fights!" },
        { text = "Fall before my might!" },
        { text = "Pathetic!" },
        { text = "The battlefield is my home!" },
        { text = "Rest now. In pieces." },
        
        -- Arms Spec
        { text = "One strike, one kill!", spec = 1 },
        { text = "Execute! Clean and swift!", spec = 1 },
        { text = "My blade claims another!", spec = 1 },
        
        -- Fury Spec
        { text = "MORE! I WANT MORE!", spec = 2 },
        { text = "Your blood fuels my rage!", spec = 2 },
        { text = "Rampage complete!", spec = 2 },
        { text = "The fury is satisfied... for now!", spec = 2 },
        
        -- Protection Spec
        { text = "Shield Slam sends regards!", spec = 3 },
        { text = "Defended and destroyed!", spec = 3 },
        { text = "That's what happens when you attack my allies!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival (Low Health)
    ------------------------------------------------------------
    surv = {
        -- General
        { text = "I... will not... fall!" },
        { text = "Pain only makes me stronger!" },
        { text = "Is that all you've got?!" },
        { text = "I've survived worse!" },
        { text = "My rage keeps me alive!" },
        { text = "A warrior never gives up!" },
        { text = "Blood and thunder!" },
        { text = "I will NOT die here!" },
        
        -- Fury Spec
        { text = "Enraged Regeneration! Keep fighting!", spec = 2 },
        { text = "Pain is just fuel for my fury!", spec = 2 },
        
        -- Protection Spec
        { text = "Shield Wall! Hold the line!", spec = 3 },
        { text = "Last Stand! I'm not done yet!", spec = 3 },
        { text = "My shield will protect me!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        -- General
        { text = "Victory! As expected!" },
        { text = "Another glorious battle won!" },
        { text = "The battlefield is mine!" },
        { text = "Honor and glory!" },
        { text = "That was a good fight!" },
        { text = "My ancestors smile upon me!" },
        { text = "Let them sing songs of this victory!" },
        { text = "The warrior's way brings triumph!" },
        { text = "Blood, sweat, and victory!" },
        
        -- Fury Spec
        { text = "My fury is temporarily sated!", spec = 2 },
        { text = "The rage subsides... until next time!", spec = 2 },
        
        -- Protection Spec
        { text = "Everyone behind me survived. Mission accomplished!", spec = 3 },
        { text = "The shield held. We won!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Mid-Combat
    ------------------------------------------------------------
    mid = {
        -- General
        { text = "Keep fighting!" },
        { text = "I can do this all day!" },
        { text = "You're tougher than you look!" },
        { text = "More! Give me more!" },
        { text = "A worthy opponent!" },
        
        -- Arms Spec
        { text = "Colossus Smash! Now you're vulnerable!", spec = 1 },
        { text = "Deep Wounds will finish you!", spec = 1 },
        
        -- Fury Spec
        { text = "Recklessness! Maximum carnage!", spec = 2 },
        { text = "Enrage! I GROW STRONGER!", spec = 2 },
        { text = "RAMPAGE!", spec = 2 },
        
        -- Protection Spec
        { text = "Thunder Clap! Stay back!", spec = 3 },
        { text = "Revenge! How does that feel?!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced ready for battle!" },
        { text = "A warrior's day begins. Let's find some fights!" },
        { text = "Steel sharpened, armor polished. Ready for war!" },
        { text = "Glory awaits! Let's go!" },
        { text = "Another day, another battle!" },
    },
    
    ------------------------------------------------------------
    -- Rare/Random
    ------------------------------------------------------------
    rare = {
        { text = "I should really get this armor repaired..." },
        { text = "War never changes, but my weapons do!" },
        { text = "They don't make enemies like they used to." },
        { text = "I wonder if there's a battle somewhere nearby..." },
        { text = "Peaceful days make me restless." },
        { text = "My blade is getting bored." },
        { text = "Training is good, but real combat is better!" },
    },
    
    ------------------------------------------------------------
    -- Taunt
    ------------------------------------------------------------
    taunt = {
        { text = "HEY! Over here, ugly!" },
        { text = "Your fight is with ME!" },
        { text = "Face me, coward!" },
        { text = "I'm your opponent now!" },
        { text = "Come and get me!" },
        
        -- Protection Spec
        { text = "Focus on the shield, idiots!", spec = 3 },
        { text = "I'm the tank! Hit ME!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Interrupt
    ------------------------------------------------------------
    interrupt = {
        { text = "Pummel! No casting for you!" },
        { text = "Did you think I'd let you finish that?" },
        { text = "Spell? Interrupted!" },
        { text = "Warriors don't need magic to stop magic!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "A... glorious death..." },
        { text = "I die... with honor..." },
        { text = "Tell them... I fought well..." },
        { text = "The battle... continues without me..." },
        { text = "Valhalla... awaits..." },
    },
    
    ------------------------------------------------------------
    -- Critical Strike
    ------------------------------------------------------------
    crit = {
        { text = "CRUSHING BLOW!" },
        { text = "Feel that?!" },
        { text = "MASSIVE HIT!" },
        { text = "That one hurt!" },
        
        -- Arms Spec
        { text = "Mortal Strike CRITICAL!", spec = 1 },
        { text = "Overpower! Never miss!", spec = 1 },
        
        -- Fury Spec
        { text = "Bloodthirst CRITS! More healing!", spec = 2 },
        { text = "Raging Blow CRITICAL!", spec = 2 },
    },
    
    ------------------------------------------------------------
    -- PvP Kills
    ------------------------------------------------------------
    pvp = {
        { text = "Another player falls to my blade!" },
        { text = "PvP is where warriors shine!" },
        { text = "You should have stayed in your garrison!" },
        { text = "Outskilled and outfought!" },
        { text = "That's how we do it on the battlefield!" },
    },
})

------------------------------------------------------------
-- RUSSIAN QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("WARRIOR", "ruRU", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "ВО ИМЯ СЛАВЫ!" },
        { text = "В АТАКУ!" },
        { text = "Твой череп станет отличным трофеем!" },
        { text = "Сталь встречает плоть!" },
        { text = "Выходи и сразись со мной, трус!" },
        { text = "Я ждал настоящей битвы!" },
        { text = "Да начнётся сражение!" },
        { text = "Ты пожалеешь, что встал на моём пути!" },
        { text = "Мой клинок жаждет крови!" },
        
        -- Arms Spec
        { text = "Одного удара достаточно!", spec = 1 },
        { text = "Мой клинок знает только победу!", spec = 1 },
        
        -- Fury Spec
        { text = "ЯЯЯРОСТЬ!", spec = 2 },
        { text = "Моя ярость не знает границ!", spec = 2 },
        { text = "Два клинка — двойное разрушение!", spec = 2 },
        
        -- Protection Spec
        { text = "Хотите до них добраться? Через МЕНЯ!", spec = 3 },
        { text = "Я — стена, которую не сломить!", spec = 3 },
        { text = "Мой щит — твоя погибель!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Ещё один повержен!" },
        { text = "Слишком легко!" },
        { text = "Это лучшее, на что ты способен?" },
        { text = "Победа моя!" },
        { text = "Ты сражался жалко!" },
        { text = "Вот как сражаются воины!" },
        { text = "Падите перед моей мощью!" },
        { text = "Жалкий!" },
        
        -- Fury Spec
        { text = "ЕЩЁ! Я ХОЧУ ЕЩЁ!", spec = 2 },
        { text = "Твоя кровь питает мою ярость!", spec = 2 },
    },
    
    ------------------------------------------------------------
    -- Survival
    ------------------------------------------------------------
    surv = {
        { text = "Я... не... упаду!" },
        { text = "Боль делает меня сильнее!" },
        { text = "Это всё, на что ты способен?!" },
        { text = "Я переживал и худшее!" },
        { text = "Ярость поддерживает меня!" },
        { text = "Воин никогда не сдаётся!" },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        { text = "Победа! Как и ожидалось!" },
        { text = "Ещё одна славная битва выиграна!" },
        { text = "Поле боя моё!" },
        { text = "Честь и слава!" },
        { text = "Это была хорошая битва!" },
        { text = "Мои предки гордятся мной!" },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced готов к битве!" },
        { text = "День воина начинается. Найдём сражения!" },
        { text = "Сталь заточена, броня начищена. Готов к войне!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "Славная... смерть..." },
        { text = "Умираю... с честью..." },
        { text = "Скажите им... я сражался достойно..." },
    },
    
    ------------------------------------------------------------
    -- Taunt
    ------------------------------------------------------------
    taunt = {
        { text = "ЭЙ! Сюда, уродец!" },
        { text = "Твой бой — со МНОЙ!" },
        { text = "Сразись со мной, трус!" },
        { text = "Я теперь твой противник!" },
    },
})

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    local count = AzerothVoiced_CountQuotes and AzerothVoiced_CountQuotes("WARRIOR") or 0
    print("|cff00ccff[AzerothVoiced]|r Quotes_Warrior.lua loaded (" .. count .. " quotes)")
end
