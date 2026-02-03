-- AzerothVoiced/Locales/Quotes_Paladin.lua
-- Paladin Class Quotes
-- v2.0.0

------------------------------------------------------------
-- ENGLISH QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("PALADIN", "enUS", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "By the Light!" },
        { text = "Justice shall be served!" },
        { text = "The Light will guide my blade!" },
        { text = "For honor! For justice!" },
        { text = "Evil shall be purged!" },
        { text = "Face the wrath of the righteous!" },
        { text = "The crusade begins!" },
        { text = "In the name of the Light!" },
        { text = "Your darkness ends here!" },
        { text = "Stand and face divine judgment!" },
        { text = "The Light protects!" },
        
        -- Holy Spec
        { text = "The Light's healing shall prevail!", spec = 1 },
        { text = "I fight so others may live!", spec = 1 },
        { text = "Holy power, protect the innocent!", spec = 1 },
        
        -- Protection Spec
        { text = "My faith is my shield!", spec = 2 },
        { text = "I am the bulwark against evil!", spec = 2 },
        { text = "None shall harm those I protect!", spec = 2 },
        { text = "Stand behind me, allies!", spec = 2 },
        { text = "The Light's defense is absolute!", spec = 2 },
        
        -- Retribution Spec
        { text = "Retribution is at hand!", spec = 3 },
        { text = "Feel the Light's vengeance!", spec = 3 },
        { text = "Justice through strength!", spec = 3 },
        { text = "Divine Storm approaches!", spec = 3 },
        { text = "Avenging Wrath! TASTE THE LIGHT!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Justice is done!" },
        { text = "The Light prevails!" },
        { text = "Evil has been vanquished!" },
        { text = "Righteous fury claims another!" },
        { text = "Return to the shadows!" },
        { text = "The crusade continues!" },
        { text = "Your sins have been judged!" },
        { text = "Light's blessing, delivered swiftly!" },
        
        -- Protection Spec
        { text = "Shield of the Righteous strikes true!", spec = 2 },
        { text = "Defense is the best offense!", spec = 2 },
        
        -- Retribution Spec
        { text = "Templar's Verdict! Guilty!", spec = 3 },
        { text = "Final Verdict rendered!", spec = 3 },
        { text = "Execution Sentence served!", spec = 3 },
        { text = "Divine judgment complete!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival (Low Health)
    ------------------------------------------------------------
    surv = {
        -- General
        { text = "Light, give me strength!" },
        { text = "I will not fall!" },
        { text = "Divine Shield, protect me!" },
        { text = "Lay on Hands! Now!" },
        { text = "My faith sustains me!" },
        { text = "The Light has not abandoned me!" },
        { text = "Blessing of Protection!" },
        
        -- Holy Spec
        { text = "I can heal through this!", spec = 1 },
        { text = "Light of the Martyr, if I must!", spec = 1 },
        
        -- Protection Spec
        { text = "Ardent Defender, save me!", spec = 2 },
        { text = "Guardian of Ancient Kings!", spec = 2 },
        
        -- Retribution Spec
        { text = "Word of Glory on myself!", spec = 3 },
        { text = "Eye for an Eye activating!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        -- General
        { text = "The Light has triumphed!" },
        { text = "Victory for the righteous!" },
        { text = "Justice has been served this day!" },
        { text = "May the fallen find peace." },
        { text = "The crusade marches on!" },
        { text = "Light be praised!" },
        { text = "Another victory for the faithful!" },
        { text = "Evil will never prevail!" },
        
        -- Holy Spec
        { text = "Everyone survived. The Light is good!", spec = 1 },
        
        -- Retribution Spec
        { text = "Vengeance delivered. Time to reflect.", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Mid-Combat
    ------------------------------------------------------------
    mid = {
        -- General
        { text = "The Light guides my strikes!" },
        { text = "Hold fast! Victory is near!" },
        { text = "Keep fighting for what's right!" },
        
        -- Holy Spec
        { text = "Holy Shock! Stay alive, everyone!", spec = 1 },
        { text = "Aura Mastery! Maximum protection!", spec = 1 },
        
        -- Protection Spec
        { text = "Consecration! Stand in the Light!", spec = 2 },
        { text = "Avenger's Shield away!", spec = 2 },
        
        -- Retribution Spec
        { text = "Blade of Justice strikes!", spec = 3 },
        { text = "Crusader Strike! Building holy power!", spec = 3 },
        { text = "Wake of Ashes! Burn, evil!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced loaded. Light be with you!" },
        { text = "The Light guides us this day!" },
        { text = "Ready to serve justice and protect the innocent!" },
        { text = "May the Light illuminate our path!" },
        { text = "A paladin stands ready!" },
    },
    
    ------------------------------------------------------------
    -- Rare/Random
    ------------------------------------------------------------
    rare = {
        { text = "The Light provides... but gold helps too." },
        { text = "Even paladins need to eat. Preferably something blessed." },
        { text = "I should polish my armor. Again." },
        { text = "Do you think the Light judges my transmog choices?" },
        { text = "Bubble-hearth? I would never... okay, maybe once." },
        { text = "The Argent Crusade sent a letter. I should read it eventually." },
        { text = "My horse is holier than your horse." },
    },
    
    ------------------------------------------------------------
    -- Healing (Holy specific)
    ------------------------------------------------------------
    heal = {
        { text = "Holy Light, mend their wounds!", spec = 1 },
        { text = "Flash of Light! Quick healing!", spec = 1 },
        { text = "Beacon of Light established!", spec = 1 },
        { text = "The Light restores you!", spec = 1 },
        { text = "Lay on Hands! Maximum healing!", spec = 1 },
        { text = "Holy Shock! Critical heal!", spec = 1 },
    },
    
    ------------------------------------------------------------
    -- Taunt (Protection specific)
    ------------------------------------------------------------
    taunt = {
        { text = "Face me, villain!", spec = 2 },
        { text = "Hand of Reckoning! Your fight is with me!", spec = 2 },
        { text = "The shield commands your attention!", spec = 2 },
        { text = "I am your opponent now!", spec = 2 },
    },
    
    ------------------------------------------------------------
    -- Interrupt
    ------------------------------------------------------------
    interrupt = {
        { text = "Rebuke! The Light silences you!" },
        { text = "Your dark magic is denied!" },
        { text = "No spellcasting allowed!" },
        { text = "Interrupted in the name of justice!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "The Light... calls me home..." },
        { text = "My watch... has ended..." },
        { text = "I go... to join the Light..." },
        { text = "Remember... the Light always wins..." },
        { text = "Tell them... I kept the faith..." },
    },
    
    ------------------------------------------------------------
    -- Critical Strike
    ------------------------------------------------------------
    crit = {
        { text = "The Light strikes true!" },
        { text = "Divine critical!" },
        { text = "Blessed strike!" },
        
        -- Retribution Spec
        { text = "Templar's Verdict CRITICAL!", spec = 3 },
        { text = "Divine Storm crits everyone!", spec = 3 },
        { text = "Hammer of Wrath SMASHES!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- PvP Kills
    ------------------------------------------------------------
    pvp = {
        { text = "Justice served, player style!" },
        { text = "The Light judges all, even players!" },
        { text = "Another falls to righteous fury!" },
        { text = "Perhaps you should have respected the bubble!" },
    },
})

------------------------------------------------------------
-- RUSSIAN QUOTES
------------------------------------------------------------

AzerothVoiced_RegisterQuotes("PALADIN", "ruRU", {
    ------------------------------------------------------------
    -- Combat Initiation
    ------------------------------------------------------------
    init = {
        -- General
        { text = "Во имя Света!" },
        { text = "Справедливость восторжествует!" },
        { text = "Свет направит мой клинок!" },
        { text = "За честь! За справедливость!" },
        { text = "Зло будет очищено!" },
        { text = "Познай гнев праведника!" },
        { text = "Крестовый поход начинается!" },
        { text = "Во имя Света!" },
        { text = "Твоей тьме конец!" },
        
        -- Protection Spec
        { text = "Моя вера — мой щит!", spec = 2 },
        { text = "Я — оплот против зла!", spec = 2 },
        
        -- Retribution Spec
        { text = "Возмездие близко!", spec = 3 },
        { text = "Почувствуй месть Света!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Killing Blow
    ------------------------------------------------------------
    kill = {
        -- General
        { text = "Справедливость свершилась!" },
        { text = "Свет восторжествовал!" },
        { text = "Зло повержено!" },
        { text = "Праведная ярость забирает ещё одного!" },
        { text = "Вернись во тьму!" },
        { text = "Крестовый поход продолжается!" },
        
        -- Retribution Spec
        { text = "Приговор тамплиера! Виновен!", spec = 3 },
        { text = "Божественный суд свершён!", spec = 3 },
    },
    
    ------------------------------------------------------------
    -- Survival
    ------------------------------------------------------------
    surv = {
        { text = "Свет, дай мне силы!" },
        { text = "Я не упаду!" },
        { text = "Божественный щит, защити меня!" },
        { text = "Возложение рук! Сейчас!" },
        { text = "Моя вера поддерживает меня!" },
        { text = "Свет не покинул меня!" },
    },
    
    ------------------------------------------------------------
    -- Victory
    ------------------------------------------------------------
    vict = {
        { text = "Свет восторжествовал!" },
        { text = "Победа праведников!" },
        { text = "Сегодня справедливость восторжествовала!" },
        { text = "Пусть павшие обретут покой." },
        { text = "Хвала Свету!" },
    },
    
    ------------------------------------------------------------
    -- Greetings
    ------------------------------------------------------------
    greet = {
        { text = "Azeroth Voiced загружен. Свет с вами!" },
        { text = "Свет ведёт нас в этот день!" },
        { text = "Готов служить справедливости и защищать невинных!" },
    },
    
    ------------------------------------------------------------
    -- Death
    ------------------------------------------------------------
    death = {
        { text = "Свет... зовёт меня домой..." },
        { text = "Мой дозор... окончен..." },
        { text = "Я иду... присоединиться к Свету..." },
    },
})

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

if AzerothVoicedDB and AzerothVoicedDB.debugMode then
    local count = AzerothVoiced_CountQuotes and AzerothVoiced_CountQuotes("PALADIN") or 0
    print("|cff00ccff[AzerothVoiced]|r Quotes_Paladin.lua loaded (" .. count .. " quotes)")
end
