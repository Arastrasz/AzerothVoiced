# Changelog

All notable changes to MageQuotes will be documented in this file.

## [1.5.5] - 2025-02-01

### Fixed
- **Critical: searchBox nil error** - Fixed the UI crash when selecting "Custom Only" filter
  - The searchBox variable is now defined before dropdown click handlers that reference it
- **Unicode display issues** - Replaced problematic Unicode characters with ASCII alternatives:
  - Star symbol (★) replaced with [*]
  - Status indicators (●/○) replaced with [ON]/[OFF]
  - Dropdown arrows (▼/▲) replaced with v/^
  - Close button (×) replaced with X
- **Language switching** - Now shows a message telling users to /reload for full translation

### Added
- **CustomQuotes.lua module** - Complete implementation of custom quote system:
  - Add/remove/toggle quotes via UI or slash commands
  - Import/export with full Unicode support (Cyrillic, special characters)
  - New hex-based serialization (MQP2 format) for reliable data transfer
  - Slash commands: /mqc add, /mqc list, /mqc export, /mqc import, /mqc clear
- Reload notice when changing languages

### Changed
- Version updated to 1.5.5
- Improved code comments for maintainability

## [1.5.0] - 2025-01-31

### Added
- **Custom Quote Editor** - New "Custom" tab in settings UI
  - Add your own quotes in-game
  - Assign to any category
  - Optional sound file linking
  - Spec-specific filtering
  - Toggle quotes on/off
- **Import/Export System**
  - Export all custom quotes as shareable strings
  - Import friend's quote packs
  - Automatic duplicate detection
- **New Slash Commands**
  - `/mqc help` - Custom quotes help
  - `/mqc add <category> <text>` - Add quote
  - `/mqc export` - Export quotes
  - `/mqc import <string>` - Import quotes

## [1.4.0] - 2025-01-31

### Added
- **Custom Quote Editor** - New "Custom" tab in settings UI
- **Import/Export System** for sharing quotes
- **Organized Folder Structure**

### Changed
- Frame width increased to accommodate 8 tabs
- Improved module version display

### Fixed
- Variable shadowing bug causing UI crash
- Close button now properly hides window

## [1.3.0] - 2025-01-30

### Added
- **Midnight 12.0.0 Compatibility**
  - All SendChatMessage calls removed
  - Inner Whisper only mode (Blizzard restriction)
- **Dracthyr Module**
  - Automatic voice switching between forms
  - Visage to Dragon detection
- **Debug Console**
  - New Debug tab in settings
  - Real-time event logging
- **Module System**
  - Modules tab showing all components
  - Version display for each module

### Changed
- Channel selection disabled (Midnight API restriction)
- Combat queue removed (no longer needed)

### Fixed
- Protected function errors resolved
- Locale system integration

## [1.2.0] - 2025-01-29

### Added
- Multi-language support (EN, RU, DE, IT)
- Spec-specific quote filtering
- Voice actor system
- Audio channel selection

### Changed
- Modernized UI design
- Improved combat detection

## [1.1.0] - 2025-01-28

### Added
- Categories tab
- Per-category cooldowns
- Statistics tracking

### Fixed
- Quote cooldown timing
- Combat state detection

## [1.0.0] - 2025-01-27

### Added
- Initial release
- Basic quote system
- Settings UI
- Minimap button
- Combat initiation quotes
- Killing blow quotes
- Survival quotes
- Victory quotes
