-- AzerothVoiced UIStrings.lua
-- UI Translation System v1.5.1
-- FIXED: Function names now match what Core.lua and UI.lua expect

AzerothVoiced_UIStrings = AzerothVoiced_UIStrings or {}

------------------------------------------------------------
-- English (US) - PRIMARY LANGUAGE
------------------------------------------------------------
AzerothVoiced_UIStrings["enUS"] = {
  -- Main UI
  title = "Azeroth Voiced",
  version = "Version",
  active = "ACTIVE",
  inactive = "INACTIVE",
  
  -- Tabs
  settings = "Settings",
  quotes = "Quotes",
  categories = "Categories",
  audio = "Audio",
  stats = "Statistics",
  modules = "Modules",
  debug = "Debug",
  custom = "Custom",
  triggers = "Triggers",
  libraries = "Libraries",
  
  -- Settings Tab
  masterControl = "Master Control",
  enableAddon = "Enable Azeroth Voiced",
  cooldowns = "Cooldowns",
  globalCooldown = "Global Cooldown (seconds):",
  messageChannel = "Message Channel",
  specFilter = "Specialization Filter",
  language = "Language / Язык / Sprache / Lingua",
  
  -- Spec options
  specAuto = "Auto (Player)",
  specAll = "All Specs",
  specArcane = "Arcane",
  specFire = "Fire",
  specFrost = "Frost",
  
  -- Categories Tab
  categorySettings = "Category Settings",
  enableCategory = "Enable",
  categoryCooldown = "Cooldown (s)",
  categoryChance = "Chance %",
  applySettings = "Apply Settings",
  resetDefaults = "Reset Defaults",
  categoryHelp = "Each category can be enabled/disabled with custom cooldowns and trigger chance.",
  
  -- Category Names
  catInit = "Combat Initiation",
  catKill = "Killing Blow",
  catSurv = "Survival",
  catVict = "Victory",
  catRare = "Rare/Random",
  catMid = "Mid-Combat",
  catGreet = "Greetings",
  catSpell = "Spell Cast",
  catInterrupt = "Interrupt",
  catDeath = "On Death",
  
  -- Audio Tab
  voiceSettings = "Voice Settings",
  enableVoice = "Enable Voice Lines",
  audioChannel = "Audio Channel",
  voiceActor = "Voice Actor Selection",
  currentVoice = "Current Voice:",
  nextActor = "Next Actor",
  testAudio = "Test Audio",
  testVoice = "Test Voice",
  soundChannel = "Sound Channel:",
  
  -- Stats Tab
  sessionStats = "Session Statistics",
  totalQuotes = "Total Quotes:",
  combatState = "Combat State:",
  inCombat = "In Combat",
  outOfCombat = "Out of Combat",
  killsThisCombat = "Kills This Combat:",
  lastQuote = "Last Quote:",
  noneYet = "None yet",
  refresh = "Refresh",
  quotesTriggered = "Quotes Triggered:",
  uptime = "Session Uptime:",
  
  -- Modules Tab
  addonModules = "Addon Modules",
  coreModules = "Core Modules",
  optionalModules = "Optional Modules",
  moduleStatus = "Module Status",
  moduleName = "Module Name",
  moduleDescription = "Description",
  moduleEnabled = "Enabled",
  moduleDisabled = "Disabled",
  moduleNotInstalled = "Not Installed",
  
  -- Module Names
  moduleCore = "Core System",
  moduleDracthyr = "Dracthyr Voice Switching",
  moduleAPI = "Public API",
  moduleEventBus = "Event Bus",
  moduleCustomQuotes = "Custom Quotes",
  moduleTriggers = "Spell Triggers",
  moduleLibraries = "Quote Libraries",
  
  -- Module Descriptions
  coreDesc = "Main quote engine and combat detection",
  dracthyrDesc = "Auto-switch voice between Visage and Dragon form",
  apiDesc = "Developer API for external addons",
  eventBusDesc = "Internal event system for module communication",
  customQuotesDesc = "Create and manage your own quotes",
  triggersDesc = "Trigger quotes on specific spells",
  librariesDesc = "Organize quotes into collections",
  
  -- Debug Tab
  enableDebugMode = "Enable Debug Mode",
  clearLog = "Clear Log",
  debugNotAvailable = "Debug API not available",
  noDebugEntries = "No debug entries yet.\n\nEnable debug mode and perform actions to see logs.",
  debugConsole = "Debug Console",
  triggerDebug = "Trigger Debug",
  triggerDebugDesc = "Show why quotes were or weren't triggered",
  
  -- Custom Quotes Tab
  addNewQuote = "Add New Quote",
  quoteText = "Quote Text:",
  category = "Category:",
  soundFile = "Sound File:",
  addQuote = "Add Quote",
  customQuotes = "Custom Quotes",
  standardQuotes = "Standard Quotes",
  allQuotes = "All Quotes",
  filterBy = "Filter By:",
  
  -- Import/Export
  importExport = "Import / Export",
  exportAll = "Export All",
  exportSelected = "Export Selected",
  import = "Import",
  clearAll = "Clear All",
  quoteAdded = "Quote added!",
  quotesImported = "Quotes imported!",
  exportSuccess = "Exported! Copy the string.",
  pasteImportString = "Paste import string and click Import",
  selectQuotesToExport = "Select quotes to export",
  importError = "Import failed",
  exportError = "Export failed",
  
  -- Libraries
  libraryName = "Library Name:",
  libraryAuthor = "Author:",
  libraryQuoteCount = "Quotes:",
  createLibrary = "Create Library",
  deleteLibrary = "Delete Library",
  viewLibrary = "View Library",
  assignToLibrary = "Assign to Library",
  removeFromLibrary = "Remove from Library",
  noLibraries = "No libraries created yet",
  libraryCreated = "Library created!",
  libraryDeleted = "Library deleted",
  libraryBrowser = "Library Browser",
  closeWindow = "Close",
  
  -- Triggers Tab
  spellTriggers = "Spell Triggers",
  addTrigger = "Add Trigger",
  removeTrigger = "Remove",
  spellId = "Spell ID:",
  spellName = "Spell Name:",
  triggerOn = "Trigger On:",
  triggerCastStart = "Cast Start",
  triggerCastSuccess = "Cast Success",
  triggerCooldownUsed = "Cooldown Used",
  selectSpell = "Select Spell",
  assignQuotes = "Assign Quotes",
  noTriggers = "No spell triggers configured",
  triggerAdded = "Trigger added!",
  triggerRemoved = "Trigger removed",
  enterSpellId = "Enter Spell ID or drag spell here",
  spellIcon = "Spell Icon",
  
  -- Situations
  situations = "Situations",
  sitCombatEnter = "Enter Combat",
  sitCombatLeave = "Leave Combat",
  sitPlayerKill = "Player Kill",
  sitPlayerDeath = "Player Death",
  sitLowHealth = "Low Health",
  sitInterrupt = "Successful Interrupt",
  sitSpellCast = "Specific Spell Cast",
  
  -- Quotes Tab Filter
  filterAllQuotes = "All Quotes",
  filterStandard = "Standard",
  filterCustom = "Custom Only",
  filterByCategory = "By Category",
  quotesCount = "quotes",
  noQuotesFound = "No quotes found",
  
  -- Action Bar
  quickTest = "Quick Test",
  reloadUI = "Reload UI",
  help = "Help",
  
  -- Messages
  cannotOpenInCombat = "Cannot open settings during combat",
  addonEnabled = "Azeroth Voiced Enabled",
  addonDisabled = "Azeroth Voiced Disabled",
  settingsApplied = "Settings applied successfully",
  playingTest = "Playing test quote...",
  voiceActorChanged = "Voice actor:",
  categoriesApplied = "Category settings applied",
  
  -- Channels
  channelSay = "SAY",
  channelYell = "YELL",
  channelParty = "PARTY",
  channelRaid = "RAID",
  channelWhisper = "INNER_WHISPER",
  innerWhisperOnly = "Inner Whisper Only (WoW Midnight restriction)",
  
  -- Search
  searchQuotes = "Search quotes...",
  noResults = "No quotes match your search",
  
  -- Misc
  enabled = "Enabled",
  disabled = "Disabled",
  save = "Save",
  cancel = "Cancel",
  close = "Close",
  confirm = "Confirm",
  yes = "Yes",
  no = "No",
  optional = "(optional)",
  loading = "Loading...",
  error = "Error",
  success = "Success",
}

