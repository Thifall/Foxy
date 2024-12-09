extends Control

@onready var score_label: Label = $MC/HB/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MC/HB/HBHearts
@onready var vb_level_complete: VBoxContainer = $ColorRect/VBLevelComplete
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver
@onready var color_rect: ColorRect = $ColorRect
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var continue_timer: Timer = $ContinueTimer

var _hearts: Array
var _can_continue: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_hearts = hb_hearts.get_children()
	SignalManager.onPlayerHit.connect(on_player_hit)
	SignalManager.onLevelStarted.connect(on_player_hit)
	SignalManager.onGameOver.connect(on_game_over)
	SignalManager.onScoreUpdated.connect(on_score_updated)
	SignalManager.onLevelCompleted.connect(on_level_completed)
	
func _process(_delta: float) -> void:
	if _can_continue and Input.is_action_just_pressed("Jump"):
		if vb_game_over.visible:
			GameManager.load_main_scene()
		else:
			GameManager.load_next_level_scene()

func on_player_hit(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life
		
func on_game_over() -> void:
	vb_game_over.show()
	show_hud()
	SoundManager.play_clip(sound, SoundManager.SOUND_GAMEOVER)
	
func on_level_completed() -> void:
	vb_level_complete.show()
	show_hud()

func show_hud() -> void:
	color_rect.show()
	continue_timer.start()
	
func on_score_updated(score: int) -> void:
	score_label.text = "%05d" % score


func _on_continue_timer_timeout() -> void:
	_can_continue = true
