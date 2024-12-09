extends Node

#region Navigating Signals
signal onMainMenuLoaded
signal onNewGameSelected
signal onLevelCompleted
#endregion

signal onCreateBullet(position: Vector2, direction: Vector2, lifeSpan: float, speed: float, 
	objectType: Constants.ObjectType)
	
signal onCreateObject(position: Vector2, objectType: Constants.ObjectType)

signal onPickupPicked(points: int)
signal onEnemyHit(points:int)
signal onScoreUpdated(score: int)
signal onGameOver
signal onPlayerHit(lives: int)
signal onLevelStarted(lives: int)

signal onBossDefeated(points: int)
