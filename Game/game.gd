extends Node2D

@onready var LevelSelectScene : PackedScene = load("res://LevelSelect/level_select.tscn")

#Variables ////////////////////////////////////////////////////////////////

@onready var GameFunctions : Node = get_child(0)
@onready var Audio : Node = $Audio
@onready var UIUX : Control = $UIUX
var Levels : Array = []

#Setup ////////////////////////////////////////////////////////////////////

func _process(_delta: float) -> void:
	if visible:
		InputCheck()

#Custom Functions /////////////////////////////////////////////////////////	

func init() -> void:
	get_child(3).connect('Action',LevelAction)

func InputCheck() -> void:
	pass
	if Input.is_action_just_pressed('Esc'):
		LevelSelect()
	elif Input.is_action_just_pressed('Ctrl'):
		Globals.LevelsComplete.append(Globals.LevelsComplete)

func LevelSelect() ->void:
	var NewLevelSelect : Node2D = LevelSelectScene.instantiate()
	add_sibling(NewLevelSelect)
	queue_free()
	
func LevelAction(Command : String, Item : Variant= null) -> void:
	if has_method(Command):
		if Item:
			call(Command,Item)
		else: call(Command) 
	elif GameFunctions.has_method(Command): 
		GameFunctionPass(Command,Item)
	else: print('No Such "' + Command + '" Command, sorry dawg.')
	
func GameFunctionPass(Command : String ,Item : Variant = null) -> void:
	if Item:
		GameFunctions.call(Command,Item)
	else: GameFunctions.call(Command)
	
#func yay(...args : Array) -> String:
	#print('yay' + str(args))
	#return('yay')
