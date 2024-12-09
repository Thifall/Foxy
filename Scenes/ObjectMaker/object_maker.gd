extends Node2D

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER:preload("res://Scenes/BulletBase/BulletPlayer.tscn"),
	Constants.ObjectType.BULLET_ENEMY:preload("res://Scenes/BulletBase/BulletEnemy.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://Scenes/Explosion/explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://Scenes/FruitPickUp/fruit_pick_up.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.onCreateBullet.connect(onCreateBullet)
	SignalManager.onCreateObject.connect(onCreateObject)

func onCreateBullet(pos: Vector2, direction: Vector2, lifeSpan: float, speed: float, 
	objectType: Constants.ObjectType) -> void:
		if !OBJECT_SCENES.has(objectType):
			return
		var nb: Bullet = OBJECT_SCENES[objectType].instantiate()
		nb.setup(pos, direction, lifeSpan, speed)
		call_deferred("add_child", nb)

func onCreateObject(_position: Vector2, objectType: Constants.ObjectType) -> void:
		if !OBJECT_SCENES.has(objectType):
			return
		var newObject = OBJECT_SCENES[objectType].instantiate()
		newObject.position = _position
		call_deferred("add_child", newObject)
