# Locales Folder

This folder contains all localization/translation files for the addon.

## Files

### Quotes.lua
Contains the actual quote text organized by language and category.

**Supported Languages:**
- `enUS` - English (US) - Primary
- `ruRU` - Russian
- `deDE` - German
- `itIT` - Italian

**Quote Categories:**
| Key | Description |
|-----|-------------|
| `init` | Combat initiation quotes |
| `kill` | Killing blow quotes |
| `surv` | Survival/near-death quotes |
| `vict` | Victory/combat end quotes |
| `rare` | Rare random quotes |
| `mid` | Mid-combat quotes |
| `greet` | Greeting/login quotes |

### UIStrings.lua
Contains all user interface text translations.

Covers:
- Tab names
- Button labels
- Settings descriptions
- Error messages
- Help text

## Adding a New Language

1. In `Quotes.lua`, add a new locale section:
```lua
MageQuotesLocale["frFR"] = {
  sections = {
    { header = "Combat Initiation",
      quotes = {
        { text = "Your French quote here", sound = "combat_01" },
      }
    },
  },
  greetings = {
    { text = "French greeting" },
  }
}
```

2. In `UIStrings.lua`, add UI translations:
```lua
MageQuotes_UIStrings["frFR"] = {
  title = "Citations de Mage",
  settings = "Paramètres",
  -- ... all other strings
}
```

3. Add the locale code to supported locales list in `UIStrings.lua`

## Quote Format

Each quote can have:
```lua
{
  text = "Quote text shown in chat",  -- Required
  sound = "sound_file_name",           -- Optional, for voice
  soundKey = "alternate_key",          -- Optional, override sound lookup
  spec = "fire",                       -- Optional: "all", "arcane", "fire", "frost"
}
```

## Sound File Naming

Sound files should be placed in:
`Voices/<ActorName>/<Locale>/<soundKey>.ogg`

Example: `Voices/MageA/enUS/combat_01.ogg`
