extends Node2D

func _ready() -> void:
	await get_tree().create_timer(10)
	Globals.Bird.position = Vector2(600,-1525)
	Globals.Bird.scale = Vector2(2.5,2.5)
