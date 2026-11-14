extends Node

@onready var GameControl : Node2D = $".."

var Holding : Area2D
var Place : bool

var Data : Dictionary = { 
	0 : null, # Hold
	1 : null, # Current Place
	2 : null, # Place Position
	3 : null,  # Place Scale
}

func _process(_delta: float) -> void:
	if Data[0]:
		Data[0].position = GameControl.get_global_mouse_position()
		
func VisToggle(Item : Area2D , Group : String = '') -> void:
	if Item.visible:
		Item.visible = false
	else: 
		Item.visible = true
		
func Hold(Item : Area2D) -> void:
	Data[0] = Item

func Unhold() -> void:
	Data[0] = null

func CenterBig(Place : Area2D) -> void:
	if Data[1] != Place:
		Data[1] = Place
		Data[2] = Place.position
		Data[3] = Place.scale
		Place.position = Vector2(700,550)
		Place.scale *= 3
		PlaceToggle()
	else:
		Place.position = Data[2]
		Place.scale = Data[3]
		Data[1] = null
		Data[2] = null
		Data[3] = null
		PlaceToggle()

func PlaceToggle() -> void:
	var LevelItems : Array = GameControl.get_child(3).get_children()
	print(LevelItems)
	if not Place:
		Place = true
		LevelItems[2].visible = false
	else: 
		Place = false
		LevelItems[2].visible = true
