# Azeroth Voiced

**Voice lines for all World of Warcraft classes**

A WoW addon that displays contextual "inner voice" quotes during combat and exploration, with optional voice acting support.

![WoW Version](https://img.shields.io/badge/WoW-Midnight%2012.0-blue)
![Version](https://img.shields.io/badge/version-2.0.0-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## Features

- 🎭 **Multi-Class Support** - Voice lines for all 13 WoW classes
- ⚔️ **Combat Quotes** - Automatic triggers for combat start, kills, survival, victory
- 🎤 **Voice Acting Ready** - Supports custom voice files (.ogg format)
- ✏️ **Custom Quote Editor** - Add your own quotes in-game
- 📦 **Quote Packs** - One-click installable quote collections
- 🌍 **Multi-Language** - English and Russian translations included
- 🐉 **Dracthyr Support** - Automatic voice switching between forms

## Installation

1. Download the latest release
2. Extract to `World of Warcraft\_retail_\Interface\AddOns\`
3. Ensure the folder is named `AzerothVoiced`
4. Restart WoW or type `/reload`

## Slash Commands

| Command | Description |
|---------|-------------|
| `/av` | Show main help |
| `/av status` | Display addon status |
| `/av test <category>` | Test a quote category |
| `/av debug` | Toggle debug mode |
| `/avc` | Custom quotes commands |
| `/avpacks` | Quote packs browser |
| `/avdragon` | Dracthyr voice switching |

## Quote Categories

| Category | Trigger |
|----------|---------|
| `init` | Combat starts |
| `kill` | Killing blow |
| `surv` | Low health (25%) |
| `vict` | Combat victory |
| `mid` | During long fights |
| `rare` | Random ambient |
| `greet` | Login greeting |
| `death` | Player dies |
| `interrupt` | Spell interrupt |
| `taunt` | Taunt ability used |

## File Structure

```
AzerothVoiced/
├── AzerothVoiced.toc      # Addon manifest
├── Core.lua               # Main engine
├── UI.lua                 # Settings interface
├── Art/
│   └── Icons.lua          # Icon paths
├── Libs/
│   └── Lib.lua            # Utility functions
├── Locales/
│   ├── Quotes.lua         # Quote database
│   └── UIStrings.lua      # UI translations
├── Modules/
│   ├── CustomQuotes.lua   # Custom quote editor
│   ├── Dracthyr.lua       # Dracthyr voice switching
│   ├── QuotePacks.lua     # Quote pack system
│   └── QuotePacksUI.lua   # Pack browser UI
└── Voices/                # Voice files (optional)
    └── VoiceA/
        └── enUS/
            └── *.ogg
```

## Adding Voice Files

1. Create folder: `AzerothVoiced/Voices/VoiceA/enUS/`
2. Add `.ogg` files named to match quote sound keys
3. Select voice actor in settings

## API Reference

```lua
-- Trigger a quote manually
AzerothVoicedAPI.TriggerManualQuote("kill")

-- Check if addon is enabled
local enabled = AzerothVoicedAPI.IsEnabled()

-- Get last played quote
local quote = AzerothVoicedAPI.GetLastQuote()

-- Rebuild quote caches
AzerothVoicedAPI.RebuildCaches()
```

## Compatibility

- **WoW Version**: Midnight 12.0.0+
- **Midnight API**: Fully compatible with new restrictions
- **Inner Whisper**: All quotes display locally (SendChatMessage restricted)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - See LICENSE file for details

## Credits

- **Author**: Vaelan
- **Quote Packs**: Azeroth Voiced Team
- **Translations**: Community contributors
