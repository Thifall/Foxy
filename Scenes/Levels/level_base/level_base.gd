extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("bullet"):
		SignalManager.onCreateBullet.emit(
			Vector2(50,-50), 
			Vector2(1,-1), 
			3.0, 
			50.0, 
			Constants.ObjectType.BULLET_PLAYER)
