extends CharacterBody2D

var Dir : Vector2 = Vector2(3000,0)

func _process(delta: float) -> void:
	
	velocity = velocity.move_toward(Dir,1)
	
	if is_on_wall(): Dir = -Dir
	
	move_and_slide()
