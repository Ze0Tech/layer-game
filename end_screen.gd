extends Node2D

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	get_tree().change_scene_to_file('res://scrunch_frame.tscn')
