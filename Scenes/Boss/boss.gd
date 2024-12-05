extends Node2D

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@export var lives: int = 2
@export var points: int = 5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visual: Node2D = $Visual
@onready var bossHitBox: CollisionShape2D = $Visual/BossHitBox/CollisionShape2D

var _isInvincible = false

func _on_boss_trigger_area_entered(area: Area2D) -> void:
	animation_tree[TRIGGER_CONDITION] = true
	
func set_invinviclbe(invincible: bool) -> void:
	_isInvincible = invincible
	if(invincible):
		state_machine.travel("hit")
	
func reduce_lives() -> void:
	lives -= 1
	if lives<=0 :
		SignalManager.onBossDefeated.emit(points)
		queue_free()
	
func tween_hit() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(visual, "position", Vector2.ZERO, 1.8)
	tween.tween_callback(set_invinviclbe.bind(false))

func take_damage() -> void:
	if(_isInvincible):
		return
	set_invinviclbe(true)
	tween_hit()
	reduce_lives()

func enable_hit_box() -> void:
	bossHitBox.set_deferred("disabled", false)
	
func _on_boss_hit_box_area_entered(area: Area2D) -> void:
	take_damage()
