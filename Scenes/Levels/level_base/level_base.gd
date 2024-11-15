extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.onGameOver.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("bullet"):
		SignalManager.onCreateBullet.emit(
			Vector2(50,-50), 
			Vector2(1,-1), 
			3.0, 
			50.0, 
			Constants.ObjectType.BULLET_PLAYER)

func on_game_over() -> void:
	for mv in get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP):
		mv.set_process(false)
		mv.set_physics_process(false)
