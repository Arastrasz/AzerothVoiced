-- AzerothVoiced/Locales/UIStrings.lua
-- UI Text Translations
-- v2.0.0

AzerothVoiced_UIStrings = AzerothVoiced_UIStrings or {}

------------------------------------------------------------
-- English (Default)
------------------------------------------------------------
AzerothVoiced_UIStrings["enUS"] = {
    -- Addon Info
    addonName = "Azeroth Voiced",
    addonDesc = "Dynamic voice lines for all classes",
    version = "Version",
    
    -- Main Tabs
    tabs = {
        settings = "Settings",
        quotes = "Quotes",
        categories = "Categories",
        sound = "Sound",
        custom = "Custom",
        modules = "Modules",
        debug = "Debug",
        about = "About",
    },
    
    -- Settings Tab
    settings = {
        title = "General Settings",
        enabled = "Enable Addon",
        enabledDesc = "Turn voice lines on/off globally",
        classMode = "Class Mode",
        classModeAuto = "Auto-detect",
        classModeManual = "Manual select",
        selectedClass = "Selected Class",
        language = "Language",
        languageNote = "Note: Reload UI after changing language (/reload)",
        minimapButton = "Minimap Button",
        minimapButtonDesc = "Show minimap icon",
        combatOnly = "Combat Only",
        combatOnlyDesc = "Only play quotes during combat",
        globalCooldown = "Global Cooldown",
        globalCooldownDesc = "Minimum seconds between quotes",
        seconds = "seconds",
    },
    
    -- Quote Categories
    categories = {
        title = "Quote Categories",
        enableAll = "Enable All",
        disableAll = "Disable All",
        init = "Combat Initiation",
        initDesc = "When entering combat",
        kill = "Killing Blow",
        killDesc = "When defeating an enemy",
        surv = "Survival",
        survDesc = "When health drops low",
        vict = "Victory",
        victDesc = "When combat ends",
        rare = "Rare",
        rareDesc = "Random rare quotes",
        mid = "Mid-Combat",
        midDesc = "During extended fights",
        greet = "Greeting",
        greetDesc = "On login or reload",
        spell = "Spell Cast",
        spellDesc = "When casting specific spells",
        interrupt = "Interrupt",
        interruptDesc = "When interrupting a cast",
        death = "Death",
        deathDesc = "When your character dies",
        crit = "Critical Strike",
        critDesc = "When landing a critical hit",
        taunt = "Taunt",
        tauntDesc = "When taunting enemies",
        heal = "Healing",
        healDesc = "When healing allies",
        pvp = "PvP Kill",
        pvpDesc = "When killing a player",
    },
    
    -- Sound Tab
    sound = {
        title = "Sound Settings",
        volume = "Volume",
        channel = "Audio Channel",
        channelMaster = "Master",
        channelSFX = "Sound Effects",
        channelMusic = "Music",
        channelAmbience = "Ambience",
        channelDialog = "Dialog",
        voiceActor = "Voice Actor",
        testSound = "Test Sound",
        noVoice = "No voice files installed",
    },
    
    -- Custom Quotes Tab
    custom = {
        title = "Custom Quotes",
        add = "Add Quote",
        edit = "Edit",
        delete = "Delete",
        deleteConfirm = "Are you sure you want to delete this quote?",
        import = "Import",
        export = "Export",
        exportAll = "Export All",
        importPrompt = "Paste import string:",
        category = "Category",
        text = "Quote Text",
        textPlaceholder = "Enter your quote here...",
        sound = "Sound File (optional)",
        spec = "Specialization",
        specAll = "All Specs",
        enabled = "Enabled",
        noCustom = "No custom quotes yet. Click 'Add Quote' to create one!",
        imported = "Imported %d quotes",
        exported = "Exported %d quotes to clipboard",
        duplicate = "Quote already exists",
        added = "Quote added",
        deleted = "Quote deleted",
        browse = "Browse Packs",
    },
    
    -- Modules Tab
    modules = {
        title = "Addon Modules",
        core = "Core Engine",
        coreDesc = "Main quote system and event handling",
        ui = "User Interface",
        uiDesc = "Settings window and controls",
        customQuotes = "Custom Quotes",
        customQuotesDesc = "Add and manage your own quotes",
        quotePacks = "Quote Packs",
        quotePacksDesc = "Pre-made quote collections",
        loaded = "Loaded",
        notLoaded = "Not Loaded",
        optional = "(Optional)",
    },
    
    -- Debug Tab
    debug = {
        title = "Debug Console",
        enabled = "Debug Mode",
        enabledDesc = "Enable debug logging",
        printToChat = "Print to Chat",
        printToChatDesc = "Also show debug in chat",
        clearLog = "Clear Log",
        copyLog = "Copy Log",
        events = "Recent Events",
        noEvents = "No events recorded yet",
    },
    
    -- About Tab
    about = {
        title = "About Azeroth Voiced",
        description = "Azeroth Voiced adds immersive voice lines to your gameplay. Your character will speak dynamic quotes based on combat events, spells, and other actions.",
        features = "Features",
        feature1 = "Support for all 13 classes",
        feature2 = "Multiple quote categories",
        feature3 = "Custom quote creation",
        feature4 = "Import/Export sharing",
        feature5 = "Multi-language support",
        credits = "Credits",
        author = "Author",
        website = "Website",
        discord = "Discord",
        license = "License: MIT",
    },
    
    -- Quotes Browser
    browser = {
        title = "Quotes Browser",
        search = "Search quotes...",
        filter = "Filter",
        filterAll = "All Quotes",
        filterCustom = "Custom Only",
        filterStandard = "Standard Only",
        noResults = "No quotes found",
        total = "Total: %d quotes",
        play = "Play",
        edit = "Edit",
        copyText = "Copy Text",
    },
    
    -- Common UI
    common = {
        save = "Save",
        cancel = "Cancel",
        close = "Close",
        reset = "Reset",
        resetDefaults = "Reset to Defaults",
        confirm = "Confirm",
        yes = "Yes",
        no = "No",
        on = "ON",
        off = "OFF",
        loading = "Loading...",
        error = "Error",
        success = "Success",
        warning = "Warning",
    },
    
    -- Slash Commands
    commands = {
        help = "Available commands:",
        toggle = "Toggle settings window",
        enable = "Enable/disable addon",
        reload = "Reload quote database",
        test = "Play a test quote",
        debug = "Toggle debug mode",
        reset = "Reset all settings",
    },
    
    -- Messages
    messages = {
        enabled = "Azeroth Voiced enabled",
        disabled = "Azeroth Voiced disabled",
        loaded = "Azeroth Voiced loaded. Type /av for settings.",
        quotePlayed = "Playing quote",
        noQuotes = "No quotes available for this category",
        cooldown = "Quote on cooldown",
        classChanged = "Class changed to %s",
        specChanged = "Specialization changed",
        settingsSaved = "Settings saved",
        settingsReset = "Settings reset to defaults",
    },
}

