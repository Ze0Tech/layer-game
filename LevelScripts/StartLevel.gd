extends Node2D

@onready var LevelItems : Array = get_children()

var Items : Array
var Finished : bool
var Place : bool
var Touched : Area2D 
var Held : Area2D
var Pieces : Array

signal Action(Command : String, Item : Area2D)

func _ready() -> void:
	for i : Node2D in LevelItems:
		if i.name == 'Background' or i.name == 'Buttons':
			pass
		elif i.name == 'LayerItems':
			var NewItems : Array = i.get_children()
			for q : Area2D in NewItems:
				q.add_to_group(i.name)
				print(q.get_groups())
				
				q.connect('input_event',ItemInput.bind(q))
				q.connect('area_entered',AreaEntered.bind(q,1))
				q.connect('area_exited',AreaEntered.bind(q,0))
				q.add_to_group('Objects')
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
		
		Pieces = LevelItems[2].get_children()
				
func ItemInput(_viewport : Variant, input : InputEvent, _shape_idx : Variant, area : Area2D, Vsprite : Sprite2D = null) -> void:
	if input.is_action_pressed("LMB"):
		if area.is_in_group('Layers'):
			var LayerObj : Area2D = LevelItems[2].get_child(area.get_index())
			Action.emit('VisToggle',LayerObj)
			Vsprite.frame = not LayerObj.visible
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
		elif area.is_in_group('Objects'):# and area.is_in_group('Holdable'):
			if area.is_in_group('Placed'):
				area.remove_from_group('Placed')
			Action.emit('Hold',area)
	if input.is_action_released('LMB'):
		if Held:
			Held.remove_from_group('Held')
			Action.emit('Unhold')
			PuzzleCheck()
			
func AreaEntered(NewHeld : Area2D, NewTouched : Area2D, State : int) -> void: # 1 - Enter 0 - Exit
	if NewHeld.visible and NewTouched.visible:
		if State == 1:
			if NewHeld.is_in_group('Held'):
				Touched = NewTouched
				Held = NewHeld
		else:
				Touched = null

func PuzzleCheck() -> void:
	if Touched:
		var PieceIndex : int = Held.get_index()
		var TouchedIndex : int = Touched.get_index()
		PieceMove(PieceIndex,TouchedIndex)
		Held.add_to_group('Placed')
		Touched.add_to_group('Placed')
	FinishedCheck()
	
func FinishedCheck() -> void:
	var Piece1 : Area2D = $LayerItems/Piece1
	var StartButton : Button = $Buttons/Button
	var WinDist : Array = [0.0, 160.0, 384.837615966797, 350.0]
	Finished = true
	for i : Area2D in Pieces:
		var Dist : float = Piece1.position.distance_to(i.position)
		if not round(Dist) == round(WinDist[i.get_index()]):
			Finished = false
		else: print('yay')
		
	if Finished:
		StartButton.visible = true
		StartButton.position = Piece1.position - Vector2(175,80)
		for i : Area2D in Pieces:
			i.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
func PieceMove(PieceIndex : int ,TouchedIndex : int) -> void:
		if PieceIndex == 0:
			if TouchedIndex == 1:
				Held.position = Touched.position + Vector2(0,-160) # DownMove
			elif TouchedIndex == 3:
				Held.position = Touched.position + Vector2(-350,0) # RightMove
		elif PieceIndex == 1:
			if TouchedIndex == 0:
				Held.position = Touched.position + Vector2(0,160) # UpMove
			elif TouchedIndex == 2:
				Held.position = Touched.position + Vector2(-350,0) # RightMove
		elif PieceIndex == 2:
			if TouchedIndex == 1:
				Held.position = Touched.position + Vector2(350,0) # LeftMove
			elif TouchedIndex == 3:
				Held.position = Touched.position + Vector2(0,160) # UpMove
		elif PieceIndex == 3:
			if TouchedIndex == 0:
				Held.position = Touched.position + Vector2(350,0) # LeftMove
			elif TouchedIndex == 2:
				Held.position = Touched.position + Vector2(0,-160) # DownMove	

func _on_button_button_down() -> void:
	for i : Area2D in Pieces:
		i.modulate = Color(0.784, 0.784, 0.784, 1.0)
		
func _on_button_button_up() -> void:
	for i : Area2D in Pieces:
		i.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
