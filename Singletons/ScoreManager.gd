extends Node

const SCORE_FILENAME: String = "user://FoxyHighscores.json"
const MAX_SCORES_COUNT: int = 10

var _score: int = 0
var _scores_history: Array = []

func _ready() -> void:
	SignalManager.onEnemyHit.connect(update_score)
	SignalManager.onBossDefeated.connect(update_score)
	SignalManager.onPickupPicked.connect(update_score)
	SignalManager.onGameOver.connect(on_game_over)
	load_scores_history()

func update_score(points: int) -> void:
	_score += points
	SignalManager.onScoreUpdated.emit(_score)
	
func on_game_over() -> void:
	_scores_history.append({"score": _score})
	save_scores()
	
func save_scores() -> void:
	_scores_history.sort_custom(compare_scores)
	var file = FileAccess.open(SCORE_FILENAME, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_scores_history.slice(0,MAX_SCORES_COUNT)))
		file.close()
	
func reset_score() -> void:
	_score = 0

func get_score() -> int:
	return _score
	
func load_scores_history() -> void:
	_scores_history.clear()
	var file = FileAccess.open(SCORE_FILENAME, FileAccess.READ)
	if file:
		var text: String = file.get_as_text()
		if text and text.length() > 0:
			_scores_history = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		save_scores()
	_scores_history.sort_custom(compare_scores)
	print(_scores_history)
	
func compare_scores(a, b):
	return b.score < a.score
