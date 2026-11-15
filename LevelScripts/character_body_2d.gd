extends CharacterBody2D

@export var Speed : float = 10.0
@export var Friction : float = .95
@export var Gravity : int = 500
@export var Force : float = 0.05
@export var Jump : float = -2000.0
@export var JumpSpeed : float = 0.1

func _process(delta: float) -> void:
	InputCheck()
	
	move_and_slide()
	
func InputCheck():
	if Input.is_action_pressed('A'):
		velocity += Vector2.LEFT * Speed
	if Input.is_action_pressed('D'):
		velocity += Vector2.RIGHT * Speed	
	if Input.is_action_just_pressed('Space') and is_on_floor():
		velocity.y = lerp(velocity.y,Jump,JumpSpeed)
	
	velocity.x = velocity.x * Friction
	velocity += Vector2(0,Gravity)
