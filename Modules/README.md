# Modules Folder

This folder contains optional feature modules that extend the core addon functionality.

## Files

### CustomQuotes.lua
**Custom Quote Editor & Import/Export System**

Features:
- Add custom quotes in-game via UI or slash commands
- Assign quotes to any category (init, kill, surv, vict, rare, mid, greet)
- Optional sound file linking
- Spec-specific quote filtering
- Export quotes as shareable strings
- Import friend's quote packs
- Toggle quotes on/off individually

Slash Commands:
- `/avc help` - Show all commands
- `/avc add <category> <text>` - Add a quote
- `/avc list` - List all custom quotes
- `/avc export` - Export all quotes
- `/avc import <string>` - Import from string

### Dracthyr.lua
**Visage ↔ Dragon Voice Switching**

Automatically switches between two voice actors based on Dracthyr form:
- **VoiceA**: Used when in Visage (humanoid) form
- **VoiceB**: Used when in Dragon (true) form

Features:
- Auto-detects form changes via aura monitoring
- Midnight 12.0.0 compatible API usage
- Integrates with Core's event bus
- Manual refresh available

Slash Commands:
- `/avdragon status` - Show current form/voice
- `/avdragon refresh` - Force voice update
- `/avdragon test` - Test voice switching

### QuotePacks.lua
**Curated Quote Collections**

Pre-made quote packs that can be installed with one click:
- Classic fantasy quotes
- Spec-specific quotes (Arcane, Fire, Frost, etc.)
- PvP battle cries
- RP immersion packs
- Russian language packs

Features:
- Browse available packs
- One-click install/uninstall
- Non-destructive (won't affect your custom quotes)
- Can be safely removed without breaking the addon

Slash Commands:
- `/avpacks list` - Show available packs
- `/avpacks install <id>` - Install a pack
- `/avpacks uninstall <id>` - Remove a pack
- `/avpacks info <id>` - Show pack details

### QuotePacksUI.lua
**Quote Packs Browser Interface**

Visual browser for exploring and managing quote packs:
- Grid view of all available packs
- Filter by category (All, Installed, Available)
- Preview quotes before installing
- Install/uninstall buttons
- Quote count and author info

Access via:
- `/avpacks` command
- "Browse Packs" button in the Custom tab

## Creating New Modules

1. Create a new `.lua` file in this folder
2. Add it to `AzerothVoiced.toc` in the Modules section
3. Use `AzerothVoiced_EventBus` for inter-module communication
4. Register a public API table for external access

Example template:
```lua
-- MyModule.lua
local MODULE_VERSION = "1.0.0"
local MODULE_NAME = "AzerothVoiced_MyModule"

-- Your module code here

-- Public API
AzerothVoiced_MyModuleAPI = {
  VERSION = MODULE_VERSION,
  -- Your functions here
}
```

## Event Bus Events

Modules can listen for these events via `AzerothVoiced_EventBus`:

| Event | Description |
|-------|-------------|
| `AZEROTH_VOICED_QUOTE_PLAYED` | Fired when any quote is displayed |
| `AZEROTH_VOICED_CUSTOM_UPDATED` | Fired when custom quotes change |
| `AZEROTH_VOICED_LOCALE_CHANGED` | Fired when language is changed |
| `AZEROTH_VOICED_PACKS_UPDATED` | Fired when packs are installed/removed |
