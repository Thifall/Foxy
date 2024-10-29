extends EnemyBase

@onready var jump_timer: Timer = $JumpTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const JUMP_WAIT_TIME_MIN: float = 2.0
const JUMP_WAIT_TIME_MAX: float = 4.0
const JUMP_VELOCITY_X: float = 100
const JUMP_VELOCITY_Y: float = -150
const JUMP_VELOCITY_RIGHT: Vector2 = Vector2(JUMP_VELOCITY_X, JUMP_VELOCITY_Y)
const JUMP_VELOCITY_LEFT: Vector2 = Vector2(-JUMP_VELOCITY_X, JUMP_VELOCITY_Y)

var _canJump: bool = false
var _seenPlayer: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:		
		velocity.x = 0
		animated_sprite_2d.play("Idle")
	
	_apply_jump()
	move_and_slide()
	flip_frog()

func flip_frog() -> void:
	if velocity.x != 0:
		return
	if _playerReference.global_position.x > global_position.x  and !animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = true
	elif _playerReference.global_position.x <= global_position.x and animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false

func _apply_jump() -> void:
	if !is_on_floor():
		return
	
	if !_seenPlayer or !_canJump:
		return
		
	if !animated_sprite_2d.flip_h:
		velocity = JUMP_VELOCITY_LEFT
	else:
		velocity = JUMP_VELOCITY_RIGHT
	_canJump = false
	animated_sprite_2d.play("Jump")
	start_jump_timer()
	
func start_jump_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_WAIT_TIME_MIN, JUMP_WAIT_TIME_MAX)
	jump_timer.start()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	_seenPlayer = true 
	start_jump_timer()

func _on_jump_timer_timeout() -> void:
	_canJump = true
