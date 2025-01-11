extends Node2D

class_name Devil

@onready var sprite_2d: Sprite2D = $Visuals/DevilHitbox/Sprite2D
@export var BossLives: int = 3
@onready var shooter: Shooter = $Shooting/Shooter
@onready var animation_tree: AnimationTree = $AnimationTree
#@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var _playerReference: Player
var _currentLife: int = 0
var _invincible: bool = false

func _ready() -> void:
	_currentLife = BossLives
	_playerReference = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)

func _physics_process(_delta: float) -> void:
	face_player()

func face_player() -> void:
	var dir = global_position.direction_to(_playerReference.global_position)
	if (dir.x > 0):
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

func _on_devil_hitbox_area_entered(area: Area2D) -> void:
	if _invincible :
		return
	take_damage()

func set_invincible(invincible: bool) -> void:
	_invincible = invincible

func take_damage() -> void:
	pass
	#set_invincible(true)
	#_currentLife -=1
	#if _currentLife > 0 :
		#state_machine.travel("Hurt")
	#else:		
		#state_machine.travel("Death")

func shoot() -> void:
	var dir = global_position.direction_to(_playerReference.global_position)
	shooter.shoot(dir)  

func die() -> void:	
	queue_free()

func _on_shoot_timer_timeout() -> void:
	pass
	#if(state_machine.get_current_node() == "Idle"):
		#state_machine.travel("Attack")
