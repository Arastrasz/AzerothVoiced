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
- `/mqc help` - Show all commands
- `/mqc add <category> <text>` - Add a quote
- `/mqc list` - List all custom quotes
- `/mqc export` - Export all quotes
- `/mqc import <string>` - Import from string

### Dracthyr.lua
**Visage ↔ Dragon Voice Switching**

Automatically switches between two voice actors based on Dracthyr form:
- **MageA**: Used when in Visage (humanoid) form
- **MageB**: Used when in Dragon (true) form

Features:
- Auto-detects form changes via aura monitoring
- Midnight 12.0.0 compatible API usage
- Integrates with Core's event bus
- Manual refresh available

Slash Commands:
- `/mqdragon status` - Show current form/voice
- `/mqdragon refresh` - Force voice update
- `/mqdragon test` - Test voice switching

## Creating New Modules

1. Create a new `.lua` file in this folder
2. Add it to `MageQuotes.toc` in the Modules section
3. Use `MageQuotes_EventBus` for inter-module communication
4. Register a public API table for external access

Example template:
```lua
-- MyModule.lua
local MODULE_VERSION = "1.0.0"
local MODULE_NAME = "MageQuotes_MyModule"

-- Your module code here

-- Public API
MageQuotes_MyModuleAPI = {
  VERSION = MODULE_VERSION,
  -- Your functions here
}
```