------------------------------------------------------------
-- Russian
------------------------------------------------------------
AzerothVoiced_UIStrings["ruRU"] = {
    -- Addon Info
    addonName = "Azeroth Voiced",
    addonDesc = "Динамические голосовые реплики для всех классов",
    version = "Версия",
    
    -- Main Tabs
    tabs = {
        settings = "Настройки",
        quotes = "Цитаты",
        categories = "Категории",
        sound = "Звук",
        custom = "Свои",
        modules = "Модули",
        debug = "Отладка",
        about = "О аддоне",
    },
    
    -- Settings Tab
    settings = {
        title = "Общие настройки",
        enabled = "Включить аддон",
        enabledDesc = "Включить/выключить голосовые реплики",
        classMode = "Режим класса",
        classModeAuto = "Автоопределение",
        classModeManual = "Ручной выбор",
        selectedClass = "Выбранный класс",
        language = "Язык",
        languageNote = "Примечание: Перезагрузите интерфейс после смены языка (/reload)",
        minimapButton = "Кнопка у миникарты",
        minimapButtonDesc = "Показывать иконку у миникарты",
        combatOnly = "Только в бою",
        combatOnlyDesc = "Воспроизводить реплики только в бою",
        globalCooldown = "Глобальная задержка",
        globalCooldownDesc = "Минимум секунд между репликами",
        seconds = "секунд",
    },
    
    -- Quote Categories
    categories = {
        title = "Категории цитат",
        enableAll = "Включить все",
        disableAll = "Отключить все",
        init = "Начало боя",
        initDesc = "При вступлении в бой",
        kill = "Добивание",
        killDesc = "При убийстве врага",
        surv = "Выживание",
        survDesc = "При низком здоровье",
        vict = "Победа",
        victDesc = "При окончании боя",
        rare = "Редкие",
        rareDesc = "Случайные редкие реплики",
        mid = "В бою",
        midDesc = "Во время затяжных боёв",
        greet = "Приветствие",
        greetDesc = "При входе в игру",
        spell = "Заклинание",
        spellDesc = "При применении заклинаний",
        interrupt = "Прерывание",
        interruptDesc = "При прерывании каста",
        death = "Смерть",
        deathDesc = "При гибели персонажа",
        crit = "Критический удар",
        critDesc = "При нанесении крита",
        taunt = "Насмешка",
        tauntDesc = "При провокации врагов",
        heal = "Исцеление",
        healDesc = "При лечении союзников",
        pvp = "PvP убийство",
        pvpDesc = "При убийстве игрока",
    },
    
    -- Sound Tab
    sound = {
        title = "Настройки звука",
        volume = "Громкость",
        channel = "Аудиоканал",
        channelMaster = "Основной",
        channelSFX = "Звуковые эффекты",
        channelMusic = "Музыка",
        channelAmbience = "Окружение",
        channelDialog = "Диалоги",
        voiceActor = "Голосовой актёр",
        testSound = "Тест звука",
        noVoice = "Голосовые файлы не установлены",
    },
    
    -- Custom Quotes Tab
    custom = {
        title = "Свои цитаты",
        add = "Добавить",
        edit = "Изменить",
        delete = "Удалить",
        deleteConfirm = "Вы уверены, что хотите удалить эту цитату?",
        import = "Импорт",
        export = "Экспорт",
        exportAll = "Экспортировать все",
        importPrompt = "Вставьте строку импорта:",
        category = "Категория",
        text = "Текст цитаты",
        textPlaceholder = "Введите вашу цитату...",
        sound = "Звуковой файл (опционально)",
        spec = "Специализация",
        specAll = "Все специализации",
        enabled = "Включено",
        noCustom = "Пока нет своих цитат. Нажмите 'Добавить' чтобы создать!",
        imported = "Импортировано %d цитат",
        exported = "Экспортировано %d цитат в буфер обмена",
        duplicate = "Цитата уже существует",
        added = "Цитата добавлена",
        deleted = "Цитата удалена",
        browse = "Обзор паков",
    },
    
    -- Modules Tab
    modules = {
        title = "Модули аддона",
        core = "Ядро",
        coreDesc = "Основная система цитат и обработка событий",
        ui = "Интерфейс",
        uiDesc = "Окно настроек и элементы управления",
        customQuotes = "Свои цитаты",
        customQuotesDesc = "Добавление и управление своими цитатами",
        quotePacks = "Паки цитат",
        quotePacksDesc = "Готовые коллекции цитат",
        loaded = "Загружен",
        notLoaded = "Не загружен",
        optional = "(Опционально)",
    },
    
    -- Debug Tab
    debug = {
        title = "Консоль отладки",
        enabled = "Режим отладки",
        enabledDesc = "Включить журнал отладки",
        printToChat = "Вывод в чат",
        printToChatDesc = "Также показывать отладку в чате",
        clearLog = "Очистить",
        copyLog = "Копировать",
        events = "Последние события",
        noEvents = "События ещё не записаны",
    },
    
    -- About Tab
    about = {
        title = "Об Azeroth Voiced",
        description = "Azeroth Voiced добавляет погружающие голосовые реплики в вашу игру. Ваш персонаж будет произносить динамические фразы в зависимости от боевых событий, заклинаний и других действий.",
        features = "Возможности",
        feature1 = "Поддержка всех 13 классов",
        feature2 = "Множество категорий цитат",
        feature3 = "Создание своих цитат",
        feature4 = "Импорт/Экспорт для обмена",
        feature5 = "Мультиязычность",
        credits = "Благодарности",
        author = "Автор",
        website = "Сайт",
        discord = "Discord",
        license = "Лицензия: MIT",
    },
    
    -- Quotes Browser
    browser = {
        title = "Обзор цитат",
        search = "Поиск цитат...",
        filter = "Фильтр",
        filterAll = "Все цитаты",
        filterCustom = "Только свои",
        filterStandard = "Только стандартные",
        noResults = "Цитаты не найдены",
        total = "Всего: %d цитат",
        play = "Воспроизвести",
        edit = "Изменить",
        copyText = "Копировать текст",
    },
    
    -- Common UI
    common = {
        save = "Сохранить",
        cancel = "Отмена",
        close = "Закрыть",
        reset = "Сброс",
        resetDefaults = "Сбросить настройки",
        confirm = "Подтвердить",
        yes = "Да",
        no = "Нет",
        on = "ВКЛ",
        off = "ВЫКЛ",
        loading = "Загрузка...",
        error = "Ошибка",
        success = "Успешно",
        warning = "Внимание",
    },
    
    -- Slash Commands
    commands = {
        help = "Доступные команды:",
        toggle = "Открыть/закрыть окно настроек",
        enable = "Включить/выключить аддон",
        reload = "Перезагрузить базу цитат",
        test = "Воспроизвести тестовую цитату",
        debug = "Переключить режим отладки",
        reset = "Сбросить все настройки",
    },
    
    -- Messages
    messages = {
        enabled = "Azeroth Voiced включён",
        disabled = "Azeroth Voiced выключен",
        loaded = "Azeroth Voiced загружен. Введите /av для настроек.",
        quotePlayed = "Воспроизведение цитаты",
        noQuotes = "Нет доступных цитат для этой категории",
        cooldown = "Цитата на перезарядке",
        classChanged = "Класс изменён на %s",
        specChanged = "Специализация изменена",
        settingsSaved = "Настройки сохранены",
        settingsReset = "Настройки сброшены",
    },
}

