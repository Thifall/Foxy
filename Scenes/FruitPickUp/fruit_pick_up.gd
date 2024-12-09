extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY: float = 160.0
const JUMP: float = -180
const POINTS: int = 2

var _startY: float
var _speedY: float = JUMP
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_startY = position.y
	var animationsList: Array[String] = []
	animationsList.append_array(animated_sprite_2d.sprite_frames.get_animation_names())
	#for an in animated_sprite_2d.sprite_frames.get_animation_names():
		#animationsList.push_back(an)
	animated_sprite_2d.animation  = animationsList.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += _speedY * delta
	_speedY += gravity * delta
	if position.y > _startY:
		set_process(false)
		
func remove_me():
	hide()
	queue_free()


func _on_lifespan_timer_timeout() -> void:
	remove_me()


func _on_area_entered(_area: Area2D) -> void:
	SignalManager.onPickupPicked.emit(POINTS)
	remove_me()
