extends Node2D

var item : Area2D = null
var slot : Area2D = null
var colors : Array = [
	'Red',
	'Green',
	'Blue'
]

@onready var pieces : Array = $Slots.get_children()
@onready var slots : Array = $Pieces.get_children()
@onready var layers : Array = $Layers.get_children()

func _ready() -> void:
	for i : Area2D in slots:
		i.connect('area_entered',NewSlot.bind(i))
		i.add_to_group('slots')
		var poly : Polygon2D= i.get_child(0).get_child(0)
		poly.color = colors[i.get_index()]
		poly.color -= Color8(200,200,200,0)
	for i : Area2D in pieces:
		i.connect('input_event',AreaInput.bind(i))
		#print(j)
		i.add_to_group('pieces')
		var poly : Polygon2D= i.get_child(0).get_child(0)
		poly.color = colors[i.get_index()]
		
	for i : Area2D in layers:
		i.connect('input_event',LayerInput.bind(i))
		i.add_to_group('layers')
		var poly : Polygon2D= i.get_child(0).get_child(0)
		poly.color = colors[i.get_index()]

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		call_deferred('MainMenu')
		
	if Input.is_action_pressed("LMB"):
		if item and item.is_in_group('pieces'):
			item.position = get_global_mouse_position()
			
	
	if Input.is_action_just_pressed('Q'):
		get_tree().change_scene_to_file("res://Game.tscn")
		
func LayerInput(_viewport,input,_shape_idx,area:Area2D) -> void:
	if Input.is_action_just_pressed("LMB") and not pieces[area.get_index()].is_in_group('slotted'):
		Toggle(pieces[area.get_index()])

func Toggle(piece : Area2D) -> void:
	if item:
		item = null
	if piece.is_in_group('pieces'):
		piece.remove_from_group('pieces')
		piece.get_child(0).get_child(0).color -= Color8(150,150,150,0)
	elif not piece.is_in_group('slots'):
		piece.add_to_group('pieces')
		piece.get_child(0).get_child(0).color += Color8(150,150,150,0)
	print(piece.get_groups())
func AreaInput(_viewport,input,_shape_idx,area:Area2D) -> void:
	#print(area.get_groups())
	if input.is_action_pressed("LMB") and not area.is_in_group('slotted'):
		item = area
	if input.is_action_released('LMB') and slot and item:
		if slot.get_index() == item.get_index():
			item.remove_from_group('pieces')
			item.position = slot.position
			item.add_to_group('slotted')
			item = null
			
	if input.is_action_released('LMB') and item:
		item = null

func NewSlot(_Area,NewSlot) -> void:
	print(NewSlot)
	slot = NewSlot
	pass
	#slot = NewSlot

	#print(thing1)
	#print(thing2)
	#print(thing3)
	#print(thing3)
	#print(thing3)
	
func MainMenu():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
