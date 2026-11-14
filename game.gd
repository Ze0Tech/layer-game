extends Node2D
#Variables ////////////////////////////////////////////////////////////////

@onready var GameFunctions : Node = $GameFunctions
@onready var Audio : Node = $Audio
@onready var UIUX : Control = $UIUX
var Levels : Array = []

#Setup ////////////////////////////////////////////////////////////////////

func _ready() -> void:
	
	LevelSetup()
	
	NextLevel()

func _process(_delta: float) -> void:
	
	InputCheck()

#Custom Functions /////////////////////////////////////////////////////////	

func InputCheck() -> void:
	if Input.is_action_just_pressed('Q'):
		NextLevel()

func LevelAction(Command : String, Item : Area2D = null) -> void:
	if has_method(Command):
		if Item:
			call(Command,Item)
		else: call(Command) 
	elif GameFunctions.has_method(Command): 
		GameFunctionPass(Command,Item)
	else: print('No Such "' + Command + '" Command, sorry dawg.')
func GameFunctionPass(Command : String,Item : Area2D = null) -> void:
	if Item:
		GameFunctions.call(Command,Item)
	else: GameFunctions.call(Command)
func LevelSetup() -> void:
	for Scene : String in DirAccess.open("res://LevelScenes/").get_files():
		Scene = Scene.trim_suffix(".remap")
		Levels.append(load("res://LevelScenes/" + Scene))
	print(Levels)

func NextLevel() -> void:
	if get_child(3) and get_child(3).is_in_group('Levels'):
		get_child(3).queue_free()
	if Levels.size() > 0:
		LevelLoad()

func LevelLoad() -> void:
	var Level : Node2D = Levels.pop_front().instantiate()
	add_child(Level)
	Level.name = 'Level'
	Level.add_to_group('Levels')
	Level.connect('Action',LevelAction)
	#
	
	

func yay(...args) -> String:
	print('yay')
	return('yay')
