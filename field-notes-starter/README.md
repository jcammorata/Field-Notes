# Field Notes

A Godot 4 adventure where kids learn to think like scientists by figuring out the creatures of strange worlds.

## Getting started

1. Open Godot 4, choose **Import**, and select `project.godot` in this folder.
2. Press **Play**. You'll get a test room with a floor and a ledge. The player is invisible until the rig is built (step below), but it already moves.
3. Controls: **A/D** or arrow keys to move, **Space** to jump. Touch controls come later.

## Folder layout

```
art/characters/naturalist/parts/   one PNG per body part
scenes/player.tscn                 the naturalist (movement + empty Rig)
scenes/test_room.tscn              a floor and a ledge for testing
scripts/player.gd                  movement and animation switching
scripts/input_setup.gd             input actions, registered in code
```

## Building the cutout rig

Open `scenes/player.tscn` and build the character under the **Rig** node with one **Sprite2D** per part. Children follow their parent when it rotates, and nodes lower in the list draw on top.

Suggested tree, back to front:

```
Rig
├── ArmBack (upper_arm_back) → ForearmBack → HandBack
├── LegBack (thigh_back) → ShinBack → BootBack
├── Pack → PackFlap
│   └── LanternHook → Lantern
├── ScarfHang
├── Torso
├── LegFront (thigh_front) → ShinFront → BootFront
├── Head → Hair, Eye, Brow, Cap
├── ScarfWrap
└── ArmFront (upper_arm_front) → ForearmFront → HandFront
```

For each part:

1. Drag its PNG from `art/characters/naturalist/parts/` onto the Sprite2D's **Texture**.
2. Set the pivot: move the art (the Sprite2D's **Offset**) so the joint, such as the shoulder for an upper arm, sits on the node's origin. Rotation then happens around the joint.
3. Position the node where that joint sits on its parent.

The parts are drawn large, so build the rig at full size, then scale the **Rig** node down (around 0.3) until the kid is about as tall as the collision capsule. The script flips the rig to face left or right and keeps its size.

The tree above is a starting point; the far arm or leg may need to move above or below other parts depending on the pose.

## Animations

In the **AnimationPlayer**, create animations named `idle`, `walk`, `jump` and `fall` by keying the **rotation** of the joints (and position of the Rig for bobbing). Turn on looping for `idle` and `walk`. The script plays them automatically and skips any that don't exist yet. Use the key pose sheets as reference.

Later: the scarf and lantern swing will be handled in code, face expressions will be texture swaps on Eye, Brow and a Mouth sprite, and the lantern glow will be a light rather than part of the art.
