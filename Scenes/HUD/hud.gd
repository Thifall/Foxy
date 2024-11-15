extends Control

@onready var score_label: Label = $MC/HB/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MC/HB/HBHearts
@onready var vb_level_complete: VBoxContainer = $ColorRect/VBLevelComplete
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver
@onready var color_rect: ColorRect = $ColorRect

var _hearts: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_hearts = hb_hearts.get_children()
	SignalManager.onPlayerHit.connect(on_player_hit)
	SignalManager.onLevelStarted.connect(on_player_hit)
	SignalManager.onGameOver.connect(on_game_over)
	SignalManager.onScoreUpdated.connect(on_score_updated)

func on_player_hit(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life
		
func on_game_over() -> void:
	vb_game_over.show()
	show_hud()

func show_hud() -> void:
	color_rect.show()
	
func on_score_updated(score: int) -> void:
	score_label.text = "%05d" % score
