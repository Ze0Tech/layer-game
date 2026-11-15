extends Node

var MusicMod : float = 0
var SFXMod : float = 0
var AltControl : bool = 0

@onready var Bird : Node2D = $Bird
@onready var ClothesNode : Node2D = $Bird/Clothes
@export var Clothes : Array = [0,0,0]

func BirdUpdate() -> void:
	Bird.visible = true
	if Clothes != [0,0,0]:
		for i : Node2D in ClothesNode.get_children():
			if i.get_child(Clothes[i.get_index()]):
				i.get_child(Clothes[i.get_index()]).visible = true
	
func BirdHide() -> void:
	for i : Node2D in ClothesNode.get_children():
		for q : Sprite2D in i.get_children():
			q.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('Q'):
		print(Clothes)
