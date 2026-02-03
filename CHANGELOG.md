# Changelog

All notable changes to Azeroth Voiced will be documented in this file.

---

## [2.0.0] - 2026-02-03

### 🎉 Complete Rewrite - "AzerothVoiced"

Major overhaul from the original "MageQuotes" addon to support all classes.

### Added

- **All 13 Classes Supported**
  - Warrior, Mage, Rogue, Hunter, Paladin, Priest, Warlock
  - Shaman, Druid, Monk, Death Knight, Demon Hunter, Evoker
  
- **Specialization-Aware Quotes**
  - Quotes can now be spec-specific
  - Fire Mage quotes differ from Frost Mage, etc.
  
- **12 Quote Categories**
  - `init` - Combat initiation
  - `kill` - Enemy killed
  - `surv` - Low health survival
  - `vict` - Victory/combat end
  - `greet` - Login/greeting
  - `mid` - Mid-combat (long fights)
  - `rare` - Random out-of-combat
  - `taunt` - Tank taunt abilities
  - `death` - Player death
  - `crit` - Critical hits
  - `interrupt` - Spell interrupts
  - `pvp` - Player kills in PvP
  
- **Multi-Language Support**
  - English (enUS) - ~635 quotes
  - Russian (ruRU) - ~235 quotes
  
- **Smart Cooldown System**
  - Global cooldown (default 5s)
  - Per-category cooldowns
  - Anti-repetition (tracks recent quotes)
  
- **Combat Detection**
  - Automatic combat start/end detection
  - Health monitoring for survival quotes
  - Combat log event processing
  
- **Custom Quotes System**
  - Add your own quotes via SavedVariables
  - Per-class and per-spec filtering
  
- **Utility Library (Lib.lua)**
  - Event bus for inter-module communication
  - Class colors and icons
  - Table utilities (deep copy, merge)
  - String formatting helpers
  
- **UI Infrastructure**
  - Minimap button with tooltip
  - Slash command system (/av)
  - UIStrings localization system
  
- **Voice Support Preparation**
  - Sound playback framework
  - Actor/voice pack system
  - Locale-aware sound paths

### Changed

- Renamed addon from "MageQuotes" to "AzerothVoiced"
- Complete code restructure for multi-class support
- New file organization with Libs/, Locales/, Art/, Modules/
- Improved quote selection algorithm

### Technical

- Core.lua: 1200+ lines of main engine code
- Lib.lua: Utility functions and event bus
- 14 quote files (Common + 13 classes)
- UIStrings.lua: Interface text localization
- Icons.lua: Class icon management

---

## [1.0.0] - Original Release

### Original "MageQuotes" Addon

- Single class support (Mage only)
- Basic quote triggering
- Simple configuration

---

## Roadmap

### Planned for 2.1.0
- Full options UI panel
- Profile system (character/account-wide)
- Quote editor in-game
- More quotes per class

### Planned for 2.2.0
- Voice pack support (TTS integration)
- Streamer mode options
- WeakAuras integration
- ElvUI skin

### Future Ideas
- Race-specific quotes
- Faction-specific quotes
- Raid/dungeon boss reactions
- Achievement celebrations
- Mount/pet commentary

---

## Contributing

Contributions welcome! See README.md for guidelines.

---

*Thank you for using Azeroth Voiced!*
