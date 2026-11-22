extends Node

@onready var GameControl : Node2D = get_parent()

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
		
func VisToggle(Item : Variant) -> void:
	
		if Item.visible:
			Item.visible = false
		else: Item.visible = true

func VisOn(Item : Variant) -> void:
	Item.visible = true
func VisOff(Item : Variant) -> void:
	Item.visible = false
	
func CollisionToggle(Item : Variant) -> void:

		if Item.collision_layer == 1:
			Item.collision_layer = 0
		else: Item.collision_layer = 1

func CollOn(Item : Variant) -> void:
	Item.collision_layer = 1
	
func CollOff(Item : Variant) -> void:
	Item.collision_layer = 0
			
func Hold(Item : Area2D) -> void:
	Data[0] = Item
	Data[0].add_to_group('Held')

func Unhold() -> void:
	if Data[0]:
		Data[0].remove_from_group('Held')
		Data[0] = null

func CenterBig(NewPlace : Area2D) -> void:
	if Data[1] != NewPlace:
		Data[1] = NewPlace
		Data[2] = NewPlace.position
		Data[3] = NewPlace.scale
		NewPlace.position = Vector2(700,100)
		NewPlace.scale *= 3
		PlaceToggle()
	else:
		NewPlace.position = Data[2]
		NewPlace.scale = Data[3]
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
