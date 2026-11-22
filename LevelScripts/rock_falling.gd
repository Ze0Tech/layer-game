extends Node2D

@onready var LevelItems : Array = get_children()

@onready var RockCopy : RigidBody2D = $Rocks/RockCopy

@onready var RockTimer : Timer = $Timers/RockSpawn

@onready var Character : CharacterBody2D = $Character/CharacterBody2D

@onready var Bar : ProgressBar = $Background/ProgressBar

@onready var SurvTimer : Timer = $Timers/Survive

var Items : Array
var Finished : bool
var Place : bool

signal Action(Command : String, Item : Variant)

func _ready() -> void:
	
	for Category : Node2D in LevelItems:
		print(Category.name)
		if Category.name == 'Background' or Category.name == 'Timers' or Category.name == 'Audio':
			pass
		else:
			var NewItems : Array = Category.get_children()
			for item : Variant in NewItems:
				item.add_to_group(Category.name)
				item.input_event.connect(
		
				func(
					_viewport : Viewport ,
					event : InputEvent,
					_shape_idx : int
					) -> void:
					ItemInput(event,item))

func _process(delta: float) -> void:
	Bar.value = SurvTimer.time_left * 10

func ItemInput(input : InputEvent, area : Variant) -> void:
	
	if input.is_action_pressed("LMB"):
		
		if area.is_in_group('LayerUI'):
			var index : int = area.get_index()
			if index == 0:
				find_child('LayerUI').get_child(0).get_child(0).get_child(1).frame = 0
				find_child('LayerUI').get_child(1).get_child(0).get_child(1).frame = 1
				find_child('LayerUI').get_child(2).get_child(0).get_child(1).frame = 1
				find_child('Objects').get_child(0).visible = true
				find_child('Objects').get_child(0).get_child(2).collision_layer = 1
				find_child('Objects').get_child(1).visible = false
				find_child('Objects').get_child(1).get_child(2).collision_layer = 0
				find_child('Objects').get_child(2).visible = false
				find_child('Objects').get_child(2).get_child(2).collision_layer = 0
			elif index == 1:
				find_child('LayerUI').get_child(0).get_child(0).get_child(1).frame = 1
				find_child('LayerUI').get_child(1).get_child(0).get_child(1).frame = 0
				find_child('LayerUI').get_child(2).get_child(0).get_child(1).frame = 1
				find_child('Objects').get_child(1).visible = true
				find_child('Objects').get_child(1).get_child(2).collision_layer = 1
				find_child('Objects').get_child(0).visible = false
				find_child('Objects').get_child(0).get_child(2).collision_layer = 0
				find_child('Objects').get_child(2).visible = false
				find_child('Objects').get_child(2).get_child(2).collision_layer = 0
			elif index == 2:
				find_child('LayerUI').get_child(0).get_child(0).get_child(1).frame = 1
				find_child('LayerUI').get_child(1).get_child(0).get_child(1).frame = 1
				find_child('LayerUI').get_child(2).get_child(0).get_child(1).frame = 0
				find_child('Objects').get_child(2).visible = true
				find_child('Objects').get_child(2).get_child(2).collision_layer = 1
				find_child('Objects').get_child(1).visible = false
				find_child('Objects').get_child(1).get_child(2).collision_layer = 0
				find_child('Objects').get_child(0).visible = false
				find_child('Objects').get_child(0).get_child(2).collision_layer = 0
			else: print('error')
			
		if area.is_in_group('Places'):
			Action.emit('CenterBig',area)
			Place = not Place
			print(Place)
			
		elif area.is_in_group('Objects'):# and area.is_in_group('Holdable'):
			Action.emit('Hold',area)
			
	if input.is_action_released('LMB'):
			Action.emit('Unhold')


func RockSpawn() -> void:
	
	RockTimer.wait_time = randf_range(0.2,1)
	
	var NewRock : RigidBody2D = RockCopy.duplicate()
	
	NewRock.position = Vector2(randi_range(180,1180),125)
	NewRock.visible = true
	NewRock.add_to_group('Rock')

	
	find_child('Rocks').add_child(NewRock)
	
	NewRock.process_mode = Node.PROCESS_MODE_INHERIT

func _on_rock_spawn_timeout() -> void:
	RockSpawn()


func _on_animation_timeout() -> void:
	for i : RigidBody2D in find_child('Rocks').get_children():
		var sprite : Sprite2D = i.get_child(2)
		sprite.frame = (sprite.frame + 1) % 3
		sprite.rotation += 0.3


func _on_survive_timeout() -> void:
	RockTimer.stop()
	$Audio/VictorySfx.play()
	Character.StopMove()
	Globals.LevelsComplete += 1
	await get_tree().create_timer(4).timeout
	
	get_parent().LevelSelect()
