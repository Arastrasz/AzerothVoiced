-- AzerothVoiced/Locales/Quotes_Mage.lua
-- Mage Class Quotes
-- v2.0.0

------------------------------------------------------------
-- ENGLISH QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("MAGE", "enUS", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "Time to show them the power of the arcane!" },
        { text = "You dare challenge a master of magic?" },
        { text = "Let the spellweaving begin!" },
        { text = "My magic will be your undoing!" },
        { text = "The elements bend to my will!" },
        { text = "Prepare to face the fury of a true mage!" },
        { text = "Your fate is sealed in arcane fire!" },
        { text = "I've studied for this moment my entire life!" },
        { text = "Knowledge is power, and I have plenty of both!" },
        { text = "Let's see how you handle real magic!" },
        
        -- Arcane Spec
        { text = "The mysteries of the arcane shall consume you!", spec = 1 },
        { text = "Arcane power flows through me!", spec = 1 },
        { text = "Feel the raw energy of the universe!", spec = 1 },
        { text = "Your mind cannot comprehend my power!", spec = 1 },
        
        -- Fire Spec
        { text = "BURN! Burn in cleansing fire!", spec = 2 },
        { text = "Fire consumes all in its path!", spec = 2 },
        { text = "Let the flames judge you!", spec = 2 },
        { text = "I am the flame that cleanses!", spec = 2 },
        { text = "Your world is about to get a lot hotter!", spec = 2 },
        
        -- Frost Spec
        { text = "Winter is coming... for you!", spec = 3 },
        { text = "Feel the cold embrace of death!", spec = 3 },
        { text = "Ice in my veins, frost in my heart!", spec = 3 },
        { text = "You will shatter like frozen glass!", spec = 3 },
        { text = "The cold never bothered me anyway!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "As expected from a superior intellect!" },
        { text = "Another lesson in magical superiority!" },
        { text = "Did you really think you could win?" },
        { text = "Magic always triumphs!" },
        { text = "That's what happens when you fight a mage!" },
        { text = "Textbook execution, if I do say so myself!" },
        { text = "You were never a match for me!" },
        { text = "Consider that your final lesson!" },
        { text = "The Kirin Tor would be proud!" },
        { text = "Another victory for the scholarly arts!" },
        
        -- Arcane Spec
        { text = "Arcane missiles never miss their mark!", spec = 1 },
        { text = "Your existence has been... corrected!", spec = 1 },
        { text = "Reality itself rejected you!", spec = 1 },
        
        -- Fire Spec
        { text = "Reduced to ashes, as it should be!", spec = 2 },
        { text = "That's hot! Literally!", spec = 2 },
        { text = "Combustion complete!", spec = 2 },
        { text = "Phoenix flames claim another!", spec = 2 },
        
        -- Frost Spec
        { text = "Shattered! Just as I calculated!", spec = 3 },
        { text = "Ice cold victory!", spec = 3 },
        { text = "Frozen solid and finished!", spec = 3 },
        { text = "Brain freeze? More like brain deleted!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival (Low Health)
    ------------------------------------------------------------
    surv = {
        -- General
        { text = "A minor setback in my calculations..." },
        { text = "Ice Block, don't fail me now!" },
        { text = "Time to reconsider my strategy!" },
        { text = "This wasn't in my research notes!" },
        { text = "Blink! Blink! BLINK!" },
        { text = "Perhaps I underestimated them slightly..." },
        { text = "A tactical repositioning is in order!" },
        { text = "My barriers are holding... barely!" },
        { text = "Time to pull out the emergency spells!" },
        
        -- Fire Spec
        { text = "Playing with fire goes both ways, apparently!", spec = 2 },
        { text = "Cauterize! Please work!", spec = 2 },
        
        -- Frost Spec
        { text = "Cold Snap! Give me another chance!", spec = 3 },
        { text = "Need more ice... lots more ice!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        -- General
        { text = "Another successful experiment!" },
        { text = "Magic wins again, as always!" },
        { text = "I'll note this in my research journal!" },
        { text = "That was almost too easy!" },
        { text = "Intellect triumphs once more!" },
        { text = "The pen is mightier than the sword... but fireballs are mightier still!" },
        { text = "Another day, another magical victory!" },
        { text = "Time for some well-deserved conjured refreshments!" },
        { text = "I love the smell of victory in the morning. Smells like... arcane!" },
        { text = "That went exactly according to my calculations!" },
        
        -- Arcane Spec
        { text = "The arcane energies have been balanced... in my favor!", spec = 1 },
        
        -- Fire Spec  
        { text = "Nothing left but cinders. Perfect!", spec = 2 },
        { text = "Who needs an army when you have fireballs?", spec = 2 },
        
        -- Frost Spec
        { text = "Cool, calm, and victorious!", spec = 3 },
        { text = "They underestimated the cold. Fatal mistake!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Mid-Combat
    ------------------------------------------------------------
    mid = {
        -- General
        { text = "Is that all you've got?" },
        { text = "I could do this all day!" },
        { text = "You're making this too easy!" },
        { text = "My mana reserves are limitless!" },
        { text = "Keep trying, it's amusing!" },
        
        -- Arcane Spec
        { text = "Arcane charges building... this will hurt!", spec = 1 },
        { text = "Feel the surge of arcane power!", spec = 1 },
        
        -- Fire Spec
        { text = "More fire! Always more fire!", spec = 2 },
        { text = "Heating up!", spec = 2 },
        { text = "Pyroblast incoming!", spec = 2 },
        
        -- Frost Spec
        { text = "Shatter combo ready!", spec = 3 },
        { text = "Fingers of Frost, don't disappoint me!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced loaded. Time to make some magic!" },
        { text = "Greetings! Let's weave some spells today!" },
        { text = "A mage is always prepared. Let's begin!" },
        { text = "My spellbook is ready. Are you?" },
        { text = "The arcane arts await!" },
    },
    
    ------------------------------------------------------------
    -- Rare/Random
    ------------------------------------------------------------
    rare = {
        { text = "I wonder if there's a spell for this..." },
        { text = "Did someone say Dalaran?" },
        { text = "I should really update my teleportation coordinates..." },
        { text = "Note to self: don't polymorph the quest giver again." },
        { text = "These robes aren't just for show, you know!" },
        { text = "I've got portals to places you've never even heard of!" },
        { text = "Arcane intellect: making me smarter since level 1!" },
    },
    
    ------------------------------------------------------------
    -- Spell Cast
    ------------------------------------------------------------
    spell = {
        { text = "Pyroblast!" },
        { text = "Glacial Spike, away!" },
        { text = "Arcane Barrage!" },
        { text = "Feel the power of the arcane!" },
        { text = "Frozen orb, do your thing!" },
    },
    
    ------------------------------------------------------------
    -- Interrupt
    ------------------------------------------------------------
    interrupt = {
        { text = "Counterspell! Not today!" },
        { text = "Did you think I'd let you cast that?" },
        { text = "Your spell? Denied!" },
        { text = "Interrupted! Try again... actually, don't!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "This... wasn't in my calculations..." },
        { text = "I'll be back... after I respawn..." },
        { text = "Should have used Ice Block..." },
        { text = "Tell my spellbook... I loved it..." },
        { text = "At least I died doing what I love... casting!" },
    },
    
    ------------------------------------------------------------
    -- Critical Strike
    ------------------------------------------------------------
    crit = {
        { text = "Critical hit! As planned!" },
        { text = "Massive damage!" },
        { text = "That's gonna leave a mark!" },
        { text = "Feel the full force of my magic!" },
        
        -- Fire Spec
        { text = "Hot streak! Here comes the pain!", spec = 2 },
        { text = "Combustion critical!", spec = 2 },
        
        -- Frost Spec
        { text = "Shatter! Beautiful!", spec = 3 },
        { text = "Ice Lance critical! Perfection!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- PvP Kills
    ------------------------------------------------------------
    pvp = {
        { text = "Another player falls to my magic!" },
        { text = "PvP? More like P-v-Mage-wins!" },
        { text = "You should have stayed in the city!" },
        { text = "That's what you get for flagging PvP!" },
        { text = "Outplayed and outmaged!" },
    },
})

------------------------------------------------------------
-- RUSSIAN QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("MAGE", "ruRU", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "Время показать силу магии!" },
        { text = "Ты смеешь бросить вызов мастеру магии?" },
        { text = "Начнём плетение заклинаний!" },
        { text = "Моя магия станет твоей погибелью!" },
        { text = "Стихии подчиняются моей воле!" },
        { text = "Приготовься встретить ярость истинного мага!" },
        { text = "Твоя судьба запечатана в волшебном огне!" },
        { text = "Я готовился к этому всю жизнь!" },
        { text = "Знание - сила, и у меня много обоих!" },
        
        -- Arcane Spec
        { text = "Тайны арканы поглотят тебя!", spec = 1 },
        { text = "Сила арканы течёт через меня!", spec = 1 },
        
        -- Fire Spec
        { text = "ГОРИ! Гори в очищающем пламени!", spec = 2 },
        { text = "Огонь поглощает всё на своём пути!", spec = 2 },
        { text = "Пусть пламя судит тебя!", spec = 2 },
        
        -- Frost Spec
        { text = "Зима близко... для тебя!", spec = 3 },
        { text = "Почувствуй холодные объятия смерти!", spec = 3 },
        { text = "Лёд в моих венах, мороз в моём сердце!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Как и ожидалось от высшего интеллекта!" },
        { text = "Ещё один урок магического превосходства!" },
        { text = "Ты правда думал, что сможешь победить?" },
        { text = "Магия всегда торжествует!" },
        { text = "Вот что бывает, когда сражаешься с магом!" },
        { text = "Образцовое исполнение!" },
        { text = "Кирин-Тор гордился бы мной!" },
        
        -- Fire Spec
        { text = "Превращён в пепел, как и должно быть!", spec = 2 },
        { text = "Горячо! Буквально!", spec = 2 },
        
        -- Frost Spec
        { text = "Разбит вдребезги! Как я и рассчитывал!", spec = 3 },
        { text = "Ледяная победа!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival
    ------------------------------------------------------------
    surv = {
        { text = "Небольшая погрешность в расчётах..." },
        { text = "Ледяная глыба, не подведи!" },
        { text = "Пора пересмотреть стратегию!" },
        { text = "Этого не было в моих записях!" },
        { text = "Скачок! Скачок! СКАЧОК!" },
        { text = "Возможно, я их слегка недооценил..." },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        { text = "Ещё один успешный эксперимент!" },
        { text = "Магия снова побеждает!" },
        { text = "Запишу это в журнал исследований!" },
        { text = "Это было почти слишком легко!" },
        { text = "Интеллект снова торжествует!" },
        { text = "Время для заслуженных колдовских угощений!" },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced загружен. Время творить магию!" },
        { text = "Приветствую! Давайте сплетём заклинания!" },
        { text = "Маг всегда готов. Начнём!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "Это... не было в моих расчётах..." },
        { text = "Я вернусь... после возрождения..." },
        { text = "Надо было использовать Ледяную глыбу..." },
    },
})

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    local count = AzerothVoiced_CountQuotes and AzerothVoiced_CountQuotes("MAGE") or 0
    print("|cff00ccff[AzerothVoiced]|r Quotes_Mage.lua loaded (" .. count .. " quotes)")
end
