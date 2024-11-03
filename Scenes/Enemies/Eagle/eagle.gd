extends EnemyBase

@onready var shooter: Shooter = $Shooter
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var direction_timer: Timer = $DirectionTimer

const FLY_SPEED: Vector2 = Vector2(35,15)

var _flyDirection: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity = _flyDirection
	move_and_slide()
	shoot()

func shoot() -> void:
	if player_detector.is_colliding():
		shooter.shoot(global_position.direction_to(_playerReference.global_position))

func _fly_to_player() -> void:
	var xDir = sign(_playerReference.global_position.x - global_position.x)
	if xDir > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	_flyDirection = Vector2(xDir, 1) * FLY_SPEED

func _on_direction_timer_timeout() -> void:
	_fly_to_player()
	
func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	animated_sprite_2d.play("fly")
	direction_timer.start()
	_fly_to_player()
