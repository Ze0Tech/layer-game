extends CharacterBody2D

@onready var Sprite : Sprite2D = $Chick
@onready var FlipTimer : Timer = $Flip
@onready var Area : Area2D = $Area2D

var Hearts : int = 3
var Move : bool = true
var Dir : Vector2 = Vector2(3000,5000)

func _ready() -> void:
	
	Area.connect('body_entered',Die)

func _process(delta: float) -> void:
	
	Death()
	
	if Move:	
		velocity = velocity.move_toward(Dir ,1)
		
		if is_on_wall() and FlipTimer.is_stopped(): 
			Dir.x = -Dir.x ; 
			velocity = Vector2(0,5000) ; 
			Sprite.flip_h = not Sprite.flip_h
			FlipTimer.start()
			
		if not is_on_floor():
			velocity += Vector2(0,5000)
		move_and_slide()
	else:
		velocity = Vector2(0,0)
		
func Death():
	if Hearts == -1:
		Move = false
		velocity = Vector2(0,0)
		await get_tree().create_timer(2).timeout
		get_parent().get_parent().get_parent().LevelSelect()

func Die(body : Variant) -> void:
	if body.is_in_group('Rock'):
		$Hearts.get_child(Hearts).visible = false
		Hearts -= 1
		
func StopMove() -> void:
	Move = false
	
func _on_animation_timeout() -> void:
	Sprite.frame = (Sprite.frame + 1) % 3
