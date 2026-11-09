# Field Notes

A 2D exploration adventure for iOS and Android where kids aged 7–12 (core 7–10) learn to think like scientists by figuring out the creatures of strange worlds, then use what they learn to restore an ancient treehouse that once guided a great migration between worlds.

## Working with me

- I'm a game designer and a beginner in Godot. Explain Godot concepts briefly when you use them, and tell me what to do in the editor when a step can't be done in files.
- Prefer scenes built in the editor for anything visible, and scripts for behavior. Don't build visible node trees in code unless there's a clear reason.
- Keep scripts small, typed, and commented. GDScript only.
- Ask before adding addons or plugins, renaming or moving folders, or changing project settings.
- After a change, tell me how to test it in the editor.

## Tech

- Engine: Godot 4, GDScript, 2D only.
- Display: landscape, 1280×720 base, `canvas_items` stretch, Mobile renderer.
- Characters are cutout rigs: one Sprite2D per body part, parented at the joints, animated with AnimationPlayer, switched with AnimationTree later.
- Code handles secondary motion (scarf, lantern swing). Lantern glow is a Light2D, never baked into art. Face expressions are texture swaps (eyes, brows, mouth). Kid customization is recoloring via modulate or a palette shader on skin, hair and clothing parts.

### Architecture conventions

| What | Approach |
| --- | --- |
| Worlds, treehouse, player, HUD, journal | Scenes |
| Creatures | One base `Creature` scene; each species is an inherited scene |
| Creature rules | Small reusable rule nodes added in the editor, e.g. `AttractedBy`, `ScaredByShadow` |
| Creature facts, items, build recipes | Resource files edited in the inspector |
| Journal, backpack, progress | Autoload scripts holding game-wide state |
| Communication between systems | Signals, e.g. a creature emits `fact_confirmed` and the journal listens |

### Current layout

```
art/characters/naturalist/parts/   one PNG per body part (cut from my parts sheet)
scenes/player.tscn                 CharacterBody2D, collision, empty Rig, AnimationPlayer, Camera2D
scenes/test_room.tscn              floor and a ledge
scripts/player.gd                  movement, forgiving platforming, animation switching
scripts/input_setup.gd             autoload that registers input actions in code
```

Input actions: `move_left`, `move_right`, `jump`, `use` (keyboard for desktop testing). `player.gd` plays animations named `idle`, `walk`, `jump`, `fall` and skips any that don't exist.

## Design rules the code must respect

- **Pillars:** Discovery, Ingenuity, Problem-solving, on a foundation of a beautiful world where mistakes are safe. Every feature serves at least one pillar.
- **Forgiving play:** coyote time, jump buffering, short hop on early release, no fall damage (a fall returns the kid to the last safe spot). No lives, no game over, no timers.
- **Mistakes are progress:** a wrong guess gets a funny reaction and a blue "Ruled out" stamp; a right one gets an orange "Confirmed" stamp. Retries are always seconds away. Hints escalate after misses but never give the answer.
- **Creatures are never fought or harmed.** The only enemies are the blight (shadow wisps, thorn crawlers, dust blooms). Blight bursts into petals or light rather than dying. A hit knocks the kid back and may drop one backpack item; no health bar.
- **Creatures run on simple shared rules,** not scripts: what attracts them, what scares them, moods, and schedule. Rules are consistent across all worlds so kids can predict and experiment. Puzzles should allow more than one solution ("Found a new way!" stamp).
- **Controls:** floating analog stick on the left, Jump and Use buttons on the right, tap objects to interact, tap a spot to send the companion. Large touch targets for small hands. Little required reading; icons and behavior carry meaning.

## Privacy and child safety (non-negotiable)

- No ads, no purchases aimed at kids, no third-party analytics or SDKs that collect data.
- Kids' drawings, writing and any recordings stay on the device. No network calls that send kids' data anywhere.
- No sharing between kids. Saving or printing journal pages, settings, and any link out of the game sit behind a parent gate (press and hold for 3 seconds).
- Build toward COPPA and the Apple Kids Category and Google Families rules from the start.

## Vocabulary

- **Creatures**, never "animals," for the game's wildlife.
- **The naturalist:** the player character, a customizable kid with a teal cap, red scarf, blue-gray coat, big olive backpack, and a lantern hanging from a hook on the pack.
- **The companion:** a silent, lost young migrator who follows the kid, acts as the hint system, and gains abilities as worlds heal. Not designed yet.
- **The treehouse:** home base, built by the ancients in an old tree as a waystation. Each room holds a **beacon** for one world; restored rooms relight beacons and open **mural doors** to worlds.
- **The ancients:** long-gone caretakers who wrote in creature symbols. A symbol becomes readable once its creature is understood.
- **The blight:** what spreads into a weakened world; the only thing kids fight.
- **First creature:** Bubble Toad (puffs up and floats when a shadow passes; eats glowmoths). Others in the first world: glowmoths, Shellbacks, burrowers.

## Current milestone: phase 1, one-screen prototype

Goal: the player, one Bubble Toad, a leaf and a moth, and the guess-and-test loop, nothing else. Gate to move on: kids replay it without being asked.

Next tasks, in order:

1. Help me build the naturalist's cutout rig under `Rig` in `player.tscn` and set pivots.
2. Animate `idle`, `walk`, `jump`, `fall` from my key pose sheets.
3. Touch controls: floating stick plus Jump and Use buttons.
4. Pick-up: item arcs from hand into the pack (Tween, shrinking), a small CPUParticles2D sparkle, and a one-time bounce of the pack flap.
5. A Bubble Toad that reacts to offered items: a leaf gets a sniff and a turned-away head ("Ruled out"), a moth gets eaten ("Confirmed").
6. A minimal journal that records those two stamps.

Later phases: systems prototype (3–4 creatures with 3–4 rules each), then a vertical slice of the first world, then full production.

## Open questions (don't decide these without me)

- Which 4–5 worlds, and their science themes
- The companion's look, name, abilities per world, and fate at the end
- Whether backpack items are used up by builds
- Business model
- The first world's keystone puzzle
- How much kids can customize the naturalist
