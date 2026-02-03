# Libs Folder

This folder contains internal utility libraries used by the addon.

## Files

### Lib.lua
Internal helper library with common utility functions.

**Available Functions:**

```lua
local Lib = MageQuotesLib

-- String trimming
Lib.Trim("  hello  ")  -- Returns: "hello"

-- Get filename without extension
Lib.BasenameNoExt("path/to/file.ogg")  -- Returns: "file"

-- Clamp integer to range
Lib.ClampInt(15, 0, 10)  -- Returns: 10
Lib.ClampInt(-5, 0, 10)  -- Returns: 0

-- Random integer in range
Lib.RandRangeInt(1, 10)  -- Returns: random 1-10

-- Create local event bus
local bus = Lib.CreateLocalBus()
bus:RegisterCallback("MY_EVENT", function(owner, data)
  print("Event received:", data)
end, "MyModule")
bus:TriggerEvent("MY_EVENT", "hello")
```

## External Libraries (Optional)

If you need external libraries, add them here:

### LibDataBroker-1.1
Used for minimap button integration.
```
Libs/LibDataBroker-1.1/LibDataBroker-1.1.lua
```

### LibDBIcon-1.0
Provides minimap button functionality.
```
Libs/LibDBIcon-1.0/LibDBIcon-1.0.lua
```

### LibStub
Required by most Ace3 libraries.
```
Libs/LibStub/LibStub.lua
```

## Adding External Libraries

1. Download the library
2. Create folder: `Libs/LibraryName/`
3. Add library files
4. Update `MageQuotes.toc`:
```
# External Libraries
Libs\LibStub\LibStub.lua
Libs\LibDataBroker-1.1\LibDataBroker-1.1.lua
```

5. Make sure to load them BEFORE files that use them

## Event Bus Usage

The addon provides a global event bus for module communication:

```lua
-- Register for events
MageQuotes_EventBus:RegisterCallback("MAGE_QUOTES_LOCALE_CHANGED", function()
  print("Locale changed!")
end, "MyModule")

-- Trigger events
MageQuotes_EventBus:TriggerEvent("MAGE_QUOTES_SETTINGS_CHANGED")

-- Available events:
-- MAGE_QUOTES_LOCALE_CHANGED
-- MAGE_QUOTES_SETTINGS_CHANGED
-- MAGE_QUOTES_VOICE_CHANGED
-- MAGE_QUOTES_CUSTOM_UPDATED
-- MAGE_QUOTES_QUOTE_PLAYED
```