------------------------------------------------------------
-- Russian (RU)
------------------------------------------------------------
AzerothVoiced_UIStrings["ruRU"] = {
  -- Main UI
  title = "Цитаты мага",
  version = "Версия",
  active = "АКТИВЕН",
  inactive = "НЕАКТИВЕН",
  
  -- Tabs
  settings = "Настройки",
  quotes = "Цитаты",
  categories = "Категории",
  audio = "Звук",
  stats = "Статистика",
  modules = "Модули",
  debug = "Отладка",
  custom = "Свои",
  triggers = "Триггеры",
  libraries = "Библиотеки",
  
  -- Settings Tab
  masterControl = "Главное управление",
  enableAddon = "Включить Цитаты мага",
  cooldowns = "Задержки",
  globalCooldown = "Глобальная задержка (секунд):",
  messageChannel = "Канал сообщений",
  specFilter = "Фильтр специализации",
  language = "Язык / Language / Sprache / Lingua",
  
  -- Spec options
  specAuto = "Авто (игрока)",
  specAll = "Все спеки",
  specArcane = "Тайная магия",
  specFire = "Огонь",
  specFrost = "Лёд",
  
  -- Categories Tab
  categorySettings = "Настройки категорий",
  enableCategory = "Вкл",
  categoryCooldown = "Задержка (с)",
  categoryChance = "Шанс %",
  applySettings = "Применить",
  resetDefaults = "Сбросить",
  categoryHelp = "Каждую категорию можно включить/выключить с настраиваемой задержкой и шансом срабатывания.",
  
  -- Category Names
  catInit = "Начало боя",
  catKill = "Добивание",
  catSurv = "Выживание",
  catVict = "Победа",
  catRare = "Редкие",
  catMid = "В бою",
  catGreet = "Приветствия",
  catSpell = "Заклинание",
  catInterrupt = "Прерывание",
  catDeath = "При смерти",
  
  -- Audio Tab
  voiceSettings = "Настройки голоса",
  enableVoice = "Включить озвучку",
  audioChannel = "Аудиоканал",
  voiceActor = "Выбор актёра озвучки",
  currentVoice = "Текущий голос:",
  nextActor = "Следующий",
  testAudio = "Тест звука",
  testVoice = "Тест голоса",
  soundChannel = "Звуковой канал:",
  
  -- Stats Tab
  sessionStats = "Статистика сессии",
  totalQuotes = "Всего цитат:",
  combatState = "Состояние боя:",
  inCombat = "В бою",
  outOfCombat = "Вне боя",
  killsThisCombat = "Убийств в бою:",
  lastQuote = "Последняя цитата:",
  noneYet = "Пока нет",
  refresh = "Обновить",
  quotesTriggered = "Сработавших цитат:",
  uptime = "Время работы:",
  
  -- Modules Tab
  addonModules = "Модули аддона",
  coreModules = "Основные модули",
  optionalModules = "Дополнительные модули",
  moduleStatus = "Статус модулей",
  moduleName = "Модуль",
  moduleDescription = "Описание",
  moduleEnabled = "Включён",
  moduleDisabled = "Выключен",
  moduleNotInstalled = "Не установлен",
  
  -- Module Names
  moduleCore = "Основная система",
  moduleDracthyr = "Переключение голоса драктиров",
  moduleAPI = "Публичный API",
  moduleEventBus = "Шина событий",
  moduleCustomQuotes = "Свои цитаты",
  moduleTriggers = "Триггеры заклинаний",
  moduleLibraries = "Библиотеки цитат",
  
  -- Module Descriptions
  coreDesc = "Основной движок цитат и обнаружение боя",
  dracthyrDesc = "Автопереключение голоса между обликами Визаж и Дракон",
  apiDesc = "API для разработчиков внешних аддонов",
  eventBusDesc = "Внутренняя система событий для связи модулей",
  customQuotesDesc = "Создание и управление своими цитатами",
  triggersDesc = "Триггер цитат на определённые заклинания",
  librariesDesc = "Организация цитат в коллекции",
  
  -- Debug Tab
  enableDebugMode = "Режим отладки",
  clearLog = "Очистить лог",
  debugNotAvailable = "API отладки недоступен",
  noDebugEntries = "Записей отладки пока нет.\n\nВключите режим отладки и выполните действия.",
  debugConsole = "Консоль отладки",
  triggerDebug = "Отладка триггеров",
  triggerDebugDesc = "Показывать почему цитата сработала или нет",
  
  -- Custom Quotes Tab
  addNewQuote = "Добавить цитату",
  quoteText = "Текст цитаты:",
  category = "Категория:",
  soundFile = "Звуковой файл:",
  addQuote = "Добавить",
  customQuotes = "Свои цитаты",
  standardQuotes = "Стандартные цитаты",
  allQuotes = "Все цитаты",
  filterBy = "Фильтр:",
  
  -- Import/Export
  importExport = "Импорт / Экспорт",
  exportAll = "Экспорт",
  exportSelected = "Экспорт выбранных",
  import = "Импорт",
  clearAll = "Очистить всё",
  quoteAdded = "Цитата добавлена!",
  quotesImported = "Цитаты импортированы!",
  exportSuccess = "Экспортировано! Скопируйте строку.",
  pasteImportString = "Вставьте строку импорта и нажмите Импорт",
  selectQuotesToExport = "Выберите цитаты для экспорта",
  importError = "Ошибка импорта",
  exportError = "Ошибка экспорта",
  
  -- Libraries
  libraryName = "Название библиотеки:",
  libraryAuthor = "Автор:",
  libraryQuoteCount = "Цитат:",
  createLibrary = "Создать библиотеку",
  deleteLibrary = "Удалить библиотеку",
  viewLibrary = "Просмотр библиотеки",
  assignToLibrary = "В библиотеку",
  removeFromLibrary = "Убрать из библиотеки",
  noLibraries = "Библиотеки не созданы",
  libraryCreated = "Библиотека создана!",
  libraryDeleted = "Библиотека удалена",
  libraryBrowser = "Обзор библиотеки",
  closeWindow = "Закрыть",
  
  -- Triggers Tab
  spellTriggers = "Триггеры заклинаний",
  addTrigger = "Добавить триггер",
  removeTrigger = "Удалить",
  spellId = "ID заклинания:",
  spellName = "Название:",
  triggerOn = "Срабатывает на:",
  triggerCastStart = "Начало каста",
  triggerCastSuccess = "Успешный каст",
  triggerCooldownUsed = "Использование КД",
  selectSpell = "Выбрать заклинание",
  assignQuotes = "Назначить цитаты",
  noTriggers = "Триггеры не настроены",
  triggerAdded = "Триггер добавлен!",
  triggerRemoved = "Триггер удалён",
  enterSpellId = "Введите ID заклинания или перетащите сюда",
  spellIcon = "Иконка заклинания",
  
  -- Situations
  situations = "Ситуации",
  sitCombatEnter = "Вход в бой",
  sitCombatLeave = "Выход из боя",
  sitPlayerKill = "Убийство игрока",
  sitPlayerDeath = "Смерть игрока",
  sitLowHealth = "Мало здоровья",
  sitInterrupt = "Успешное прерывание",
  sitSpellCast = "Определённое заклинание",
  
  -- Quotes Tab Filter
  filterAllQuotes = "Все цитаты",
  filterStandard = "Стандартные",
  filterCustom = "Только свои",
  filterByCategory = "По категории",
  quotesCount = "цитат",
  noQuotesFound = "Цитаты не найдены",
  
  -- Action Bar
  quickTest = "Быстрый тест",
  reloadUI = "Перезагрузить",
  help = "Помощь",
  
  -- Messages
  cannotOpenInCombat = "Нельзя открыть настройки в бою",
  addonEnabled = "Цитаты мага включены",
  addonDisabled = "Цитаты мага выключены",
  settingsApplied = "Настройки применены",
  playingTest = "Проигрывание тестовой цитаты...",
  voiceActorChanged = "Актёр озвучки:",
  categoriesApplied = "Настройки категорий применены",
  
  -- Channels
  channelSay = "СКАЗАТЬ",
  channelYell = "КРИКНУТЬ",
  channelParty = "ГРУППА",
  channelRaid = "РЕЙД",
  channelWhisper = "ВНУТР. ШЁПОТ",
  innerWhisperOnly = "Только внутренний шёпот (ограничение WoW Midnight)",
  
  -- Search
  searchQuotes = "Поиск цитат...",
  noResults = "Нет цитат, соответствующих запросу",
  
  -- Misc
  enabled = "Включено",
  disabled = "Выключено",
  save = "Сохранить",
  cancel = "Отмена",
  close = "Закрыть",
  confirm = "Подтвердить",
  yes = "Да",
  no = "Нет",
  optional = "(необязательно)",
  loading = "Загрузка...",
  error = "Ошибка",
  success = "Успех",
}

