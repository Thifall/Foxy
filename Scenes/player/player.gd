extends CharacterBody2D

class_name Player

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter
@onready var invincibility_timer: Timer = $InvinvcibilityTimer
@onready var invincibility_animation: AnimationPlayer = $InvinvcibilityAnimation
@onready var hurt_timer: Timer = $HurtTimer
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var player_camera: Camera2D = $PlayerCamera

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -300.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -130)
const OFF_SCREEN_Y_LIMIT: float = 200.0

var _state: PlayerState = PlayerState.IDLE
var _lives: int = 5
var isInvincible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("late_setup")
	
func late_setup() -> void:
	_lives = GameManager.get_persisted_player_health()
	SignalManager.onLevelStarted.emit(_lives)
	SignalManager.onLevelCompleted.connect(on_level_completed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	fallen_off()
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	get_input()
	move_and_slide()
	calculate_state()
	update_debug_label()
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func set_camera_limits(camera_min: Vector2, camera_max: Vector2) -> void:
	player_camera.limit_bottom = int(camera_min.y)
	player_camera.limit_top	 = int(camera_max.y)
	player_camera.limit_left = int(camera_min.x)
	player_camera.limit_right = int(camera_max.x)

func fallen_off() -> void:
	if global_position.y < OFF_SCREEN_Y_LIMIT:
		return
	is_player_alive_after_hit(_lives)
		
func update_debug_label() -> void:
	debug_label.text = "On floor: %s\nVelocity: %.0f,%.0f\nstate: %s\n%d" % \
	[ is_on_floor(), velocity.x, velocity.y, PlayerState.keys()[_state], _lives ]

func get_input() -> void:
	if _state == PlayerState.HURT:
		return
	velocity.x = 0
	if Input.is_action_pressed("Left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif  Input.is_action_pressed("Right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
		SoundManager.play_clip(sound, SoundManager.SOUND_JUMP)
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func calculate_state() -> void:
	if _state == PlayerState.HURT:
		return
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
		
	if _state == PlayerState.FALL:
		if newState == PlayerState.IDLE or newState == PlayerState.RUN:
			SoundManager.play_clip(sound, SoundManager.SOUND_LAND)
	
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
			apply_hurt_jump()
	
func shoot() -> void:
	if sprite_2d.flip_h:
		shooter.shootRelative(Vector2(0,5), Vector2.LEFT)
	else:
		shooter.shootRelative(Vector2(0,5), Vector2.RIGHT)

func on_level_completed() -> void:
	GameManager.persist_player_health(_lives)
	
#region Player onHit
func is_player_alive_after_hit(damage: int) -> bool:
	_lives -= damage
	SignalManager.onPlayerHit.emit(_lives)
	if _lives <= 0:
		SignalManager.onGameOver.emit()
		set_physics_process(false)
		animation_player.stop()
		invincibility_animation.stop()
		print("player died")
		return false	
	return true

func go_invincible() -> void:
	isInvincible = true
	invincibility_animation.play("invincibility")
	invincibility_timer.start()

func apply_hit() -> void:
	if isInvincible:
		return
	
	if !is_player_alive_after_hit(1):
		return
		
	SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)
	go_invincible()
	set_state(PlayerState.HURT)

func _on_hitbox_area_entered(_area: Area2D) -> void:
	apply_hit()
		
func _on_invinvcibility_timer_timeout() -> void:
	isInvincible = false
	invincibility_animation.stop()

func apply_hurt_jump() -> void:
	animation_player.play("Hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()

func _on_hurt_timer_timeout() -> void:
	set_state(PlayerState.IDLE)
#endregion
