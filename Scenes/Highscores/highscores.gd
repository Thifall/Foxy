extends Control

const H_SCORE_ELEMENT = preload("res://Scenes/HScoreElement/h_score_element.tscn")
var MAIN: PackedScene = load("res://Scenes/Main/main.tscn")
@onready var v_box_container: VBoxContainer = $UIMainBase/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_scores()

func set_scores() -> void:
	var i: int = 1;
	for s in ScoreManager.get_score_history():
		var lb: Label = H_SCORE_ELEMENT.instantiate()
		lb.text = "%d: %04d" % [i, s]
		v_box_container.add_child(lb)
		i+=1


func _on_back_btn_pressed() -> void:
	GameManager.load_main_scene()