------------------------------------------------------------
-- German (DE) - Partial
------------------------------------------------------------
AzerothVoiced_UIStrings["deDE"] = {
  title = "Magier-Zitate",
  version = "Version",
  active = "AKTIV",
  inactive = "INAKTIV",
  
  settings = "Einstellungen",
  quotes = "Zitate",
  categories = "Kategorien",
  audio = "Audio",
  stats = "Statistik",
  modules = "Module",
  debug = "Debug",
  custom = "Eigene",
  triggers = "Auslöser",
  libraries = "Bibliotheken",
  
  masterControl = "Hauptsteuerung",
  enableAddon = "Magier-Zitate aktivieren",
  cooldowns = "Abklingzeiten",
  globalCooldown = "Globale Abklingzeit (Sekunden):",
  
  specAll = "Alle Specs",
  specArcane = "Arkan",
  specFire = "Feuer",
  specFrost = "Frost",
  
  quickTest = "Schnelltest",
  reloadUI = "UI neuladen",
  help = "Hilfe",
}

------------------------------------------------------------
-- Italian (IT) - Partial
------------------------------------------------------------
AzerothVoiced_UIStrings["itIT"] = {
  title = "Citazioni del Mago",
  version = "Versione",
  active = "ATTIVO",
  inactive = "INATTIVO",
  
  settings = "Impostazioni",
  quotes = "Citazioni",
  categories = "Categorie",
  audio = "Audio",
  stats = "Statistiche",
  modules = "Moduli",
  debug = "Debug",
  custom = "Personalizzate",
  triggers = "Trigger",
  libraries = "Librerie",
  
  masterControl = "Controllo principale",
  enableAddon = "Attiva Citazioni del Mago",
  cooldowns = "Tempi di ricarica",
  globalCooldown = "Ricarica globale (secondi):",
  
  specAll = "Tutte le Spec",
  specArcane = "Arcano",
  specFire = "Fuoco",
  specFrost = "Gelo",
  
  quickTest = "Test rapido",
  reloadUI = "Ricarica UI",
  help = "Aiuto",
}

