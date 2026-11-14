extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		call_deferred('MainMenu')
		
func MainMenu():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
