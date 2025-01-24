extends Node

const MAIN = preload("res://Scenes/Main/main.tscn")
const TOTAL_LEVELS: int = 2

var _level_scenes: Dictionary = {}
var _current_level: int = 0
var _persisted_player_health: int = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ln in range(1, TOTAL_LEVELS+1):
		_level_scenes[ln] = load("res://Scenes/Levels/level_base/level_%d.tscn" % ln)

func get_persisted_player_health() -> int:
	return _persisted_player_health
	
func persist_player_health(hp: int):
	_persisted_player_health = hp

func load_main_scene() -> void:
	_current_level = 0
	ScoreManager.reset_score()
	get_tree().change_scene_to_packed(MAIN)

func load_next_level_scene() -> void:
	set_next_level()
	get_tree().change_scene_to_packed(_level_scenes[_current_level])

func set_next_level() -> void:
	_current_level += 1
	if _current_level > TOTAL_LEVELS:
		_current_level = 1
	
