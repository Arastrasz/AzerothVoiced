# Art Folder

This folder contains visual assets for the addon.

## Structure

```
Art/
├── Icons.lua           # Icon path definitions
└── Icons/              # Actual icon image files
    └── icon.tga        # Minimap button icon (32x32 or 64x64)
```

## Icons.lua

Defines paths to icon textures used throughout the addon:

```lua
MageQuotesIcons = {
  main = "Interface\\AddOns\\MageQuotes\\Art\\Icons\\icon.tga",
  -- Add more icons as needed:
  -- arcane = "Interface\\Icons\\Spell_Arcane_Arcane01",
  -- fire = "Interface\\Icons\\Spell_Fire_FireBolt02", 
  -- frost = "Interface\\Icons\\Spell_Frost_FrostBolt02",
}
```

## Creating Custom Icons

### TGA Format (Recommended)
- **Size**: 32x32 or 64x64 pixels
- **Format**: 32-bit TGA (with alpha channel)
- **Compression**: Uncompressed or RLE

### Using GIMP
1. Create new image: 64x64, transparent background
2. Design your icon
3. Export: File → Export As → icon.tga
4. Options: RLE compression (optional)

### Using Photoshop
1. Create 64x64 document
2. Design icon with transparency
3. Save As → Targa (.tga)
4. 32 bits/pixel

## Using WoW Built-in Icons

You can reference any WoW icon by path:

```lua
"Interface\\Icons\\Spell_Frost_IceStorm"      -- Frost spell icon
"Interface\\Icons\\Ability_Mage_Firestarter"  -- Fire ability icon
"Interface\\Icons\\Spell_Arcane_Arcane01"     -- Arcane spell icon
```

Browse icons at: https://www.wowhead.com/icons

## Icon Usage in Code

```lua
-- Get icon path
local icon = MageQuotesIcons.main

-- Use in frame texture
local tex = frame:CreateTexture(nil, "ARTWORK")
tex:SetTexture(icon)

-- Use in minimap button
local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("MageQuotes", {
  type = "launcher",
  icon = MageQuotesIcons.main,
})
```

## Additional Assets

You can add more visual assets here:
- **Backgrounds**: UI panel backgrounds
- **Borders**: Custom frame borders
- **Buttons**: Custom button textures
- **Fonts**: Custom font files (.ttf)
