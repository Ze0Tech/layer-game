extends Node2D

@onready var LevelItems : Array = get_children()

var Items : Array
var Finished : bool
var Place : bool

signal Action(Command : String, Item : Area2D)

func _ready() -> void:
	for i : Node2D in LevelItems:
		if i.name == 'Background':
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
			var LayerObj : Area2D = LevelItems[2].get_child(Index)
			if LayerObj:
				#Action.emit('VisToggle',LayerObj)
				#Action.emit('Swap',Index)
				Swap(Index)
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects'):# and area.is_in_group('Holdable'):
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
			Action.emit('Unhold')
