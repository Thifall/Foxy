extends Node2D

class_name Shooter

@onready var shoot_timer: Timer = $ShootTimer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var speed: float = 250
@export var lifeSpan: float = 3
@export var bulletKey: Constants.ObjectType
@export var shootDelay: float = 0.7

var canShoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_timer.wait_time = shootDelay

func shoot(direction: Vector2) -> void:
	if !canShoot:
		return		
	canShoot = false
	SignalManager.onCreateBullet.emit(global_position, direction, lifeSpan, speed, bulletKey)
	shoot_timer.start()
	
func shootRelative(relativePosition:Vector2, direction: Vector2) -> void:
	if !canShoot:
		return	
	canShoot = false
	SignalManager.onCreateBullet.emit(global_position + relativePosition, direction, lifeSpan, speed, bulletKey)
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	canShoot = true
