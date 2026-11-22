extends Node

var MusicMod : float = 0
var SFXMod : float = 0
var AltControl : bool = 0
var LevelsComplete : int = 0

@onready var Mouse : Sprite2D = $Canvas/MouseIcon
@onready var Bird : Node2D = $Canvas/Bird
@onready var ClothesNode : Node2D = $Canvas/Bird/Clothes
@export var Clothes : Array = [7,7,7]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func BirdUpdate() -> void:
	print(Clothes)
	Bird.visible = true
	for i : Node2D in ClothesNode.get_children():
		for q : Sprite2D in i.get_children():
			if q.get_index() == Clothes[i.get_index()]:
				q.visible = true
			elif not q.get_index() == Clothes[i.get_index()] : q.visible = false
	
func BirdHide() -> void:
	for i : Node2D in ClothesNode.get_children():
		for q : Sprite2D in i.get_children():
			q.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('Q'):
		print(Clothes)
		
	Mouse.position = Mouse.get_global_mouse_position()
