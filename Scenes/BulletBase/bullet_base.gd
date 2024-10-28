extends Area2D

class_name Bullet

var _direction: Vector2 = Vector2(100,0)
var _lifeSpan: float = 5.0
var _lifeTime: float = 0.0

func _process(delta: float) -> void:
	position += _direction * delta
	check_expired(delta)

func check_expired(delta: float) -> void:
	_lifeTime += delta
	if _lifeTime >= _lifeSpan:
		queue_free()

func setup(position: Vector2, direction: Vector2, lifeSpan: float, speed: float):
	_direction = direction.normalized() * speed
	_lifeSpan = lifeSpan
	global_position = position

func _on_area_entered(area: Area2D) -> void:
	queue_free()
