extends Node2D

@onready var LevelItems : Array = get_children()
@onready var ClothesNode : Node2D = $LayerItems/Clothes
var Items : Array
var Finished : bool
var Place : bool

var Clothes : Array = [
	0,
	0,
	0
]


signal Action(Command : String, Item : Area2D)

func _ready() -> void:
	for i : Node2D in LevelItems:
		if i.name == 'Background':
			pass
		elif i.name == 'LayerItems':
			pass
		else:
			var NewItems : Array = i.get_children()
			for q : Area2D in NewItems:
				q.add_to_group(i.name)
				print(q.get_groups())
				q.connect('input_event',ItemInput.bind(q))
				
func ItemInput(_viewport : Variant, input : InputEvent, _shape_idx : Variant, area : Area2D) -> void:
	if input.is_action_pressed("LMB"):
		var Index : int = area.get_index()
		if area.is_in_group('Layers'):
			Swap(Index)
			#var LayerObj : Area2D = LevelItems[2].get_child(Index)
			#if LayerObj:
				#Action.emit('VisToggle',LayerObj)
				#Action.emit('Swap',Index)
			
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects'):# and area.is_in_group('Holdable'):
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
			Action.emit('Unhold')

func Swap(Index : int) -> void:
	var Category : Node2D = ClothesNode.get_child(Index)
	
	Clothes[Index] += 1
	
	if Clothes[Index] > Category.get_children().size():
		Clothes[Index] = 0
		
	Change()
	
func Change() -> void:
	
	for i : Node2D in ClothesNode.get_children():
		for q : Sprite2D in i.get_children():
			if q.get_index() == Clothes[i.get_index()]:
				q.visible = true
			else : q.visible = false
	
	#if Index == 0:
		#print(Index)
	#elif Index == 1:
		#print(Index)
	#else:
		#print(Index)
	
