extends CharacterBody2D

var Jumping : bool = false

@export var Speed : float = 10.0
@export var Friction : float = .95
@export var Gravity : int = 500
@export var Force : float = 0.05
@export var Jump : float = -2000.0
@export var JumpSpeed : float = 0.1

@onready var Sprite : Sprite2D = $Idle

var walljump : bool

func _process(_delta: float) -> void:
	InputCheck()
	
	move_and_slide()
	
	Globals.Bird.position = position
	
	if is_on_floor():
		Jumping = false
	
	if is_on_wall() and not is_on_floor():
		walljump = true
	else:
		walljump = false
	
func InputCheck():
	
	Sprite.visible = false
	
	if not Jumping:
		Sprite = $Idle
	
	if Input.is_action_pressed('A'):
		Sprite = $Run
		Sprite.flip_h = true
		velocity += Vector2.LEFT * Speed
	elif Input.is_action_pressed('D'):
		Sprite = $Run
		Sprite.flip_h = false
		velocity += Vector2.RIGHT * Speed	
	if Input.is_action_just_pressed('Space') and is_on_floor() or Input.is_action_just_pressed('Space') and walljump:
		velocity.y = lerp(velocity.y,Jump,JumpSpeed)
		Sprite = $Jump
		Jumping = true

	
	Sprite.visible = true
	velocity.x = velocity.x * Friction
	velocity += Vector2(0,Gravity)


func _on_animate_timeout() -> void:
	Sprite.frame = (Sprite.frame + 1) % 3
