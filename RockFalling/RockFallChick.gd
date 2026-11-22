extends CharacterBody2D

@onready var Sprite : Sprite2D = $Chick
@onready var FlipTimer : Timer = $Flip
@onready var Area : Area2D = $Area2D


var Move : bool = true
var Dir : Vector2 = Vector2(3000,5000)

func _ready() -> void:
	
	Area.connect('body_entered',Die)

func _process(delta: float) -> void:
	if Move:	
		velocity = velocity.move_toward(Dir ,1)
		
		if is_on_wall() and FlipTimer.is_stopped(): 
			Dir.x = -Dir.x ; 
			velocity = Vector2(0,5000) ; 
			Sprite.flip_h = not Sprite.flip_h
			FlipTimer.start()
		move_and_slide()
	else:
		velocity = Vector2(0,0)
func Die(body : Variant) -> void:
	if body.is_in_group('Rock'):
		print('death')
		
func StopMove() -> void:
	Move = false
	
func _on_animation_timeout() -> void:
	Sprite.frame = (Sprite.frame + 1) % 3
