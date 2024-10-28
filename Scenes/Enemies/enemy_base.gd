extends CharacterBody2D

class_name EnemyBase

const OFF_SCREEN_Y_LIMIT: float = 200.0

@export var Points: int = 1

var _playerReference: Player
var _gravity: float = 800.0
var dying: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_playerReference = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	fallen_off()
	
func fallen_off() -> void:
	if global_position.y > OFF_SCREEN_Y_LIMIT:
		queue_free()
		
func die() -> void:
	if dying:
		return
	dying = true
	set_physics_process(false)
	hide()
	#other stuff
	
	queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	die()


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	pass # Replace with function body.
