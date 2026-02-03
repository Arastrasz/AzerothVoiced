# Locales Folder - Quote System

This folder contains all localization files for Azeroth Voiced.

## File Structure

```
Locales/
├── UIStrings.lua         # Interface text translations
├── Quotes_Common.lua     # Quote registration system
└── Quotes_*.lua          # Class-specific quotes (13 files)
```

## Class Quote Files

| File | Class |
|------|-------|
| `Quotes_Mage.lua` | Mage |
| `Quotes_Warrior.lua` | Warrior |
| `Quotes_Paladin.lua` | Paladin |
| `Quotes_Hunter.lua` | Hunter |
| `Quotes_Rogue.lua` | Rogue |
| `Quotes_Priest.lua` | Priest |
| `Quotes_DeathKnight.lua` | Death Knight |
| `Quotes_Shaman.lua` | Shaman |
| `Quotes_Warlock.lua` | Warlock |
| `Quotes_Monk.lua` | Monk |
| `Quotes_Druid.lua` | Druid |
| `Quotes_DemonHunter.lua` | Demon Hunter |
| `Quotes_Evoker.lua` | Evoker |

## Quote Categories

| Category | When it triggers |
|----------|------------------|
| `init` | Combat start |
| `kill` | Killing blow on enemy |
| `surv` | Health drops below 25% |
| `vict` | Victory (combat ends after 3+ seconds) |
| `mid` | Random during long fights |
| `greet` | Addon loaded/login |
| `rare` | Random ambient (every 3-8 minutes) |
| `spell` | Spell cast (disabled by default) |
| `interrupt` | Successfully interrupted a spell |
| `death` | Player dies |
| `crit` | Critical hit (disabled by default) |
| `taunt` | Taunt ability used (tanks) |
| `heal` | Large heal cast (disabled by default) |
| `pvp` | PvP player kill |

## Adding Your Own Quotes

### Basic Quote

```lua
AzerothVoiced_RegisterQuotes("MAGE", "enUS", {
    init = {
        { text = "Your quote text here!" },
    },
})
```

### Specialization-Specific Quote

Use `spec = N` where N matches the spec index:

```lua
{ text = "Arcane only!", spec = 1 },  -- Arcane Mage
{ text = "Fire only!", spec = 2 },     -- Fire Mage
{ text = "Frost only!", spec = 3 },    -- Frost Mage
```

### With Sound File Reference

```lua
{ text = "Quote with voice!", sound = "init_custom" },
```

The sound file should be at: `Voices/default/enUS/init_custom.ogg`

## Specialization Indices

### Warrior
1. Arms, 2. Fury, 3. Protection

### Paladin
1. Holy, 2. Protection, 3. Retribution

### Hunter
1. Beast Mastery, 2. Marksmanship, 3. Survival

### Rogue
1. Assassination, 2. Outlaw, 3. Subtlety

### Priest
1. Discipline, 2. Holy, 3. Shadow

### Death Knight
1. Blood, 2. Frost, 3. Unholy

### Shaman
1. Elemental, 2. Enhancement, 3. Restoration

### Mage
1. Arcane, 2. Fire, 3. Frost

### Warlock
1. Affliction, 2. Demonology, 3. Destruction

### Monk
1. Brewmaster, 2. Mistweaver, 3. Windwalker

### Druid
1. Balance, 2. Feral, 3. Guardian, 4. Restoration

### Demon Hunter
1. Havoc, 2. Vengeance

### Evoker
1. Devastation, 2. Preservation, 3. Augmentation

## Adding a New Language

1. Create quotes in a new locale (e.g., "deDE" for German):

```lua
AzerothVoiced_RegisterQuotes("MAGE", "deDE", {
    init = {
        { text = "German quote!" },
    },
    -- Add all categories...
})
```

2. Add UI strings in `UIStrings.lua`:

```lua
L["deDE"] = {
    LOADED = "geladen",
    -- Add all UI strings...
}
```

## Best Practices

1. **Keep quotes short** - They display in chat, so brevity helps
2. **Match class fantasy** - Warriors shouldn't say "Feel my magic!"
3. **Use spec tags** - Makes quotes more immersive
4. **Avoid spam categories** - `spell`, `crit`, `heal` are off by default for a reason
5. **Test in-game** - Use `/av test init` to preview quotes

## Quote Format Reference

```lua
{
    text = "Required: The quote text",
    spec = 2,           -- Optional: Spec restriction (1-4)
    sound = "filename", -- Optional: Voice file (no extension)
    chance = 0.5,       -- Optional: Trigger probability (0-1)
}
```
