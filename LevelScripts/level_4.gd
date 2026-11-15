extends Node2D

@onready var LevelItems : Array = get_children()

var Items : Array
var Finished : bool
var Place : bool
var Player : CharacterBody2D

signal Action(Command : String, Item : Variant)

func _ready() -> void:
	for i : Node2D in LevelItems:
		if i.name == 'Background':
			pass
		elif i.name == 'Objects':
			Player = i.get_child(0)
		elif i.name == 'LayerItems':
			var NewItems : Array = i.get_children()
			
			for q : Area2D in NewItems:
				q.add_to_group(i.name)
				q.add_to_group('Holdable')
				print(q.get_groups())
				q.connect('input_event',ItemInput.bind(q))
				
		else:
			var NewItems : Array = i.get_children()
			for q : Variant in NewItems:
				if q is Area2D:
					q.add_to_group(i.name)
					print(q.get_groups())
					q.connect('input_event',ItemInput.bind(q))
				
func ItemInput(_viewport : Variant, input : InputEvent, _shape_idx : Variant, area : Area2D) -> void:
	if input.is_action_pressed("LMB"):
		if area.is_in_group('Layers'):
			var LayerObj : Variant = LevelItems[2].get_child(area.get_index())
			if LayerObj:
				Action.emit('VisToggle',LayerObj)
				for i in LayerObj.get_children():
					Action.emit('CollisionToggle',i.get_child(2))
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects') or area.is_in_group('Holdable'):
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
			Action.emit('Unhold')


func _on_area_2d_body_entered(body: Node2D) -> void:
	print('yey')
