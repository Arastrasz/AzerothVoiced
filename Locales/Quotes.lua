AzerothVoicedLocale = AzerothVoicedLocale or {}

----------------------------------------------------------------
-- English (US) - ENHANCED REALISTIC QUOTES
----------------------------------------------------------------
AzerothVoicedLocale["enUS"] = {
  ui = {
    title = "Azeroth Voiced",
    enable = "Enable Azeroth Voiced",
    categories        = "Categories",
    enabledLabel      = "Enabled",
    cooldownLabelCat  = "Cooldown (s)",
    chanceLabelCat    = "Chance %",
    apply             = "Apply",
    cooldownLabel = "Quote Cooldown",
    rarityLabel = "Quote Chance",
    channelLabel = "Message Channel",
    availableHeader = "Available Quotes:",
    voiceActor = "Voice Actor",
    voiceActorHint = "Folder in Voices/<Actor>",
  },

  ----------------------------------------------------------
  -- Greetings - Brief acknowledgments
  ----------------------------------------------------------
  greetings = {
    { text = "Mana flows steady.", file = "Greeting_ManaFlows" },
    { text = "The ley lines are clear.", file = "Greeting_LeyLines" },
    { text = "Arcane reserves full.", file = "Greeting_ArcaneReserves", spec="arcane" },
    { text = "Fire waits for no one.", file = "Greeting_FireWaits", spec="fire" },
    { text = "Ice answers the call.", file = "Greeting_IceAnswers", spec="frost" },
    { text = "Another day, another spell.", file = "Greeting_AnotherDay" },
  },

  sections = {

    ----------------------------------------------------------
    -- Combat Initiation - Opening strikes
    ----------------------------------------------------------
    {
      header = "Combat Initiation",
      quotes = {
        { text = "Light them up!", file = "Init_LightThemUp", spec="fire" },
        { text = "Freeze!", file = "Init_Freeze", spec="frost" },
        { text = "Missiles away!", file = "Init_MissilesAway", spec="arcane" },
        { text = "Let's end this quickly.", file = "Init_EndQuickly" },
        { text = "Time to burn.", file = "Init_TimeToBurn", spec="fire" },
        { text = "Shatter them!", file = "Init_ShatterThem", spec="frost" },
        { text = "Charging up!", file = "Init_ChargingUp", spec="arcane" },
        { text = "Here we go!", file = "Init_HereWeGo" },
        { text = "Ignition!", file = "Init_Ignition", spec="fire" },
        { text = "Glacial advance!", file = "Init_GlacialAdvance", spec="frost" },
        { text = "Arcane barrage ready!", file = "Init_BarrageReady", spec="arcane" },
      },
    },

    ----------------------------------------------------------
    -- Killing Blows - Finishing enemies
    ----------------------------------------------------------
    {
      header = "Killing Blows",
      quotes = {
        { text = "Ashes to ashes.", file = "Kill_AshesToAshes", spec="fire" },
        { text = "Frozen solid.", file = "Kill_FrozenSolid", spec="frost" },
        { text = "Disintegrated.", file = "Kill_Disintegrated", spec="arcane" },
        { text = "Down you go.", file = "Kill_DownYouGo" },
        { text = "Burned to cinders.", file = "Kill_BurnedToCinders", spec="fire" },
        { text = "Ice cold finish.", file = "Kill_IceColdFinish", spec="frost" },
        { text = "Obliterated!", file = "Kill_Obliterated", spec="arcane" },
        { text = "That's done.", file = "Kill_ThatsDone" },
        { text = "Scorched.", file = "Kill_Scorched", spec="fire" },
        { text = "Shattered!", file = "Kill_Shattered", spec="frost" },
        { text = "Target eliminated.", file = "Kill_TargetEliminated" },
        { text = "Another one bites the dust.", file = "Kill_AnotherOne" },
      },
    },

    ----------------------------------------------------------
    -- Survival - Defensive reactions
    ----------------------------------------------------------
    {
      header = "Survival",
      quotes = {
        { text = "Block up!", file = "Surv_BlockUp", spec="frost" },
        { text = "Barrier!", file = "Surv_Barrier" },
        { text = "Not today!", file = "Surv_NotToday" },
        { text = "Shields holding!", file = "Surv_ShieldsHolding" },
        { text = "Blink out!", file = "Surv_BlinkOut" },
        { text = "Ice Block!", file = "Surv_IceBlock", spec="frost" },
        { text = "Blazing Barrier!", file = "Surv_BlazingBarrier", spec="fire" },
        { text = "Prismatic defense!", file = "Surv_PrismaticDefense", spec="arcane" },
        { text = "Mirror Image!", file = "Surv_MirrorImage" },
        { text = "That was close!", file = "Surv_ThatWasClose" },
        { text = "Invisibility!", file = "Surv_Invisibility" },
        { text = "Get off me!", file = "Surv_GetOffMe" },
      },
    },

    ----------------------------------------------------------
    -- Mid-Combat - Active battle commentary
    ----------------------------------------------------------
    {
      header = "Mid-Combat",
      quotes = {
        { text = "Counterspell!", file = "Mid_Counterspell" },
        { text = "Silenced!", file = "Mid_Silenced" },
        { text = "Got you!", file = "Mid_GotYou" },
        { text = "Keep the pressure on!", file = "Mid_KeepPressure" },
        { text = "Combustion!", file = "Mid_Combustion", spec="fire" },
        { text = "Icy Veins!", file = "Mid_IcyVeins", spec="frost" },
        { text = "Arcane Power!", file = "Mid_ArcanePower", spec="arcane" },
        { text = "Pyroblast incoming!", file = "Mid_Pyroblast", spec="fire" },
        { text = "Frozen Orb!", file = "Mid_FrozenOrb", spec="frost" },
        { text = "Evocation!", file = "Mid_Evocation", spec="arcane" },
        { text = "Watch this!", file = "Mid_WatchThis" },
        { text = "Time Warp!", file = "Mid_TimeWarp" },
        { text = "Polymorph!", file = "Mid_Polymorph" },
        { text = "Dragon's Breath!", file = "Mid_DragonsBreath", spec="fire" },
        { text = "Ring of Frost!", file = "Mid_RingOfFrost", spec="frost" },
        { text = "Shifting Power!", file = "Mid_ShiftingPower" },
        { text = "Slow them down!", file = "Mid_SlowDown" },
        { text = "Focus fire!", file = "Mid_FocusFire" },
        { text = "Kiting!", file = "Mid_Kiting" },
        { text = "Casting sequence!", file = "Mid_CastingSequence" },
      },
    },

    ----------------------------------------------------------
    -- Victory - Battle end
    ----------------------------------------------------------
    {
      header = "Victory",
      quotes = {
        { text = "Well fought.", file = "Vict_WellFought" },
        { text = "Victory is ours.", file = "Vict_VictoryOurs" },
        { text = "That'll do.", file = "Vict_ThatllDo" },
        { text = "Easy enough.", file = "Vict_EasyEnough" },
        { text = "Flawless execution.", file = "Vict_FlawlessExecution" },
        { text = "Time for a drink.", file = "Vict_TimeForDrink" },
        { text = "Could've been worse.", file = "Vict_CouldBeWorse" },
        { text = "Another day, another victory.", file = "Vict_AnotherVictory" },
        { text = "The fire has spoken.", file = "Vict_FireSpoken", spec="fire" },
        { text = "Frozen battlefield.", file = "Vict_FrozenBattlefield", spec="frost" },
        { text = "Arcane supremacy.", file = "Vict_ArcaneSupremacy", spec="arcane" },
        { text = "On to the next.", file = "Vict_OnToNext" },
      },
    },

    ----------------------------------------------------------
    -- Rare - Special moments
    ----------------------------------------------------------
    {
      header = "Rare",
      quotes = {
        { text = "Power like this comes with a price.", file = "Rare_PowerPrice" },
        { text = "The arcane is endless, but I am not.", file = "Rare_ArcaneEndless", spec="arcane" },
        { text = "Fire consumes all, even its master.", file = "Rare_FireConsumes", spec="fire" },
        { text = "Ice preserves, ice endures.", file = "Rare_IceEndures", spec="frost" },
        { text = "Magic is a tool, not a toy.", file = "Rare_ToolNotToy" },
        { text = "Every spell is a calculated risk.", file = "Rare_CalculatedRisk" },
        { text = "The ley lines whisper secrets.", file = "Rare_LeyWhispers" },
        { text = "Dalaran taught me well.", file = "Rare_DalaranTaught" },
        { text = "Khadgar would be proud.", file = "Rare_KhadgarProud" },
        { text = "This is what years of study looks like.", file = "Rare_YearsOfStudy" },
      },
    },
  },
}

