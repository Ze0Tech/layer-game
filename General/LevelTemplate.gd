extends Node2D

@onready var LevelItems : Array = get_children()

var Items : Array
var Finished : bool
var Place : bool

signal Action(Command : String, Item : Variant)

func _ready() -> void:
	for Category : Node2D in LevelItems:
		
		if Category.name == 'Background':
			pass
		else:
			var NewItems : Array = Category.get_children()
			for item : Variant in NewItems:
				item.add_to_group(Category.name)
				item.input_event.connect(
				func
					(
					_viewport : Viewport ,
					event : InputEvent,
					_shape_idx : int
					) -> void:
					ItemInput(event,item))
				
func ItemInput(input : InputEvent, area : Variant) -> void:
	if input.is_action_pressed("LMB"):
		if area.is_in_group('LayerUI'):
			var LayerObj : Variant = LevelItems[2].get_child(area.get_index())
			if LayerObj:
				var VSprite : Sprite2D = area.get_child(0).get_child(1)
				Action.emit('VisToggle',LayerObj)
				VSprite.frame = not LayerObj.visible
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects'):# and area.is_in_group('Holdable'):
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
			Action.emit('Unhold')
