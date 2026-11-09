extends CharacterBody2D
## The naturalist: forgiving platforming plus animation state.
## Build the cutout rig under the "Rig" node; this script flips it
## to face the direction of travel and plays animations by name:
## "idle", "walk", "jump" and "fall" (any that don't exist yet are skipped).

@export var walk_speed := 220.0
@export var jump_velocity := -620.0
@export var gravity := 1600.0
## Seconds after walking off a ledge when a jump still works.
@export var coyote_time := 0.12
## Seconds a jump press is remembered before landing.
@export var jump_buffer := 0.12
## Falling below this height returns the kid to the last safe spot.
@export var fall_limit_y := 1500.0

@onready var rig: Node2D = $Rig
@onready var anim: AnimationPlayer = $AnimationPlayer

var _coyote := 0.0
var _buffer := 0.0
var _last_safe_position := Vector2.ZERO


func _ready() -> void:
	_last_safe_position = global_position


func _physics_process(delta: float) -> void:
	if is_on_floor():
		_coyote = coyote_time
		_last_safe_position = global_position
	else:
		velocity.y += gravity * delta
		_coyote -= delta

	_buffer -= delta
	if Input.is_action_just_pressed("jump"):
		_buffer = jump_buffer
	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = jump_velocity
		_buffer = 0.0
		_coyote = 0.0
	# Letting go of jump early gives a smaller hop.
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5

	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * walk_speed
	if direction != 0.0:
		# Keep the rig's size; only flip which way it faces.
		rig.scale.x = absf(rig.scale.x) * (1.0 if direction > 0.0 else -1.0)

	move_and_slide()

	# No fall damage: a fall just puts the kid back where they were.
	if global_position.y > fall_limit_y:
		global_position = _last_safe_position
		velocity = Vector2.ZERO

	_update_animation(direction)


func _update_animation(direction: float) -> void:
	var next := "idle"
	if not is_on_floor():
		next = "jump" if velocity.y < 0.0 else "fall"
	elif direction != 0.0:
		next = "walk"
	if anim.current_animation != next and anim.has_animation(next):
		anim.play(next)
