extends Control

const HIGHSCORES: PackedScene = preload("res://Scenes/Highscores/highscores.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		GameManager.load_next_level_scene()

func _on_highscores_btn_pressed() -> void:
	get_tree().change_scene_to_packed(HIGHSCORES)
