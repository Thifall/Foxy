extends EnemyBase

@onready var floor_detection: RayCast2D = $FloorDetection
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var Speed: float = 35


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = Speed if animated_sprite_2d.flip_h else -Speed 
	move_and_slide()
	
	if is_on_floor():
		if is_on_wall() or !floor_detection.is_colliding():
			flip_snail()
			
	
func flip_snail() -> void:
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	floor_detection.position.x = -floor_detection.position.x
	
