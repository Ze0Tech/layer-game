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
			
		elif i.name == 'Layers':
			var NewItems : Array = i.get_children()
			for q : Area2D in NewItems:
				q.add_to_group(i.name)
				var v : Sprite2D = q.get_child(0).get_child(1)
				#print(q.get_groups())
				q.connect('input_event',ItemInput.bind(q,v))
				
		else:
			var NewItems : Array = i.get_children()
			for q : Variant in NewItems:
				if q is Area2D:
					q.add_to_group(i.name)
					print(q.get_groups())
					q.connect('input_event',ItemInput.bind(q))
				
func ItemInput(_viewport : Variant, input : InputEvent, _shape_idx : Variant, area : Area2D, Vsprite : Sprite2D) -> void:
	
	if input.is_action_pressed("LMB"):
		
		if area.is_in_group('Layers') or _shape_idx == 1:
			
			var Index = area.get_index()
			var Layers : Array = LevelItems[2].get_children()
			
			for i in Layers:
				var Boxes : Array = i.get_children()
				for Box in Boxes:

					if i.get_index() == Index:
						Action.emit('VisOn',Box)
						Action.emit('CollOn',Box.get_child(2))
						
						#fuck() 
						Vsprite.frame = Box.visible
						
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


func _on_death_body_entered(body: Node2D) -> void:
	Player.position = Vector2(325,550)
	var input = InputEventAction.new()
	input.action = 'LMB'
	input.pressed = true
	ItemInput(null,input,1,$Layers/Layer3,$Layers/Layer1/LayerIcon/VisIcon)
