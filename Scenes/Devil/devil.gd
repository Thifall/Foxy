extends Node2D

class_name Devil

@export var BossLives: int = 3
@export var BossPoints: int = 10

#region OnReady
@onready var sprite_2d: Sprite2D = $Visuals/DevilHitbox/Sprite2D
@onready var shooter: Shooter = $Visuals/Shooting/Shooter
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visuals: Node2D = $Visuals
@onready var hitbox: CollisionPolygon2D = $Visuals/DevilHitbox/CollisionPolygon2D
@onready var debug_label: Label = $"Visuals/debug label"
@onready var idle_timer: Timer = $PhasesTimers/IdleTimer
#endregion

#region Vars
var _playerReference: Player
var _currentLife: int = 0
var _invincible: bool = false
var _appeared = false
var _currentPhase: PHASES = PHASES.INIT
var _lastActivePhase: PHASES = PHASES.FLYING
var _attacksMade: int = 0
var _isAttacking: bool = false
var _tween: Tween
#endregion

enum PHASES{
	INIT,
	IDLE,
	ATTACKING,
	FLYING,
}

func _ready() -> void:
	_currentLife = BossLives
	_playerReference = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	debug_label.text = PHASES.find_key(_currentPhase)

func _process(_delta: float) -> void:
	face_player()
	debug_label.text = PHASES.find_key(_currentPhase)

#region MISC
func face_player() -> void:
	if _currentPhase == PHASES.FLYING:
		return
	var dir = visuals.global_position.direction_to(_playerReference.global_position)
	if (dir.x > 0):
		sprite_2d.flip_h = true	
		#adjust hitbox
	else:
		sprite_2d.flip_h = false
		#adjust hitbox
#endregion
		
#region BOSS DAMAGE
func _on_devil_hitbox_area_entered(_area: Area2D) -> void:
	if _invincible :
		return
	take_damage()

func set_invincible(invincible: bool) -> void:
	_invincible = invincible

func take_damage() -> void:
	pass
	set_invincible(true)
	_currentLife -=1
	if _currentLife > 0 :
		state_machine.travel("Hurt")
	else:		
		state_machine.travel("Death")

func die() -> void:	
	SignalManager.onBossDefeated.emit(BossPoints)
	_tween.kill()
	queue_free()
#endregion

#region PHASE CHANGING
func start_new_phase() -> void:		
	print("new phase starting...")
	if (_currentPhase != PHASES.IDLE):
		start_idle_phase()
		return
	#alternating between attack/flying	
	if _currentPhase == PHASES.IDLE:
		if _lastActivePhase == PHASES.ATTACKING:
			start_flying_phase()
		else:
			start_attacking_phase()

func start_idle_phase() -> void:
	if(_currentPhase != PHASES.IDLE):
		_lastActivePhase = _currentPhase
		print("Devil: started idle phase")
	_currentPhase = PHASES.IDLE
	idle_timer.start()
	
func start_attacking_phase() -> void:
	_currentPhase = PHASES.ATTACKING
	attack()
	print("Devil: started attacking phase")

func start_flying_phase() -> void:
	_currentPhase = PHASES.FLYING
	print("Devil: started flying phase")
	fly()
	

func _on_idle_timer_timeout() -> void:
	start_new_phase()
	
#endregion

#region INIT
func _on_boss_trigger_area_entered(_area: Area2D) -> void:
	if(_appeared):
		return
	print("Boss triggered")
	_appeared = true
	animation_tree["parameters/conditions/playerEnter"] = true
func show_devil() -> void:
	visuals.show()
	enable_hitbox()

func enable_hitbox() -> void:
	hitbox.disabled = false
#endregion

#region attacking
func shoot() -> void:
	var dir = shooter.global_position.direction_to(_playerReference.global_position)
	shooter.shoot(dir) 
	
func attack_finished() -> void:
	_attacksMade += 1
	_isAttacking = false
	print("Devil: attacks made: %s" % str(_attacksMade))
	if(_attacksMade >= 5):
		start_new_phase()
		_attacksMade = 0
	attack()

func attack() -> void:	
	if !_isAttacking and _currentPhase == PHASES.ATTACKING:
		_isAttacking = true
		state_machine.travel("Attack")
#endregion

#region flying
func fly() -> void:	
	if visuals.position.x < 0:
		fly_back()
	else: 
		fly_across()	
	
func fly_across() -> void:
	_tween = get_tree().create_tween()
	_tween.tween_property(visuals, "position", Vector2(-15, -110), 0.1)	
	_tween.tween_property(visuals, "position", Vector2(-30, -60), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-45, -20), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-100, 0), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-155, -20), 0.2)		
	_tween.tween_property(visuals, "position", Vector2(-170, -60), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-185, -110), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-200, -150), 0.1)
	_tween.tween_callback(start_new_phase)
	
func fly_back() -> void:
	_tween = get_tree().create_tween()
	_tween.tween_property(visuals, "position", Vector2(-185, -110), 0.1)	
	_tween.tween_property(visuals, "position", Vector2(-170, -60), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-155, -20), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-100, -0), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-45, -20), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(-30, -60), 0.2)		
	_tween.tween_property(visuals, "position", Vector2(-15, -110), 0.2)	
	_tween.tween_property(visuals, "position", Vector2(0, -150), 0.1)	
	_tween.tween_callback(start_new_phase)
#endregion
