# MageQuotes v1.5.0 - Major Update

## 🎯 What's New in v1.5.0

### ✅ FIXED: Import/Export System
The import/export system has been completely rewritten to handle:
- **Cyrillic characters** (Russian, Ukrainian, etc.)
- **Special characters** (quotes, newlines, punctuation)
- **Color codes and markup**
- **Player names with special characters**

**Technical Details:**
- New hex-based serialization that encodes ALL characters safely
- URL-safe compression with `~XX` escape sequences
- New pack format signature: `MQP2` (v2 format)
- Legacy `MQPACK:` format detection with graceful error message

### ✅ Complete English Localization
All UI strings now have proper English translations:
- "Modules" tab → fully translated
- "Свои" tab → "Custom" in English
- All category names
- All button labels and messages
- Debug and error messages

### ✅ New Features

#### Quote Libraries
- Organize quotes into named collections
- Each library has: name, author, description, quote count
- Export/import entire libraries
- Commands: `/mqc libs`, `/mqc newlib <name>`

#### Spell Triggers (Foundation)
- Assign quotes to specific spells by SpellID
- Categories: Spell Cast, Interrupt, On Death
- API ready for UI integration

#### Enhanced Categories
New trigger categories added:
- `spell` - Spell Cast triggers
- `interrupt` - Successful interrupt triggers  
- `death` - On player death triggers

---

## 📁 Updated Folder Structure

```
MageQuotes/
├── MageQuotes.toc           # v1.5.0
├── Core.lua                 # Main engine
├── UI.lua                   # Settings UI
├── README.md
│
├── Modules/
│   ├── CustomQuotes.lua     # NEW: v1.5.0 with fixed import/export
│   └── Dracthyr.lua         # Voice switching
│
├── Locales/
│   ├── Quotes.lua           # Quote content
│   └── UIStrings.lua        # NEW: Complete translations
│
├── Libs/
│   └── Lib.lua              # Utilities
│
├── Art/
│   ├── Icons.lua            # Icon definitions
│   └── Icons/
│       └── icon.tga
│
└── Voices/
    ├── MageA/
    └── MageB/
```

---

## 🔧 Key Code Changes

### CustomQuotes.lua Changes

1. **New Serialization System**
```lua
-- Old (broken with Cyrillic):
if str:match("[^%w%s%p]") then
  return nil, "Invalid characters"
end

-- New (works with ALL characters):
local function StringToHex(str)
  return (str:gsub('.', function(c)
    return string.format('%02X', string.byte(c))
  end))
end
```

2. **Library Data Structure**
```lua
MageQuotesDB.libraries = {
  ["lib_123456_7890"] = {
    name = "My Library",
    author = "PlayerName",
    description = "Description",
    created = timestamp,
  }
}
```

3. **Spell Trigger Data Structure**
```lua
MageQuotesDB.spellTriggers = {
  [12345] = { 1, 3, 7 },  -- SpellID → Quote indices
}
```

### UIStrings.lua Changes
- Added 50+ new English strings
- Added 50+ new Russian strings
- Added Library-related strings
- Added Trigger-related strings
- Added situation strings

---

## 📋 TODO: Remaining Work (for future versions)

### High Priority
1. **UI for Spell Triggers** - Visual spell picker with icons
2. **Quotes Tab Dropdown** - Filter: Standard vs Custom vs All
3. **Export Selection UI** - Checkboxes for individual quotes

### Medium Priority
4. **Library Browser Window** - Click to view quotes in library
5. **Trigger Debug Mode** - Show why quotes triggered/blocked
6. **Combat quote fixes** - Investigate in-combat triggering

### Low Priority
7. **Quote search improvements**
8. **Drag-drop quote ordering**
9. **Quote favorites system**

---

## 🧪 Testing the Import/Export Fix

### Test 1: Cyrillic Export/Import
```
/mqc add init Привет, мир! Это тестовая цитата.
/mqc export
```
Copy the output, then:
```
/mqc clear
/mqc import <paste the string>
/mqc list
```
The quote should appear correctly.

### Test 2: Special Characters
```
/mqc add kill "Victory!" he shouted. 'Die, monster!'
/mqc export
```
Should export/import without errors.

---

## 🔄 Migration from v1.4

Users upgrading from v1.4:
1. Existing custom quotes are preserved
2. Old export strings (MQPACK:...) will show: "Legacy format not supported, please re-export"
3. Simply re-export quotes to get new format strings

---

## 📝 Changelog v1.5.0

### Added
- Complete English localization for all UI elements
- Quote Libraries system for organizing quotes
- Spell Triggers data structure and API
- New categories: spell, interrupt, death
- Hex-based serialization for Unicode support

### Fixed
- Import/Export now handles Cyrillic characters
- Import/Export now handles special characters
- Import error messages are more descriptive

### Changed
- Export format changed from MQPACK to MQP2
- Serialization completely rewritten
- UIStrings reorganized with better structure
