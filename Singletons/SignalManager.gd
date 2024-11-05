extends Node

signal onCreateBullet(position: Vector2, direction: Vector2, lifeSpan: float, speed: float, 
	objectType: Constants.ObjectType)
	
signal onCreateObject(position: Vector2, objectType: Constants.ObjectType)

signal onPickupPicked(points: int)
