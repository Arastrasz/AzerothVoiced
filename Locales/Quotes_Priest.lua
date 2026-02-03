-- AzerothVoiced/Locales/Quotes_Priest.lua
-- Priest Class Quotes
-- v2.0.0

AzerothVoiced_RegisterQuotes("PRIEST", "enUS", {
    init = {
        { text = "The Light shall guide us!" },
        { text = "May peace be upon you... or not!" },
        { text = "Power Word: Pain incoming!" },
        { text = "The shadows bend to my will!", spec = 3 },
        { text = "Embrace the void!", spec = 3 },
        { text = "Holy fire descends!", spec = 1 },
        { text = "I will protect my allies!", spec = 2 },
    },
    kill = {
        { text = "The Light prevails!" },
        { text = "Return to the void!" },
        { text = "Shadow Word: Death completes you!", spec = 3 },
        { text = "Holy judgment delivered!", spec = 1 },
    },
    surv = {
        { text = "Desperate Prayer! Save me!" },
        { text = "Fade! You can't target me!" },
        { text = "Power Word: Shield! Protect me!" },
        { text = "Dispersion! I am the void!", spec = 3 },
    },
    vict = {
        { text = "The Light blesses our victory!" },
        { text = "Peace has been restored!" },
        { text = "The shadows are satisfied!", spec = 3 },
    },
    greet = {
        { text = "Azeroth Voiced loaded. Blessings upon you!" },
        { text = "The Light guides our path today!" },
    },
    heal = {
        { text = "Flash Heal! Stay with me!", spec = 1 },
        { text = "Prayer of Healing for all!", spec = 1 },
        { text = "Renew upon you!", spec = 1 },
        { text = "Atonement heals as I strike!", spec = 2 },
    },
    death = {
        { text = "The Light... fades..." },
        { text = "I return... to the void...", spec = 3 },
    },
})

AzerothVoiced_RegisterQuotes("PRIEST", "ruRU", {
    init = {
        { text = "Свет направит нас!" },
        { text = "Мир вам... или нет!" },
        { text = "Слово силы: Боль!" },
        { text = "Тени подчиняются мне!", spec = 3 },
    },
    kill = {
        { text = "Свет торжествует!" },
        { text = "Вернись в пустоту!" },
    },
    greet = {
        { text = "Azeroth Voiced загружен. Благословения вам!" },
    },
})
