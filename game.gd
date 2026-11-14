extends Node2D

var item : Area2D = null

@onready var areas : Array = $Areas.get_children()

func _ready() -> void:
	for i in areas:
		i.connect('input_event',AreaInput.bind(i))
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		call_deferred('MainMenu')
		
	if Input.is_action_pressed("LMB"):
		if item:
			item.position = get_global_mouse_position()

func AreaInput(viewport,input,shape_idx,area) ->void:
	if input.is_action_pressed("LMB"):
		item = area
	if input.is_action_released('LMB') and item:
		item = null
	#print(thing1)
	#print(thing2)
	#print(thing3)
	#print(thing3)
	#print(thing3)
	
func MainMenu():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
