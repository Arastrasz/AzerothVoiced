-- AzerothVoiced/Locales/Quotes_Shaman.lua
-- Shaman Class Quotes
-- v2.0.0

AzerothVoiced_RegisterQuotes("SHAMAN", "enUS", {
    init = {
        { text = "The elements are with me!" },
        { text = "Storm, Earth, and Fire, heed my call!" },
        { text = "Nature's fury unleashed!" },
        { text = "Feel the power of the elements!" },
        { text = "Ancestors, guide my strikes!" },
        { text = "The spirits demand battle!" },
        { text = "Lightning crashes!", spec = 1 },
        { text = "Lava Burst incoming!", spec = 1 },
        { text = "Stormstrike!", spec = 2 },
        { text = "Windfury, empower me!", spec = 2 },
        { text = "The waters will heal us!", spec = 3 },
    },
    kill = {
        { text = "The elements are satisfied!" },
        { text = "Return to the earth!" },
        { text = "Thunderstruck!" },
        { text = "The spirits claim you!" },
        { text = "Chain Lightning finishes you!", spec = 1 },
        { text = "Lava Lash burns!", spec = 2 },
    },
    surv = {
        { text = "Astral Shift! Phase out!" },
        { text = "Earth Elemental, protect me!" },
        { text = "Healing Surge on myself!" },
        { text = "Spirit Link! Share the pain!" },
        { text = "Reincarnation ready... just in case!" },
    },
    vict = {
        { text = "The elements are appeased!" },
        { text = "Balance is restored!" },
        { text = "The ancestors smile upon us!" },
        { text = "Elemental mastery proven!" },
    },
    greet = {
        { text = "Azeroth Voiced loaded. The elements awaken!" },
        { text = "Storm clouds gather. Time for action!" },
        { text = "Totems ready, elements willing!" },
    },
    mid = {
        { text = "Earth Shock! Interrupt!" },
        { text = "Flame Shock spreading!" },
        { text = "Feral Spirit! Wolves, attack!", spec = 2 },
        { text = "Healing Rain for everyone!", spec = 3 },
    },
    heal = {
        { text = "Healing Wave incoming!", spec = 3 },
        { text = "Chain Heal bouncing!", spec = 3 },
        { text = "Riptide on you!", spec = 3 },
        { text = "Spirit Link Totem! Share the burden!", spec = 3 },
    },
    rare = {
        { text = "The elements speak to me... they say 'more totems'." },
        { text = "Reincarnation is ready. Always have a backup plan!" },
        { text = "I should commune with the elements more often." },
        { text = "Bloodlust/Heroism ready... don't waste it!" },
    },
    interrupt = {
        { text = "Wind Shear! Silenced!" },
        { text = "The wind cuts your spell!" },
        { text = "Grounding Totem absorbs that!" },
    },
    death = {
        { text = "The elements... release me..." },
        { text = "I return... to the ancestors..." },
        { text = "Reincarnation... don't fail me..." },
    },
    crit = {
        { text = "ELEMENTAL OVERLOAD!", spec = 1 },
        { text = "Stormstrike CRITS!", spec = 2 },
        { text = "Lightning strikes true!" },
    },
    pvp = {
        { text = "Thunderstormed off the cliff!" },
        { text = "Hex! Now you're a frog!" },
        { text = "The elements judge players too!" },
    },
})

AzerothVoiced_RegisterQuotes("SHAMAN", "ruRU", {
    init = {
        { text = "Стихии со мной!" },
        { text = "Буря, Земля и Огонь, услышьте мой зов!" },
        { text = "Ярость природы высвобождена!" },
        { text = "Почувствуй силу стихий!" },
        { text = "Предки, направьте мои удары!" },
    },
    kill = {
        { text = "Стихии удовлетворены!" },
        { text = "Вернись в землю!" },
        { text = "Поражён громом!" },
    },
    surv = {
        { text = "Астральный сдвиг! Выхожу из фазы!" },
        { text = "Элементаль земли, защити меня!" },
    },
    vict = {
        { text = "Стихии умиротворены!" },
        { text = "Баланс восстановлен!" },
        { text = "Предки улыбаются нам!" },
    },
    greet = {
        { text = "Azeroth Voiced загружен. Стихии пробуждаются!" },
        { text = "Грозовые тучи собираются. Время действовать!" },
    },
    death = {
        { text = "Стихии... отпускают меня..." },
        { text = "Возвращаюсь... к предкам..." },
    },
})
