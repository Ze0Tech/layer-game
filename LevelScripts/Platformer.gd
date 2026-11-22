extends Node2D

@onready var LevelItems : Array = get_children()
@onready var Star : Sprite2D = $Background/Star

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
			for q : Variant in NewItems:
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
				
func ItemInput(_viewport : Variant, input : InputEvent, _shape_idx : Variant, area : Variant, Vsprite : Sprite2D) -> void:
	
	if input.is_action_pressed("LMB"):
		
		if area.is_in_group('Layers') or _shape_idx == 1:
			var index : int = area.get_index()
			if index == 0: # Red
				$Background/Red.visible = true
				$Background/Blue.visible = false
				$Background/Green.visible = false
				find_child('Layers').get_child(0).get_child(0).get_child(1).frame = 0
				find_child('Layers').get_child(1).get_child(0).get_child(1).frame = 1
				find_child('Layers').get_child(2).get_child(0).get_child(1).frame = 1
				for i in find_child('LayerObjects').get_child(0).get_children():
					i.visible = true
					i.get_child(2).collision_layer = 1
				for i in find_child('LayerObjects').get_child(1).get_children():
					i.visible = false
					i.get_child(2).collision_layer = 0
				for i in find_child('LayerObjects').get_child(2).get_children():
					i.visible = false
					i.get_child(2).collision_layer = 0
			elif index == 1: #Blue
				$Background/Red.visible = false
				$Background/Blue.visible = true
				$Background/Green.visible = false
				find_child('Layers').get_child(0).get_child(0).get_child(1).frame = 1
				find_child('Layers').get_child(1).get_child(0).get_child(1).frame = 0
				find_child('Layers').get_child(2).get_child(0).get_child(1).frame = 1
				for i in find_child('LayerObjects').get_child(1).get_children():
					i.visible = true
					i.get_child(2).collision_layer = 1
				for i in find_child('LayerObjects').get_child(0).get_children():
					i.visible = false
					i.get_child(2).collision_layer = 0
				for i in find_child('LayerObjects').get_child(2).get_children():
					i.visible = false
					i.get_child(2).collision_layer = 0
			elif index == 2: #Green
				$Background/Red.visible = false
				$Background/Blue.visible = false
				$Background/Green.visible = true
				find_child('Layers').get_child(0).get_child(0).get_child(1).frame = 1
				find_child('Layers').get_child(1).get_child(0).get_child(1).frame = 1
				find_child('Layers').get_child(2).get_child(0).get_child(1).frame = 0
				for i in find_child('LayerObjects').get_child(2).get_children():
					i.visible = true
					i.get_child(2).collision_layer = 1
				for i in find_child('LayerObjects').get_child(1).get_children():
					i.visible = false
					i.get_child(2).collision_layer = 0
				for i in find_child('LayerObjects').get_child(0).get_children():
					i.visible = false
					i.get_child(2).collision_layer = 0
						

		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
			
		elif area.is_in_group('Objects') or area.is_in_group('Holdable'):	
			Action.emit('Hold',area)
			
	if input.is_action_released('LMB'):
			Action.emit('Unhold')


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print('yey')
	$Audio/VictorySfx.play()
	$Places/Win.queue_free()
	if not Globals.LevelsComplete.has('Platformer'):
		Globals.LevelsComplete.append('Platformer')
	await get_tree().create_timer(3).timeout
	get_parent().LevelSelect()

func _on_death_body_entered(_body: Node2D) -> void:
	Player.position = Vector2(325,550)
	var input = InputEventAction.new()
	input.action = 'LMB'
	input.pressed = true
	ItemInput(null,input,1,$Layers/Layer3,$Layers/Layer1/LayerIcon/VisIcon)


func _on_animate_timeout() -> void:
	Star.frame = (Star.frame + 1) % 3
