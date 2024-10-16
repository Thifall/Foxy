extends CharacterBody2D

class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D


const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -260.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	getInput()
	move_and_slide()
		

func getInput() -> void:
	velocity.x = 0
	if Input.is_action_pressed("Left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif  Input.is_action_pressed("Right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)
