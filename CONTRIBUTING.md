# Contributing to Azeroth Voiced

Thank you for your interest in contributing to Azeroth Voiced! This document provides guidelines for various types of contributions.

---

## Ways to Contribute

1. **Submit Quotes** - Add new voice lines for classes
2. **Add Translations** - Translate quotes to other languages
3. **Report Bugs** - Help us identify issues
4. **Suggest Features** - Propose new functionality
5. **Create Voice Packs** - Record actual voice acting
6. **Code Contributions** - Improve the addon's functionality

---

## Submitting Quotes

### Quick Guide

1. Open the appropriate class file: `Locales/Quotes_[ClassName].lua`
2. Add your quote to the right category
3. Test in-game with `/av test [category]`
4. Submit a pull request

### Quote Format

```lua
-- Basic quote
{ text = "Your quote here!" },

-- Spec-specific quote
{ text = "Spec-specific quote!", spec = 2 },

-- With sound reference (for voice packs)
{ text = "Quote with voice!", sound = "custom_sound_01" },
```

### Guidelines

**DO:**
- Keep quotes under 60 characters for chat readability
- Match the class fantasy (Paladins mention Light, Warlocks mention demons)
- Reference actual abilities when appropriate
- Include humor in `rare` category quotes
- Test all quotes in-game before submitting

**DON'T:**
- Include explicit language or slurs
- Reference real-world politics
- Use copyrighted content (movie quotes, song lyrics)
- Create quotes that mock other players
- Submit duplicate or very similar quotes

### Category Reference

| Category | Trigger | Tone |
|----------|---------|------|
| `init` | Combat start | Battle cry, aggressive |
| `kill` | Enemy death | Victorious, satisfied |
| `surv` | Low health | Desperate, defiant |
| `vict` | Combat end | Triumphant, relieved |
| `mid` | During fight | Persistent, focused |
| `greet` | Login | Welcoming, ready |
| `rare` | Random idle | Humorous, contemplative |
| `death` | Player dies | Final words, regret |
| `taunt` | Tank taunts | Challenging, protective |
| `crit` | Critical hit | Excited, powerful |
| `interrupt` | Interrupt | Satisfied, denial |
| `pvp` | Player kill | Competitive |

See `QUOTES_GUIDE.md` for detailed writing tips.

---

## Adding Translations

### Supported Languages

Currently:
- English (enUS) - Primary
- Russian (ruRU) - Complete

Welcome:
- German (deDE)
- French (frFR)
- Spanish (esES)
- Portuguese (ptBR)
- Korean (koKR)
- Chinese Simplified (zhCN)
- Chinese Traditional (zhTW)

### How to Translate

1. Create quotes in the appropriate class file:

```lua
AzerothVoiced_RegisterQuotes("MAGE", "deDE", {
    init = {
        { text = "Spürt die Flammen!" },
        { text = "Arkane Macht!" },
    },
    -- ... other categories
})
```

2. Add UI strings in `Locales/UIStrings.lua`:

```lua
L["deDE"] = {
    LOADED = "geladen",
    ADDON_ENABLED = "Addon aktiviert",
    -- ... all UI strings
}
```

### Translation Guidelines

- **Don't literal translate** - Adapt to sound natural in the target language
- **Keep class fantasy intact** - A Paladin still serves the Light in any language
- **Use official WoW terminology** - Match Blizzard's translations for spells/abilities
- **Cultural adaptations are welcome** - Humor that works in one language may not in another

---

## Reporting Bugs

### Before Reporting

1. Update to the latest version
2. Disable other addons to check for conflicts
3. Check existing issues for duplicates
4. Enable debug mode: `/av debug`

### Bug Report Template

```
**Addon Version:** 2.0.0
**WoW Version:** 11.0.5
**Class/Spec:** Fire Mage

**Description:**
What happened?

**Steps to Reproduce:**
1. Step one
2. Step two
3. Step three

**Expected Behavior:**
What should have happened?

**Actual Behavior:**
What actually happened?

**Debug Output:** (if available)
Paste any error messages or debug output here.

**Other Addons:** (if potentially relevant)
List any addons that might interact.
```

---

## Suggesting Features

### Good Feature Requests

- **Clear problem statement** - What issue does this solve?
- **Use case examples** - When would this be useful?
- **Scope awareness** - Is this feasible for an addon?

### Feature Request Template

```
**Feature:** Brief title

**Problem:**
What problem does this solve?

**Proposed Solution:**
How should it work?

**Alternatives Considered:**
Other ways to solve this?

**Additional Context:**
Screenshots, mockups, examples from other addons
```

---

## Creating Voice Packs

### Requirements

- OGG Vorbis format
- 44100 Hz sample rate
- Mono audio
- 64-128 kbps bitrate
- 1-5 seconds duration per clip

### Folder Structure

```
Voices/
└── your_actor_name/
    ├── enUS/
    │   ├── init_1.ogg
    │   ├── init_2.ogg
    │   ├── kill_1.ogg
    │   └── ...
    └── ruRU/
        └── ...
```

### Naming Convention

Files should be named: `{category}_{number}.ogg`

Examples:
- `init_1.ogg`, `init_2.ogg`
- `kill_1.ogg`, `kill_2.ogg`
- `death_1.ogg`

### Recording Tips

1. **Consistent volume** - Normalize to -3dB
2. **Clean audio** - Minimal background noise
3. **Match the text** - Record the exact quote text
4. **Class voice** - Different voice styles for different classes
5. **Emotion matters** - Match the quote's intended emotion

---

## Code Contributions

### Setup

1. Fork the repository
2. Clone to your WoW AddOns folder
3. Create a feature branch: `git checkout -b feature/my-feature`
4. Make your changes
5. Test thoroughly in-game
6. Submit a pull request

### Code Style

```lua
-- Use 4-space indentation
function MyFunction()
    local result = 0
    
    -- Comments above code they describe
    for i = 1, 10 do
        result = result + i
    end
    
    return result
end

-- Use meaningful variable names
local playerHealthPercent = (currentHealth / maxHealth) * 100

-- Localize frequently-used globals
local pairs, ipairs = pairs, ipairs
local GetTime = GetTime
```

### Pull Request Guidelines

1. **One feature per PR** - Keep changes focused
2. **Test thoroughly** - Include steps to test
3. **Update documentation** - If behavior changes
4. **Follow existing patterns** - Consistency matters
5. **Be responsive** - Address review feedback promptly

### Areas Needing Help

- [ ] Settings UI panel (Blizzard options frame)
- [ ] LibDBIcon integration for minimap
- [ ] LibDataBroker support
- [ ] ElvUI/Tukui skin
- [ ] WeakAuras integration
- [ ] Performance optimization
- [ ] Unit tests

---

## Community Guidelines

1. **Be respectful** - We're all here to improve the addon
2. **Be patient** - Maintainers are volunteers
3. **Be constructive** - Focus on solutions, not complaints
4. **Give credit** - Acknowledge others' contributions
5. **Have fun** - This is a game addon after all!

---

## License

By contributing to Azeroth Voiced, you agree that your contributions will be licensed under the same license as the project.

---

## Questions?

- Open an issue for questions
- Join our Discord (if available)
- Contact the maintainers directly

---

*Thank you for making Azeroth Voiced better for everyone!*
