extends Node2D
#Variables ////////////////////////////////////////////////////////////////

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

func LevelSetup() -> void:
	for Scene : String in DirAccess.open("res://LevelScenes/").get_files():
		Levels.append(load("res://LevelScenes/" + Scene))
	print(Levels)

func NextLevel() -> void:
	if get_child(0).is_in_group('Levels'):
		get_child(0)
	if Levels.size() > 0:
		var Level : Node2D = Levels.pop_front().instantiate()
		add_child(Level)
		Level.add_to_group('Levels')
	
