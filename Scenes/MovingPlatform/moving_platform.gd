extends AnimatableBody2D

@export var destination: Marker2D
@export var speed: float = 50.0

var _startPosition: Vector2
var _endPosition: Vector2
var _timeToMove: float = 0.0
var _tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.onGameOver.connect(_on_game_over)
	_startPosition = global_position
	_endPosition = destination.global_position
	
	var distance: float = _startPosition.distance_to(_endPosition)
	_timeToMove = distance/speed
	_set_moving()
	
func _set_moving() -> void:
	_tween = get_tree().create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "global_position", _endPosition, _timeToMove)
	_tween.tween_property(self, "global_position", _startPosition, _timeToMove)

func _exit_tree() -> void:
	_kill_tween()

func _on_game_over() -> void:
	_kill_tween()

func _kill_tween() -> void:
	if _tween:
		_tween.kill()
