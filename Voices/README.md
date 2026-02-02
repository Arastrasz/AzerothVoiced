# Voices Folder

This folder contains voice acting audio files for the addon.

## Structure

```
Voices/
├── MageA/                  # Voice Actor A (default: humanoid/visage)
│   ├── enUS/               # English voice files
│   │   ├── combat_init_01.ogg
│   │   ├── combat_init_02.ogg
│   │   ├── kill_01.ogg
│   │   └── ...
│   └── ruRU/               # Russian voice files
│       ├── combat_init_01.ogg
│       └── ...
│
└── MageB/                  # Voice Actor B (default: draconic)
    ├── enUS/
    └── ruRU/
```

## Audio File Requirements

| Property | Requirement |
|----------|-------------|
| Format | OGG Vorbis (.ogg) |
| Sample Rate | 44100 Hz recommended |
| Channels | Mono (1 channel) recommended |
| Bit Depth | 16-bit |
| Duration | 1-5 seconds typical |
| Volume | Normalized to -3dB peak |

## Naming Convention

Files should match the `soundKey` or `sound` field in quote definitions:

```
<category>_<number>.ogg
```

Examples:
- `combat_init_01.ogg`
- `kill_03.ogg`
- `survival_01.ogg`
- `victory_02.ogg`
- `rare_01.ogg`
- `greeting_01.ogg`

## Adding Voice Actors

1. Create a new folder: `Voices/YourActorName/`
2. Create locale subfolders: `Voices/YourActorName/enUS/`
3. Add .ogg files
4. Update `MageQuotesDB.sound.actors` to include the new actor name:
```lua
MageQuotesDB.sound.actors = { "MageA", "MageB", "YourActorName" }
```

## Sound Template Path

The addon uses these templates to find sound files:

**With Locale:**
```
Interface\AddOns\MageQuotes\Voices\<ActorName>\<Locale>\<FileName>.ogg
```

**Without Locale:**
```
Interface\AddOns\MageQuotes\Voices\<ActorName>\<FileName>.ogg
```

## Creating Voice Files

### Using Audacity (Free)
1. Record or import audio
2. Normalize: Effect → Normalize → -3dB
3. Export: File → Export → Export as OGG
4. Quality: 6-8 recommended

### Using AI Voice Generation
1. Use ElevenLabs, LOVO, or similar
2. Download as MP3/WAV
3. Convert to OGG using FFmpeg:
```bash
ffmpeg -i input.mp3 -c:a libvorbis -q:a 6 output.ogg
```

## Testing Voice Files

1. Enable voice in addon: `/mq` → Audio tab → Enable Voice
2. Set debug mode: Audio tab → Enable debug
3. Test: `/mq test` or trigger combat
4. Check chat for "Playing sound:" messages
