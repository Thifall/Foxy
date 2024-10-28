extends CharacterBody2D

class_name Player

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -260.0

var _state: PlayerState = PlayerState.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	get_input()
	move_and_slide()
	calculate_state()
	update_debug_label()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func update_debug_label() -> void:
	debug_label.text = "On floor: %s\nVelocity: %.0f,%.0f\nstate: %s" % \
	[ is_on_floor(), velocity.x, velocity.y, PlayerState.keys()[_state] ]

func get_input() -> void:
	velocity.x = 0
	if Input.is_action_pressed("Left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif  Input.is_action_pressed("Right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func calculate_state() -> void:
	if is_on_floor():
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else:
			set_state(PlayerState.RUN)
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL)
		else:
			set_state(PlayerState.JUMP)

func set_state(newState: PlayerState) -> void:
	if newState == _state:
		return;
	_state = newState
	match _state:
		PlayerState.IDLE:
			animation_player.play("Idle")
		PlayerState.RUN:
			animation_player.play("Run")
		PlayerState.JUMP:
			animation_player.play("Jump")
		PlayerState.FALL:
			animation_player.play("Fall")
		PlayerState.HURT:
			animation_player.play("Hurt")
	
func shoot() -> void:
	if sprite_2d.flip_h:
		shooter.shootRelative(Vector2(0,5), Vector2.LEFT)
	else:
		shooter.shootRelative(Vector2(0,5), Vector2.RIGHT)
	
