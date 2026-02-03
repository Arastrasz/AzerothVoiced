# Voices Folder - Sound Files

This folder contains voice acting files for Azeroth Voiced.

## Folder Structure

```
Voices/
├── default/              # Default voice actor
│   ├── enUS/             # English quotes
│   │   ├── init_1.ogg
│   │   ├── init_2.ogg
│   │   ├── kill_1.ogg
│   │   └── ...
│   └── ruRU/             # Russian quotes
│       ├── init_1.ogg
│       └── ...
└── custom/               # Additional voice actors
    └── enUS/
        └── ...
```

## File Naming Convention

Files are named: `{category}_{number}.ogg`

| Category | Example Files |
|----------|---------------|
| init | `init_1.ogg`, `init_2.ogg`, `init_3.ogg` |
| kill | `kill_1.ogg`, `kill_2.ogg` |
| surv | `surv_1.ogg`, `surv_2.ogg` |
| vict | `vict_1.ogg`, `vict_2.ogg` |
| mid | `mid_1.ogg`, `mid_2.ogg` |
| greet | `greet_1.ogg`, `greet_2.ogg` |
| rare | `rare_1.ogg`, `rare_2.ogg` |
| interrupt | `interrupt_1.ogg` |
| death | `death_1.ogg`, `death_2.ogg` |
| crit | `crit_1.ogg`, `crit_2.ogg` |
| taunt | `taunt_1.ogg` |
| heal | `heal_1.ogg` |
| pvp | `pvp_1.ogg` |

## Audio Requirements

| Property | Requirement |
|----------|-------------|
| Format | OGG Vorbis (`.ogg`) |
| Sample Rate | 22050 Hz or 44100 Hz |
| Channels | Mono recommended |
| Bitrate | 64-128 kbps |
| Duration | 1-5 seconds typical |

## Converting Audio Files

### Using FFmpeg

```bash
# Convert any audio to WoW-compatible OGG
ffmpeg -i input.mp3 -ar 44100 -ac 1 -b:a 96k output.ogg

# Batch convert MP3 folder
for f in *.mp3; do ffmpeg -i "$f" -ar 44100 -ac 1 -b:a 96k "${f%.mp3}.ogg"; done
```

### Using Audacity

1. Open your audio file
2. Project → Resample → 44100 Hz
3. Tracks → Mix → Mix Stereo Down to Mono
4. File → Export → Export as OGG
5. Quality: 5-7 (96-128 kbps)

## Adding Voice Actors

1. Create a new folder: `Voices/myactor/enUS/`
2. Add your OGG files
3. In-game, change the actor setting:
   ```
   /av actor myactor
   ```

## Linking Quotes to Sound Files

In quote files, use the `sound` field:

```lua
{ text = "Feel the burn!", sound = "init_fire_1" },
```

This plays: `Voices/{actor}/enUS/init_fire_1.ogg`

## Sound Categories to Prioritize

For a minimal voice pack, record these first:

1. **greet** - Heard every login
2. **init** - Combat start (very frequent)
3. **vict** - Victory (satisfying feedback)
4. **death** - Player death
5. **kill** - Killing blows

## Testing Sounds

```
/av testsound default/enUS/init_1.ogg
```

## Troubleshooting

### Sound not playing?
- Check file format is OGG Vorbis
- Verify path is correct
- Ensure WoW sound is not muted
- Check the sound channel setting

### Sound too quiet?
- Normalize audio to -3dB
- Check in-game volume settings
- Try different sound channels (Master, SFX, Dialog)

### Crackling/distortion?
- Lower bitrate to 64 kbps
- Ensure mono audio
- Check sample rate matches (44100 Hz)