----------------------------------------------------------------
-- Russian (RU) - ENHANCED REALISTIC QUOTES
----------------------------------------------------------------
AzerothVoicedLocale["ruRU"] = {
  ui = {
    title = "Цитаты мага",
    enable = "Включить цитаты мага",
    categories        = "Категории",
    enabledLabel      = "Вкл",
    cooldownLabelCat  = "Перезарядка (с)",
    chanceLabelCat    = "Шанс %",
    apply             = "Применить",
    cooldownLabel = "Перезарядка реплики",
    rarityLabel = "Шанс реплики",
    channelLabel = "Канал сообщений",
    availableHeader = "Доступные цитаты мага:",
    voiceActor = "Актёр озвучки",
    voiceActorHint = "Папка в Voices/<Actor>",
  },

  greetings = {
    { text = "Мана на месте.", file = "Greeting_ManaReady_ru" },
    { text = "Всё готово к бою.", file = "Greeting_ReadyForBattle_ru" },
    { text = "Магия в воздухе.", file = "Greeting_MagicInAir_ru" },
  },

  sections = {
    { header = "Начало боя", quotes = {
        { text = "Поджигаем!", file = "Init_Ignite_ru", spec="fire" },
        { text = "Заморозить!", file = "Init_Freeze_ru", spec="frost" },
        { text = "Ракеты пошли!", file = "Init_Missiles_ru", spec="arcane" },
        { text = "Быстро покончим с этим!", file = "Init_QuickFinish_ru" },
        { text = "Время гореть!", file = "Init_TimeToBurn_ru", spec="fire" },
        { text = "Разорвать их!", file = "Init_ShatterThem_ru", spec="frost" },
        { text = "Заряжаюсь!", file = "Init_ChargingUp_ru", spec="arcane" },
        { text = "Начинаем!", file = "Init_Start_ru" },
    }},
    
    { header = "Смертельный удар", quotes = {
        { text = "Прах к праху.", file = "Kill_AshesToAshes_ru", spec="fire" },
        { text = "Заморожен намертво.", file = "Kill_FrozenSolid_ru", spec="frost" },
        { text = "Дезинтегрирован!", file = "Kill_Disintegrated_ru", spec="arcane" },
        { text = "Падай!", file = "Kill_Down_ru" },
        { text = "Сгорел дотла.", file = "Kill_BurnedDown_ru", spec="fire" },
        { text = "Ледяной финиш.", file = "Kill_IceFinish_ru", spec="frost" },
        { text = "Уничтожен!", file = "Kill_Obliterated_ru", spec="arcane" },
        { text = "Готово.", file = "Kill_Done_ru" },
        { text = "Разбит вдребезги!", file = "Kill_Shattered_ru", spec="frost" },
        { text = "Цель устранена.", file = "Kill_TargetDown_ru" },
    }},
    
    { header = "Выживание", quotes = {
        { text = "Призматическая защита!", file = "Surv_WardHolds_ru", spec="arcane" }
    }},

    { header = "В бою", quotes = {
        { text = "Контрзаклинание!", file = "Mid_Counterspell_ru" },
        { text = "Заглушен!", file = "Mid_Silenced_ru" },
        { text = "Попался!", file = "Mid_GotYou_ru" },
        { text = "Давим дальше!", file = "Mid_KeepPressure_ru" },
        { text = "Возгорание!", file = "Mid_Combustion_ru", spec="fire" },
        { text = "Ледяные жилы!", file = "Mid_IcyVeins_ru", spec="frost" },
        { text = "Мощь тайной магии!", file = "Mid_ArcanePower_ru", spec="arcane" },
        { text = "Огненный шар летит!", file = "Mid_Pyroblast_ru", spec="fire" },
        { text = "Ледяная сфера!", file = "Mid_FrozenOrb_ru", spec="frost" },
        { text = "Восстановление!", file = "Mid_Evocation_ru", spec="arcane" },
        { text = "Смотрите!", file = "Mid_Watch_ru" },
        { text = "Искажение времени!", file = "Mid_TimeWarp_ru" },
        { text = "Превращение!", file = "Mid_Polymorph_ru" },
        { text = "Дыхание дракона!", file = "Mid_DragonsBreath_ru", spec="fire" },
        { text = "Кольцо льда!", file = "Mid_RingOfFrost_ru", spec="frost" },
        { text = "Замедлить их!", file = "Mid_Slow_ru" },
        { text = "Сосредоточенный огонь!", file = "Mid_FocusFire_ru" },
    }},

    { header = "Победа", quotes = {
        { text = "Отлично сражались.", file = "Vict_WellFought_ru" },
        { text = "Победа за нами.", file = "Vict_Victory_ru" },
        { text = "Справились.", file = "Vict_Done_ru" },
        { text = "Легко.", file = "Vict_Easy_ru" },
        { text = "Безупречно.", file = "Vict_Flawless_ru" },
        { text = "Время передохнуть.", file = "Vict_Rest_ru" },
        { text = "Могло быть хуже.", file = "Vict_CouldBeWorse_ru" },
        { text = "Огонь всё решил.", file = "Vict_FireSpoke_ru", spec="fire" },
        { text = "Замороженное поле боя.", file = "Vict_Frozen_ru", spec="frost" },
        { text = "Превосходство магии.", file = "Vict_Supremacy_ru", spec="arcane" },
    }},
    
    { header = "Редкое", quotes = {
        { text = "Такая сила требует жертв.", file = "Rare_PowerPrice_ru" },
        { text = "Магия бесконечна, но я нет.", file = "Rare_ArcaneEndless_ru", spec="arcane" },
        { text = "Огонь пожирает всех, даже хозяина.", file = "Rare_FireConsumes_ru", spec="fire" },
        { text = "Лёд сохраняет, лёд живёт.", file = "Rare_IceEndures_ru", spec="frost" },
        { text = "Магия — инструмент, не игрушка.", file = "Rare_ToolNotToy_ru" },
        { text = "Каждое заклинание — риск.", file = "Rare_Risk_ru" },
        { text = "Даларан научил меня многому.", file = "Rare_Dalaran_ru" },
        { text = "Кадгар гордился бы.", file = "Rare_Khadgar_ru" },
        { text = "Годы учёбы не прошли даром.", file = "Rare_Years_ru" },
    }},
  },
}