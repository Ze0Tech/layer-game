extends Node2D

@onready var KeyItem : Area2D = $Objects/Key
@onready var LockItem : Area2D = $Places/Cage/Lock
@onready var LevelItems : Array = get_children()

var Items : Array
var Lock : bool
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
		if area.is_in_group('Layers'):
			var LayerObj : Area2D = LevelItems[2].get_child(area.get_index())
			Action.emit('VisToggle',LayerObj)
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			KeyItem.position = Vector2(1350,150)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects') and area.is_in_group('Holdable'):
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
			Action.emit('Unhold')
	if not Place and not Finished:
		PuzzleCheck()
	elif Place:
		LockCheck()
#func PlaceToggle():
	

func PuzzleCheck() -> void:
	Finished = true
	for i : Area2D in LevelItems[2].get_children():
		if i.visible:
			Finished = false
			KeyItem.position = i.position
				
	if Finished == true:
		KeyItem.visible = true
		KeyItem.add_to_group('Holdable')

func LockCheck() -> void:			
	if Lock:
		var WinLabel : Label = $Places/Cage/Label
		LockItem.visible = false
		WinLabel.visible = true


func _on_lock_area_entered(area: Area2D) -> void:
	if area.name == 'Key':
		Lock = true

func _on_lock_area_exited(_area: Area2D) -> void:
	Lock = false
