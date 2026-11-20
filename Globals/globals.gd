extends Node

var MusicMod : float = 0
var SFXMod : float = 0
var AltControl : bool = 0

@onready var Mouse : Sprite2D = $Canvas/MouseIcon
@onready var Bird : Node2D = $Canvas/Bird
@onready var ClothesNode : Node2D = $Canvas/Bird/Clothes
@export var Clothes : Array = [0,0,0]

#func _ready() -> void:
	#

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
		
	Mouse.position = Mouse.get_global_mouse_position()