------------------------------------------------------------
-- Locale Management
------------------------------------------------------------

local activeLocale = "enUS"
local supportedLocales = { "enUS", "ruRU" }

-- Get localized string
function AV_L(key, subkey)
    local strings = AzerothVoiced_UIStrings[activeLocale] or AzerothVoiced_UIStrings["enUS"]
    
    if subkey then
        local section = strings[key]
        if type(section) == "table" then
            return section[subkey] or key .. "." .. subkey
        end
        return key .. "." .. subkey
    end
    
    return strings[key] or key
end

-- Set active locale
function AzerothVoiced_SetLocale(locale)
    if AzerothVoiced_UIStrings[locale] then
        activeLocale = locale
        if AzerothVoicedDB then
            AzerothVoicedDB.locale = locale
        end
        -- Trigger event for UI refresh
        if AzerothVoiced_EventBus and AzerothVoiced_EventBus.TriggerEvent then
            AzerothVoiced_EventBus:TriggerEvent("AZEROTH_VOICED_LOCALE_CHANGED", locale)
        end
        return true
    end
    return false
end

-- Get active locale
function AzerothVoiced_GetLocale()
    return activeLocale
end

-- Get supported locales
function AzerothVoiced_GetSupportedLocales()
    return supportedLocales
end

-- Initialize locale from saved data or game client
function AzerothVoiced_InitLocale()
    -- Check saved preference first
    if AzerothVoicedDB and AzerothVoicedDB.locale then
        if AzerothVoiced_UIStrings[AzerothVoicedDB.locale] then
            activeLocale = AzerothVoicedDB.locale
            return
        end
    end
    
    -- Fall back to game client locale
    local gameLocale = GetLocale()
    if AzerothVoiced_UIStrings[gameLocale] then
        activeLocale = gameLocale
    else
        activeLocale = "enUS"
    end
end

-- Shorthand global
L = AV_L
