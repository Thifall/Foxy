extends Node2D

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER:preload("res://Scenes/BulletBase/BulletPlayer.tscn"),
	Constants.ObjectType.BULLET_ENEMY:preload("res://Scenes/BulletBase/BulletEnemy.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.onCreateBullet.connect(onCreateBullet)

func onCreateBullet(position: Vector2, direction: Vector2, lifeSpan: float, speed: float, 
	objectType: Constants.ObjectType) -> void:
		if !OBJECT_SCENES.has(objectType):
			return
		var nb: Bullet = OBJECT_SCENES[objectType].instantiate()
		nb.setup(position, direction, lifeSpan, speed)
		call_deferred("add_child", nb)
