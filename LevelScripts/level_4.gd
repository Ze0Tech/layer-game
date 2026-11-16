extends Node2D

@onready var LevelItems : Array = get_children()

var Items : Array
var Finished : bool
var Place : bool
var Player : CharacterBody2D

signal Action(Command : String, Item : Variant , State : Variant)

func _ready() -> void:
	
	for i : Node2D in LevelItems:
		
		if i.name == 'Background':
			pass
			
		elif i.name == 'Objects':
			Player = i.get_child(0)
			
		#elif i.name == 'LayerObjects':
			#var LayerObjs: Array = i.get_children()
			#
			#for Layer in LayerObjs:
				#var Boxes = Layer.get_children()
				#if q.visible:
					#q.get_child(2).collision_layer = true
				#else:
					#q.get_child(2).collision_layer = false
				
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
			
			var Index = area.get_index()
			var Layers : Array = LevelItems[2].get_children()
			
			for i in Layers:
				var Boxes : Array = i.get_children()
				for Box in Boxes:
					if i.get_index() == Index:
						Action.emit('VisOn',Box)
						Action.emit('CollOn',Box.get_child(2))
					else:
						Action.emit('VisOff',Box)
						Action.emit('CollOff',Box.get_child(2))
			
			
			
			
			
			
			
			
			#var LayerObj : Area2D = LevelItems[2].get_child(area.get_index())
			#var CollBoxes : Array = LayerObj.get_children()
		#
			#Action.emit('VisToggle', LayerObj)
			#for i in CollBoxes:
				#Action.emit('CollisionToggle',i)
		
		
		
		
			#var LayerObj : Variant = LevelItems[2].get_child(area.get_index())
			#if LayerObj:
				#Action.emit('VisToggle',LayerObj)
				#for i in LayerObj.get_children():
					#Action.emit('CollisionToggle',i.get_child(2))


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
