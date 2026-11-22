extends Node2D

@onready var KeyItem : Area2D = $Objects/Key
@onready var LockItem : Area2D = $Places/Cage/Lock
@onready var LevelItems : Array = get_children()

@onready var ChickSprite : Sprite2D = $Places/Cage/BirdcageNode/BirdCelebrateSheet

var Sprites : Array
var Items : Array
var Lock : bool
var Finished : bool
var Place : bool
var Mod : Area2D
signal Action(Command : String, Item : Area2D)

func _ready() -> void:
	for i : Node2D in LevelItems:
		if i.name == 'Background' or i.name == 'Audio':
			pass
		elif i.name == 'Timers':
			pass
		elif i.name == 'Layers':
			var NewItems : Array = i.get_children()
			for q : Area2D in NewItems:
				q.add_to_group(i.name)
				var v : Sprite2D = q.get_child(0).get_child(1)
				#print(q.get_groups())
				q.connect('input_event',ItemInput.bind(q,v))
				
		else:
			var NewItems : Array = i.get_children()
			for q : Area2D in NewItems:
				q.add_to_group(i.name)
				print(q.get_groups())
				q.connect('input_event',ItemInput.bind(q))
	
	for i : Area2D in LevelItems[2].get_children():
		Sprites.append(i.get_child(2))
	Sprites.append($Places/Cage/BirdcageNode/Birdcage)
	Sprites.append($Objects/Key/KeySheet)
	Sprites.append($Places/Cage/BirdcageNode/ShadowSheet)
				
func ItemInput(_viewport : Variant, input : InputEvent, _shape_idx : Variant, area : Area2D, Vsprite : Sprite2D = null) -> void:
	if input.is_action_pressed("LMB"):
		
		if area.is_in_group('Layers'):
			#area.modulate = Color8(100,100,100,100)
			Mod = area
			var LayerObj : Area2D = LevelItems[2].get_child(area.get_index())
			Action.emit('VisToggle',LayerObj)
			Vsprite.frame = not LayerObj.visible
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			KeyItem.position = Vector2(1350,150)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects') and area.is_in_group('Holdable'):
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
		if Mod:
			#Mod.modulate = Color8(0,0,0,0)
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
		var WinLabel : Label = $Places/Cage/WinLabel
		LockItem.visible = false
		$Places/Cage/BirdcageNode/Birdcage.visible = false
		$Places/Cage/BirdcageNode/BirdCelebrateSheet.visible = true
		WinLabel.visible = true
		$Audio/VictorySfx.play()

func _on_lock_area_entered(area: Area2D) -> void:
	if area.name == 'Key':
		Lock = true

func _on_lock_area_exited(_area: Area2D) -> void:
	Lock = false


func _on_animation_timeout() -> void:
	for i : Sprite2D in Sprites:
		i.frame = (i.frame + 1) % 3
	ChickSprite.frame = (ChickSprite.frame +1) % 5
		
	
