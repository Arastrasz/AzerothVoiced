-- AzerothVoiced/Art/Icons.lua
-- Icon path definitions for all classes and UI elements
-- v2.0.0

AzerothVoicedIcons = {
    ------------------------------------------------------------
    -- Main Addon Icons
    ------------------------------------------------------------
    main = "Interface\\AddOns\\AzerothVoiced\\Art\\Icons\\icon.tga",
    fallback = "Interface\\Icons\\INV_Misc_Book_09",
    
    ------------------------------------------------------------
    -- Class Icons (Official Blizzard Icons)
    ------------------------------------------------------------
    classes = {
        WARRIOR = "Interface\\Icons\\ClassIcon_Warrior",
        PALADIN = "Interface\\Icons\\ClassIcon_Paladin",
        HUNTER = "Interface\\Icons\\ClassIcon_Hunter",
        ROGUE = "Interface\\Icons\\ClassIcon_Rogue",
        PRIEST = "Interface\\Icons\\ClassIcon_Priest",
        DEATHKNIGHT = "Interface\\Icons\\ClassIcon_DeathKnight",
        SHAMAN = "Interface\\Icons\\ClassIcon_Shaman",
        MAGE = "Interface\\Icons\\ClassIcon_Mage",
        WARLOCK = "Interface\\Icons\\ClassIcon_Warlock",
        MONK = "Interface\\Icons\\ClassIcon_Monk",
        DRUID = "Interface\\Icons\\ClassIcon_Druid",
        DEMONHUNTER = "Interface\\Icons\\ClassIcon_DemonHunter",
        EVOKER = "Interface\\Icons\\ClassIcon_Evoker",
    },
    
    ------------------------------------------------------------
    -- Spec Icons by Class
    ------------------------------------------------------------
    specs = {
        -- Warrior
        WARRIOR = {
            [1] = "Interface\\Icons\\Ability_Warrior_Savageblow",      -- Arms
            [2] = "Interface\\Icons\\Ability_Warrior_InnerRage",       -- Fury
            [3] = "Interface\\Icons\\Ability_Warrior_DefensiveStance", -- Protection
        },
        -- Paladin
        PALADIN = {
            [1] = "Interface\\Icons\\Spell_Holy_HolyBolt",             -- Holy
            [2] = "Interface\\Icons\\Spell_Holy_AuraOfLight",          -- Protection
            [3] = "Interface\\Icons\\Spell_Holy_AvengeWrath",          -- Retribution
        },
        -- Hunter
        HUNTER = {
            [1] = "Interface\\Icons\\Ability_Hunter_BeastTaming",      -- Beast Mastery
            [2] = "Interface\\Icons\\Ability_Hunter_FocusedAim",       -- Marksmanship
            [3] = "Interface\\Icons\\Ability_Hunter_Camouflage",       -- Survival
        },
        -- Rogue
        ROGUE = {
            [1] = "Interface\\Icons\\Ability_Rogue_Eviscerate",        -- Assassination
            [2] = "Interface\\Icons\\Ability_BackStab",                -- Outlaw
            [3] = "Interface\\Icons\\Ability_Stealth",                 -- Subtlety
        },
        -- Priest
        PRIEST = {
            [1] = "Interface\\Icons\\Spell_Holy_PowerWordShield",      -- Discipline
            [2] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",       -- Holy
            [3] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",     -- Shadow
        },
        -- Death Knight
        DEATHKNIGHT = {
            [1] = "Interface\\Icons\\Spell_Deathknight_BloodPresence", -- Blood
            [2] = "Interface\\Icons\\Spell_Deathknight_FrostPresence", -- Frost
            [3] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",-- Unholy
        },
        -- Shaman
        SHAMAN = {
            [1] = "Interface\\Icons\\Spell_Nature_Lightning",          -- Elemental
            [2] = "Interface\\Icons\\Spell_Shaman_ImprovedStormstrike",-- Enhancement
            [3] = "Interface\\Icons\\Spell_Nature_MagicImmunity",      -- Restoration
        },
        -- Mage
        MAGE = {
            [1] = "Interface\\Icons\\Spell_Holy_MagicalSentry",        -- Arcane
            [2] = "Interface\\Icons\\Spell_Fire_FireBolt02",           -- Fire
            [3] = "Interface\\Icons\\Spell_Frost_FrostBolt02",         -- Frost
        },
        -- Warlock
        WARLOCK = {
            [1] = "Interface\\Icons\\Spell_Shadow_DeathCoil",          -- Affliction
            [2] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",      -- Demonology
            [3] = "Interface\\Icons\\Spell_Shadow_RainOfFire",         -- Destruction
        },
        -- Monk
        MONK = {
            [1] = "Interface\\Icons\\Spell_Monk_BrewMaster_Spec",      -- Brewmaster
            [2] = "Interface\\Icons\\Spell_Monk_MistWeaver_Spec",      -- Mistweaver
            [3] = "Interface\\Icons\\Spell_Monk_WindWalker_Spec",      -- Windwalker
        },
        -- Druid
        DRUID = {
            [1] = "Interface\\Icons\\Spell_Nature_StarFall",           -- Balance
            [2] = "Interface\\Icons\\Ability_Druid_CatForm",           -- Feral
            [3] = "Interface\\Icons\\Ability_Racial_BearForm",         -- Guardian
            [4] = "Interface\\Icons\\Spell_Nature_HealingTouch",       -- Restoration
        },
        -- Demon Hunter
        DEMONHUNTER = {
            [1] = "Interface\\Icons\\Ability_DemonHunter_SpecDPS",     -- Havoc
            [2] = "Interface\\Icons\\Ability_DemonHunter_SpecTank",    -- Vengeance
        },
        -- Evoker
        EVOKER = {
            [1] = "Interface\\Icons\\ClassIcon_Evoker_Devastation",    -- Devastation
            [2] = "Interface\\Icons\\ClassIcon_Evoker_Preservation",   -- Preservation
            [3] = "Interface\\Icons\\ClassIcon_Evoker_Augmentation",   -- Augmentation
        },
    },
    
    ------------------------------------------------------------
    -- Quote Category Icons
    ------------------------------------------------------------
    categories = {
        init = "Interface\\Icons\\Ability_Warrior_Charge",             -- Combat initiation
        kill = "Interface\\Icons\\Ability_Rogue_MurderSpree",          -- Killing blow
        surv = "Interface\\Icons\\Spell_Shadow_SoulLeech_3",           -- Survival/near death
        vict = "Interface\\Icons\\Achievement_Boss_Illidan",           -- Victory
        rare = "Interface\\Icons\\INV_Misc_Gift_02",                   -- Rare random
        mid = "Interface\\Icons\\Ability_DualWield",                   -- Mid-combat
        greet = "Interface\\Icons\\Spell_Holy_Dizzy",                  -- Greeting/login
        spell = "Interface\\Icons\\Spell_Arcane_Arcane01",             -- Spell cast
        interrupt = "Interface\\Icons\\Ability_Kick",                  -- Interrupt
        death = "Interface\\Icons\\Ability_Rogue_FeignDeath",          -- On death
        crit = "Interface\\Icons\\Ability_Warrior_Rampage",            -- Critical strike
        taunt = "Interface\\Icons\\Ability_Bullrush",                  -- Taunting
        heal = "Interface\\Icons\\Spell_Holy_FlashHeal",               -- Healing
        buff = "Interface\\Icons\\Spell_Holy_PowerInfusion",           -- Buffing
        mount = "Interface\\Icons\\Ability_Mount_Ridinghorse",         -- Mounting
        pvp = "Interface\\Icons\\Achievement_PVP_A_A",                 -- PvP kills
    },
    
    ------------------------------------------------------------
    -- UI Icons
    ------------------------------------------------------------
    ui = {
        settings = "Interface\\Icons\\INV_Misc_Gear_01",
        sound = "Interface\\Icons\\INV_Misc_Drum_02",
        quotes = "Interface\\Icons\\INV_Misc_Book_09",
        debug = "Interface\\Icons\\INV_Misc_EngGizmos_20",
        custom = "Interface\\Icons\\INV_Inscription_TradeskillScroll01",
        modules = "Interface\\Icons\\INV_Gizmo_GoblingTonkController",
        help = "Interface\\Icons\\INV_Misc_QuestionMark",
        check = "Interface\\Icons\\Spell_ChargePositive",
        cross = "Interface\\Icons\\Spell_ChargeNegative",
        play = "Interface\\Icons\\INV_Misc_Drum_05",
        stop = "Interface\\Icons\\Ability_Creature_Cursed_04",
    },
}

-- Helper function to get icon
function AzerothVoicedIcons.Get(category, key)
    if not category then return AzerothVoicedIcons.fallback end
    
    local cat = AzerothVoicedIcons[category]
    if not cat then return AzerothVoicedIcons.fallback end
    
    if key then
        return cat[key] or AzerothVoicedIcons.fallback
    else
        return cat
    end
end

-- Get class icon
function AzerothVoicedIcons.GetClassIcon(class)
    return AzerothVoicedIcons.classes[class] or AzerothVoicedIcons.fallback
end

-- Get spec icon
function AzerothVoicedIcons.GetSpecIcon(class, specIndex)
    local classSpecs = AzerothVoicedIcons.specs[class]
    if classSpecs and classSpecs[specIndex] then
        return classSpecs[specIndex]
    end
    return AzerothVoicedIcons.GetClassIcon(class)
end

-- Get category icon
function AzerothVoicedIcons.GetCategoryIcon(category)
    return AzerothVoicedIcons.categories[category] or AzerothVoicedIcons.fallback
end