------------------------------------------------------------
-- Locale State
------------------------------------------------------------
local activeLocale = "enUS"

-- Initialize locale from game or saved settings
local function InitLocale()
  -- First try saved locale
  if AzerothVoicedDB and AzerothVoicedDB.locale and AzerothVoiced_UIStrings[AzerothVoicedDB.locale] then
    activeLocale = AzerothVoicedDB.locale
    return
  end
  -- Fall back to game locale
  local gameLocale = GetLocale and GetLocale() or "enUS"
  if AzerothVoiced_UIStrings[gameLocale] then
    activeLocale = gameLocale
  else
    activeLocale = "enUS"
  end
end

-- Run initialization immediately AND after a delay to catch saved variables
InitLocale()
C_Timer.After(0.1, InitLocale)
C_Timer.After(1, InitLocale)

------------------------------------------------------------
-- API Functions (FIXED: Names match what Core.lua expects)
------------------------------------------------------------

-- Get a single translated string
function AzerothVoiced_GetUIString(key)
  -- Try active locale first
  local str = AzerothVoiced_UIStrings[activeLocale]
  if str and str[key] then
    return str[key]
  end
  -- Fallback to English
  local enStr = AzerothVoiced_UIStrings["enUS"]
  if enStr and enStr[key] then
    return enStr[key]
  end
  return key
end

-- Get all strings for current locale
function AzerothVoiced_GetUIStrings()
  return AzerothVoiced_UIStrings[activeLocale] or AzerothVoiced_UIStrings["enUS"],
         activeLocale,
         {"enUS", "ruRU", "deDE", "itIT"}
end

-- Set locale (FIXED: This is the function UI.lua calls!)
function AzerothVoiced_SetLocale(locale)
  if AzerothVoiced_UIStrings[locale] then
    activeLocale = locale
    -- Save to DB
    if AzerothVoicedDB then
      AzerothVoicedDB.locale = locale
    end
    -- Fire event for other modules
    if AzerothVoiced_EventBus and AzerothVoiced_EventBus.TriggerEvent then
      AzerothVoiced_EventBus:TriggerEvent("AZEROTH_VOICED_LOCALE_CHANGED", locale)
    end
    return true
  end
  return false
end

-- Alias for compatibility
AzerothVoiced_SetUILocale = AzerothVoiced_SetLocale

-- Get current locale
function AzerothVoiced_GetCurrentUILocale()
  return activeLocale
end

-- Check if locale is supported
function AzerothVoiced_IsSupportedLocale(locale)
  return AzerothVoiced_UIStrings[locale] ~= nil
end
