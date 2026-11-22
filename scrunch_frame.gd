extends Node2D

func _ready() -> void:
	await get_tree().create_timer(10)
	Globals.Bird.position = Vector2(575,-2700)
	Globals.Bird.scale = Vector2(4,4)
