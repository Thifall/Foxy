extends Control

const HIGHSCORES: PackedScene = preload("res://Scenes/Highscores/highscores.tscn")

func _on_highscores_btn_pressed() -> void:
	get_tree().change_scene_to_packed(HIGHSCORES)

func _on_new_game_btn_pressed() -> void:	
	GameManager.load_next_level_scene()
	SignalManager.onNewGameSelected.emit()
